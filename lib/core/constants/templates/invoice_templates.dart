import '../../../models/document_asset.dart';
import '../../../models/document_template.dart';

abstract class InvoiceTemplates {
  static const List<DocumentTemplate> templates = [
    DocumentTemplate(
      id: 'inv-modern',
      name: 'Modern Minimal',
      description: 'Clean layout with subtle accents.',
      type: DocumentType.invoice,
      promptInstructions: 'Use a modern minimalist style. High contrast between headers and body. Large, clear "INVOICE" title at the top right. Compact item table with light grey zebra stripping.',
    ),
    DocumentTemplate(
      id: 'inv-classic',
      name: 'Corporate Classic',
      description: 'Traditional structured grid.',
      type: DocumentType.invoice,
      promptInstructions: 'Use a formal corporate style. Heavy borders on the item table. Company details on the left, client details on the right. Explicit sections for payment terms and notes at the bottom.',
    ),
    DocumentTemplate(
      id: 'inv-bold',
      name: 'Bold Accent',
      description: 'Striking design with brand colors.',
      type: DocumentType.invoice,
      promptInstructions: 'Use bold typography and brand color backgrounds for table headers. Logo should be large and centered. Total amount should be highlighted in a colored box.',
    ),
    DocumentTemplate(
      id: 'inv-service',
      name: 'Service Fee',
      description: 'Optimized for consultancy and hours.',
      type: DocumentType.invoice,
      promptInstructions: 'Focus on time-tracking and service descriptions. Include columns for Date, Hours, and Rate. Use a clean, professional sans-serif font throughout.',
    ),
    DocumentTemplate(
      id: 'inv-simple',
      name: 'Simple List',
      description: 'No tables, just a clean itemized list.',
      type: DocumentType.invoice,
      promptInstructions: 'Avoid heavy borders. Use a list-based layout for items with subtle horizontal separators. Ideal for small sales or single-service billing.',
    ),
    DocumentTemplate(
      id: 'inv-luxury',
      name: 'High-End Luxury',
      description: 'Elegant serif fonts and gold/dark accents.',
      type: DocumentType.invoice,
      promptInstructions: 'Use premium serif fonts for headers. Incorporate subtle gold or charcoal accents. Ample white space. Small, elegant logo placement.',
    ),
  ];
}
