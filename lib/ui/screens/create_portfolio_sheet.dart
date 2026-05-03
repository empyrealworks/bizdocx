import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../providers/portfolio_provider.dart';

class CreatePortfolioSheet extends ConsumerStatefulWidget {
  const CreatePortfolioSheet({super.key});

  @override
  ConsumerState<CreatePortfolioSheet> createState() =>
      _CreatePortfolioSheetState();
}

class _CreatePortfolioSheetState
    extends ConsumerState<CreatePortfolioSheet> {
  final _nameCtrl     = TextEditingController();
  final _descCtrl     = TextEditingController();
  final _missionCtrl  = TextEditingController();
  final _audienceCtrl = TextEditingController();
  final _colorCtrl    = TextEditingController();
  
  // New context fields
  final _addressCtrl  = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _phoneCtrl    = TextEditingController();
  final _webCtrl      = TextEditingController();
  final _countryCtrl  = TextEditingController(text: 'Nigeria');
  final _currencyCtrl = TextEditingController(text: 'NGN');

  final _formKey      = GlobalKey<FormState>();

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

  Future<void> _create() async {
    if (!_formKey.currentState!.validate()) return;
    final colors = _colorCtrl.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    try {
      final notifier = ref.read(portfolioNotifierProvider.notifier);
      await notifier.create(
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

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        final errorStr = e.toString();
        if (errorStr.contains('limit reached')) {
          _showUpgradePrompt(errorStr.replaceAll('Exception: ', ''));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorStr), backgroundColor: AppColors.error),
          );
        }
      }
    }
  }

  void _showUpgradePrompt(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Limit Reached'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Maybe Later')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Close sheet
              context.push('/settings/subscription');
            },
            child: const Text('View Plans'),
          ),
        ],
      ),
    );
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
              Row(
                children: [
                  Text('New Business',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, color: c.iconSecondary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Provide more details to help the AI generate smarter, localized documents.',
                style: TextStyle(color: c.textMuted, fontSize: 13),
              ),
              const SizedBox(height: 24),
              
              _SectionLabel('Basic Info'),
              const SizedBox(height: 12),
              _field(_nameCtrl, 'Business Name *',
                  validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 12),
              _field(_descCtrl, 'Short Description (e.g. Creative Design Agency)'),
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
              _field(_webCtrl, 'Website (e.g. www.empyreal.works)'),
              
              const SizedBox(height: 24),
              _SectionLabel('Localization'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _field(_countryCtrl, 'Country')),
                  const SizedBox(width: 12),
                  Expanded(child: _field(_currencyCtrl, 'Default Currency (e.g. NGN)')),
                ],
              ),
              
              const SizedBox(height: 24),
              _SectionLabel('Branding'),
              const SizedBox(height: 12),
              _field(_colorCtrl, 'Brand Colors (comma-separated hex, e.g. #FF6B35, #28A99E)'),
              const SizedBox(height: 12),
              _field(_audienceCtrl, 'Target Audience (e.g. Small business owners)'),
              
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: state.isLoading ? null : _create,
                  child: state.isLoading
                      ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: c.filledButtonFg),
                  )
                      : const Text('Create Portfolio', style: TextStyle(fontWeight: FontWeight.bold)),
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
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
