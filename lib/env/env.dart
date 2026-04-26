// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', obfuscate: true, randomSeed: 42)
abstract class Env {
  @EnviedField(varName: 'GEMINI_API_KEY')
  static final String geminiApiKey = _Env.geminiApiKey;

  @EnviedField(varName: 'GEMINI_TEXT_MODEL')
  static final String geminiTextModel = _Env.geminiTextModel;

  @EnviedField(varName: 'GEMINI_VISION_MODEL')
  static final String geminiVisionModel = _Env.geminiVisionModel;

  @EnviedField(varName: 'PDF_ENGINE_URL')
  static final String pdfEngineUrl = _Env.pdfEngineUrl;
}
