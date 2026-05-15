import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scam_detector/services/scam_analyzer_service.dart';
import 'package:scam_detector/models/user_feedback.dart';
import 'package:scam_detector/models/risk_level.dart';

void main() {
  group('Adaptive Feedback Scenario', () {
    late ScamAnalyzerService analyzer;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      analyzer = ScamAnalyzerService();
    });

    test('Safe message becomes suspicious after repeated actuallyScam feedback', () async {
      // 1. Use one safe-looking SMS (initially 0 or very low score)
      const message = 'Hey, are we still meeting for lunch at 1pm?';

      // 2. Analyze it before feedback
      final initialResult = await analyzer.analyze(message);
      expect(initialResult.riskLevel, RiskLevel.safe);
      final initialScore = initialResult.confidenceScore;

      // 3. Store repeated UserFeedbackType.actuallyScam feedback (x2)
      // First feedback
      await analyzer.submitFeedback(UserFeedback(
        message: message,
        predictedRiskLevel: initialResult.riskLevel,
        predictedConfidence: initialResult.confidenceScore,
        feedbackType: UserFeedbackType.actuallyScam,
        createdAt: DateTime.now(),
        detectedSignals: initialResult.signals,
        categories: initialResult.categories,
        features: initialResult.features,
      ));

      // Re-analyze once to get intermediate state
      final midResult = await analyzer.analyze(message);
      
      // Second feedback
      await analyzer.submitFeedback(UserFeedback(
        message: message,
        predictedRiskLevel: midResult.riskLevel,
        predictedConfidence: midResult.confidenceScore,
        feedbackType: UserFeedbackType.actuallyScam,
        createdAt: DateTime.now(),
        detectedSignals: midResult.signals,
        categories: midResult.categories,
        features: midResult.features,
      ));

      // 4. Re-analyze the same message
      final finalResult = await analyzer.analyze(message);

      // 5. Compares actual vs expected
      // - score after feedback must be higher than before
      expect(finalResult.confidenceScore, greaterThan(initialScore));
      
      // - risk after feedback must not remain Safe
      expect(finalResult.riskLevel, isNot(RiskLevel.safe));
      
      // - expected score after feedback should be at least 25 (Suspicious threshold)
      // Fingerprint boost is +15 per feedback. 2 feedbacks = +30.
      expect(finalResult.confidenceScore, greaterThanOrEqualTo(25));
    });
  });
}
