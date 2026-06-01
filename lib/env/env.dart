// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', obfuscate: true, randomSeed: 42)
abstract class Env {
  @EnviedField(varName: 'GEMINI_API_KEY')
  static final String geminiApiKey = _Env.geminiApiKey;

  @EnviedField(varName: 'PDF_ENGINE_URL')
  static final String pdfEngineUrl = _Env.pdfEngineUrl;

  @EnviedField(varName: 'PDF_ENGINE_API_KEY')
  static final String pdfEngineApiKey = _Env.pdfEngineApiKey;

  @EnviedField(varName: 'REVENUECAT_ANDROID_KEY')
  static final String revenueCatAndroidKey = _Env.revenueCatAndroidKey;

  @EnviedField(varName: 'REVENUECAT_IOS_KEY')
  static final String revenueCatIosKey = _Env.revenueCatIosKey;
}
