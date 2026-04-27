import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../models/user_profile.dart';
import '../../services/firebase_service.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileStream = FirebaseService.instance.watchProfile();
    final c = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plans & Pricing'),
        leading: const BackButton(),
      ),
      body: StreamBuilder<UserProfile?>(
        stream: profileStream,
        builder: (context, snapshot) {
          final profile = snapshot.data;
          if (profile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CurrentPlanHeader(profile: profile),
                const SizedBox(height: 32),
                _PlanCard(
                  tier: UserTier.free,
                  price: '₦0',
                  subtitle: 'The "Hook"',
                  description: 'Perfect for kicking the tires.',
                  features: const [
                    '1 Workspace / Business',
                    '1 Document per day',
                    '1 Image per week',
                    'Watermarked PDFs',
                    'Standard templates only',
                  ],
                  isCurrent: profile.isFree,
                  onSelect: () => _handleUpgrade(context, UserTier.free),
                ),
                const SizedBox(height: 20),
                _PlanCard(
                  tier: UserTier.pro,
                  price: '₦5,000',
                  subtitle: 'The "Freelancer"',
                  description: 'For solo entrepreneurs who need more power.',
                  features: const [
                    '1 Workspace / Business',
                    '100 AI Credits per month',
                    'NO Watermarks',
                    'Premium Templates access',
                    'High-resolution exports',
                  ],
                  isCurrent: profile.isPro,
                  highlight: true,
                  onSelect: () => _handleUpgrade(context, UserTier.pro),
                ),
                const SizedBox(height: 20),
                _PlanCard(
                  tier: UserTier.premium,
                  price: '₦15,000',
                  subtitle: 'The "Agency"',
                  description: 'For managing multiple brands and high volume.',
                  features: const [
                    'Up to 3 Workspaces',
                    '500 AI Credits per month',
                    'Custom brand palettes',
                    'Priority AI generation',
                    'Bulk export features',
                  ],
                  isCurrent: profile.isPremium,
                  onSelect: () => _handleUpgrade(context, UserTier.premium),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleUpgrade(BuildContext context, UserTier tier) async {
    // In a real app, this would trigger Stripe, Paystack, RevenueCat, etc.
    // For now, we'll simulate a successful payment and update Firestore.
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Upgrade to ${tier.name.toUpperCase()}?'),
        content: Text('This will simulate a payment for the ${tier.name} plan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Simulate Payment')),
        ],
      ),
    );

    if (ok == true) {
      final fb = FirebaseService.instance;
      final profile = await fb.fetchProfile();
      final limits = TierLimits.get(tier);
      
      final updated = profile.copyWith(
        tier: tier,
        credits: limits.monthlyCredits,
        lastCreditReset: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await fb.updateProfile(updated);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully upgraded to ${tier.name.toUpperCase()}!'), backgroundColor: AppColors.success),
        );
      }
    }
  }
}

class _CurrentPlanHeader extends StatelessWidget {
  const _CurrentPlanHeader({required this.profile});
  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.chipFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CURRENT PLAN', style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 4),
          Text(
            profile.tier.name.toUpperCase(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (!profile.isFree) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.auto_awesome, size: 16, color: Color(0xFFFF6B35)),
                const SizedBox(width: 8),
                Text('${profile.credits} AI Credits remaining', style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.tier,
    required this.price,
    required this.subtitle,
    required this.description,
    required this.features,
    required this.isCurrent,
    required this.onSelect,
    this.highlight = false,
  });

  final UserTier tier;
  final String price;
  final String subtitle;
  final String description;
  final List<String> features;
  final bool isCurrent;
  final bool highlight;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final borderColor = highlight ? const Color(0xFFFF6B35) : c.border;

    return Container(
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: highlight ? 2 : 1),
        boxShadow: highlight ? [
          BoxShadow(color: const Color(0xFFFF6B35).withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 8))
        ] : null,
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tier.name.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  Text(subtitle, style: TextStyle(color: c.textMuted, fontSize: 12)),
                ],
              ),
              Text(
                price,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(description, style: TextStyle(color: c.textBody, fontSize: 14)),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),
          ...features.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.success),
                const SizedBox(width: 12),
                Expanded(child: Text(f, style: const TextStyle(fontSize: 13))),
              ],
            ),
          )),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: isCurrent ? null : onSelect,
              style: highlight ? FilledButton.styleFrom(backgroundColor: const Color(0xFFFF6B35)) : null,
              child: Text(isCurrent ? 'Current Plan' : 'Select Plan'),
            ),
          ),
        ],
      ),
    );
  }
}
