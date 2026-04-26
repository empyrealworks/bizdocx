import '../../../models/document_asset.dart';
import '../../../models/document_template.dart';

abstract class LogoTemplates {
  static const List<DocumentTemplate> templates = [
    DocumentTemplate(
      id: 'logo-minimal',
      name: 'Minimalist Mark',
      description: 'Simple shapes focus.',
      type: DocumentType.logo,
      promptInstructions: 'Focus on a single, clean icon or mark. Use flat design. Avoid gradients. High impact through simplicity.',
      supportedAspectRatios: ['1:1', '3:2', '2:3'],
    ),
    DocumentTemplate(
      id: 'logo-typography',
      name: 'Wordmark',
      description: 'Creative name treatment.',
      type: DocumentType.logo,
      promptInstructions: 'Primary focus is on the company name. Unique font treatment or custom lettering. Maybe a small integrated symbol.',
      supportedAspectRatios: ['3:1', '2:1', '1:1'],
    ),
    DocumentTemplate(
      id: 'logo-emblem',
      name: 'Classic Emblem',
      description: 'Enclosed seal designs.',
      type: DocumentType.logo,
      promptInstructions: 'Enclose the brand mark and text within a shape (circle, shield, hexagon). Professional, established, and traditional feel.',
      supportedAspectRatios: ['1:1'],
    ),
    DocumentTemplate(
      id: 'logo-monogram',
      name: 'Monogram / Initial',
      description: 'Stylish brand initials.',
      type: DocumentType.logo,
      promptInstructions: 'Combine the initials of the business name into a creative, stylized mark. Elegant and recognizable.',
      supportedAspectRatios: ['1:1'],
    ),
    DocumentTemplate(
      id: 'logo-tech',
      name: 'Modern Tech',
      description: 'Geometric and futuristic.',
      type: DocumentType.logo,
      promptInstructions: 'Use geometric patterns, sharp lines, and futuristic fonts. Suggests innovation, speed, and precision.',
      supportedAspectRatios: ['1:1', '3:2'],
    ),
  ];
}
