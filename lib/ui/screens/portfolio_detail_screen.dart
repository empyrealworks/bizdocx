import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/extensions/context_extensions.dart';
import '../../models/business_portfolio.dart';
import '../../models/document_asset.dart';
import '../../models/document_folder.dart';
import '../../providers/document_generation_provider.dart';
import '../../providers/folder_provider.dart';
import '../../providers/portfolio_provider.dart';
import '../../services/firebase_service.dart';
import '../sheets/asset_manager_sheet.dart';
import '../sheets/edit_portfolio_sheet.dart';
import '../sheets/scanning_workflow_sheet.dart';
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
  DocumentType?  _typeFilter;

  List<DocumentAsset> _applyFilters(List<DocumentAsset> docs) => docs
      .where((d) =>
  (_pipelineFilter == null || d.pipeline == _pipelineFilter) &&
      (_typeFilter == null || d.type == _typeFilter))
      .toList();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    final portfolio = ref.watch(portfolioListProvider)
        .whenData((list) {
      try { return list.firstWhere((p) => p.id == widget.portfolioId); }
      catch (_) { return null; }
    })
        .value;

    final documentsAsync = ref.watch(documentListProvider(widget.portfolioId));
    final folderState = ref.watch(folderProvider(widget.portfolioId));
    final folderNotifier = ref.read(folderProvider(widget.portfolioId).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(portfolio?.name ?? 'Portfolio'),
        leading: folderState.isSelectionMode 
          ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: folderNotifier.clearSelection,
            )
          : BackButton(onPressed: () => context.go('/')),
        actions: [
          if (folderState.isSelectionMode) ...[
            IconButton(
              icon: const Icon(Icons.drive_file_move_outlined),
              onPressed: () => _showMoveDialog(context, folderState.folders),
              tooltip: 'Move to folder',
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _confirmBatchDelete(context, documentsAsync.value ?? []),
              tooltip: 'Delete selected',
            ),
          ] else if (portfolio != null) ...[
            _ManualModeToggle(portfolio: portfolio),
            IconButton(
              icon: const Icon(Icons.sort),
              onPressed: () => _showSortMenu(context, folderNotifier),
              tooltip: 'Sort options',
            ),
            IconButton(
              icon: Icon(Icons.photo_library_outlined,
                  size: 20, color: c.iconPrimary),
              tooltip: 'Manage assets & logo',
              onPressed: () => _showSheet(
                  context, AssetManagerSheet(portfolioId: widget.portfolioId)),
            ),
            IconButton(
              icon: Icon(Icons.edit_outlined,
                  size: 20, color: c.iconPrimary),
              tooltip: 'Edit business info',
              onPressed: () =>
                  _showSheet(context, EditPortfolioSheet(portfolio: portfolio)),
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          if (portfolio != null && !folderState.isSelectionMode) 
            _ContextBanner(portfolio: portfolio),
          if (!folderState.isSelectionMode)
            _FilterBar(
              pipelineFilter: _pipelineFilter,
              typeFilter: _typeFilter,
              onPipelineChanged: (p) =>
                  setState(() { _pipelineFilter = p; _typeFilter = null; }),
              onTypeChanged: (t) => setState(() => _typeFilter = t),
            ),
          Expanded(
            child: documentsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text('$e',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.error)),
              ),
              data: (docs) {
                final filtered = _applyFilters(docs);
                if (filtered.isEmpty) {
                  return _EmptyDocState(
                    hasFilters: _pipelineFilter != null || _typeFilter != null,
                    onClearFilters: () => setState(() {
                      _pipelineFilter = null;
                      _typeFilter = null;
                    }),
                  );
                }

                if (portfolio?.enableManualMode == true) {
                   return _ManualFolderView(
                     docs: filtered,
                     folders: folderState.folders,
                     portfolioId: widget.portfolioId,
                     selectionMode: folderState.isSelectionMode,
                     selectedIds: folderState.selectedDocumentIds,
                     onSelect: folderNotifier.toggleDocumentSelection,
                     onLongPress: folderNotifier.toggleSelectionMode,
                   );
                }

                if (folderState.sortCriteria == DocumentSortCriteria.date) {
                   return _DocumentList(
                    docs: filtered,
                    portfolioId: widget.portfolioId,
                    selectionMode: folderState.isSelectionMode,
                    selectedIds: folderState.selectedDocumentIds,
                    onSelect: folderNotifier.toggleDocumentSelection,
                    onLongPress: folderNotifier.toggleSelectionMode,
                  );
                }

                // AI Generated / Categorized View
                return _CategorizedView(
                  docs: filtered,
                  folders: folderState.folders,
                  portfolioId: widget.portfolioId,
                  sortCriteria: folderState.sortCriteria,
                  selectionMode: folderState.isSelectionMode,
                  selectedIds: folderState.selectedDocumentIds,
                  onSelect: folderNotifier.toggleDocumentSelection,
                  onLongPress: folderNotifier.toggleSelectionMode,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: folderState.isSelectionMode ? null : Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () => _showScanningSheet(context),
            backgroundColor: context.colors.card,
            foregroundColor: context.colors.iconPrimary,
            heroTag: 'scan_fab',
            icon: const Icon(Icons.document_scanner_outlined),
            label: const Text('Scan'),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            onPressed: () =>
                context.go('/portfolio/${widget.portfolioId}/generate'),
            backgroundColor: context.colors.filledButtonBg,
            foregroundColor: context.colors.filledButtonFg,
            icon: const Icon(Icons.auto_awesome, size: 18),
            label: const Text('Generate'),
            heroTag: 'gen_fab',
          ),
        ],
      ),
    );
  }

  void _showSheet(BuildContext context, Widget sheet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => sheet,
    );
  }

  void _showSortMenu(BuildContext context, FolderNotifier notifier) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Sort by Date'),
            onTap: () { notifier.setSortCriteria(DocumentSortCriteria.date); Navigator.pop(ctx); },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Group by Client'),
            onTap: () { notifier.setSortCriteria(DocumentSortCriteria.client); Navigator.pop(ctx); },
          ),
          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: const Text('Group by Type'),
            onTap: () { notifier.setSortCriteria(DocumentSortCriteria.type); Navigator.pop(ctx); },
          ),
        ],
      ),
    );
  }

  void _showMoveDialog(BuildContext context, List<DocumentFolder> folders) {
     showDialog(
       context: context,
       builder: (ctx) => AlertDialog(
         title: const Text('Move to Folder'),
         content: SizedBox(
           width: double.maxFinite,
           child: ListView(
             shrinkWrap: true,
             children: [
               ListTile(
                 title: const Text('Root / No Folder'),
                 onTap: () {
                   ref.read(folderProvider(widget.portfolioId).notifier).moveSelectedToFolder(null);
                   Navigator.pop(ctx);
                 },
               ),
               ...folders.map((f) => ListTile(
                 title: Text(f.name),
                 onTap: () {
                   ref.read(folderProvider(widget.portfolioId).notifier).moveSelectedToFolder(f.id);
                   Navigator.pop(ctx);
                 },
               )),
               const Divider(),
               ListTile(
                 leading: const Icon(Icons.add),
                 title: const Text('New Folder'),
                 onTap: () {
                    Navigator.pop(ctx);
                    _showNewFolderDialog(context);
                 },
               ),
             ],
           ),
         ),
       ),
     );
  }

  void _showNewFolderDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Folder'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Folder name'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(folderProvider(widget.portfolioId).notifier).createFolder(controller.text);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _confirmBatchDelete(BuildContext context, List<DocumentAsset> allDocs) {
     showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Selected?'),
        content: const Text('Are you sure you want to delete all selected documents? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              ref.read(folderProvider(widget.portfolioId).notifier).deleteSelectedDocuments(allDocs);
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showScanningSheet(BuildContext context) {
    _showSheet(context, ScanningWorkflowSheet(portfolioId: widget.portfolioId));
  }
}

// ── Manual Mode Toggle ────────────────────────────────────────────────────────

class _ManualModeToggle extends ConsumerWidget {
  const _ManualModeToggle({required this.portfolio});
  final BusinessPortfolio portfolio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(
        portfolio.enableManualMode ? Icons.lock_open : Icons.auto_awesome_mosaic,
        color: portfolio.enableManualMode ? context.colors.iconPrimary : context.colors.textMuted,
      ),
      tooltip: portfolio.enableManualMode ? 'Manual Mode Enabled' : 'AI Routing Enabled',
      onPressed: () {
        FirebaseService.instance.updatePortfolio(
          portfolio.copyWith(enableManualMode: !portfolio.enableManualMode),
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(portfolio.enableManualMode 
            ? 'AI Organization Mode Enabled' 
            : 'Manual Organization Mode Enabled'),
          duration: const Duration(seconds: 2),
        ));
      },
    );
  }
}

// ── Categorized / Folder View ────────────────────────────────────────────────

class _CategorizedView extends StatelessWidget {
  const _CategorizedView({
    required this.docs,
    required this.folders,
    required this.portfolioId,
    required this.sortCriteria,
    required this.selectionMode,
    required this.selectedIds,
    required this.onSelect,
    required this.onLongPress,
  });

  final List<DocumentAsset> docs;
  final List<DocumentFolder> folders;
  final String portfolioId;
  final DocumentSortCriteria sortCriteria;
  final bool selectionMode;
  final Set<String> selectedIds;
  final ValueChanged<String> onSelect;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    if (sortCriteria == DocumentSortCriteria.client) {
      return _buildClientGroups(context);
    }
    return _buildTypeGroups(context);
  }

  Widget _buildClientGroups(BuildContext context) {
    final Map<String, List<DocumentAsset>> groups = {};
    for (var doc in docs) {
      final client = doc.clientName ?? 'Unknown Client';
      groups.putIfAbsent(client, () => []).add(doc);
    }

    final clients = groups.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: clients.length,
      itemBuilder: (context, i) {
        final client = clients[i];
        final clientDocs = groups[client]!;
        return _FolderExpansionTile(
          title: client,
          icon: Icons.person_outline,
          count: clientDocs.length,
          children: clientDocs.map((doc) => DocumentTile(
            asset: doc,
            selectionMode: selectionMode,
            isSelected: selectedIds.contains(doc.id),
            onSelect: onSelect,
            onLongPress: onLongPress,
            onTap: () => context.go('/portfolio/$portfolioId/doc/${doc.id}', extra: doc),
          )).toList(),
        );
      },
    );
  }

  Widget _buildTypeGroups(BuildContext context) {
    final Map<DocumentType, List<DocumentAsset>> groups = {};
    for (var doc in docs) {
      groups.putIfAbsent(doc.type, () => []).add(doc);
    }

    final types = groups.keys.toList()..sort((a, b) => a.name.compareTo(b.name));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: types.length,
      itemBuilder: (context, i) {
        final type = types[i];
        final typeDocs = groups[type]!;
        return _FolderExpansionTile(
          title: type.name.toUpperCase(),
          icon: Icons.folder_open,
          count: typeDocs.length,
          children: typeDocs.map((doc) => DocumentTile(
            asset: doc,
            selectionMode: selectionMode,
            isSelected: selectedIds.contains(doc.id),
            onSelect: onSelect,
            onLongPress: onLongPress,
            onTap: () => context.go('/portfolio/$portfolioId/doc/${doc.id}', extra: doc),
          )).toList(),
        );
      },
    );
  }
}

class _ManualFolderView extends ConsumerWidget {
  const _ManualFolderView({
    required this.docs,
    required this.folders,
    required this.portfolioId,
    required this.selectionMode,
    required this.selectedIds,
    required this.onSelect,
    required this.onLongPress,
  });

  final List<DocumentAsset> docs;
  final List<DocumentFolder> folders;
  final String portfolioId;
  final bool selectionMode;
  final Set<String> selectedIds;
  final ValueChanged<String> onSelect;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rootDocs = docs.where((d) => d.folderId == null).toList();
    
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        ...folders.map((f) {
           final folderDocs = docs.where((d) => d.folderId == f.id).toList();
           return _FolderExpansionTile(
             title: f.name,
             icon: Icons.folder,
             count: folderDocs.length,
             onDelete: () => _confirmDeleteFolder(context, ref, f),
             children: folderDocs.map((doc) => DocumentTile(
               asset: doc,
               selectionMode: selectionMode,
               isSelected: selectedIds.contains(doc.id),
               onSelect: onSelect,
               onLongPress: onLongPress,
               onTap: () => context.go('/portfolio/$portfolioId/doc/${doc.id}', extra: doc),
             )).toList(),
           );
        }),
        if (rootDocs.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text('Files', style: TextStyle(fontWeight: FontWeight.bold, color: context.colors.textPrimary.withValues(alpha: 0.5))),
          ),
          ...rootDocs.map((doc) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: DocumentTile(
              asset: doc,
              selectionMode: selectionMode,
              isSelected: selectedIds.contains(doc.id),
              onSelect: onSelect,
              onLongPress: onLongPress,
              onTap: () => context.go('/portfolio/$portfolioId/doc/${doc.id}', extra: doc),
            ),
          )),
        ],
      ],
    );
  }

  void _confirmDeleteFolder(BuildContext context, WidgetRef ref, DocumentFolder folder) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Folder?'),
        content: const Text('Deleting a folder will not delete the documents inside; they will move to the root.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
               ref.read(folderProvider(portfolioId).notifier).deleteFolder(folder);
               Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _FolderExpansionTile extends StatelessWidget {
  const _FolderExpansionTile({
    required this.title,
    required this.icon,
    required this.count,
    required this.children,
    this.onDelete,
  });
  final String title; final IconData icon; final int count; final List<Widget> children;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Icon(icon, color: context.colors.iconSecondary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$count', style: TextStyle(color: context.colors.textMuted)),
            if (onDelete != null) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18),
                onPressed: onDelete,
              ),
            ],
          ],
        ),
        childrenPadding: const EdgeInsets.only(left: 16),
        children: children.map((c) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: c,
        )).toList(),
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
  final DocumentType?  typeFilter;
  final ValueChanged<AssetPipeline?> onPipelineChanged;
  final ValueChanged<DocumentType?>  onTypeChanged;

  static const _structural = [
    DocumentType.invoice, DocumentType.proposal, DocumentType.letterhead,
    DocumentType.businessCard, DocumentType.contract, DocumentType.other,
  ];
  static const _graphical = [DocumentType.logo, DocumentType.icon];

  List<DocumentType> get _relevantTypes {
    if (pipelineFilter == AssetPipeline.structural) return _structural;
    if (pipelineFilter == AssetPipeline.graphical)  return _graphical;
    return [..._structural, ..._graphical];
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: c.border))),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(children: [
              _Chip(label: 'All',
                  active: pipelineFilter == null,
                  onTap: () => onPipelineChanged(null)),
              const SizedBox(width: 8),
              _Chip(
                  label: 'Structural',
                  icon: Icons.description_outlined,
                  active: pipelineFilter == AssetPipeline.structural,
                  onTap: () => onPipelineChanged(
                      pipelineFilter == AssetPipeline.structural
                          ? null : AssetPipeline.structural)),
              const SizedBox(width: 8),
              _Chip(
                  label: 'Graphical',
                  icon: Icons.auto_awesome_outlined,
                  active: pipelineFilter == AssetPipeline.graphical,
                  onTap: () => onPipelineChanged(
                      pipelineFilter == AssetPipeline.graphical
                          ? null : AssetPipeline.graphical)),
            ]),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            child: Row(children: [
              _Chip(label: 'All types',
                  active: typeFilter == null,
                  onTap: () => onTypeChanged(null),
                  small: true),
              ..._relevantTypes.map((t) => Padding(
                padding: const EdgeInsets.only(left: 6),
                child: _Chip(
                    label: _label(t),
                    active: typeFilter == t,
                    onTap: () =>
                        onTypeChanged(typeFilter == t ? null : t),
                    small: true),
              )),
            ]),
          ),
        ],
      ),
    );
  }

  String _label(DocumentType t) {
    switch (t) {
      case DocumentType.invoice:      return 'Invoice';
      case DocumentType.proposal:     return 'Proposal';
      case DocumentType.letterhead:   return 'Letterhead';
      case DocumentType.businessCard: return 'Business Card';
      case DocumentType.contract:     return 'Contract';
      case DocumentType.logo:         return 'Logo';
      case DocumentType.icon:         return 'Icon';
      case DocumentType.other:        return 'Other';
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
  final String label; final bool active; final VoidCallback onTap;
  final IconData? icon; final bool small;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(
            horizontal: small ? 10 : 12, vertical: small ? 5 : 7),
        decoration: BoxDecoration(
          color: active ? c.filledButtonBg : c.chipFill,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? c.filledButtonBg : c.border),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[
            Icon(icon,
                size: 12,
                color: active ? c.filledButtonFg : c.iconSecondary),
            const SizedBox(width: 4),
          ],
          Text(label,
              style: TextStyle(
                color: active ? c.filledButtonFg : c.textBody,
                fontSize: small ? 11 : 12,
                fontWeight: FontWeight.w500,
              )),
        ]),
      ),
    );
  }
}

// ── Context Banner ────────────────────────────────────────────────────────────

class _ContextBanner extends StatelessWidget {
  const _ContextBanner({required this.portfolio});
  final BusinessPortfolio portfolio;

  static Color? _primaryColor(List<String> colors) {
    if (colors.isEmpty) return null;
    try {
      return Color(int.parse(
          'FF${colors.first.replaceAll('#', '').trim()}',
          radix: 16));
    } catch (_) { return null; }
  }

  @override
  Widget build(BuildContext context) {
    final c      = context.colors;
    final accent = _primaryColor(portfolio.brandColors);
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: accent?.withValues(alpha: 0.3) ?? c.border),
      ),
      child: Row(children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            color: accent?.withValues(alpha: 0.15) ?? c.chipFill,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: accent?.withValues(alpha: 0.3) ?? c.border),
          ),
          child: Icon(Icons.business_center_outlined,
              color: accent ?? c.iconSecondary, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(portfolio.name,
                style: Theme.of(context).textTheme.titleLarge),
            if (portfolio.description.isNotEmpty)
              Text(portfolio.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        )),
        Text('${portfolio.documentIds.length} docs',
            style: Theme.of(context).textTheme.labelSmall),
      ]),
    );
  }
}

// ── Document List ─────────────────────────────────────────────────────────────

class _DocumentList extends ConsumerWidget {
  const _DocumentList({
    required this.docs,
    required this.portfolioId,
    this.selectionMode = false,
    this.selectedIds = const {},
    this.onSelect,
    this.onLongPress,
  });

  final List<DocumentAsset> docs;
  final String portfolioId;
  final bool selectionMode;
  final Set<String> selectedIds;
  final ValueChanged<String>? onSelect;
  final VoidCallback? onLongPress;

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
          selectionMode: selectionMode,
          isSelected: selectedIds.contains(doc.id),
          onSelect: onSelect,
          onLongPress: onLongPress,
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
  const _EmptyDocState(
      {required this.hasFilters, required this.onClearFilters});
  final bool hasFilters;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.description_outlined, color: c.textMuted, size: 48),
          const SizedBox(height: 16),
          Text(hasFilters ? 'No matching documents' : 'No documents yet',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            hasFilters
                ? 'Try clearing filters to see all documents.'
                : 'Tap Generate to create your first AI document.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (hasFilters) ...[
            const SizedBox(height: 16),
            OutlinedButton(
                onPressed: onClearFilters,
                child: const Text('Clear Filters')),
          ],
        ]),
      ),
    );
  }
}