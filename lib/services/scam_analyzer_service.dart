import '../models/risk_level.dart';
import '../models/scam_analysis_result.dart';
import '../models/scam_category.dart';
import '../models/user_feedback.dart';
import 'feature_extractor_service.dart';
import 'ml_scam_classifier_service.dart';
import 'local_feedback_storage_service.dart';
import 'feedback_learning_service.dart';

class ScamAnalyzerService {
  final FeatureExtractorService _extractor = FeatureExtractorService();
  final MlScamClassifierService _classifier = MlScamClassifierService();
  final LocalFeedbackStorageService _storage = LocalFeedbackStorageService();
  final FeedbackLearningService _learning = FeedbackLearningService();

  Future<ScamAnalysisResult> analyze(String input) async {
    if (input.trim().isEmpty) {
      return ScamAnalysisResult.safe();
    }

    // 1. Load adaptive weights from local storage
    final adaptiveWeights = await _storage.getAdaptiveWeights();

    // 2. Feature Extraction
    final features = _extractor.extract(input);

    // 3. ML-Style Classification with adaptive weights
    final signals = _classifier.classify(features);
    final confidenceScore = _classifier.calculateConfidence(signals, adaptiveWeights: adaptiveWeights);
    final riskLevel = _classifier.getRiskLevel(confidenceScore);

    // 4. Explanation Generation
    final explanation = _buildExplanation(riskLevel, signals);
    final recommendation = _buildRecommendation(riskLevel);
    
    // 5. Extract Categories
    final categories = signals.map((s) => s.category).toSet().toList();
    if (categories.isEmpty) categories.add(ScamCategory.unknown);

    return ScamAnalysisResult(
      riskLevel: riskLevel,
      confidenceScore: confidenceScore,
      explanation: explanation,
      recommendation: recommendation,
      signals: signals,
      categories: categories,
      features: features,
    );
  }

  Future<void> submitFeedback(UserFeedback feedback) async {
    await _learning.processFeedback(feedback);
  }

  Future<void> resetLearning() async {
    await _learning.resetLearning();
  }

  String _buildExplanation(RiskLevel level, List<ScamSignal> signals) {
    if (signals.isEmpty) {
      return 'This message does not show common scam patterns. Still be careful with unknown senders.';
    }

    switch (level) {
      case RiskLevel.dangerous:
        return 'This message shows strong phishing or smishing signs, such as account warnings, suspicious links, or requests for personal information.';
      case RiskLevel.suspicious:
        return 'This message contains some warning signs, such as urgent wording or a link. Verify the sender before clicking anything.';
      case RiskLevel.safe:
        return 'Minor indicators found but risk is low. The message is likely safe, but stay vigilant.';
    }
  }

  String _buildRecommendation(RiskLevel level) {
    switch (level) {
      case RiskLevel.dangerous:
        return 'Do not click the link, call the number, or share personal information. Delete or report the message.';
      case RiskLevel.suspicious:
        return 'Do not click the link yet. Open the official app or website directly and verify the message.';
      case RiskLevel.safe:
        return 'This message looks low-risk, but avoid opening unexpected links from unknown senders.';
    }
  }
}
