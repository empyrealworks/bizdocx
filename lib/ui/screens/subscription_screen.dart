import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../models/user_profile.dart';
import '../../services/firebase_service.dart';
import '../../services/iap_service.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  Offerings? _offerings;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchOfferings();
  }

  Future<void> _fetchOfferings() async {
    final offerings = await IapService.instance.getOfferings();
    if (mounted) {
      setState(() {
        _offerings = offerings;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileStream = FirebaseService.instance.watchProfile();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plans & Credits'),
        leading: const BackButton(),
        actions: [
          TextButton(
            onPressed: () => IapService.instance.restorePurchases(),
            child: const Text('Restore'),
          ),
        ],
      ),
      body: StreamBuilder<UserProfile?>(
        stream: profileStream,
        builder: (context, snapshot) {
          final profile = snapshot.data;
          if (profile == null || _loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final packages = _offerings?.current?.availablePackages ?? [];
          final solopreneurPackage = packages
              .where((p) => p.identifier.toLowerCase().contains('solopreneur'))
              .firstOrNull ?? (packages.isNotEmpty ? packages.first : null);
          
          final agencyPackage = packages
              .where((p) => p.identifier.toLowerCase().contains('agency'))
              .firstOrNull ?? (packages.isNotEmpty ? packages.last : null);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _WalletSummary(profile: profile),
                const SizedBox(height: 32),
                _SectionHeader(context, 'Subscription Plans'),
                const SizedBox(height: 12),
                _PlanCard(
                  tier: UserTier.free,
                  price: '\$0',
                  subtitle: 'Draft Only',
                  description: 'Access to single-page documents and low-res drafts.',
                  features: const [
                    '50 Draft Credits / Month',
                    '1 Workspace',
                    'Watermarked PDFs',
                    'Standard templates only',
                  ],
                  isCurrent: profile.isFree,
                  onSelect: () => _simulateUpgrade(UserTier.free),
                ),
                const SizedBox(height: 16),
                _buildPackageCard(
                  package: solopreneurPackage,
                  tier: UserTier.solopreneur,
                  fallbackPrice: '\$9.99',
                  subtitle: 'The "Freelancer"',
                  description: 'Perfect for regular proposal and invoice needs.',
                  features: const [
                    '1,200 Credits / Month',
                    'Rollover up to 3,600',
                    'NO Watermarks',
                    'Multi-page Docs (Contracts/Proposals)',
                    'High-Res Image unlock',
                  ],
                  isCurrent: profile.isSolopreneur,
                  highlight: true,
                ),
                const SizedBox(height: 16),
                _buildPackageCard(
                  package: agencyPackage,
                  tier: UserTier.agency,
                  fallbackPrice: '\$24.99',
                  subtitle: 'The "Small Business"',
                  description: 'For power users managing multiple brands.',
                  features: const [
                    '3,500 Credits / Month',
                    'Rollover up to 10,500',
                    'Up to 3 Workspaces',
                    'Access to Heavy AI Models (Pro)',
                    'Priority Generation Queue',
                  ],
                  isCurrent: profile.isAgency,
                ),
                const SizedBox(height: 32),
                _SectionHeader(context, 'Top-Up Credits (Never Expire)'),
                const SizedBox(height: 12),
                _TopUpSection(onSelect: (amount) => _handleTopUp(context, amount)),
                const SizedBox(height: 40),
                
                // Debug / Info note
                if (packages.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'Note: Prices are fetched directly from the Play Store/App Store and may vary by region.',
                      style: TextStyle(color: context.colors.textMuted, fontSize: 10, fontStyle: FontStyle.italic),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPackageCard({
    Package? package,
    required UserTier tier,
    required String fallbackPrice,
    required String subtitle,
    required String description,
    required List<String> features,
    required bool isCurrent,
    bool highlight = false,
  }) {
    final price = package?.storeProduct.priceString ?? fallbackPrice;
    
    return _PlanCard(
      tier: tier,
      price: isCurrent ? price : '$price/mo',
      subtitle: subtitle,
      description: description,
      features: features,
      isCurrent: isCurrent,
      highlight: highlight,
      onSelect: package != null 
          ? () => _handlePurchase(package) 
          : () => _simulateUpgrade(tier), // Fallback to simulation if package not found
    );
  }

  Future<void> _handlePurchase(Package package) async {
    final success = await IapService.instance.purchasePackage(package);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully upgraded!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _simulateUpgrade(UserTier tier) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Simulate ${tier.name.toUpperCase()}?'),
        content: const Text('This will simulate a successful subscription and apply rollover logic.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Simulate')),
        ],
      ),
    );

    if (ok == true) {
      await FirebaseService.instance.processSubscriptionChange(
        newTier: tier,
        purchaseDate: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 30)),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Simulated ${tier.name} upgrade.'), backgroundColor: AppColors.success),
        );
      }
    }
  }

  Future<void> _handleTopUp(BuildContext context, int amount) async {
     await FirebaseService.instance.addTopUpCredits(amount);
     if (context.mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Added $amount credits to your top-up wallet!'), backgroundColor: AppColors.success),
       );
     }
  }

  Widget _SectionHeader(BuildContext context, String text) => Text(
    text.toUpperCase(),
    style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.1, fontWeight: FontWeight.bold, color: context.colors.textMuted),
  );
}

class _WalletSummary extends StatelessWidget {
  const _WalletSummary({required this.profile});
  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: c.chipFill,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _WalletCol(label: 'Subscription', value: profile.subscriptionCredits, color: const Color(0xFFFF6B35)),
              Container(width: 1, height: 40, color: c.border),
              _WalletCol(label: 'Top Up', value: profile.topUpCredits, color: Colors.blueAccent),
            ],
          ),
          const Divider(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Total Available: ',
                style: TextStyle(color: c.textMuted, fontSize: 13),
              ),
              Text(
                '${profile.totalCredits} Credits',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WalletCol extends StatelessWidget {
  const _WalletCol({required this.label, required this.value, required this.color});
  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label.toUpperCase(), style: TextStyle(color: context.colors.textMuted, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: color),
        ),
      ],
    );
  }
}

class _TopUpSection extends StatelessWidget {
  const _TopUpSection({required this.onSelect});
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TopUpItem(amount: 400, price: '\$4.99', onSelect: onSelect),
        const SizedBox(width: 12),
        _TopUpItem(amount: 900, price: '\$9.99', onSelect: onSelect),
        const SizedBox(width: 12),
        _TopUpItem(amount: 2000, price: '\$19.99', onSelect: onSelect),
      ],
    );
  }
}

class _TopUpItem extends StatelessWidget {
  const _TopUpItem({required this.amount, required this.price, required this.onSelect});
  final int amount;
  final String price;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Expanded(
      child: GestureDetector(
        onTap: () => onSelect(amount),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: c.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: c.border),
          ),
          child: Column(
            children: [
              Text('$amount', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
              Text('Credits', style: TextStyle(color: c.textMuted, fontSize: 10)),
              const SizedBox(height: 8),
              Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFFF6B35))),
            ],
          ),
        ),
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
          BoxShadow(color: const Color(0xFFFF6B35).withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 8))
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
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(description, style: TextStyle(color: c.textBody, fontSize: 13, height: 1.4)),
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
              child: Text(isCurrent ? 'Active Plan' : 'Select Plan'),
            ),
          ),
        ],
      ),
    );
  }
}
