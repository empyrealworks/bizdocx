import 'package:flutter/material.dart';
import '../../core/extensions/context_extensions.dart';

enum AppButtonStyle { filled, outlined, text }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.loading = false,
    this.style = AppButtonStyle.filled,
    this.width = double.infinity,
    this.height = 54,
    this.backgroundColor,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool loading;
  final AppButtonStyle style;
  final double width;
  final double height;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isDisabled = onPressed == null || loading;

    Widget content;
    if (loading) {
      content = SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: style == AppButtonStyle.filled ? c.filledButtonFg : c.filledButtonBg,
        ),
      );
    } else {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18),
            const SizedBox(width: 8),
          ],
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      );
    }

    switch (style) {
      case AppButtonStyle.filled:
        return SizedBox(
          width: width,
          height: height,
          child: FilledButton(
            onPressed: isDisabled ? null : onPressed,
            style: backgroundColor != null 
              ? FilledButton.styleFrom(backgroundColor: backgroundColor) 
              : null,
            child: content,
          ),
        );
      case AppButtonStyle.outlined:
        return SizedBox(
          width: width,
          height: height,
          child: OutlinedButton(
            onPressed: isDisabled ? null : onPressed,
            child: content,
          ),
        );
      case AppButtonStyle.text:
        return TextButton(
          onPressed: isDisabled ? null : onPressed,
          child: content,
        );
    }
  }
}
