import 'package:flutter_test/flutter_test.dart';
import 'package:scam_detector/models/risk_level.dart';
import 'package:scam_detector/models/scam_category.dart';
import 'package:scam_detector/services/scam_analyzer_service.dart';

void main() {
  late ScamAnalyzerService service;

  setUp(() {
    service = ScamAnalyzerService();
  });

  group('ScamAnalyzerService Required Cases', () {
    test('Safe message: dinner meeting', () {
      final result = service.analyze('Hi, are we still meeting at 6 PM for dinner?');
      expect(result.riskLevel, RiskLevel.safe);
      expect(result.confidenceScore, lessThan(25));
    });

    test('Banking smishing: BOI account limited', () {
      final result = service.analyze(
        'Dear BOI customer, your account has been limited. Please follow the steps to reactivate: https://updatedonlinesecurity-banking.com',
      );
      expect(result.riskLevel, RiskLevel.dangerous);
      expect(result.confidenceScore, greaterThanOrEqualTo(70));
      expect(result.categories, anyOf(contains(ScamCategory.banking), contains(ScamCategory.accountVerification)));
      
      final titles = result.signals.map((s) => s.title).toList();
      expect(titles, contains('Classic Phishing Pattern'));
    });

    test('Delivery smishing: FedEx delivery failed', () {
      final result = service.analyze(
        'FedEx: We attempted to deliver your package today but failed. Schedule redelivery here: http://fedex-delivery-track.info',
      );
      // Brand(10) + Link(10) + Insecure(15) + Delivery(15) + Action(20) + Suspicious Domain(20) + Pattern(40) = 100
      expect(result.riskLevel, anyOf(RiskLevel.dangerous, RiskLevel.suspicious));
      expect(result.confidenceScore, greaterThanOrEqualTo(60));
    });

    test('Prize scam: iPhone winner', () {
      final result = service.analyze(
        'Congratulations! You are the lucky winner of a free iPhone. Claim your reward now: http://tinyurl.com/reward-prize',
      );
      expect(result.riskLevel, RiskLevel.dangerous);
      expect(result.confidenceScore, greaterThanOrEqualTo(70));
    });

    test('Government IRS scam: unpaid taxes', () {
      final result = service.analyze(
        'IRS notice: You have unpaid taxes. Call this number immediately to avoid arrest: +1 555 0199',
      );
      expect(result.riskLevel, RiskLevel.dangerous);
      expect(result.confidenceScore, greaterThanOrEqualTo(70));
    });

    test('Account verification scam: unfamiliar location', () {
      final result = service.analyze(
        'We detected a login attempt from an unfamiliar location. Secure your account here: https://secure-login-verification.com',
      );
      expect(result.riskLevel, RiskLevel.dangerous);
      expect(result.confidenceScore, greaterThanOrEqualTo(70));
    });

    test('Edge case: Empty input', () {
      final result = service.analyze('');
      expect(result.riskLevel, RiskLevel.safe);
      expect(result.confidenceScore, 0);
    });

    // AI-generated test, reviewed and refined manually.
    test('Shortened URL with reward keywords', () {
      final result = service.analyze('You have a reward waiting. Check bit.ly/my-prize');
      expect(result.riskLevel, RiskLevel.dangerous);
      expect(result.confidenceScore, greaterThanOrEqualTo(60));
    });
  });
}
