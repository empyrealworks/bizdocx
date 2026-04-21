import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import '../env/env.dart';
import '../models/document_asset.dart';
import '../models/user_context.dart';

class GeminiRagService {
  GeminiRagService._();
  static final GeminiRagService instance = GeminiRagService._();
  
  static final _apiKey = Env.geminiApiKey;

  static const _geminiUrl = 'https://generativelanguage.googleapis.com/v1alpha/models/gemini-3.1-pro-preview:generateContent';
  static const _imagenUrl = 'https://generativelanguage.googleapis.com/v1beta/models/imagen-4.0-generate-001:predict';

  // ── Structural Document Generation (Gemini 3.1 Pro Preview) ────────────────
  Future<String> generateStructuralDocument({
    required String userPrompt,
    required DocumentType documentType,
    required UserContext context,
  }) async {
    final augmented = _buildStructuralPrompt(
      userPrompt: userPrompt,
      documentType: documentType,
      context: context,
    );

    final payload = {
      'contents': [
        {
          'parts': [{'text': augmented}]
        }
      ],
      'generationConfig': {
        'temperature': 0.5, // Lower temperature for more stable HTML structure
        'maxOutputTokens': 8192,
      }
    };

    final response = await _post(_geminiUrl, payload);
    
    try {
      final text = response['candidates'][0]['content']['parts'][0]['text'] as String;
      return _stripMarkdownFences(text);
    } catch (e) {
      debugPrint('[Gemini] Error parsing structural response: $e');
      throw Exception('Failed to parse Gemini response');
    }
  }

  // ── Graphical Asset Generation (Imagen 4.0) ────────────────────────────────
  Future<Uint8List> generateImage({
    required String userPrompt,
    required UserContext context,
  }) async {
    final promptInstruction = '''
Refine the following user request into a highly detailed, professional prompt for Imagen 4.0.
Output ONLY the refined prompt.

CONTEXT:
- Business: ${context.companyName}
- Mission: ${context.mission}
- Brand Colors: ${context.brandColors.join(', ')}

USER REQUEST: $userPrompt
''';

    final refinedPrompt = await _refinePromptWithGemini(promptInstruction);
    debugPrint('[Imagen] Refined Prompt: $refinedPrompt');

    final payload = {
      'instances': [
        {'prompt': refinedPrompt}
      ],
      'parameters': {
        'sampleCount': 1,
        'aspectRatio': '1:1',
      }
    };

    final response = await _post(_imagenUrl, payload);

    try {
      final base64String = response['predictions'][0]['bytesBase64Encoded'] as String;
      return base64Decode(base64String);
    } catch (e) {
      debugPrint('[Imagen] Error parsing prediction: $e');
      throw Exception('Image generation failed: Invalid response from Imagen API');
    }
  }

  // ── Helper: Manual POST for specific endpoints/versions ───────────────────
  Future<Map<String, dynamic>> _post(String url, Map<String, dynamic> body) async {
    final client = HttpClient();
    try {
      final uri = Uri.parse('$url?key=$_apiKey');
      final request = await client.postUrl(uri);
      
      request.headers.set('Content-Type', 'application/json');
      request.add(utf8.encode(jsonEncode(body)));

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode != 200) {
        debugPrint('[AI Service] HTTP ${response.statusCode}: $responseBody');
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
          'parts': [{'text': instruction}]
        }
      ]
    };
    final response = await _post(_geminiUrl, payload);
    return response['candidates'][0]['content']['parts'][0]['text'] as String;
  }

  String _buildStructuralPrompt({
    required String userPrompt,
    required DocumentType documentType,
    required UserContext context,
  }) {
    return '''
You are an expert business designer and PDF-optimized HTML engineer.

BUSINESS CONTEXT:
- Company: ${context.companyName}
- Mission: ${context.mission}
- Colors: ${context.brandColors.join(', ')}

DOCUMENT TYPE: ${documentType.name}
USER REQUEST: $userPrompt

TECHNICAL REQUIREMENTS FOR PDF RENDERING:
1. Output ONLY raw HTML with 100% inline CSS.
2. IMPORTANT: Use Flexbox or Standard HTML Tables for layout. AVOID 'display: grid' as it causes rendering hangs in mobile PDF engines.
3. Keep the design aesthetically pleasing, minimal, and premium. Use ample white space.
4. Avoid complex CSS filters, blurs, or heavy box-shadows.
5. Use professional typography (serif for headers, sans-serif for body).
6. Ensure all content is within A4 bounds.
7. Return only the HTML starting with <!DOCTYPE html>.
''';
  }

  String _stripMarkdownFences(String raw) {
    return raw
        .replaceAll(RegExp(r'^```html\s*', multiLine: true), '')
        .replaceAll(RegExp(r'^```\s*', multiLine: true), '')
        .trim();
  }
}
