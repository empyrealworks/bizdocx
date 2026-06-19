import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A simplified ReviewService that tracks first export and provides a hook for rating.
/// Note: Real in-app reviews require the 'in_app_review' package.
class ReviewService {
  ReviewService._();
  static final ReviewService instance = ReviewService._();

  static const _kFirstExportDone = 'review_first_export_done';
  static const _kHasPromptedReview = 'review_has_prompted';

  Future<void> markFirstExportDone() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_kFirstExportDone) ?? false) return;
    
    await prefs.setBool(_kFirstExportDone, true);
    debugPrint('[ReviewService] First export marked as done.');
  }

  Future<bool> shouldPromptReview() async {
    final prefs = await SharedPreferences.getInstance();
    final firstExport = prefs.getBool(_kFirstExportDone) ?? false;
    final hasPrompted = prefs.getBool(_kHasPromptedReview) ?? false;
    
    return firstExport && !hasPrompted;
  }

  Future<void> markReviewPrompted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kHasPromptedReview, true);
  }
}
