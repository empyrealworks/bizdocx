import 'package:flutter/material.dart';
import '../../core/extensions/context_extensions.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l.privacyPolicy)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section(context, l.privacyIntroTitle, l.privacyIntroBody),
            _section(context, l.privacyCollectionTitle, l.privacyCollectionBody),
            _section(context, l.privacyAiTitle, l.privacyAiBody),
            _section(context, l.privacySecurityTitle, l.privacySecurityBody),
            _section(context, l.privacyRightsTitle, l.privacyRightsBody),
            const SizedBox(height: 40),
            Text(l.lastUpdated, style: TextStyle(color: c.textMuted, fontSize: 12)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _section(BuildContext context, String title, String body) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(body, style: TextStyle(color: c.textBody, fontSize: 14, height: 1.5)),
        ],
      ),
    );
  }
}
