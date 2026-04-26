import '../../../models/document_asset.dart';
import '../../../models/document_template.dart';
import 'invoice_templates.dart';
import 'proposal_templates.dart';
import 'letterhead_templates.dart';
import 'business_card_templates.dart';
import 'contract_templates.dart';
import 'logo_templates.dart';
import 'icon_templates.dart';

class DocumentTemplates {
  static const List<DocumentTemplate> templates = [
    ...InvoiceTemplates.templates,
    ...ProposalTemplates.templates,
    ...LetterheadTemplates.templates,
    ...BusinessCardTemplates.templates,
    ...ContractTemplates.templates,
    ...LogoTemplates.templates,
    ...IconTemplates.templates,
  ];

  static List<DocumentTemplate> getByType(DocumentType type) {
    return templates.where((t) => t.type == type).toList();
  }
}
