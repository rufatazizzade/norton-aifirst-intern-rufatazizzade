import '../constants/feature_keys.dart';

class ExtractedFeatures {
  final bool hasUrl;
  final bool hasShortenedUrl;
  final bool hasHttpUrl;
  final bool hasSuspiciousDomainKeyword;
  final bool hasLookalikeBrandDomain;
  final bool hasPhoneNumber;
  final bool hasUrgencyLanguage;
  final bool hasThreatLanguage;
  final bool hasRewardLanguage;
  final bool hasCredentialRequest;
  final bool hasFinancialLanguage;
  final bool hasDeliveryLanguage;
  final bool hasGovernmentLanguage;
  final bool hasAccountRestrictionLanguage;
  final bool hasActionRequest;
  final bool hasBrandName;
  final int suspiciousWordCount;
  final int messageLength;
  final List<String> detectedKeywords;
  final List<String> detectedUrls;
  final List<String> detectedBrands;

  ExtractedFeatures({
    this.hasUrl = false,
    this.hasShortenedUrl = false,
    this.hasHttpUrl = false,
    this.hasSuspiciousDomainKeyword = false,
    this.hasLookalikeBrandDomain = false,
    this.hasPhoneNumber = false,
    this.hasUrgencyLanguage = false,
    this.hasThreatLanguage = false,
    this.hasRewardLanguage = false,
    this.hasCredentialRequest = false,
    this.hasFinancialLanguage = false,
    this.hasDeliveryLanguage = false,
    this.hasGovernmentLanguage = false,
    this.hasAccountRestrictionLanguage = false,
    this.hasActionRequest = false,
    this.hasBrandName = false,
    this.suspiciousWordCount = 0,
    this.messageLength = 0,
    this.detectedKeywords = const [],
    this.detectedUrls = const [],
    this.detectedBrands = const [],
  });

  Map<String, bool> toMap() {
    return {
      FeatureKeys.hasUrl: hasUrl,
      FeatureKeys.hasShortenedUrl: hasShortenedUrl,
      FeatureKeys.hasSuspiciousDomainKeyword: hasSuspiciousDomainKeyword,
      FeatureKeys.hasUrgencyLanguage: hasUrgencyLanguage,
      FeatureKeys.hasThreatLanguage: hasThreatLanguage,
      FeatureKeys.hasRewardLanguage: hasRewardLanguage,
      FeatureKeys.hasCredentialRequest: hasCredentialRequest,
      FeatureKeys.hasFinancialLanguage: hasFinancialLanguage,
      FeatureKeys.hasDeliveryLanguage: hasDeliveryLanguage,
      FeatureKeys.hasGovernmentLanguage: hasGovernmentLanguage,
      FeatureKeys.hasAccountRestrictionLanguage: hasAccountRestrictionLanguage,
      FeatureKeys.hasActionRequest: hasActionRequest,
      FeatureKeys.hasBrandName: hasBrandName,
    };
  }

  @override
  String toString() {
    return 'ExtractedFeatures(words: $suspiciousWordCount, length: $messageLength, urls: ${detectedUrls.length})';
  }
}
