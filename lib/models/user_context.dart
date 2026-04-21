import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_context.freezed.dart';
part 'user_context.g.dart';

/// The RAG context profile stored per portfolio.
/// Fetched silently and appended to every Gemini prompt.
@freezed
abstract class UserContext with _$UserContext {
  const factory UserContext({
    required String userId,
    required String portfolioId,
    @Default('') String companyName,
    @Default('') String mission,
    @Default([]) List<String> brandColors,
    @Default('') String targetAudience,
    String? logoStorageUrl,
    // Injected from recent doc metadata for stylistic continuity
    @Default([]) List<String> recentDocumentTitles,
    // Client snippets for invoice/proposal auto-fill
    @Default({}) Map<String, String> savedClientDetails,
    // Paths to user-uploaded assets in Storage
    @Default([]) List<String> uploadedAssetStoragePaths,
    DateTime? lastUpdated,
  }) = _UserContext;

  const UserContext._();

  factory UserContext.empty(String uid, String pid) =>
      UserContext(userId: uid, portfolioId: pid);

  factory UserContext.fromJson(Map<String, dynamic> json) =>
      _$UserContextFromJson(json);

  factory UserContext.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserContext.fromJson({
      ...data,
      'lastUpdated': data['lastUpdated'] is Timestamp
          ? (data['lastUpdated'] as Timestamp).toDate().toIso8601String()
          : data['lastUpdated'],
    });
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    return {
      ...json,
      'lastUpdated': lastUpdated != null 
          ? Timestamp.fromDate(lastUpdated!) 
          : Timestamp.now(),
    };
  }
}
