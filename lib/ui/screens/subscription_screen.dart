import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../models/user_profile.dart';
import '../../services/firebase_service.dart';
import '../../services/iap_service.dart';
import '../widgets/confirm_dialog.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  Offerings? _offerings;
  bool _loading = true;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _fetchOfferings();
  }

  Future<void> _fetchOfferings() async {
    final offerings = await IapService.instance.getOfferings();
    if (mounted) {
      final pkgs = offerings?.current?.availablePackages ?? [];
      debugPrint('[IAP] Available Packages in Store: ${pkgs.map((p) => p.identifier).join(', ')}');
      
      setState(() {
        _offerings = offerings;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileStream = FirebaseService.instance.watchProfile();
    final c = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plans & Credits'),
        leading: const BackButton(),
        actions: [
          TextButton(
            onPressed: _isProcessing ? null : () => IapService.instance.restorePurchases(),
            child: const Text('Restore'),
          ),
        ],
      ),
      body: Stack(
        children: [
          StreamBuilder<UserProfile?>(
            stream: profileStream,
            builder: (context, snapshot) {
              final profile = snapshot.data;
              if (profile == null || _loading) {
                return const Center(child: CircularProgressIndicator());
              }

              final currentOffering = _offerings?.current;
              final packages = currentOffering?.availablePackages ?? [];
              
              // Find packages using case-insensitive partial match
              final solopreneurPackage = packages
                  .where((p) => p.identifier.toLowerCase().contains('solopreneur'))
                  .firstOrNull;
              
              final agencyPackage = packages
                  .where((p) => p.identifier.toLowerCase().contains('agency'))
                  .firstOrNull;

              final topUpPackages = packages
                  .where((p) => p.identifier.toLowerCase().contains('topup') || p.identifier.toLowerCase().contains('refill'))
                  .toList()
                ..sort((a, b) => a.storeProduct.price.compareTo(b.storeProduct.price));

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
                    
                    if (topUpPackages.isNotEmpty)
                       _TopUpSection(
                         packages: topUpPackages,
                         onSelect: (pkg) => _handlePurchase(pkg, isTopUp: true),
                       )
                    else
                      _TopUpSectionSimulated(onSelect: (amount) => _confirmTopUpSimulated(context, amount)),
                    
                    const SizedBox(height: 40),
                    
                    if (packages.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          'Note: Prices are fetched directly from the Play Store/App Store. Sandbox/Testing may show placeholder names.',
                          style: TextStyle(color: context.colors.textMuted, fontSize: 10, fontStyle: FontStyle.italic),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
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
          : () => _simulateUpgrade(tier),
    );
  }

  Future<void> _handlePurchase(Package package, {bool isTopUp = false}) async {
    setState(() => _isProcessing = true);
    try {
      final success = await IapService.instance.purchasePackage(package);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isTopUp ? 'Credits added successfully!' : 'Successfully upgraded!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _simulateUpgrade(UserTier tier) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmDialog(
        title: 'Simulate ${tier.name.toUpperCase()}?',
        message: 'This will simulate a successful subscription renewal and apply rollover logic.',
        actionLabel: 'Simulate',
        icon: Icons.refresh_rounded,
        onConfirm: () async {
          setState(() => _isProcessing = true);
          await FirebaseService.instance.processSubscriptionChange(
            newTier: tier,
            purchaseDate: DateTime.now(),
            expiryDate: DateTime.now().add(const Duration(days: 30)),
          );
          if (mounted) {
            setState(() => _isProcessing = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Simulated ${tier.name} upgrade.'), backgroundColor: AppColors.success),
            );
          }
        },
      ),
    );
  }

  Future<void> _confirmTopUpSimulated(BuildContext context, int amount) async {
    await showDialog(
      context: context,
      builder: (ctx) => ConfirmDialog(
        title: 'Add $amount Credits?',
        message: 'This will simulate a one-time Top-Up purchase.',
        actionLabel: 'Add Credits',
        icon: Icons.add_card_rounded,
        onConfirm: () async {
           setState(() => _isProcessing = true);
           await FirebaseService.instance.addTopUpCredits(amount);
           if (mounted) {
             setState(() => _isProcessing = false);
             ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text('Added $amount credits to your top-up wallet! (Simulated)'), backgroundColor: AppColors.success),
             );
           }
        },
      ),
    );
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
  const _TopUpSection({required this.packages, required this.onSelect});
  final List<Package> packages;
  final ValueChanged<Package> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: packages.map((pkg) {
        final amount = _parseAmount(pkg.identifier);
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: pkg == packages.last ? 0 : 12),
            child: _TopUpCard(
              amount: amount,
              price: pkg.storeProduct.priceString,
              onTap: () => onSelect(pkg),
            ),
          ),
        );
      }).toList(),
    );
  }

  int _parseAmount(String id) {
    final lowerId = id.toLowerCase();
    if (lowerId.contains('mini')) return 400;
    if (lowerId.contains('standard')) return 900;
    if (lowerId.contains('pro')) return 2000;
    return 0;
  }
}

class _TopUpSectionSimulated extends StatelessWidget {
  const _TopUpSectionSimulated({required this.onSelect});
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _TopUpCard(amount: 400, price: '\$4.99', onTap: () => onSelect(400))),
        const SizedBox(width: 12),
        Expanded(child: _TopUpCard(amount: 900, price: '\$9.99', onTap: () => onSelect(900))),
        const SizedBox(width: 12),
        Expanded(child: _TopUpCard(amount: 2000, price: '\$19.99', onTap: () => onSelect(2000))),
      ],
    );
  }
}

class _TopUpCard extends StatelessWidget {
  const _TopUpCard({required this.amount, required this.price, required this.onTap});
  final int amount;
  final String price;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
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
    final borderColor = isCurrent ? const Color(0xFFFFD60A) : (highlight ? const Color(0xFFFF6B35) : c.border);

    return Container(
      decoration: BoxDecoration(
        color: isCurrent ? const Color(0xFFFFD60A).withValues(alpha: 0.05) : c.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: (highlight || isCurrent) ? 2 : 1),
        boxShadow: (highlight || isCurrent) ? [
          BoxShadow(color: borderColor.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 8))
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
                  Row(
                    children: [
                      Text(tier.name.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                      if (isCurrent) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFFFD60A), borderRadius: BorderRadius.circular(4)),
                          child: const Text('ACTIVE', style: TextStyle(color: Colors.black, fontSize: 8, fontWeight: FontWeight.w900)),
                        ),
                      ]
                    ],
                  ),
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
              style: isCurrent 
                  ? FilledButton.styleFrom(backgroundColor: c.chipFill, foregroundColor: c.textMuted)
                  : (highlight ? FilledButton.styleFrom(backgroundColor: const Color(0xFFFF6B35)) : null),
              child: Text(isCurrent ? 'Current Plan' : 'Select Plan'),
            ),
          ),
        ],
      ),
    );
  }
}
