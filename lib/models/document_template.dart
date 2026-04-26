import 'package:freezed_annotation/freezed_annotation.dart';
import 'document_asset.dart';

part 'document_template.freezed.dart';

@freezed
abstract class DocumentTemplate with _$DocumentTemplate {
  const factory DocumentTemplate({
    required String id,
    required String name,
    required String description,
    required DocumentType type,
    required String promptInstructions,
    String? sampleImageUrl, // URL or Storage path for the sample image
    @Default([]) List<String> supportedAspectRatios,
    @Default(true) bool supportsOrientation,
  }) = _DocumentTemplate;
}
