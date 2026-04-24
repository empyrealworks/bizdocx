import 'package:flutter/material.dart';
import '../../core/extensions/context_extensions.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: c.chipFill,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.support_agent_rounded, size: 40, color: c.textPrimary),
            ),
            const SizedBox(height: 24),
            Text('How can we help?', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            Text(
              'Have a question, feedback, or need help with a document? Reach out to our team.',
              textAlign: TextAlign.center,
              style: TextStyle(color: c.textBody, fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 40),
            _contactCard(
              context,
              icon: Icons.email_outlined,
              title: 'Email Support',
              value: 'support@bizdocx.com',
              onTap: () {
                // In a real app, use url_launcher to open email client
              },
            ),
            const SizedBox(height: 16),
            _contactCard(
              context,
              icon: Icons.chat_bubble_outline_rounded,
              title: 'Feedback',
              value: 'Send us your thoughts',
              onTap: () {
                // Open feedback form
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    final c = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: c.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: c.iconPrimary, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(value, style: TextStyle(color: c.textMuted, fontSize: 14)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: c.borderStrong, size: 14),
          ],
        ),
      ),
    );
  }
}
