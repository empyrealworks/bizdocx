import '../../../models/document_asset.dart';
import '../../../models/document_template.dart';

abstract class LetterheadTemplates {
  static const List<DocumentTemplate> templates = [
    DocumentTemplate(
      id: 'lh-centered',
      name: 'Centered Authority',
      description: 'Balanced centered logo.',
      type: DocumentType.letterhead,
      supportsOrientation: false,
      promptInstructions: 'Center the company logo at the top. Place contact details in a thin footer. Maintain wide margins for the body text.',
    ),
    DocumentTemplate(
      id: 'lh-sidebar',
      name: 'Modern Sidebar',
      description: 'Contact info in left margin.',
      type: DocumentType.letterhead,
      supportsOrientation: false,
      promptInstructions: 'Place logo in the top left. Create a vertical sidebar on the left containing company address, phone, and email. Main body area is shifted to the right.',
    ),
    DocumentTemplate(
      id: 'lh-minimal-header',
      name: 'Minimal Header',
      description: 'Single line header details.',
      type: DocumentType.letterhead,
      supportsOrientation: false,
      promptInstructions: 'Logo on the far left, company contact details on the far right in a small font. A single horizontal line separates the header from the body.',
    ),
    DocumentTemplate(
      id: 'lh-cornered',
      name: 'Top-Right Accent',
      description: 'Modern offset layout.',
      type: DocumentType.letterhead,
      supportsOrientation: false,
      promptInstructions: 'Place the logo in the top right. Contact details should be subtle and right-aligned. A very clean, asymmetrical layout.',
    ),
  ];
}
