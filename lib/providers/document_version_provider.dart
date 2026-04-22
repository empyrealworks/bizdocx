import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/document_version.dart';
import '../services/firebase_service.dart';

/// Live stream of all versions for a given document, newest first.
final documentVersionsProvider = StreamProvider.family
    .autoDispose<List<DocumentVersion>, ({String portfolioId, String documentId})>(
      (ref, args) => FirebaseService.instance.watchVersions(
    portfolioId: args.portfolioId,
    documentId: args.documentId,
  ),
);