import '../../../models/document_asset.dart';
import '../../../models/document_template.dart';

abstract class BusinessCardTemplates {
  static const List<DocumentTemplate> templates = [
    DocumentTemplate(
      id: 'bc-minimal',
      name: 'Minimal Pro',
      description: 'Elegant white space usage.',
      type: DocumentType.businessCard,
      promptInstructions: 'Very clean design. Logo on one side, name and contact details on the other. Use a premium sans-serif font.',
      supportedAspectRatios: ['3.5:2', '2:3.5', '1:1'],
    ),
    DocumentTemplate(
      id: 'bc-geometric',
      name: 'Geometric Accent',
      description: 'Bold shapes and patterns.',
      type: DocumentType.businessCard,
      promptInstructions: 'Incorporate geometric shapes or patterns using brand colors. Dynamic placement of text, perhaps aligned to one edge.',
      supportedAspectRatios: ['3.5:2', '2:3.5'],
    ),
    DocumentTemplate(
      id: 'bc-classic',
      name: 'Executive Classic',
      description: 'Traditional centered layout.',
      type: DocumentType.businessCard,
      promptInstructions: 'Centered text layout. Logo at the top or left. High quality serif font for the name. Professional and trustworthy feel.',
      supportedAspectRatios: ['3.5:2'],
    ),
    DocumentTemplate(
      id: 'bc-vertical',
      name: 'Modern Vertical',
      description: 'Striking tall orientation.',
      type: DocumentType.businessCard,
      promptInstructions: 'Designed specifically for vertical orientation. Use a top-down information hierarchy. Place the logo at the top or bottom as a focal point.',
      supportedAspectRatios: ['2:3.5'],
    ),
    DocumentTemplate(
      id: 'bc-social',
      name: 'Social Focused',
      description: 'Emphasis on handles and QR.',
      type: DocumentType.businessCard,
      promptInstructions: 'Include clear icons and space for social media handles. Leave a dedicated spot for a QR code. Ideal for creators and modern brands.',
      supportedAspectRatios: ['3.5:2', '2:3.5', '1:1'],
    ),
  ];
}
