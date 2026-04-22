import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../models/business_portfolio.dart';
import '../../models/document_asset.dart';
import '../../providers/document_generation_provider.dart';
import '../../providers/portfolio_provider.dart';
import '../sheets/asset_manager_sheet.dart';
import '../sheets/edit_portfolio_sheet.dart';
import '../widgets/document_tile.dart';

class PortfolioDetailScreen extends ConsumerStatefulWidget {
  const PortfolioDetailScreen({super.key, required this.portfolioId});
  final String portfolioId;

  @override
  ConsumerState<PortfolioDetailScreen> createState() =>
      _PortfolioDetailScreenState();
}

class _PortfolioDetailScreenState
    extends ConsumerState<PortfolioDetailScreen> {
  AssetPipeline? _pipelineFilter;
  DocumentType? _typeFilter;

  List<DocumentAsset> _applyFilters(List<DocumentAsset> docs) {
    return docs.where((d) {
      if (_pipelineFilter != null && d.pipeline != _pipelineFilter) {
        return false;
      }
      if (_typeFilter != null && d.type != _typeFilter) return false;
      return true;
    }).toList();
  }

  void _showEditSheet(BuildContext context, BusinessPortfolio portfolio) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => EditPortfolioSheet(portfolio: portfolio),
    );
  }

  void _showAssetSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) =>
          AssetManagerSheet(portfolioId: widget.portfolioId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final portfoliosAsync = ref.watch(portfolioListProvider);
    final portfolio = portfoliosAsync
        .whenData((list) {
      try {
        return list.firstWhere((p) => p.id == widget.portfolioId);
      } catch (_) {
        return null;
      }
    })
        .value;

    final documentsAsync =
    ref.watch(documentListProvider(widget.portfolioId));

    return Scaffold(
      appBar: AppBar(
        title: Text(portfolio?.name ?? 'Portfolio'),
        leading: BackButton(onPressed: () => context.go('/')),
        actions: [
          if (portfolio != null) ...[
            IconButton(
              icon: const Icon(Icons.photo_library_outlined, size: 20),
              tooltip: 'Manage assets & logo',
              onPressed: () => _showAssetSheet(context),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              tooltip: 'Edit business info',
              onPressed: () => _showEditSheet(context, portfolio),
            ),
          ],
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (portfolio != null) _ContextBanner(portfolio: portfolio),
          _FilterBar(
            pipelineFilter: _pipelineFilter,
            typeFilter: _typeFilter,
            onPipelineChanged: (p) =>
                setState(() { _pipelineFilter = p; _typeFilter = null; }),
            onTypeChanged: (t) => setState(() => _typeFilter = t),
          ),
          Expanded(
            child: documentsAsync.when(
              loading: () =>
              const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text('$e',
                    style: const TextStyle(color: AppColors.error)),
              ),
              data: (docs) {
                final filtered = _applyFilters(docs);
                return filtered.isEmpty
                    ? _EmptyDocState(
                  portfolioId: widget.portfolioId,
                  hasFilters: _pipelineFilter != null ||
                      _typeFilter != null,
                  onClearFilters: () => setState(() {
                    _pipelineFilter = null;
                    _typeFilter = null;
                  }),
                )
                    : _DocumentList(
                  docs: filtered,
                  portfolioId: widget.portfolioId,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            context.go('/portfolio/${widget.portfolioId}/generate'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.black,
        icon: const Icon(Icons.auto_awesome, size: 18),
        label: const Text('Generate'),
      ),
    );
  }
}

// ── Filter Bar ────────────────────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.pipelineFilter,
    required this.typeFilter,
    required this.onPipelineChanged,
    required this.onTypeChanged,
  });

  final AssetPipeline? pipelineFilter;
  final DocumentType? typeFilter;
  final ValueChanged<AssetPipeline?> onPipelineChanged;
  final ValueChanged<DocumentType?> onTypeChanged;

  static const _structuralTypes = [
    DocumentType.invoice,
    DocumentType.proposal,
    DocumentType.letterhead,
    DocumentType.businessCard,
    DocumentType.contract,
    DocumentType.other,
  ];
  static const _graphicalTypes = [DocumentType.logo, DocumentType.icon];

  List<DocumentType> get _relevantTypes {
    if (pipelineFilter == AssetPipeline.structural) return _structuralTypes;
    if (pipelineFilter == AssetPipeline.graphical) return _graphicalTypes;
    return [..._structuralTypes, ..._graphicalTypes];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(
              children: [
                _Chip(
                  label: 'All',
                  active: pipelineFilter == null,
                  onTap: () => onPipelineChanged(null),
                ),
                const SizedBox(width: 8),
                _Chip(
                  label: 'Structural',
                  icon: Icons.description_outlined,
                  active: pipelineFilter == AssetPipeline.structural,
                  onTap: () => onPipelineChanged(
                    pipelineFilter == AssetPipeline.structural
                        ? null
                        : AssetPipeline.structural,
                  ),
                ),
                const SizedBox(width: 8),
                _Chip(
                  label: 'Graphical',
                  icon: Icons.auto_awesome_outlined,
                  active: pipelineFilter == AssetPipeline.graphical,
                  onTap: () => onPipelineChanged(
                    pipelineFilter == AssetPipeline.graphical
                        ? null
                        : AssetPipeline.graphical,
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            child: Row(
              children: [
                _Chip(
                  label: 'All types',
                  active: typeFilter == null,
                  onTap: () => onTypeChanged(null),
                  small: true,
                ),
                ..._relevantTypes.map((t) => Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: _Chip(
                    label: _typeLabel(t),
                    active: typeFilter == t,
                    onTap: () =>
                        onTypeChanged(typeFilter == t ? null : t),
                    small: true,
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _typeLabel(DocumentType t) {
    switch (t) {
      case DocumentType.invoice: return 'Invoice';
      case DocumentType.proposal: return 'Proposal';
      case DocumentType.letterhead: return 'Letterhead';
      case DocumentType.businessCard: return 'Business Card';
      case DocumentType.contract: return 'Contract';
      case DocumentType.logo: return 'Logo';
      case DocumentType.icon: return 'Icon';
      case DocumentType.other: return 'Other';
    }
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.active,
    required this.onTap,
    this.icon,
    this.small = false,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final IconData? icon;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(
          horizontal: small ? 10 : 12,
          vertical: small ? 5 : 7,
        ),
        decoration: BoxDecoration(
          color: active ? AppColors.white : AppColors.graphite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? AppColors.white : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon,
                  size: 12,
                  color: active ? AppColors.black : AppColors.silver),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: active ? AppColors.black : AppColors.silver,
                fontSize: small ? 11 : 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Context Banner ────────────────────────────────────────────────────────────

class _ContextBanner extends StatelessWidget {
  const _ContextBanner({required this.portfolio});
  final BusinessPortfolio portfolio;

  static Color? _parseFirst(List<String> colors) {
    if (colors.isEmpty) return null;
    try {
      return Color(int.parse('FF${colors.first.replaceAll('#', '')}',
          radix: 16));
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = _parseFirst(portfolio.brandColors);
    final hasLogo = portfolio.logoStoragePath != null &&
        portfolio.logoStoragePath!.isNotEmpty;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accent?.withValues(alpha: 0.3) ?? AppColors.border,
        ),
      ),
      child: Row(
        children: [
          // Logo or icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accent?.withValues(alpha: 0.15) ?? AppColors.graphite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: accent?.withValues(alpha: 0.3) ?? AppColors.border),
            ),
            child: hasLogo && portfolio.logoStoragePath != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Image.network(
                portfolio.logoStoragePath!,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                    Icons.business_center_outlined,
                    color: accent ?? AppColors.silver,
                    size: 22),
              ),
            )
                : Icon(Icons.business_center_outlined,
                color: accent ?? AppColors.silver, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(portfolio.name,
                    style: Theme.of(context).textTheme.titleLarge),
                if (portfolio.description.isNotEmpty)
                  Text(portfolio.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Text(
            '${portfolio.documentIds.length} docs',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

// ── Document List ─────────────────────────────────────────────────────────────

class _DocumentList extends ConsumerWidget {
  const _DocumentList({required this.docs, required this.portfolioId});
  final List<DocumentAsset> docs;
  final String portfolioId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      itemCount: docs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final doc = docs[i];
        return DocumentTile(
          asset: doc,
          onTap: () => context.go(
            '/portfolio/$portfolioId/doc/${doc.id}',
            extra: doc,
          ),
        );
      },
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────

class _EmptyDocState extends StatelessWidget {
  const _EmptyDocState({
    required this.portfolioId,
    required this.hasFilters,
    required this.onClearFilters,
  });
  final String portfolioId;
  final bool hasFilters;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.description_outlined,
                color: AppColors.muted, size: 48),
            const SizedBox(height: 16),
            Text(
              hasFilters ? 'No matching documents' : 'No documents yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              hasFilters
                  ? 'Try clearing the filters to see all documents.'
                  : 'Tap Generate to create your first AI document.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (hasFilters) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: onClearFilters,
                child: const Text('Clear Filters'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}