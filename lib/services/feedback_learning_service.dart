import 'dart:math';
import '../models/user_feedback.dart';
import '../models/risk_level.dart';
import 'local_feedback_storage_service.dart';

class FeedbackLearningService {
  final LocalFeedbackStorageService _storage = LocalFeedbackStorageService();

  static const int maxAdjustment = 15;
  static const int minAdjustment = -15;

  Future<void> processFeedback(UserFeedback feedback) async {
    // 1. Save the raw feedback
    await _storage.saveFeedback(feedback);

    // 2. Adjust weights if feedback is not just "Correct"
    if (feedback.feedbackType == UserFeedbackType.correct) {
      // Optional: tiny reinforcement
      if (feedback.predictedRiskLevel == RiskLevel.dangerous) {
        await _updateWeights(feedback, 1);
      }
      return;
    }

    if (feedback.feedbackType == UserFeedbackType.actuallyScam) {
      // The model missed it or was unsure. Increase weights.
      // Increase more if it was predicted as Safe.
      int boost = feedback.predictedRiskLevel == RiskLevel.safe ? 8 : 5;
      await _updateWeights(feedback, boost);
    } else if (feedback.feedbackType == UserFeedbackType.actuallySafe) {
      // False positive. Decrease weights.
      int reduction = feedback.predictedRiskLevel == RiskLevel.dangerous ? -8 : -5;
      await _updateWeights(feedback, reduction);
    }
  }

  Future<void> _updateWeights(UserFeedback feedback, int delta) async {
    final currentWeights = await _storage.getAdaptiveWeights();

    // Update signal weights (titles)
    for (final signal in feedback.detectedSignals) {
      final key = 'signal_${signal.title}';
      currentWeights[key] = _clampWeight((currentWeights[key] ?? 0) + delta);
    }

    // Update category weights
    for (final category in feedback.categories) {
      final key = 'category_${category.name}';
      // Categories get slightly smaller adjustments
      int catDelta = (delta > 0) ? max(1, delta ~/ 2) : min(-1, delta ~/ 2);
      currentWeights[key] = _clampWeight((currentWeights[key] ?? 0) + catDelta);
    }

    await _storage.saveAdaptiveWeights(currentWeights);
  }

  int _clampWeight(int value) {
    return value.clamp(minAdjustment, maxAdjustment);
  }

  Future<void> resetLearning() async {
    await _storage.clearAll();
  }
}
