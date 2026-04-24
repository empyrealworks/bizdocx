import 'package:flutter/material.dart';
import '../../core/extensions/context_extensions.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section(context, 'Introduction', 
              'At BizDocx, we are committed to protecting your privacy. This policy explains how we collect, use, and safeguard your information when you use our AI-powered document hub.'),
            _section(context, 'Data Collection', 
              'We collect information necessary to provide our services, including account details (name, email) and the business context you provide (company name, mission, brand colors) to generate documents.'),
            _section(context, 'AI and Your Content', 
              'Your document prompts and business context are sent to AI providers (like Google Gemini) to generate content. We do not use your data to train our own models without explicit consent.'),
            _section(context, 'Data Security', 
              'Your data is stored securely using Firebase. We implement industry-standard security measures to protect against unauthorized access or disclosure.'),
            _section(context, 'User Rights', 
              'You have the right to access, correct, or delete your data at any time through the app settings. Deleting your account will remove all associated portfolios, documents, and profile information.'),
            const SizedBox(height: 40),
            Text('Last updated: June 2024', style: TextStyle(color: c.textMuted, fontSize: 12)),
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
