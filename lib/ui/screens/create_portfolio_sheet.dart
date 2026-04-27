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
  final _formKey      = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _missionCtrl.dispose();
    _audienceCtrl.dispose();
    _colorCtrl.dispose();
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

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottom),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 24),
            _field(_nameCtrl, 'Business Name *',
                validator: (v) => v!.isEmpty ? 'Required' : null),
            const SizedBox(height: 12),
            _field(_descCtrl, 'Short Description'),
            const SizedBox(height: 12),
            _field(_missionCtrl, 'Mission Statement', maxLines: 3),
            const SizedBox(height: 12),
            _field(_audienceCtrl, 'Target Audience'),
            const SizedBox(height: 12),
            _field(_colorCtrl, 'Brand Colors (comma-separated hex)'),
            const SizedBox(height: 24),
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
    );
  }

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
