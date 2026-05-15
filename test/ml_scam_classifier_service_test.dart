import 'package:flutter_test/flutter_test.dart';
import 'package:scam_detector/models/extracted_features.dart';
import 'package:scam_detector/models/risk_level.dart';
import 'package:scam_detector/services/ml_scam_classifier_service.dart';

void main() {
  late MlScamClassifierService service;

  setUp(() {
    service = MlScamClassifierService();
  });

  group('MlScamClassifierService', () {
    test('low confidence for safe features', () {
      final f = ExtractedFeatures(messageLength: 50);
      final signals = service.classify(f);
      final score = service.calculateConfidence(signals, f, 'Test');
      expect(score, 0);
      expect(service.getRiskLevel(score), RiskLevel.safe);
    });

    test('high risk for classic phishing pattern', () {
      final f = ExtractedFeatures(
        hasAccountRestrictionLanguage: true,
        hasUrl: true,
        hasActionRequest: true,
      );
      final signals = service.classify(f);
      final score = service.calculateConfidence(signals, f, 'Message');
      expect(score, greaterThanOrEqualTo(75));
      expect(service.getRiskLevel(score), RiskLevel.dangerous);
    });

    test('high risk for brand lookalike phish', () {
      final f = ExtractedFeatures(
        hasBrandName: true,
        hasLookalikeBrandDomain: true,
        hasUrl: true,
      );
      final signals = service.classify(f);
      final score = service.calculateConfidence(signals, f, 'Message');
      expect(score, greaterThanOrEqualTo(70));
      expect(service.getRiskLevel(score), RiskLevel.dangerous);
    });

    test('high risk for login theft', () {
      final f = ExtractedFeatures(
        hasCredentialRequest: true,
        hasUrl: true,
      );
      final signals = service.classify(f);
      final score = service.calculateConfidence(signals, f, 'Message');
      expect(score, greaterThanOrEqualTo(80));
    });

    test('risk thresholds are correct', () {
      expect(service.getRiskLevel(0), RiskLevel.safe);
      expect(service.getRiskLevel(24), RiskLevel.safe);
      expect(service.getRiskLevel(25), RiskLevel.suspicious);
      expect(service.getRiskLevel(59), RiskLevel.suspicious);
      expect(service.getRiskLevel(60), RiskLevel.dangerous);
      expect(service.getRiskLevel(100), RiskLevel.dangerous);
    });
  });
}
