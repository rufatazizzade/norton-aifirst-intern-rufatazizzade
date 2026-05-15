import 'dart:math';
import '../models/user_feedback.dart';
import '../models/risk_level.dart';
import 'local_feedback_storage_service.dart';
import 'ml_scam_classifier_service.dart';

class FeedbackLearningService {
  final LocalFeedbackStorageService _storage = LocalFeedbackStorageService();
  final MlScamClassifierService _classifier = MlScamClassifierService();

  static const int maxFeatureAdjustment = 15;
  static const int minFeatureAdjustment = -15;
  
  static const int maxFingerprintAdjustment = 40;
  static const int minFingerprintAdjustment = -40;

  Future<void> processFeedback(UserFeedback feedback) async {
    // 1. Save the raw feedback
    await _storage.saveFeedback(feedback);

    // 2. Adjust weights if feedback is not just "Correct"
    if (feedback.feedbackType == UserFeedbackType.actuallyScam) {
      // The model missed it or was unsure. Increase weights.
      await _updateAdaptiveLearning(feedback, 5, 15);
    } else if (feedback.feedbackType == UserFeedbackType.actuallySafe) {
      // False positive. Decrease weights.
      await _updateAdaptiveLearning(feedback, -5, -15);
    }
  }

  Future<void> _updateAdaptiveLearning(UserFeedback feedback, int featureDelta, int fingerprintDelta) async {
    final currentWeights = await _storage.getAdaptiveWeights();

    // 1. Update Feature Weights (using central keys from ExtractedFeatures)
    final featureMap = feedback.features.toMap();
    featureMap.forEach((key, detected) {
      if (detected) {
        final weightKey = 'feature_$key';
        currentWeights[weightKey] = _clampFeatureWeight((currentWeights[weightKey] ?? 0) + featureDelta);
      }
    });

    // 2. Update Message Fingerprint Boost (for exact match)
    final fingerprint = _classifier.generateFingerprint(feedback.message);
    final fingerprintKey = 'fingerprint_$fingerprint';
    currentWeights[fingerprintKey] = _clampFingerprintWeight((currentWeights[fingerprintKey] ?? 0) + fingerprintDelta);

    await _storage.saveAdaptiveWeights(currentWeights);
  }

  int _clampFeatureWeight(int value) {
    return value.clamp(minFeatureAdjustment, maxFeatureAdjustment);
  }

  int _clampFingerprintWeight(int value) {
    return value.clamp(minFingerprintAdjustment, maxFingerprintAdjustment);
  }

  Future<void> resetLearning() async {
    await _storage.clearAll();
  }
}
