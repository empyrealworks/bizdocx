import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../providers/app_lock_provider.dart';
import '../../services/auth_security_service.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  final List<String> _pin = [];
  bool _isAuthenticating = false;
  bool _biometricsEnabled = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    final auth = AuthSecurityService.instance;
    final enabled = await auth.isBiometricsEnabled();
    setState(() => _biometricsEnabled = enabled);
    if (enabled) {
      _authenticateWithBiometrics();
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    if (_isAuthenticating) return;
    setState(() {
      _isAuthenticating = true;
      _errorMessage = null;
    });

    final success = await AuthSecurityService.instance.authenticateWithBiometrics(
      localizedReason: context.l10n.authenticateToContinue,
    );

    if (success) {
      ref.read(appLockProvider.notifier).unlock();
    } else {
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  void _onKeyPress(String value) {
    if (_pin.length < 4) {
      setState(() {
        _pin.add(value);
        _errorMessage = null;
      });

      if (_pin.length == 4) {
        _verifyPin();
      }
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin.removeLast();
        _errorMessage = null;
      });
    }
  }

  Future<void> _verifyPin() async {
    final pinString = _pin.join();
    final success = await AuthSecurityService.instance.verifyPin(pinString);

    if (success) {
      ref.read(appLockProvider.notifier).unlock();
    } else {
      setState(() {
        _pin.clear();
        _errorMessage = context.l10n.wrongPin;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;

    return Scaffold(
      backgroundColor: c.surface,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Image.asset(
              'assets/images/logo_small.png',
              height: 64,
              color: c.textPrimary,
            ),
            const SizedBox(height: 24),
            Text(
              l.appLock,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: c.textPrimary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              l.enterPin,
              style: TextStyle(color: c.textMuted),
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final isFilled = index < _pin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled ? c.textPrimary : c.borderStrong.withAlpha(51),
                    border: Border.all(
                      color: isFilled ? c.textPrimary : c.borderStrong,
                      width: 1.5,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: AppColors.error, fontSize: 13),
              ),
            const Spacer(),
            _buildKeypad(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypad(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['1', '2', '3'].map((n) => _KeyButton(n, onPressed: () => _onKeyPress(n))).toList(),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['4', '5', '6'].map((n) => _KeyButton(n, onPressed: () => _onKeyPress(n))).toList(),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['7', '8', '9'].map((n) => _KeyButton(n, onPressed: () => _onKeyPress(n))).toList(),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _biometricsEnabled 
                ? _KeyButton(
                    '',
                    icon: Icons.fingerprint_rounded,
                    onPressed: _authenticateWithBiometrics,
                  )
                : const SizedBox(width: 72),
              _KeyButton('0', onPressed: () => _onKeyPress('0')),
              _KeyButton(
                '',
                icon: Icons.backspace_outlined,
                onPressed: _onBackspace,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KeyButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;

  const _KeyButton(this.label, {this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 72,
        height: 72,
        alignment: Alignment.center,
        child: icon != null
            ? Icon(icon, size: 28, color: c.textPrimary)
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                ),
              ),
      ),
    );
  }
}
