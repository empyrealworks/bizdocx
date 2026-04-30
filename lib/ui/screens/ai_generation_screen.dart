import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/templates/document_templates.dart';
import '../../core/extensions/context_extensions.dart';
import '../../models/document_asset.dart';
import '../../models/document_template.dart';
import '../../models/user_profile.dart';
import '../../providers/document_generation_provider.dart';
import '../../providers/profile_provider.dart';
import '../../services/firebase_service.dart';
import '../widgets/generation_state_overlay.dart';
import '../widgets/template_thumbnails.dart';

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
  
  DocumentTemplate? _selectedTemplate;
  String _selectedOrientation = 'portrait';
  String _selectedAspectRatio = '1:1';

  @override
  void initState() {
    super.initState();
    _updateDefaultTemplate();
  }

  void _updateDefaultTemplate() {
    final templates = DocumentTemplates.getByType(_selectedType);
    if (templates.isNotEmpty) {
      _selectedTemplate = templates.first;
      if (_selectedTemplate!.supportedAspectRatios.isNotEmpty) {
        _selectedAspectRatio = _selectedTemplate!.supportedAspectRatios.first;
      }
    } else {
      _selectedTemplate = null;
    }
  }

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

    final fb = FirebaseService.instance;
    final profile = await fb.fetchProfile();
    
    if (_selectedTemplate?.isPremium == true && profile.isFree) {
      _showUpgradePrompt('Premium Template', 'This template is only available for Solopreneur and Agency users. Upgrade now to unlock professional designs and remove watermarks.');
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
      template: _selectedTemplate,
      orientation: _selectedOrientation,
      aspectRatio: _selectedAspectRatio,
    );

    if (asset != null && mounted) {
      context.go(
        '/portfolio/${widget.portfolioId}/doc/${asset.id}',
        extra: asset,
      );
    }
  }

  void _showUpgradePrompt(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Maybe Later')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.push('/settings/subscription');
            },
            child: const Text('View Plans'),
          ),
        ],
      ),
    );
  }

  int get _currentCost {
    if (_selectedPipeline == AssetPipeline.structural) {
      return CreditCosts.getDocCost(_selectedType);
    } else {
      return CreditCosts.imageDraft;
    }
  }

  @override
  Widget build(BuildContext context) {
    final genState = ref.watch(documentGenerationProvider(widget.portfolioId));
    final profile = ref.watch(userProfileProvider).value;
    // final c = context.colors;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Generate Asset'),
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
                if (profile != null && profile.totalCredits < 150)
                   _LowBalanceWarning(balance: profile.totalCredits),
                
                _SectionLabel('Category'),
                const SizedBox(height: 12),
                _TypeSelector(
                  selected: _selectedType,
                  pipeline: _selectedPipeline,
                  onTypeChanged: (t) {
                    setState(() {
                      _selectedType = t;
                      _updateDefaultTemplate();
                    });
                  },
                  onPipelineChanged: (p) =>
                      setState(() => _selectedPipeline = p),
                ),
                const SizedBox(height: 24),
                
                _SectionLabel('Style Template'),
                const SizedBox(height: 12),
                _TemplatePicker(
                  templates: DocumentTemplates.getByType(_selectedType),
                  selected: _selectedTemplate,
                  onSelected: (t) {
                    setState(() {
                      _selectedTemplate = t;
                      if (t.supportedAspectRatios.isNotEmpty && !t.supportedAspectRatios.contains(_selectedAspectRatio)) {
                         _selectedAspectRatio = t.supportedAspectRatios.first;
                      }
                    });
                  },
                ),
                const SizedBox(height: 24),

                if (_selectedTemplate?.supportsOrientation ?? false) ...[
                  _SectionLabel('Orientation'),
                  const SizedBox(height: 12),
                  _OrientationPicker(
                    selected: _selectedOrientation,
                    onChanged: (o) => setState(() => _selectedOrientation = o),
                  ),
                  const SizedBox(height: 24),
                ],

                if (_selectedTemplate?.supportedAspectRatios.isNotEmpty ?? false) ...[
                   _SectionLabel('Aspect Ratio'),
                   const SizedBox(height: 12),
                   _AspectRatioPicker(
                     ratios: _selectedTemplate!.supportedAspectRatios,
                     selected: _selectedAspectRatio,
                     onChanged: (r) => setState(() => _selectedAspectRatio = r),
                   ),
                   const SizedBox(height: 24),
                ],

                _SectionLabel('Asset Title'),
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
                  'Describe specific details. The style and context are applied automatically.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _promptCtrl,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: _promptHint(_selectedType),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton.icon(
                    onPressed: genState.isLoading ? null : _generate,
                    icon: const Icon(Icons.auto_awesome, size: 18),
                    label: Text('Generate ($_currentCost Credits)', style: const TextStyle(fontWeight: FontWeight.bold),),
                  ),
                ),
                const SizedBox(height: 20),
                if (_externalEditNote(_selectedType) != null)
                  _ExternalEditBanner(note: _externalEditNote(_selectedType)!),
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
          _SmartErrorOverlay(
            error: genState.error.toString(),
            onDismiss: () => ref
                .read(documentGenerationProvider(widget.portfolioId).notifier)
                .reset(),
            onUpgrade: () {
               ref.read(documentGenerationProvider(widget.portfolioId).notifier).reset();
               context.push('/settings/subscription');
            },
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
      case DocumentType.invoice: return 'e.g. Invoice for Acme Corp — June 2025';
      case DocumentType.proposal: return 'e.g. Web Redesign Proposal — Luxe Retail';
      case DocumentType.letterhead: return 'e.g. Official Letterhead Template';
      case DocumentType.businessCard: return 'e.g. Business Card — John Doe';
      case DocumentType.contract: return 'e.g. Service Agreement — Q3 2025';
      case DocumentType.logo: return 'e.g. Primary Logo Concept';
      case DocumentType.icon: return 'e.g. App Icon — Blue Minimal';
      case DocumentType.other: return 'e.g. Company Profile Sheet';
    }
  }

  String _promptHint(DocumentType t) {
    switch (t) {
      case DocumentType.invoice: return 'e.g. 200 units of ceramic vases at \$45 each. Bill to: Luxe Home Décor Ltd.';
      case DocumentType.proposal: return 'e.g. Full website redesign including UX audit, 5 pages. Timeline: 8 weeks.';
      case DocumentType.letterhead: return 'e.g. Formal template with contact details section and signature line.';
      case DocumentType.businessCard: return 'e.g. Sarah Mitchell, Head of Sales. sarah@company.com, +1 555 0123.';
      case DocumentType.contract: return 'e.g. Freelance design services. Include scope, payment terms, and IP clause.';
      case DocumentType.logo: return 'e.g. Modern minimalist for a ceramics brand. Use earth tones and vessel shapes.';
      case DocumentType.icon: return 'e.g. Clean app icon for document management. Blue/white, flat design.';
      case DocumentType.other: return 'e.g. One-page company profile with mission, services, and team size.';
    }
  }

  String? _externalEditNote(DocumentType t) {
    switch (t) {
      case DocumentType.contract:
        return 'Contracts require specific legal language. BizDocx generates the structure — export and complete specifics in Word or Google Docs.';
      case DocumentType.letterhead:
        return 'This generates a reusable branded template. Export it and add your letter body content separately.';
      default:
        return null;
    }
  }
}

class _LowBalanceWarning extends StatelessWidget {
  const _LowBalanceWarning({required this.balance});
  final int balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFF6B35).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFFF6B35), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Running low! ($balance credits remaining). Top up to avoid interruptions.',
              style: const TextStyle(color: Color(0xFFFF6B35), fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () => context.push('/settings/subscription'),
            child: const Text('Top Up', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}

// ── Template Picker ─────────────────────────────────────────────────────────

class _TemplatePicker extends ConsumerWidget {
  const _TemplatePicker({
    required this.templates,
    required this.selected,
    required this.onSelected,
  });

  final List<DocumentTemplate> templates;
  final DocumentTemplate? selected;
  final ValueChanged<DocumentTemplate> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (templates.isEmpty) return const Text('No templates available for this category.');
    final c = context.colors;

    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: templates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final t = templates[index];
          final isActive = selected?.id == t.id;
          
          return GestureDetector(
            onTap: () => onSelected(t),
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      TemplateThumbnail(
                        templateId: t.id,
                        type: t.type,
                        isSelected: isActive,
                      ),
                      if (t.isPremium)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD60A),
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star_rounded, size: 10, color: Colors.black),
                                SizedBox(width: 2),
                                Text('PRO', style: TextStyle(color: Colors.black, fontSize: 8, fontWeight: FontWeight.w900)),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  t.name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive ? c.filledButtonBg : c.textMuted,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Orientation Picker ──────────────────────────────────────────────────────

class _OrientationPicker extends StatelessWidget {
  const _OrientationPicker({required this.selected, required this.onChanged});
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: ['portrait', 'landscape'].map((o) {
        final active = selected == o;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(o),
            child: Container(
              margin: EdgeInsets.only(right: o == 'portrait' ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: active ? c.filledButtonBg : c.chipFill,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  o[0].toUpperCase() + o.substring(1),
                  style: TextStyle(
                    color: active ? c.filledButtonFg : c.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Aspect Ratio Picker ─────────────────────────────────────────────────────

class _AspectRatioPicker extends StatelessWidget {
  const _AspectRatioPicker({
    required this.ratios,
    required this.selected,
    required this.onChanged,
  });
  final List<String> ratios;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Wrap(
      spacing: 8,
      children: ratios.map((r) {
        final active = selected == r;
        return GestureDetector(
          onTap: () => onChanged(r),
          child: Chip(
            label: Text(r),
            backgroundColor: active ? c.filledButtonBg : c.chipFill,
            labelStyle: TextStyle(
              color: active ? c.filledButtonFg : c.textBody,
              fontSize: 12,
            ),
            side: BorderSide(color: active ? c.filledButtonBg : c.border),
          ),
        );
      }).toList(),
    );
  }
}

// ── External Edit Banner ─────────────────────────────────────────────────────

class _ExternalEditBanner extends StatelessWidget {
  const _ExternalEditBanner({required this.note});
  final String note;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final bgColor = isDark ? const Color(0xFF1C1A00) : const Color(0xFFFFFBE6);
    final borderColor = isDark ? const Color(0xFF4A4200) : const Color(0xFFFFE58F);
    final iconColor = isDark ? const Color(0xFFFFD60A) : const Color(0xFFFAAD14);
    final textColor = isDark ? const Color(0xFFFFD60A) : const Color(0xFF856404);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.tips_and_updates_outlined,
              size: 16, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(note,
                style: TextStyle(
                    color: textColor,
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
  bool _expanded = false;

  static const _hints = <DocumentType, List<String>>{
    DocumentType.invoice: [
      '🏢  Client name & billing address',
      '📦  Line items: description, quantity, unit price',
      '💰  Currency & total amount',
      '🏦  Your payment / bank account details',
      '📅  Invoice date & due date',
      '🧾  Tax rate (e.g. VAT 7.5%)',
    ],
    DocumentType.proposal: [
      '🎯  Project scope & objectives',
      '📋  Deliverables & milestones',
      '⏱  Estimated timeline',
      '💵  Pricing breakdown or range',
      '✅  Terms & acceptance conditions',
    ],
    DocumentType.letterhead: [
      '🏢  Company name & registered address',
      '📞  Phone, email & website',
      '🎨  Brand color preference',
      '🖼  Logo placement (top-left, centre, etc.)',
    ],
    DocumentType.businessCard: [
      '👤  Full name & job title',
      '📧  Email address',
      '📞  Phone number',
      '🌐  Website or LinkedIn URL',
    ],
    DocumentType.contract: [
      '👥  Parties involved (full legal names)',
      '📋  Scope of services or work',
      '💰  Payment terms & schedule',
      '📅  Start date & duration',
      '⚖️  Governing law / jurisdiction',
    ],
    DocumentType.logo: [
      '🏢  Business name (exact spelling)',
      '🎨  Brand colors (hex codes if possible)',
      '✏️  Style: wordmark, lettermark, emblem, or combo mark',
      '💡  Mood: minimal, bold, playful, luxury, etc.',
    ],
    DocumentType.icon: [
      '🔷  Concept or metaphor (e.g. speed, security, nature)',
      '🎨  Color palette preference',
      '✏️  Style: flat, gradient, outline, 3D',
    ],
  };

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final hints = _hints[widget.type] ?? [];
    if (hints.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: c.chipFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.border),
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
                  Icon(Icons.checklist_rtl_rounded,
                      size: 16, color: c.textSecondary),
                  const SizedBox(width: 8),
                  Text(
                    'Suggested fields for ${_typeLabel(widget.type)}',
                    style: TextStyle(
                      color: c.textSecondary,
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
                    color: c.textMuted,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            Divider(height: 1, color: c.border),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...hints.map((h) => Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Text(h,
                        style: TextStyle(
                            color: c.textBody,
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
    style: Theme.of(context).textTheme.labelSmall?.copyWith(
      letterSpacing: 1.2,
      fontWeight: FontWeight.bold,
      color: context.colors.textMuted,
    ),
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
    final c = context.colors;

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
                    color: active ? c.filledButtonBg : c.chipFill,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      p == AssetPipeline.structural
                          ? 'Structural'
                          : 'Graphical',
                      style: TextStyle(
                        color: active ? c.filledButtonFg : c.textMuted,
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
                  color: active ? c.filledButtonBg : c.chipFill,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: active ? c.filledButtonBg : c.border,
                  ),
                ),
                child: Text(
                  _label(t),
                  style: TextStyle(
                    color: active ? c.filledButtonFg : c.textBody,
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

class _SmartErrorOverlay extends StatelessWidget {
  const _SmartErrorOverlay({
    required this.error, 
    required this.onDismiss, 
    required this.onUpgrade
  });
  
  final String error;
  final VoidCallback onDismiss;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isLimitError = error.contains('limit') || error.contains('credits');
    
    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: c.overlayBarrier,
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: c.card,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isLimitError ? Icons.stars_rounded : Icons.error_outline,
                  color: isLimitError ? const Color(0xFFFFD60A) : AppColors.error, 
                  size: 48
                ),
                const SizedBox(height: 16),
                Text(
                  isLimitError ? 'Limit Reached' : 'Generation Failed',
                  style: Theme.of(context).textTheme.titleLarge
                ),
                const SizedBox(height: 12),
                Text(
                  error.replaceAll('Exception: ', ''),
                  style: TextStyle(
                      color: isLimitError ? c.textSecondary : AppColors.error, 
                      fontSize: 14,
                      height: 1.5
                  ),
                  textAlign: TextAlign.center
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onDismiss, 
                        child: const Text('Dismiss')
                      ),
                    ),
                    if (isLimitError) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: onUpgrade, 
                          style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFF6B35)),
                          child: const Text('View Plans')
                        ),
                      ),
                    ],
                  ],
                ),
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
    final c = context.colors;
    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: onDismiss,
        child: Container(
          color: c.overlayBarrier,
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(32),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: c.card,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cancel_outlined,
                      color: c.textMuted, size: 36),
                  const SizedBox(height: 16),
                  Text('Generation Cancelled',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('The operation was cancelled by the user.',
                      style: TextStyle(color: c.textMuted, fontSize: 14),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  FilledButton(
                      onPressed: onDismiss, child: const Text('Dismiss')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
