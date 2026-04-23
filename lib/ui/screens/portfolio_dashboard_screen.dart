import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/extensions/context_extensions.dart';
import '../../models/business_portfolio.dart';
import '../../providers/portfolio_provider.dart';
import '../../services/firebase_service.dart';
import '../widgets/portfolio_card.dart';
import 'create_portfolio_sheet.dart';

class PortfolioDashboardScreen extends ConsumerWidget {
  const PortfolioDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final portfoliosAsync = ref.watch(portfolioListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BizDocx'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, size: 20, color: c.iconPrimary),
            tooltip: 'Settings',
            onPressed: () => context.go('/settings'),
          ),
          IconButton(
            icon: Icon(Icons.logout_rounded, size: 20, color: c.iconPrimary),
            tooltip: 'Sign out',
            onPressed: FirebaseService.instance.signOut,
          ),
        ],
      ),
      body: portfoliosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Error: $e',
              style: TextStyle(color: Theme.of(context).colorScheme.error)),
        ),
        data: (portfolios) => portfolios.isEmpty
            ? _EmptyState(onCreateTap: () => _showCreateSheet(context, ref))
            : _PortfolioList(portfolios: portfolios),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateSheet(context, ref),
        backgroundColor: c.filledButtonBg,
        foregroundColor: c.filledButtonFg,
        icon: const Icon(Icons.add),
        label: const Text('New Business'),
      ),
    );
  }

  void _showCreateSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const CreatePortfolioSheet(),
    );
  }
}

class _PortfolioList extends StatelessWidget {
  const _PortfolioList({required this.portfolios});
  final List<BusinessPortfolio> portfolios;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: portfolios.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final p = portfolios[i];
        return PortfolioCard(
          portfolio: p,
          onTap: () => context.go('/portfolio/${p.id}'),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreateTap});
  final VoidCallback onCreateTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: c.chipFill,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: c.border),
              ),
              child: Icon(Icons.business_center_outlined,
                  color: c.iconSecondary, size: 36),
            ),
            const SizedBox(height: 24),
            Text('No businesses yet',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Create a portfolio to start generating AI-powered documents.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: onCreateTap,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Create First Business'),
            ),
          ],
        ),
      ),
    );
  }
}