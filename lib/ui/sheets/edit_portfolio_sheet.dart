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

class _EditPortfolioSheetState
    extends ConsumerState<EditPortfolioSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _missionCtrl;
  late final TextEditingController _audienceCtrl;
  late final TextEditingController _colorCtrl;
  
  late final TextEditingController _addressCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _webCtrl;
  late final TextEditingController _countryCtrl;
  late final TextEditingController _currencyCtrl;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final p = widget.portfolio;
    _nameCtrl     = TextEditingController(text: p.name);
    _descCtrl     = TextEditingController(text: p.description);
    _missionCtrl  = TextEditingController(text: p.mission);
    _audienceCtrl = TextEditingController(text: p.targetAudience);
    _colorCtrl    = TextEditingController(text: p.brandColors.join(', '));
    
    _addressCtrl  = TextEditingController(text: p.businessAddress);
    _emailCtrl    = TextEditingController(text: p.businessEmail);
    _phoneCtrl    = TextEditingController(text: p.businessPhone);
    _webCtrl      = TextEditingController(text: p.website);
    _countryCtrl  = TextEditingController(text: p.country);
    _currencyCtrl = TextEditingController(text: p.defaultCurrency);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _missionCtrl.dispose();
    _audienceCtrl.dispose();
    _colorCtrl.dispose();
    _addressCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _webCtrl.dispose();
    _countryCtrl.dispose();
    _currencyCtrl.dispose();
    super.dispose();
  }

  Future<void> _update() async {
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
      brandColors: colors,
      targetAudience: _audienceCtrl.text.trim(),
      businessAddress: _addressCtrl.text.trim(),
      businessEmail: _emailCtrl.text.trim(),
      businessPhone: _phoneCtrl.text.trim(),
      website: _webCtrl.text.trim(),
      country: _countryCtrl.text.trim(),
      defaultCurrency: _currencyCtrl.text.trim(),
    );

    await ref
        .read(portfolioNotifierProvider.notifier)
        .updatePortfolio(updated);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final c     = context.colors;
    final state = ref.watch(portfolioNotifierProvider);
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottom),
            children: [
              Row(children: [
                Text('Edit Business',
                    style: Theme.of(context).textTheme.headlineMedium),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.close, color: c.iconSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ]),
              const SizedBox(height: 24),
              
              _SectionLabel('Basic Info'),
              const SizedBox(height: 12),
              _field(_nameCtrl, 'Business Name *',
                  validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 12),
              _field(_descCtrl, 'Short Description'),
              const SizedBox(height: 12),
              _field(_missionCtrl, 'Mission Statement', maxLines: 2),
              
              const SizedBox(height: 24),
              _SectionLabel('Contact & Identity'),
              const SizedBox(height: 12),
              _field(_addressCtrl, 'Physical Address', maxLines: 2),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _field(_emailCtrl, 'Business Email', keyboardType: TextInputType.emailAddress)),
                  const SizedBox(width: 12),
                  Expanded(child: _field(_phoneCtrl, 'Phone Number', keyboardType: TextInputType.phone)),
                ],
              ),
              const SizedBox(height: 12),
              _field(_webCtrl, 'Website'),
              
              const SizedBox(height: 24),
              _SectionLabel('Localization'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _field(_countryCtrl, 'Country')),
                  const SizedBox(width: 12),
                  Expanded(child: _field(_currencyCtrl, 'Default Currency')),
                ],
              ),
              
              const SizedBox(height: 24),
              _SectionLabel('Branding'),
              const SizedBox(height: 12),
              _field(_colorCtrl, 'Brand Colors (comma-separated hex)'),
              const SizedBox(height: 12),
              _field(_audienceCtrl, 'Target Audience'),
              
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: state.isLoading ? null : _update,
                  child: state.isLoading
                      ? const SizedBox(
                          height: 20, width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Update Portfolio', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _SectionLabel(String text) => Text(
    text.toUpperCase(),
    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1, color: Colors.grey),
  );

  Widget _field(TextEditingController ctrl, String hint,
      {int maxLines = 1, String? Function(String?)? validator, TextInputType? keyboardType}) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      validator: validator,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(hintText: hint, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
    );
  }
}
