import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scam_detector/models/user_feedback.dart';
import 'package:scam_detector/models/risk_level.dart';
import 'package:scam_detector/models/scam_signal.dart';
import 'package:scam_detector/models/scam_category.dart';
import 'package:scam_detector/models/extracted_features.dart';
import 'package:scam_detector/constants/feature_keys.dart';
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
    test('Actually Scam feedback increases adaptive weight for features', () async {
      final feedback = UserFeedback(
        message: 'Suspicious message',
        predictedRiskLevel: RiskLevel.safe,
        predictedConfidence: 10,
        feedbackType: UserFeedbackType.actuallyScam,
        createdAt: DateTime.now(),
        detectedSignals: [],
        categories: [],
        features: ExtractedFeatures(hasUrl: true),
      );

      await learningService.processFeedback(feedback);
      
      final weights = await storageService.getAdaptiveWeights();
      expect(weights['feature_${FeatureKeys.hasUrl}'], 5); // actuallyScam = +5 for features
    });

    test('Actually Scam feedback increases fingerprint boost', () async {
      final feedback = UserFeedback(
        message: 'Unique Message',
        predictedRiskLevel: RiskLevel.safe,
        predictedConfidence: 10,
        feedbackType: UserFeedbackType.actuallyScam,
        createdAt: DateTime.now(),
        detectedSignals: [],
        categories: [],
        features: ExtractedFeatures(),
      );

      await learningService.processFeedback(feedback);
      
      final weights = await storageService.getAdaptiveWeights();
      expect(weights['fingerprint_unique message'], 15); // actuallyScam = +15 for fingerprint
    });

    test('Adaptive weights affect future confidence score', () {
      final classifier = MlScamClassifierService();
      final features = ExtractedFeatures(hasUrl: true);
      final signals = [
        const ScamSignal(title: 'Test', description: '', weight: 10, category: ScamCategory.unknown),
      ];
      
      // Base score
      final base = classifier.calculateConfidence(signals, features, 'Test');
      expect(base, 10);
      
      // With feature boost
      final boosted = classifier.calculateConfidence(
        signals, 
        features, 
        'Test', 
        adaptiveWeights: {'feature_${FeatureKeys.hasUrl}': 10}
      );
      expect(boosted, 20);
    });

    test('Reset learning data clears everything', () async {
      final feedback = UserFeedback(
        message: 'X',
        predictedRiskLevel: RiskLevel.safe,
        predictedConfidence: 0,
        feedbackType: UserFeedbackType.actuallyScam,
        createdAt: DateTime.now(),
        detectedSignals: [],
        categories: [],
        features: ExtractedFeatures(hasUrl: true),
      );

      await learningService.processFeedback(feedback);
      expect((await storageService.getAdaptiveWeights()).isNotEmpty, true);
      
      await learningService.resetLearning();
      expect((await storageService.getAdaptiveWeights()).isEmpty, true);
    });
  });
}
