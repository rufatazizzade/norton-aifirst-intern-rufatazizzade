import '../models/risk_level.dart';
import '../models/scam_signal.dart';
import '../models/scam_analysis_result.dart';
import '../models/scam_category.dart';
import '../models/extracted_features.dart';
import 'feature_extractor_service.dart';
import 'ml_scam_classifier_service.dart';

class ScamAnalyzerService {
  final FeatureExtractorService _extractor = FeatureExtractorService();
  final MlScamClassifierService _classifier = MlScamClassifierService();

  ScamAnalysisResult analyze(String input) {
    if (input.trim().isEmpty) {
      return ScamAnalysisResult.safe();
    }

    // 1. Feature Extraction
    final features = _extractor.extract(input);

    // 2. ML-Style Classification
    final signals = _classifier.classify(features);
    final confidenceScore = _classifier.calculateConfidence(signals);
    final riskLevel = _classifier.getRiskLevel(confidenceScore);

    // 3. Explanation Generation
    final explanation = _buildExplanation(riskLevel, signals);
    final recommendation = _buildRecommendation(riskLevel);
    
    // 4. Extract Categories
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
