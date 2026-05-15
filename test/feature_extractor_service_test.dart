import 'package:flutter_test/flutter_test.dart';
import 'package:scam_detector/services/feature_extractor_service.dart';

void main() {
  late FeatureExtractorService service;

  setUp(() {
    service = FeatureExtractorService();
  });

  group('FeatureExtractorService', () {
    test('extracts URL features correctly', () {
      final f = service.extract('Check this: http://insecure-site.com/login');
      expect(f.hasUrl, true);
      expect(f.hasHttpUrl, true);
      expect(f.hasSuspiciousDomainKeyword, true);
      expect(f.detectedUrls, contains('http://insecure-site.com/login'));
    });

    test('detects shortened URLs', () {
      final f = service.extract('Win now: https://bit.ly/prize123');
      expect(f.hasShortenedUrl, true);
    });

    test('detects brand impersonation in domain', () {
      final f = service.extract('Update your account: https://amazon-security-update.com');
      expect(f.hasBrandName, true);
      expect(f.detectedBrands, contains('Amazon'));
      expect(f.hasLookalikeBrandDomain, true);
    });

    test('detects urgency and threat language', () {
      final f = service.extract('Urgent! Your account will be suspended immediately.');
      expect(f.hasUrgencyLanguage, true);
      expect(f.hasThreatLanguage, true);
      expect(f.hasAccountRestrictionLanguage, true);
      expect(f.detectedKeywords, contains('urgent'));
      expect(f.detectedKeywords, contains('suspended'));
    });

    test('detects reward and financial language', () {
      final f = service.extract('Congratulations winner! Claim your free bonus reward now.');
      expect(f.hasRewardLanguage, true);
      expect(f.hasFinancialLanguage, true);
      expect(f.detectedKeywords, contains('winner'));
      expect(f.detectedKeywords, contains('free'));
    });

    test('detects phone numbers', () {
      final f = service.extract('Call us at +1 555 0199 for help.');
      expect(f.hasPhoneNumber, true);
    });

    test('detects delivery theme', () {
      final f = service.extract('Your package shipment is pending.');
      expect(f.hasDeliveryLanguage, true);
    });

    test('detects government theme', () {
      final f = service.extract('Official IRS notice about your tax refund.');
      expect(f.hasGovernmentLanguage, true);
      expect(f.hasRewardLanguage, true);
    });
  });
}
