import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../services/firebase_service.dart';
import '../widgets/app_button.dart';

class AuthGateScreen extends ConsumerStatefulWidget {
  const AuthGateScreen({super.key});

  @override
  ConsumerState<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends ConsumerState<AuthGateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl    = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _passCtrl    = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _isLogin    = true;
  bool _loading    = false;
  bool _obscure    = true;
  String? _error;

  // Rate limiting
  int _failedAttempts = 0;
  DateTime? _lockoutEndTime;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_lockoutEndTime != null && DateTime.now().isBefore(_lockoutEndTime!)) {
      final diff = _lockoutEndTime!.difference(DateTime.now()).inSeconds;
      setState(() => _error = "Too many failed attempts. Try again in $diff seconds.");
      return;
    }

    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    try {
      final fb = FirebaseService.instance;
      if (_isLogin) {
        await fb.signInWithEmail(_emailCtrl.text.trim(), _passCtrl.text);
      } else {
        await fb.createAccount(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
          name: _nameCtrl.text.trim(),
        );
      }
      _failedAttempts = 0;
      _lockoutEndTime = null;
    } catch (e) {
      _failedAttempts++;
      if (_failedAttempts >= 5) {
        _lockoutEndTime = DateTime.now().add(const Duration(seconds: 60));
      }
      setState(() => _error = _parseError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _googleSignIn() async {
    setState(() { _loading = true; _error = null; });
    try {
      await FirebaseService.instance.signInWithGoogle();
    } catch (e) {
      setState(() => _error = _parseError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _guestSignIn() async {
    setState(() { _loading = true; _error = null; });
    try {
      await FirebaseService.instance.signInAnonymously();
    } catch (e) {
      setState(() => _error = _parseError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _parseError(dynamic e) {
    final s = e.toString();
    final l = context.l10n;
    if (s.contains('user-not-found'))    return l.errorUserNotFound;
    if (s.contains('wrong-password'))    return l.errorWrongPassword;
    if (s.contains('email-already-in-use')) return l.errorEmailInUse;
    if (s.contains('weak-password'))     return l.errorWeakPassword;
    if (s.contains('invalid-email'))     return l.errorInvalidEmail;
    if (s.contains('credential-already-in-use')) return "Email/account already in use. Please sign in instead.";
    return l.errorGeneric;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final isDark = context.isDark;

    final isGuest = FirebaseService.instance.isAnonymous;

    return Scaffold(
      appBar: isGuest ? AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
      ) : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 80,
                    width: 80,
                    fit: BoxFit.contain,
                    // Tint black logo to white in dark mode
                    color: isDark ? Colors.white : null,
                    colorBlendMode: isDark ? BlendMode.srcIn : null,
                  ),
                ),
                const SizedBox(height: 12),
                Text(l.appTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge),
                const SizedBox(height: 8),
                Text(
                  l.appSubtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: c.textBody),
                ),
                const SizedBox(height: 60),

                if (!_isLogin) ...[
                  TextFormField(
                    controller: _nameCtrl,
                    autofillHints: const [AutofillHints.name],
                    decoration:
                    InputDecoration(hintText: l.fullName),
                    validator: (v) =>
                    (v == null || v.isEmpty) ? l.required : null,
                  ),
                  const SizedBox(height: 12),
                ],

                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: InputDecoration(hintText: l.email),
                  validator: (v) {
                    if (v == null || v.isEmpty) return l.required;
                    if (!v.contains('@')) return l.errorInvalidEmail;
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  autofillHints: [
                    _isLogin ? AutofillHints.password : AutofillHints.newPassword
                  ],
                  decoration: InputDecoration(
                    hintText: l.password,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: c.iconSecondary,
                      ),
                      onPressed: () =>
                          setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) => (v == null || v.length < 6)
                      ? l.min6Chars
                      : null,
                ),

                if (!_isLogin) ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _confirmCtrl,
                    obscureText: _obscure,
                    autofillHints: const [AutofillHints.newPassword],
                    decoration: InputDecoration(
                        hintText: l.confirmPassword),
                    validator: (v) => v != _passCtrl.text
                        ? l.passwordsDoNotMatch
                        : null,
                  ),
                ]
else ...[
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push('/auth/forgot-password'),
                      child: Text(l.forgotPassword, 
                        style: TextStyle(color: c.textMuted, fontSize: 13)),
                    ),
                  ),
                ],

                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: AppColors.error, fontSize: 13),
                  ),
                ],

                const SizedBox(height: 32),
                AppButton(
                  onPressed: _submit,
                  loading: _loading,
                  label: _isLogin ? l.signIn : l.signUp,
                ),

                const SizedBox(height: 16),
                AppButton(
                  onPressed: _googleSignIn,
                  loading: _loading,
                  style: AppButtonStyle.outlined,
                  icon: Icons.login, // Google icon from URL was a bit much
                  label: l.continueWithGoogle,
                ),

                const SizedBox(height: 16),
                if (!isGuest)
                  AppButton(
                    onPressed: _guestSignIn,
                    loading: _loading,
                    style: AppButtonStyle.text,
                    label: l.continueAsGuest,
                  ),

                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () => setState(() {
                      _isLogin = !_isLogin;
                      _error = null;
                    }),
                    child: Text(
                      _isLogin
                          ? l.noAccount
                          : l.haveAccount,
                      style: TextStyle(color: c.textBody),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
