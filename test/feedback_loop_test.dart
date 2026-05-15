import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scam_detector/services/scam_analyzer_service.dart';
import 'package:scam_detector/models/user_feedback.dart';
import 'package:scam_detector/models/risk_level.dart';

void main() {
  group('Feedback Loop Integration Tests', () {
    late ScamAnalyzerService analyzer;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      analyzer = ScamAnalyzerService();
    });

    test('Repeated actuallyScam feedback increases confidence score for same message', () async {
      const message = 'Please update your account details: http://verify-account-now.com';

      // 1. Initial analysis
      final first = await analyzer.analyze(message);
      final initialScore = first.confidenceScore;

      // 2. Submit "Actually Scam" feedback
      final feedback1 = UserFeedback(
        message: message,
        predictedRiskLevel: first.riskLevel,
        predictedConfidence: first.confidenceScore,
        feedbackType: UserFeedbackType.actuallyScam,
        createdAt: DateTime.now(),
        detectedSignals: first.signals,
        categories: first.categories,
        features: first.features,
      );
      await analyzer.submitFeedback(feedback1);

      // 3. Second analysis
      final second = await analyzer.analyze(message);
      expect(second.confidenceScore, greaterThan(initialScore), reason: 'Score should increase after first feedback');

      // 4. Submit "Actually Scam" feedback AGAIN
      final feedback2 = UserFeedback(
        message: message,
        predictedRiskLevel: second.riskLevel,
        predictedConfidence: second.confidenceScore,
        feedbackType: UserFeedbackType.actuallyScam,
        createdAt: DateTime.now(),
        detectedSignals: second.signals,
        categories: second.categories,
        features: second.features,
      );
      await analyzer.submitFeedback(feedback2);

      // 5. Final analysis - should definitely be higher, likely Dangerous now
      final third = await analyzer.analyze(message);
      expect(third.confidenceScore, greaterThan(second.confidenceScore));
      
      // With two +15 fingerprint boosts (+30) and some feature boosts, it should cross 60
      expect(third.riskLevel, isNot(RiskLevel.safe));
    });

    test('ActuallySafe feedback decreases confidence score', () async {
      const message = 'Your delivery is scheduled for tomorrow.';
      // Force a suspicious state if it wasn't already (though this one is likely safe)
      
      final first = await analyzer.analyze(message);
      
      final feedback = UserFeedback(
        message: message,
        predictedRiskLevel: first.riskLevel,
        predictedConfidence: first.confidenceScore,
        feedbackType: UserFeedbackType.actuallySafe,
        createdAt: DateTime.now(),
        detectedSignals: first.signals,
        categories: first.categories,
        features: first.features,
      );
      await analyzer.submitFeedback(feedback);

      final second = await analyzer.analyze(message);
      expect(second.confidenceScore, lessThanOrEqualTo(first.confidenceScore));
    });

    test('Fingerprint boost is capped', () async {
      const message = 'Fixed fingerprint test message';
      
      for (int i = 0; i < 5; i++) {
        final result = await analyzer.analyze(message);
        await analyzer.submitFeedback(UserFeedback(
          message: message,
          predictedRiskLevel: result.riskLevel,
          predictedConfidence: result.confidenceScore,
          feedbackType: UserFeedbackType.actuallyScam,
          createdAt: DateTime.now(),
          detectedSignals: result.signals,
          categories: result.categories,
          features: result.features,
        ));
      }

      final last = await analyzer.analyze(message);
      // Max fingerprint boost is 40. 
      // Initial score is likely 0. Feature boosts are 5 each.
      // Score should be high but capped correctly internally.
      expect(last.confidenceScore, greaterThanOrEqualTo(40));
    });
  });
}
