import '../../../models/document_asset.dart';
import '../../../models/document_template.dart';

abstract class ContractTemplates {
  static const List<DocumentTemplate> templates = [
    DocumentTemplate(
      id: 'con-standard',
      name: 'Standard Legal',
      description: 'Clear numbered clauses.',
      type: DocumentType.contract,
      promptInstructions: 'Use a formal legal font (e.g., serif). Numbered sections (1.0, 1.1). Defined terms in bold. Clear signature blocks at the end.',
    ),
    DocumentTemplate(
      id: 'con-modern',
      name: 'Plain English',
      description: 'Readable modern agreement.',
      type: DocumentType.contract,
      promptInstructions: 'Use a clean sans-serif font. Use friendly but professional language. Use boxes to highlight key terms like payment or scope.',
    ),
    DocumentTemplate(
      id: 'con-simple',
      name: 'Simple One-Page',
      description: 'Efficient minor engagement layout.',
      type: DocumentType.contract,
      promptInstructions: 'Keep it to a single page. Group related terms together. Efficient use of space while maintaining readability.',
    ),
    DocumentTemplate(
      id: 'con-nda',
      name: 'NDA / Confidentiality',
      description: 'Focused on IP and secrets.',
      type: DocumentType.contract,
      promptInstructions: 'Strict formal layout. Clear definitions of "Confidential Information". Emphasize obligations and duration of secrecy.',
    ),
    DocumentTemplate(
      id: 'con-sow',
      name: 'Statement of Work',
      description: 'Detail-heavy project scope.',
      type: DocumentType.contract,
      promptInstructions: 'Focus on deliverables, milestones, and acceptance criteria. Use tables for technical specifications and project schedules.',
    ),
  ];
}
