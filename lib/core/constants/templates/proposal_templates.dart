import '../../../models/document_asset.dart';
import '../../../models/document_template.dart';

abstract class ProposalTemplates {
  static const List<DocumentTemplate> templates = [
    DocumentTemplate(
      id: 'prop-executive',
      name: 'Executive Summary',
      description: 'Professional high-level layout.',
      type: DocumentType.proposal,
      promptInstructions: 'Formal and concise. Focus on clear headings and bullet points. Include an executive summary section, scope of work, and pricing table.',
    ),
    DocumentTemplate(
      id: 'prop-creative',
      name: 'Creative Pitch',
      description: 'Visual-heavy artistic flair.',
      type: DocumentType.proposal,
      promptInstructions: 'Use an artistic and airy layout. Larger fonts for key value propositions. Use brand colors for decorative elements like sidebar borders or underline accents.',
    ),
    DocumentTemplate(
      id: 'prop-technical',
      name: 'Technical Detailed',
      description: 'Structured for complex projects.',
      type: DocumentType.proposal,
      promptInstructions: 'Focus on hierarchy and clarity. Numbered sections. Detailed tables for milestones and deliverables. Technical specification sections.',
    ),
    DocumentTemplate(
      id: 'prop-startup',
      name: 'Startup Pitch',
      description: 'Modern, energetic, and concise.',
      type: DocumentType.proposal,
      promptInstructions: 'Use bold typography and a modern, energetic feel. Include sections for "The Problem", "The Solution", and "Market Opportunity".',
    ),
    DocumentTemplate(
      id: 'prop-roadmap',
      name: 'Project Roadmap',
      description: 'Focus on timelines and phases.',
      type: DocumentType.proposal,
      promptInstructions: 'Visualize the project timeline clearly. Use a structured, phase-by-phase layout. Emphasize milestones and delivery dates.',
    ),
  ];
}
