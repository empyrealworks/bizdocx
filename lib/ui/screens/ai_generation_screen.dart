import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../models/document_asset.dart';
import '../../providers/document_generation_provider.dart';
import '../widgets/generation_state_overlay.dart';

class AiGenerationScreen extends ConsumerStatefulWidget {
  const AiGenerationScreen({super.key, required this.portfolioId});
  final String portfolioId;

  @override
  ConsumerState<AiGenerationScreen> createState() =>
      _AiGenerationScreenState();
}

class _AiGenerationScreenState extends ConsumerState<AiGenerationScreen> {
  final _promptCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  DocumentType _selectedType = DocumentType.invoice;
  AssetPipeline _selectedPipeline = AssetPipeline.structural;

  @override
  void dispose() {
    _promptCtrl.dispose();
    _titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    FocusScope.of(context).unfocus();

    if (_promptCtrl.text.trim().isEmpty || _titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title and prompt.')),
      );
      return;
    }

    final notifier =
    ref.read(documentGenerationProvider(widget.portfolioId).notifier);
    await Future.delayed(const Duration(milliseconds: 300));

    final asset = await notifier.generate(
      prompt: _promptCtrl.text.trim(),
      type: _selectedType,
      pipeline: _selectedPipeline,
      title: _titleCtrl.text.trim(),
    );

    if (asset != null && mounted) {
      context.go(
        '/portfolio/${widget.portfolioId}/doc/${asset.id}',
        extra: asset,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final genState =
    ref.watch(documentGenerationProvider(widget.portfolioId));

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Generate Document'),
            leading: BackButton(
              onPressed: () =>
                  context.go('/portfolio/${widget.portfolioId}'),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionLabel('Document Type'),
                const SizedBox(height: 12),
                _TypeSelector(
                  selected: _selectedType,
                  pipeline: _selectedPipeline,
                  onTypeChanged: (t) =>
                      setState(() => _selectedType = t),
                  onPipelineChanged: (p) =>
                      setState(() => _selectedPipeline = p),
                ),
                const SizedBox(height: 24),
                _SectionLabel('Document Title'),
                const SizedBox(height: 12),
                TextField(
                  controller: _titleCtrl,
                  decoration: InputDecoration(
                    hintText: _titleHint(_selectedType),
                  ),
                ),
                const SizedBox(height: 24),
                _SectionLabel('Prompt'),
                const SizedBox(height: 8),
                Text(
                  'Describe what you need. Your business context is automatically included.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _promptCtrl,
                  maxLines: 7,
                  decoration: InputDecoration(
                    hintText: _promptHint(_selectedType),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: genState.isLoading ? null : _generate,
                  icon: const Icon(Icons.auto_awesome, size: 18),
                  label: const Text('Generate'),
                ),
                const SizedBox(height: 20),
                // External editing note (for content-heavy types)
                if (_externalEditNote(_selectedType) != null)
                  _ExternalEditBanner(note: _externalEditNote(_selectedType)!),
                // Document field hints
                _DocumentHints(type: _selectedType),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        if (genState.isLoading)
          GenerationStateOverlay(
            phase: genState.phase,
            onCancel: () => ref
                .read(documentGenerationProvider(widget.portfolioId).notifier)
                .cancel(),
          ),
        if (genState.hasError)
          _ErrorOverlay(
            error: genState.error.toString(),
            onDismiss: () => ref
                .read(documentGenerationProvider(widget.portfolioId).notifier)
                .reset(),
          ),
        if (genState.isCancelled)
          _CancelledOverlay(
            onDismiss: () => ref
                .read(documentGenerationProvider(widget.portfolioId).notifier)
                .reset(),
          ),
      ],
    );
  }

  String _titleHint(DocumentType t) {
    switch (t) {
      case DocumentType.invoice:
        return 'e.g. Invoice for Acme Corp — June 2025';
      case DocumentType.proposal:
        return 'e.g. Web Redesign Proposal — Luxe Retail';
      case DocumentType.letterhead:
        return 'e.g. Official Letterhead Template';
      case DocumentType.businessCard:
        return 'e.g. Business Card — John Doe';
      case DocumentType.contract:
        return 'e.g. Service Agreement — Q3 2025';
      case DocumentType.logo:
        return 'e.g. Primary Logo Concept';
      case DocumentType.icon:
        return 'e.g. App Icon — Blue Minimal';
      case DocumentType.other:
        return 'e.g. Company Profile Sheet';
    }
  }

  String _promptHint(DocumentType t) {
    switch (t) {
      case DocumentType.invoice:
        return 'e.g. Invoice for 200 units of blue ceramic vases at \$45 each. Bill to: Luxe Home Décor Ltd. Due in 30 days. Include 7.5% VAT.';
      case DocumentType.proposal:
        return 'e.g. Proposal for a full website redesign including UX audit, 5 pages, and CMS integration. Project timeline: 8 weeks. Budget: \$12,000.';
      case DocumentType.letterhead:
        return 'e.g. Create a formal letterhead template with our logo placeholder, contact details section, and signature line at the bottom.';
      case DocumentType.businessCard:
        return 'e.g. Business card for Sarah Mitchell, Head of Sales. Include email sarah@company.com, phone +1 555 0123, and LinkedIn handle.';
      case DocumentType.contract:
        return 'e.g. Service agreement template for freelance design services. Include scope, payment terms, IP ownership clause, and termination notice period.';
      case DocumentType.logo:
        return 'e.g. A modern minimalist logo for a ceramics brand. Use earth tones. Incorporate a subtle wave or vessel shape.';
      case DocumentType.icon:
        return 'e.g. A clean app icon for a document management app. Blue and white palette. Flat design with a subtle paper/fold motif.';
      case DocumentType.other:
        return 'e.g. A one-page company profile with our mission, key services, team size, and founding year.';
    }
  }

  String? _externalEditNote(DocumentType t) {
    switch (t) {
      case DocumentType.contract:
        return 'Contracts require specific legal language and review. BizDocx generates the structure and standard clauses — export as HTML and complete the specifics in Word or Google Docs before signing.';
      case DocumentType.letterhead:
        return 'This generates a reusable branded template. Export it and add your letter body content in Word or Google Docs each time you write.';
      default:
        return null;
    }
  }
}

// ── External Edit Banner ─────────────────────────────────────────────────────

class _ExternalEditBanner extends StatelessWidget {
  const _ExternalEditBanner({required this.note});
  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1A00),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF4A4200)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.tips_and_updates_outlined,
              size: 16, color: Color(0xFFFFD60A)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(note,
                style: const TextStyle(
                    color: Color(0xFFFFD60A),
                    fontSize: 12,
                    height: 1.5)),
          ),
        ],
      ),
    );
  }
}

// ── Document Hints ────────────────────────────────────────────────────────────

class _DocumentHints extends StatefulWidget {
  const _DocumentHints({required this.type});
  final DocumentType type;

  @override
  State<_DocumentHints> createState() => _DocumentHintsState();
}

class _DocumentHintsState extends State<_DocumentHints> {
  bool _expanded = true;

  static const _hints = <DocumentType, List<String>>{
    DocumentType.invoice: [
      '🏢  Client name & billing address',
      '📦  Line items: description, quantity, unit price',
      '💰  Currency & total amount',
      '🏦  Your payment / bank account details',
      '📅  Invoice date & due date',
      '🔢  Invoice or PO number',
      '🧾  Tax rate (e.g. VAT 7.5%)',
    ],
    DocumentType.proposal: [
      '🎯  Project scope & objectives',
      '📋  Deliverables & milestones',
      '⏱  Estimated timeline',
      '💵  Pricing breakdown or range',
      '✅  Terms & acceptance conditions',
      '👤  Your credentials or portfolio link',
    ],
    DocumentType.letterhead: [
      '🏢  Company name & registered address',
      '📞  Phone, email & website',
      '🎨  Brand color preference',
      '🖼  Logo placement (top-left, centre, etc.)',
      '📝  Optional tagline or slogan',
    ],
    DocumentType.businessCard: [
      '👤  Full name & job title',
      '📧  Email address',
      '📞  Phone number',
      '🌐  Website or LinkedIn URL',
      '🏢  Company name & address (optional)',
      '🎨  Style preference (minimal, bold, etc.)',
    ],
    DocumentType.contract: [
      '👥  Parties involved (full legal names)',
      '📋  Scope of services or work',
      '💰  Payment terms & schedule',
      '📅  Start date & duration',
      '⚖️  Governing law / jurisdiction',
      '🔒  IP ownership & confidentiality clauses',
      '🚪  Termination notice period',
    ],
    DocumentType.logo: [
      '🏢  Business name (exact spelling)',
      '🎨  Brand colors (hex codes if possible)',
      '✏️  Style: wordmark, lettermark, emblem, or combo mark',
      '💡  Mood: minimal, bold, playful, luxury, etc.',
      '🔍  Industry & any symbol ideas',
    ],
    DocumentType.icon: [
      '🔷  Concept or metaphor (e.g. speed, security, nature)',
      '🎨  Color palette preference',
      '✏️  Style: flat, gradient, outline, 3D',
      '📐  Platform: iOS, Android, Web favicon',
      '📏  Background: solid, transparent',
    ],
    DocumentType.other: [
      '📄  Document purpose & audience',
      '📋  Key sections to include',
      '🎨  Tone: formal, friendly, technical',
      '📏  Approximate length or page count',
    ],
  };

  @override
  Widget build(BuildContext context) {
    final hints = _hints[widget.type] ?? [];
    if (hints.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.graphite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
              child: Row(
                children: [
                  const Icon(Icons.checklist_rtl_rounded,
                      size: 16, color: AppColors.silver),
                  const SizedBox(width: 8),
                  Text(
                    'Suggested fields for ${_typeLabel(widget.type)}',
                    style: const TextStyle(
                      color: AppColors.silver,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: AppColors.muted,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            Divider(height: 1, color: AppColors.border),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Include these in your prompt for best results:',
                    style: const TextStyle(
                        color: AppColors.muted, fontSize: 11),
                  ),
                  const SizedBox(height: 10),
                  ...hints.map((h) => Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Text(h,
                        style: const TextStyle(
                            color: AppColors.silver,
                            fontSize: 13,
                            height: 1.3)),
                  )),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _typeLabel(DocumentType t) {
    switch (t) {
      case DocumentType.invoice: return 'Invoice';
      case DocumentType.proposal: return 'Proposal';
      case DocumentType.letterhead: return 'Letterhead';
      case DocumentType.businessCard: return 'Business Card';
      case DocumentType.contract: return 'Contract';
      case DocumentType.logo: return 'Logo';
      case DocumentType.icon: return 'Icon';
      case DocumentType.other: return 'Other';
    }
  }
}

// ── Supporting Widgets ────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: Theme.of(context).textTheme.labelSmall,
  );
}

class _TypeSelector extends StatelessWidget {
  const _TypeSelector({
    required this.selected,
    required this.pipeline,
    required this.onTypeChanged,
    required this.onPipelineChanged,
  });

  final DocumentType selected;
  final AssetPipeline pipeline;
  final ValueChanged<DocumentType> onTypeChanged;
  final ValueChanged<AssetPipeline> onPipelineChanged;

  static const _structural = [
    DocumentType.invoice,
    DocumentType.proposal,
    DocumentType.letterhead,
    DocumentType.businessCard,
    DocumentType.contract,
    DocumentType.other,
  ];
  static const _graphical = [DocumentType.logo, DocumentType.icon];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: AssetPipeline.values.map((p) {
            final active = pipeline == p;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  onPipelineChanged(p);
                  if (p == AssetPipeline.structural &&
                      _graphical.contains(selected)) {
                    onTypeChanged(DocumentType.invoice);
                  } else if (p == AssetPipeline.graphical &&
                      !_graphical.contains(selected)) {
                    onTypeChanged(DocumentType.logo);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  margin: EdgeInsets.only(
                      right: p == AssetPipeline.structural ? 6 : 0),
                  decoration: BoxDecoration(
                    color: active ? AppColors.white : AppColors.graphite,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      p == AssetPipeline.structural
                          ? 'Structural'
                          : 'Graphical',
                      style: TextStyle(
                        color: active ? AppColors.black : AppColors.silver,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: (pipeline == AssetPipeline.structural
              ? _structural
              : _graphical)
              .map((t) {
            final active = selected == t;
            return GestureDetector(
              onTap: () => onTypeChanged(t),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: active ? AppColors.white : AppColors.graphite,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: active ? AppColors.white : AppColors.border,
                  ),
                ),
                child: Text(
                  _label(t),
                  style: TextStyle(
                    color: active ? AppColors.black : AppColors.silver,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _label(DocumentType t) {
    switch (t) {
      case DocumentType.invoice: return 'Invoice';
      case DocumentType.proposal: return 'Proposal';
      case DocumentType.letterhead: return 'Letterhead';
      case DocumentType.businessCard: return 'Business Card';
      case DocumentType.contract: return 'Contract';
      case DocumentType.logo: return 'Logo';
      case DocumentType.icon: return 'Icon';
      case DocumentType.other: return 'Other';
    }
  }
}

class _ErrorOverlay extends StatelessWidget {
  const _ErrorOverlay({required this.error, required this.onDismiss});
  final String error;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: Colors.black87,
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline,
                    color: AppColors.error, size: 36),
                const SizedBox(height: 16),
                Text('Generation Failed',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(error,
                    style: const TextStyle(
                        color: AppColors.error, fontSize: 13),
                    textAlign: TextAlign.center),
                const SizedBox(height: 20),
                FilledButton(
                    onPressed: onDismiss, child: const Text('Dismiss')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CancelledOverlay extends StatelessWidget {
  const _CancelledOverlay({required this.onDismiss});
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: Colors.black87,
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cancel_outlined,
                    color: AppColors.silver, size: 36),
                const SizedBox(height: 16),
                Text('Generation Cancelled',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                const Text('The operation was cancelled by the user.',
                    style: TextStyle(color: AppColors.muted, fontSize: 14),
                    textAlign: TextAlign.center),
                const SizedBox(height: 20),
                FilledButton(
                    onPressed: onDismiss, child: const Text('Dismiss')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}