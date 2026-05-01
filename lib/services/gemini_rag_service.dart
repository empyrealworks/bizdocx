import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import '../env/env.dart';
import '../models/document_asset.dart';
import '../models/user_context.dart';
import '../models/document_template.dart';
import '../models/user_profile.dart';

class GeminiRagService {
  GeminiRagService._();
  static final GeminiRagService instance = GeminiRagService._();

  static final _apiKey = Env.geminiApiKey;

  // Model ID Constants - From Official Suite Guide Section 6
  static const _modelPro = 'gemini-3.1-pro-preview';
  static const _modelFlash = 'gemini-3-flash-preview';
  static const _modelFlashLite = 'gemini-3.1-flash-lite-preview';
  static const _modelImagePro = 'gemini-3-pro-image-preview';
  
  // Base URLs
  static const _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';

  String _getTextModel(UserTier tier) {
    switch (tier) {
      case UserTier.agency:
        return _modelPro;
      case UserTier.solopreneur:
        return _modelFlash;
      case UserTier.free:
      default:
        return _modelFlashLite;
    }
  }

  String _getImageModel(UserTier tier) {
    // Note: Section 6 specifically lists gemini-3-pro-image-preview.
    return _modelImagePro;
  }

  // ── Structural Document Generation ────────────────────────────────────────
  Future<String> generateStructuralDocument({
    required String userPrompt,
    required DocumentType documentType,
    required UserContext context,
    required UserTier tier,
    DocumentTemplate? template,
    String? orientation,
  }) async {
    final model = _getTextModel(tier);
    final prompt = _buildStructuralPrompt(
      userPrompt: userPrompt,
      documentType: documentType,
      context: context,
      template: template,
      orientation: orientation,
    );
    debugPrint('[Gemini] Structural prompt length: ${prompt.length} using $model');
    return _callGenerateContent(model, prompt);
  }

  // ── Iterative Refinement ─────────────────────────────────────────────────
  Future<String> refineStructuralDocument({
    required String existingHtml,
    required String refinementPrompt,
    required DocumentType documentType,
    required UserContext context,
    required UserTier tier,
  }) async {
    final model = _getTextModel(tier);
    final logoInstruction = _logoInstruction(context, documentType);

    final prompt = '''
You are an expert business document designer. A user wants to refine an existing HTML document.

BUSINESS CONTEXT:
- Company: ${context.companyName}
- Mission: ${context.mission}
- Brand Colors: ${context.brandColors.join(', ')}
${logoInstruction.isNotEmpty ? '\n$logoInstruction\n' : ''}
DOCUMENT TYPE: ${documentType.name}

REFINEMENT REQUEST: "$refinementPrompt"

EXISTING DOCUMENT HTML:
$existingHtml

INSTRUCTIONS:
1. Apply ONLY the changes described in the refinement request.
2. Keep all unchanged sections exactly as they are.
3. Maintain the same visual design, layout, and inline CSS.
4. AVOID 'display: grid' — use Flexbox or HTML tables for layout.
5. FIXED DIMENSIONS: Maintain the fixed dimensions as defined in the existing document.
6. Return ONLY the complete updated HTML starting with <!DOCTYPE html>.
7. Do NOT wrap the output in markdown code fences.
''';

    debugPrint('[Gemini] Refinement prompt length: ${prompt.length} using $model');
    return _callGenerateContent(model, prompt);
  }

  // ── Graphical Asset Generation ───────────────────────────────
  Future<Uint8List> generateImage({
    required String userPrompt,
    required UserContext context,
    required UserTier tier,
    DocumentTemplate? template,
    String? aspectRatio,
  }) async {
    final model = _getImageModel(tier);
    final templateInstruction = template != null 
        ? '\nTEMPLATE STYLE: ${template.name} - ${template.promptInstructions}\n' 
        : '';
        
    final instruction = '''
Refine the following user request into a highly detailed, professional prompt for image generation.
The final image should be a professional business asset (logo or icon).
Output ONLY the refined prompt, no preamble.

CONTEXT:
- Business: ${context.companyName}
- Mission: ${context.mission}
- Brand Colors: ${context.brandColors.join(', ')}
$templateInstruction
DESIRED ASPECT RATIO: ${aspectRatio ?? '1:1'}
USER REQUEST: $userPrompt

INSTRUCTION FOR REFINEMENT:
- Incorporate the DESIRED ASPECT RATIO into the visual description (e.g., describe the composition as being wide, tall, or square).
- Do not mention the text "aspect ratio" in the final prompt, but describe the framing and layout accordingly.
''';

    final refinedPrompt = await _refinePromptWithGemini(instruction, tier);
    debugPrint('[Gemini Image] Refined Prompt: $refinedPrompt using $model');
    
    final payload = {
      'contents': [
        {
          'parts': [
            {'text': refinedPrompt}
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.7,
      }
    };

    final url = '$_baseUrl/$model:generateContent?key=$_apiKey';
    final response = await _post(url, payload);
    
    try {
      final candidates = response['candidates'] as List;
      if (candidates.isEmpty) throw Exception('No image candidates returned.');
      
      final parts = candidates[0]['content']['parts'] as List;
      final imagePart = parts.firstWhere((p) => p.containsKey('inlineData'), orElse: () => null);
      
      if (imagePart == null) {
        throw Exception('Image model did not return image data. Check if prompt violated safety filters.');
      }
      
      final base64String = imagePart['inlineData']['data'] as String;
      return base64Decode(base64String);
    } catch (e) {
      debugPrint('[Gemini Image] Error parsing response: $e');
      throw Exception('Image generation failed: invalid response schema or content.');
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Future<String> _callGenerateContent(String model, String prompt) async {
    final payload = {
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.4,
        'maxOutputTokens': 8192,
      },
    };

    final url = '$_baseUrl/$model:generateContent?key=$_apiKey';
    final response = await _post(url, payload);
    try {
      final text =
      response['candidates'][0]['content']['parts'][0]['text'] as String;
      return _stripMarkdownFences(text);
    } catch (e) {
      debugPrint('[Gemini] Error parsing response: $e');
      throw Exception('Failed to parse Gemini response');
    }
  }

  Future<Map<String, dynamic>> _post(
      String url, Map<String, dynamic> body) async {
    final client = HttpClient();
    try {
      final uri = Uri.parse(url);
      final request = await client.postUrl(uri);
      request.headers.set('Content-Type', 'application/json');
      request.add(utf8.encode(jsonEncode(body)));

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode != 200) {
        debugPrint('[AI] HTTP ${response.statusCode}: $responseBody');
        throw Exception('AI Service Error: ${response.statusCode}');
      }

      return jsonDecode(responseBody) as Map<String, dynamic>;
    } finally {
      client.close();
    }
  }

  Future<String> _refinePromptWithGemini(String instruction, UserTier tier) async {
    final model = _getTextModel(tier);
    return _callGenerateContent(model, instruction);
  }

  /// Document types where embedding the logo makes sense.
  static const _logoRelevantTypes = {
    DocumentType.invoice,
    DocumentType.proposal,
    DocumentType.letterhead,
    DocumentType.businessCard,
    DocumentType.contract,
    DocumentType.other,
  };

  /// Returns a non-empty instruction string if a logo is available and relevant.
  String _logoInstruction(UserContext context, DocumentType type) {
    if (context.logoStorageUrl == null ||
        context.logoStorageUrl!.isEmpty ||
        !_logoRelevantTypes.contains(type)) {
      return '';
    }
    return '''
COMPANY LOGO:
The company logo is available at the following URL. You MUST embed it in the document.
Use this exact img tag and place it prominently at the top (e.g. top-left of the header):
<img src="${context.logoStorageUrl}" alt="${context.companyName} Logo" style="max-height:70px; max-width:180px; object-fit:contain; display:block;" />
Do NOT use a placeholder — use the real URL above.''';
  }

  String _buildStructuralPrompt({
    required String userPrompt,
    required DocumentType documentType,
    required UserContext context,
    DocumentTemplate? template,
    String? orientation,
  }) {
    final logoInstruction = _logoInstruction(context, documentType);
    
    // Default to A4 Portrait (96 DPI)
    String width = '794px';
    String minHeight = '1123px';
    bool isLandscape = orientation == 'landscape';

    // Letterheads are ALWAYS Portrait A4
    if (documentType == DocumentType.letterhead) {
      isLandscape = false;
    }

    // Handle A4 Landscape
    if (isLandscape && (
        documentType == DocumentType.invoice || 
        documentType == DocumentType.proposal || 
        documentType == DocumentType.contract ||
        documentType == DocumentType.other)) {
      width = '1123px';
      minHeight = '794px';
    }

    // Business Cards have special small dimensions
    if (documentType == DocumentType.businessCard) {
      if (isLandscape) {
        width = '336px'; // 3.5 inches
        minHeight = '192px'; // 2 inches
      } else {
        width = '192px';
        minHeight = '336px';
      }
    }

    // Logos & Icons (if structural)
    if (documentType == DocumentType.logo || documentType == DocumentType.icon) {
      width = '512px';
      minHeight = '512px';
    }

    final templateInstruction = template != null 
        ? '\nSELECTED TEMPLATE: ${template.name}\nSTYLE INSTRUCTIONS: ${template.promptInstructions}\n' 
        : '';

    return '''
You are an expert business designer and PDF-optimized HTML engineer.

BUSINESS CONTEXT:
- Company: ${context.companyName}
- Mission: ${context.mission}
- Brand Colors: ${context.brandColors.join(', ')}
- Target Audience: ${context.targetAudience}
${logoInstruction.isNotEmpty ? '\n$logoInstruction\n' : ''}
DOCUMENT TYPE: ${documentType.name}
$templateInstruction
USER REQUEST: $userPrompt

TECHNICAL REQUIREMENTS FOR FIXED DIMENSIONS:
1. Output ONLY raw HTML with 100% inline CSS.
2. FIXED PAGE DIMENSIONS: All content must be wrapped in a main container div with class "page-container" and exactly "width: $width; min-height: $minHeight; padding: ${documentType == DocumentType.businessCard ? '20px' : '40px'}; margin: 0 auto; background: white; box-sizing: border-box; position: relative; overflow: hidden;". 
3. NON-RESPONSIVE DESIGN: The layout MUST be fixed at the dimensions above. Do NOT use percentage widths for main structures; use pixels or fixed ratios. This ensures a consistent look when printed or exported.
4. Use Flexbox or HTML Tables for layout. NEVER use 'display: grid'.
5. Design: clean, minimal, premium. Ample white space.
6. Professional typography: serif headers, sans-serif body.
7. VIEWPORT: Include <meta name="viewport" content="width=${width.replaceAll('px', '')}"> in the <head> to ensure correct initial scaling on mobile devices (users will zoom in if needed).
8. Return only the HTML starting with <!DOCTYPE html>.
9. Do NOT wrap the output in markdown code fences.
''';
  }

  String _stripMarkdownFences(String raw) {
    return raw
        .replaceAll(RegExp(r'^```html\s*', multiLine: true), '')
        .replaceAll(RegExp(r'^```\s*', multiLine: true), '')
        .trim();
  }
}
