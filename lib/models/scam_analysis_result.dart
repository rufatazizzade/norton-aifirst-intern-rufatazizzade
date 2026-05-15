import 'risk_level.dart';
import 'scam_signal.dart';
import 'scam_category.dart';
import 'extracted_features.dart';

/// Data Transfer Object for analysis results.
class ScamAnalysisResult {
  final RiskLevel riskLevel;
  final int confidenceScore;
  final String explanation;
  final String recommendation;
  final List<ScamSignal> signals;
  final List<ScamCategory> categories;
  final ExtractedFeatures features;

  ScamAnalysisResult({
    required this.riskLevel,
    required this.confidenceScore,
    required this.explanation,
    required this.recommendation,
    required this.signals,
    this.categories = const [],
    required this.features,
  });

  /// Factory for a safe result when no signals are found.
  factory ScamAnalysisResult.safe([ExtractedFeatures? features]) {
    return ScamAnalysisResult(
      riskLevel: RiskLevel.safe,
      confidenceScore: 0,
      explanation: 'This message does not show common scam patterns. Still be careful with unknown senders.',
      recommendation: 'This message looks low-risk, but avoid opening unexpected links from unknown senders.',
      signals: [],
      categories: [],
      features: features ?? ExtractedFeatures(),
    );
  }

  @override
  String toString() => 'Result(Level: $riskLevel, Score: $confidenceScore%)';
}
