import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/utils/ui_utils.dart';
import '../../services/firebase_service.dart';
import '../widgets/app_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String? _error;
  bool _sent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    try {
      await FirebaseService.instance.sendPasswordReset(_emailCtrl.text.trim());
      setState(() => _sent = true);
    } catch (e) {
      setState(() => _error = _parseError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _parseError(dynamic e) {
    final s = e.toString();
    final l = context.l10n;
    if (s.contains('user-not-found')) return l.errorUserNotFound;
    if (s.contains('invalid-email')) return l.errorInvalidEmail;
    return l.errorGeneric;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.resetPassword),
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _sent ? _SuccessView(email: _emailCtrl.text.trim()) : _FormView(
            formKey: _formKey,
            emailCtrl: _emailCtrl,
            loading: _loading,
            error: _error,
            onSubmit: _submit,
          ),
        ),
      ),
    );
  }
}

class _FormView extends StatelessWidget {
  const _FormView({
    required this.formKey,
    required this.emailCtrl,
    required this.loading,
    required this.error,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailCtrl;
  final bool loading;
  final String? error;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Text(
            l.enterEmailForReset,
            style: TextStyle(color: c.textBody, fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: InputDecoration(hintText: l.email),
            validator: (v) => (v == null || !v.contains('@')) ? l.errorInvalidEmail : null,
          ),
          if (error != null) ...[
            const SizedBox(height: 16),
            Text(error!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.error, fontSize: 13)),
          ],
          const SizedBox(height: 32),
          AppButton(
            onPressed: onSubmit,
            loading: loading,
            label: l.sendResetLink,
          ),
        ],
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    return Column(
      children: [
        const SizedBox(height: 40),
        const Icon(Icons.mark_email_read_outlined, size: 64, color: AppColors.success),
        const SizedBox(height: 24),
        Text(l.checkYourEmail, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        Text(
          l.resetLinkSent(email),
          textAlign: TextAlign.center,
          style: TextStyle(color: c.textBody, fontSize: 15, height: 1.5),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => context.pop(),
            child: Text(l.backToSignIn),
          ),
        ),
      ],
    );
  }
}
