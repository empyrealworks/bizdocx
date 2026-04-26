import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import '../env/env.dart';
import '../models/document_asset.dart';
import '../models/user_context.dart';
import '../models/document_template.dart';

class GeminiRagService {
  GeminiRagService._();
  static final GeminiRagService instance = GeminiRagService._();

  static final _apiKey = Env.geminiApiKey;

  static const _geminiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-pro-preview:generateContent';
  static const _imagenUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/imagen-4.0-generate-001:predict';

  // ── Structural Document Generation ────────────────────────────────────────
  Future<String> generateStructuralDocument({
    required String userPrompt,
    required DocumentType documentType,
    required UserContext context,
    DocumentTemplate? template,
    String? orientation,
  }) async {
    final prompt = _buildStructuralPrompt(
      userPrompt: userPrompt,
      documentType: documentType,
      context: context,
      template: template,
      orientation: orientation,
    );
    debugPrint('[Gemini] Structural prompt length: ${prompt.length}');
    return _callTextModel(prompt);
  }

  // ── Iterative Refinement ─────────────────────────────────────────────────
  Future<String> refineStructuralDocument({
    required String existingHtml,
    required String refinementPrompt,
    required DocumentType documentType,
    required UserContext context,
  }) async {
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

    debugPrint('[Gemini] Refinement prompt length: ${prompt.length}');
    return _callTextModel(prompt);
  }

  // ── Graphical Asset Generation (Imagen 4.0) ───────────────────────────────
  Future<Uint8List> generateImage({
    required String userPrompt,
    required UserContext context,
    DocumentTemplate? template,
    String? aspectRatio,
  }) async {
    final templateInstruction = template != null 
        ? '\nTEMPLATE STYLE: ${template.name} - ${template.promptInstructions}\n' 
        : '';
        
    final instruction = '''
Refine the following user request into a highly detailed, professional prompt for Imagen 4.0.
Output ONLY the refined prompt, no preamble.

CONTEXT:
- Business: ${context.companyName}
- Mission: ${context.mission}
- Brand Colors: ${context.brandColors.join(', ')}
$templateInstruction
USER REQUEST: $userPrompt
''';

    final refinedPrompt = await _refinePromptWithGemini(instruction);
    debugPrint('[Imagen] Refined Prompt: $refinedPrompt');

    final payload = {
      'instances': [
        {'prompt': refinedPrompt}
      ],
      'parameters': {
        'sampleCount': 1, 
        'aspectRatio': _normalizeAspectRatio(aspectRatio),
      },
    };

    final response = await _post(_imagenUrl, payload);
    try {
      final base64String =
      response['predictions'][0]['bytesBase64Encoded'] as String;
      return base64Decode(base64String);
    } catch (e) {
      debugPrint('[Imagen] Error parsing prediction: $e');
      throw Exception('Image generation failed: invalid Imagen response.');
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _normalizeAspectRatio(String? ratio) {
    if (ratio == null) return '1:1';
    if (ratio == '3.5:2' || ratio == '3:2') return '3:2';
    if (ratio == '2:3.5' || ratio == '2:3') return '2:3';
    return ratio;
  }

  Future<String> _callTextModel(String prompt) async {
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

    final response = await _post(_geminiUrl, payload);
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
      final uri = Uri.parse('$url?key=$_apiKey');
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

  Future<String> _refinePromptWithGemini(String instruction) async {
    final payload = {
      'contents': [
        {
          'parts': [
            {'text': instruction}
          ]
        }
      ]
    };
    final response = await _post(_geminiUrl, payload);
    return response['candidates'][0]['content']['parts'][0]['text'] as String;
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
