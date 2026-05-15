import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scam_detector/models/user_feedback.dart';
import 'package:scam_detector/models/risk_level.dart';
import 'package:scam_detector/models/scam_signal.dart';
import 'package:scam_detector/models/scam_category.dart';
import 'package:scam_detector/services/feedback_learning_service.dart';
import 'package:scam_detector/services/local_feedback_storage_service.dart';
import 'package:scam_detector/services/ml_scam_classifier_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FeedbackLearningService learningService;
  late LocalFeedbackStorageService storageService;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    learningService = FeedbackLearningService();
    storageService = LocalFeedbackStorageService();
  });

  group('FeedbackLearningService Tests', () {
    // AI-generated test, reviewed and refined manually.
    test('Actually Scam feedback increases adaptive weight', () async {
      final feedback = UserFeedback(
        message: 'Suspicious message',
        predictedRiskLevel: RiskLevel.safe,
        predictedConfidence: 10,
        feedbackType: UserFeedbackType.actuallyScam,
        createdAt: DateTime.now(),
        detectedSignals: [
          const ScamSignal(title: 'Signal A', description: '', weight: 10, category: ScamCategory.unknown),
        ],
        categories: [ScamCategory.unknown],
      );

      await learningService.processFeedback(feedback);
      
      final weights = await storageService.getAdaptiveWeights();
      expect(weights['signal_Signal A'], 8); // Safe -> actuallyScam = +8
      expect(weights['category_unknown'], 4); // delta/2 = 4
    });

    test('Actually Safe feedback decreases adaptive weight', () async {
      final feedback = UserFeedback(
        message: 'Safe message flagged',
        predictedRiskLevel: RiskLevel.dangerous,
        predictedConfidence: 80,
        feedbackType: UserFeedbackType.actuallySafe,
        createdAt: DateTime.now(),
        detectedSignals: [
          const ScamSignal(title: 'Signal B', description: '', weight: 10, category: ScamCategory.unknown),
        ],
        categories: [ScamCategory.unknown],
      );

      await learningService.processFeedback(feedback);
      
      final weights = await storageService.getAdaptiveWeights();
      expect(weights['signal_Signal B'], -8); // Dangerous -> actuallySafe = -8
    });

    test('Weight adjustments are capped at max/min', () async {
      final feedback = UserFeedback(
        message: 'Message',
        predictedRiskLevel: RiskLevel.safe,
        predictedConfidence: 10,
        feedbackType: UserFeedbackType.actuallyScam,
        createdAt: DateTime.now(),
        detectedSignals: [
          const ScamSignal(title: 'Signal C', description: '', weight: 10, category: ScamCategory.unknown),
        ],
        categories: [ScamCategory.unknown],
      );

      // Apply multiple times to hit cap
      for (int i = 0; i < 5; i++) {
        await learningService.processFeedback(feedback);
      }
      
      final weights = await storageService.getAdaptiveWeights();
      expect(weights['signal_Signal C'], 15); // Capped at 15
    });

    test('Adaptive weights affect future confidence score', () {
      final classifier = MlScamClassifierService();
      final signals = [
        const ScamSignal(title: 'Test', description: '', weight: 10, category: ScamCategory.unknown),
      ];
      
      // Base score
      final base = classifier.calculateConfidence(signals);
      expect(base, 10);
      
      // With boost
      final boosted = classifier.calculateConfidence(signals, adaptiveWeights: {'signal_Test': 10});
      expect(boosted, 20);
      
      // With reduction
      final reduced = classifier.calculateConfidence(signals, adaptiveWeights: {'signal_Test': -5});
      expect(reduced, 5);
    });

    test('Reset learning data clears everything', () async {
      final feedback = UserFeedback(
        message: 'X',
        predictedRiskLevel: RiskLevel.safe,
        predictedConfidence: 0,
        feedbackType: UserFeedbackType.actuallyScam,
        createdAt: DateTime.now(),
        detectedSignals: [const ScamSignal(title: 'A', description: '', weight: 0, category: ScamCategory.unknown)],
        categories: [ScamCategory.unknown],
      );

      await learningService.processFeedback(feedback);
      expect((await storageService.getAdaptiveWeights()).isNotEmpty, true);
      
      await learningService.resetLearning();
      expect((await storageService.getAdaptiveWeights()).isEmpty, true);
    });
  });
}
