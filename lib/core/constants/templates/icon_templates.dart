import '../../../models/document_asset.dart';
import '../../../models/document_template.dart';

abstract class IconTemplates {
  static const List<DocumentTemplate> templates = [
    DocumentTemplate(
      id: 'icon-flat',
      name: 'Modern Flat',
      description: 'Clean 2D icons.',
      type: DocumentType.icon,
      promptInstructions: 'Flat design, no shadows or gradients. Simple, recognizable metaphor. Solid background color.',
      supportedAspectRatios: ['1:1'],
    ),
    DocumentTemplate(
      id: 'icon-gradient',
      name: 'Vibrant Gradient',
      description: 'Smooth transitions.',
      type: DocumentType.icon,
      promptInstructions: 'Use a vibrant brand-color gradient for the background or the main symbol. Subtle depth but still modern.',
      supportedAspectRatios: ['1:1'],
    ),
    DocumentTemplate(
      id: 'icon-glyph',
      name: 'Minimal Glyph',
      description: 'Monochrome interface icon.',
      type: DocumentType.icon,
      promptInstructions: 'Single color glyph. Transparent background or simple solid background. Highly scalable and legible.',
      supportedAspectRatios: ['1:1'],
    ),
    DocumentTemplate(
      id: 'icon-glass',
      name: 'Glassmorphism',
      description: 'Frosty, layered effects.',
      type: DocumentType.icon,
      promptInstructions: 'Use translucent "frosted glass" layers with subtle shadows and bright accent colors. Very modern and premium.',
      supportedAspectRatios: ['1:1'],
    ),
    DocumentTemplate(
      id: 'icon-isometric',
      name: '3D Isometric',
      description: 'Depth and perspective.',
      type: DocumentType.icon,
      promptInstructions: 'Render the icon with a 3D isometric perspective. Shows depth and physical volume.',
      supportedAspectRatios: ['1:1'],
    ),
  ];
}
