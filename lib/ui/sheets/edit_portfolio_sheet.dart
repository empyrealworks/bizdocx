import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/context_extensions.dart';
import '../../models/business_portfolio.dart';
import '../../providers/portfolio_provider.dart';

class EditPortfolioSheet extends ConsumerStatefulWidget {
  const EditPortfolioSheet({super.key, required this.portfolio});
  final BusinessPortfolio portfolio;

  @override
  ConsumerState<EditPortfolioSheet> createState() =>
      _EditPortfolioSheetState();
}

class _EditPortfolioSheetState extends ConsumerState<EditPortfolioSheet> {
  final _formKey      = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _missionCtrl;
  late final TextEditingController _audienceCtrl;
  late final TextEditingController _colorCtrl;

  @override
  void initState() {
    super.initState();
    final p = widget.portfolio;
    _nameCtrl     = TextEditingController(text: p.name);
    _descCtrl     = TextEditingController(text: p.description);
    _missionCtrl  = TextEditingController(text: p.mission);
    _audienceCtrl = TextEditingController(text: p.targetAudience);
    _colorCtrl    = TextEditingController(text: p.brandColors.join(', '));
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _missionCtrl.dispose();
    _audienceCtrl.dispose();
    _colorCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final colors = _colorCtrl.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final updated = widget.portfolio.copyWith(
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      mission: _missionCtrl.text.trim(),
      targetAudience: _audienceCtrl.text.trim(),
      brandColors: colors,
    );

    await ref.read(portfolioNotifierProvider.notifier).updatePortfolio(updated);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final c     = context.colors;
    final state = ref.watch(portfolioNotifierProvider);
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottom),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Edit Business',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, color: c.iconSecondary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Context tip
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: c.chipFill,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: c.border),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 14, color: c.iconSecondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'More detail here = better AI-generated documents.',
                        style:
                        TextStyle(color: c.textBody, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _label(context, 'Business Name *'),
              const SizedBox(height: 6),
              _field(_nameCtrl, 'e.g. Acme Ceramics Ltd',
                  validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 14),
              _label(context, 'Short Description'),
              const SizedBox(height: 6),
              _field(_descCtrl,
                  'e.g. Premium handcrafted ceramics for modern homes'),
              const SizedBox(height: 14),
              _label(context, 'Mission Statement'),
              const SizedBox(height: 6),
              _field(_missionCtrl,
                  'e.g. To bring artisan craftsmanship into everyday life',
                  maxLines: 3),
              const SizedBox(height: 14),
              _label(context, 'Target Audience'),
              const SizedBox(height: 6),
              _field(_audienceCtrl,
                  'e.g. Interior designers and home décor retailers'),
              const SizedBox(height: 14),
              _label(context, 'Brand Colors (comma-separated hex)'),
              const SizedBox(height: 6),
              _field(_colorCtrl, 'e.g. #2C3E50, #E74C3C, #ECF0F1'),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: state.isLoading ? null : _save,
                child: state.isLoading
                    ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: c.filledButtonFg),
                )
                    : const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(BuildContext context, String text) => Text(
    text.toUpperCase(),
    style: TextStyle(
      color: context.colors.textMuted,
      fontSize: 10,
      letterSpacing: 0.8,
      fontWeight: FontWeight.w500,
    ),
  );

  Widget _field(TextEditingController ctrl, String hint,
      {int maxLines = 1, String? Function(String?)? validator}) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(hintText: hint),
    );
  }
}