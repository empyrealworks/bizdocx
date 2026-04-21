import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../models/document_asset.dart';
import '../../providers/document_generation_provider.dart';
import '../../providers/portfolio_provider.dart';
import '../widgets/document_tile.dart';

class PortfolioDetailScreen extends ConsumerWidget {
  const PortfolioDetailScreen({super.key, required this.portfolioId});
  final String portfolioId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolio = ref.watch(selectedPortfolioProvider);
    final documentsAsync = ref.watch(documentListProvider(portfolioId));

    return Scaffold(
      appBar: AppBar(
        title: Text(portfolio?.name ?? 'Portfolio'),
        leading: BackButton(onPressed: () => context.go('/')),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (portfolio != null) _ContextBanner(portfolio: portfolio),
          Expanded(
            child: documentsAsync.when(
              loading: () =>
              const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text('$e',
                    style: const TextStyle(color: AppColors.error)),
              ),
              data: (docs) => docs.isEmpty
                  ? _EmptyDocState(portfolioId: portfolioId)
                  : _DocumentList(
                  docs: docs, portfolioId: portfolioId),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            context.go('/portfolio/$portfolioId/generate'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.black,
        icon: const Icon(Icons.auto_awesome, size: 18),
        label: const Text('Generate Document'),
      ),
    );
  }
}

class _ContextBanner extends StatelessWidget {
  const _ContextBanner({required this.portfolio});
  final dynamic portfolio;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.graphite,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.business_center_outlined,
                color: AppColors.silver, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(portfolio.name,
                    style: Theme.of(context).textTheme.titleLarge),
                if ((portfolio.description as String).isNotEmpty)
                  Text(portfolio.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Text(
            '${(portfolio.documentIds as List).length} docs',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _DocumentList extends ConsumerWidget {
  const _DocumentList(
      {required this.docs, required this.portfolioId});
  final List<DocumentAsset> docs;
  final String portfolioId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: docs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final doc = docs[i];
        return DocumentTile(
          asset: doc,
          onTap: () {
            context.go(
              '/portfolio/$portfolioId/doc/${doc.id}',
              extra: doc,
            );
          },
        );
      },
    );
  }
}

class _EmptyDocState extends StatelessWidget {
  const _EmptyDocState({required this.portfolioId});
  final String portfolioId;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.description_outlined,
              color: AppColors.muted, size: 48),
          const SizedBox(height: 16),
          Text('No documents yet',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Tap Generate to create your first AI document.',
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}