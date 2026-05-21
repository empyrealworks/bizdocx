import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/document_asset.dart';
import '../models/document_folder.dart';
import '../services/firebase_service.dart';

enum DocumentSortCriteria {
  date,
  client,
  type,
}

class FolderState {
  final List<DocumentFolder> folders;
  final DocumentSortCriteria sortCriteria;
  final bool isSelectionMode;
  final Set<String> selectedDocumentIds;

  FolderState({
    required this.folders,
    this.sortCriteria = DocumentSortCriteria.type,
    this.isSelectionMode = false,
    this.selectedDocumentIds = const {},
  });

  FolderState copyWith({
    List<DocumentFolder>? folders,
    DocumentSortCriteria? sortCriteria,
    bool? isSelectionMode,
    Set<String>? selectedDocumentIds,
  }) {
    return FolderState(
      folders: folders ?? this.folders,
      sortCriteria: sortCriteria ?? this.sortCriteria,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedDocumentIds: selectedDocumentIds ?? this.selectedDocumentIds,
    );
  }
}

class FolderNotifier extends Notifier<FolderState> {
  FolderNotifier(this.arg);
  final String arg;

  @override
  FolderState build() {
    final foldersAsync = ref.watch(folderListProvider(arg));
    return FolderState(folders: foldersAsync.value ?? []);
  }

  void setSortCriteria(DocumentSortCriteria criteria) {
    state = state.copyWith(sortCriteria: criteria);
  }

  void toggleSelectionMode() {
    state = state.copyWith(
      isSelectionMode: !state.isSelectionMode,
      selectedDocumentIds: {},
    );
  }

  void toggleDocumentSelection(String id) {
    final current = Set<String>.from(state.selectedDocumentIds);
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    state = state.copyWith(selectedDocumentIds: current);
  }

  void clearSelection() {
    state = state.copyWith(selectedDocumentIds: {}, isSelectionMode: false);
  }

  Future<void> createFolder(String name) async {
    final folder = DocumentFolder(
      id: '',
      portfolioId: arg,
      name: name,
      isAiGenerated: false,
      createdAt: DateTime.now(),
    );
    await FirebaseService.instance.saveFolder(folder);
  }

  Future<void> deleteFolder(DocumentFolder folder) async {
    await FirebaseService.instance.deleteFolder(folder);
  }

  Future<void> moveSelectedToFolder(String? folderId) async {
    if (state.selectedDocumentIds.isEmpty) return;
    await FirebaseService.instance.batchMoveDocuments(
      portfolioId: arg,
      documentIds: state.selectedDocumentIds.toList(),
      targetFolderId: folderId,
    );
    clearSelection();
  }

  Future<void> deleteSelectedDocuments(List<DocumentAsset> allAssets) async {
    if (state.selectedDocumentIds.isEmpty) return;
    final toDelete = allAssets.where((a) => state.selectedDocumentIds.contains(a.id)).toList();
    await FirebaseService.instance.batchDeleteDocuments(toDelete);
    clearSelection();
  }
}

final folderListProvider = StreamProvider.family<List<DocumentFolder>, String>((ref, portfolioId) {
  return FirebaseService.instance.watchFolders(portfolioId);
});

final folderProvider = NotifierProvider.family<FolderNotifier, FolderState, String>(FolderNotifier.new);
