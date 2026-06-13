import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/extensions/context_extensions.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'hello@empyrealworks.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'BizDocx Support Request',
      }),
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l.contactUs)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: c.chipFill,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.support_agent_rounded, size: 40, color: c.textPrimary),
            ),
            const SizedBox(height: 24),
            Text(l.howCanWeHelp, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            Text(
              l.contactHelp,
              textAlign: TextAlign.center,
              style: TextStyle(color: c.textBody, fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 40),
            _contactCard(
              context,
              icon: Icons.email_outlined,
              title: l.emailSupport,
              value: 'hello@empyrealworks.com',
              onTap: _sendEmail,
            ),
            const SizedBox(height: 16),
            _contactCard(
              context,
              icon: Icons.help_outline_rounded,
              title: l.helpCenter,
              value: l.browseFaqs,
              onTap: () => _launchUrl('https://empyrealworks.com/#contact'),
            ),
            const SizedBox(height: 16),
            _contactCard(
              context,
              icon: Icons.language_rounded,
              title: l.website,
              value: l.visitWebsite,
              onTap: () => _launchUrl('https://empyrealworks.com'),
            ),
            const SizedBox(height: 32),
            _SectionHeader(l.followUs),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _socialIcon(
                  icon: Icons.alternate_email_rounded,
                  onTap: () => _launchUrl('https://twitter.com/empyrealworks'),
                ),
                const SizedBox(width: 24),
                _socialIcon(
                  icon: Icons.business_center_rounded,
                  onTap: () => _launchUrl('https://linkedin.com/company/empyrealworks'),
                ),
              ],
            ),
            const SizedBox(height: 40),
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

  Widget _socialIcon({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withAlpha(51)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 24),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
              color: context.colors.textMuted,
            ),
      );
}
