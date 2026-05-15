import 'dart:math';
import '../models/risk_level.dart';
import '../models/scam_signal.dart';
import '../models/scam_category.dart';
import '../models/extracted_features.dart';
import '../constants/feature_keys.dart';

class MlScamClassifierService {
  List<ScamSignal> classify(ExtractedFeatures f) {
    final List<ScamSignal> signals = [];

    if (f.hasUrl) {
      signals.add(const ScamSignal(
        title: 'Contains Link',
        description: 'Phishing often uses links to direct users to fake websites.',
        weight: 10,
        category: ScamCategory.suspiciousUrl,
      ));
    }

    if (f.hasShortenedUrl) {
      signals.add(const ScamSignal(
        title: 'Shortened URL',
        description: 'Shortened links are used to hide the real destination.',
        weight: 25,
        category: ScamCategory.suspiciousUrl,
      ));
    }

    if (f.hasHttpUrl) {
      signals.add(const ScamSignal(
        title: 'Insecure Link',
        description: 'Uses insecure HTTP instead of encrypted HTTPS.',
        weight: 15,
        category: ScamCategory.suspiciousUrl,
      ));
    }

    if (f.hasSuspiciousDomainKeyword) {
      signals.add(const ScamSignal(
        title: 'Suspicious Domain',
        description: 'The link contains keywords often found in phishing domains.',
        weight: 20,
        category: ScamCategory.suspiciousUrl,
      ));
    }

    if (f.hasLookalikeBrandDomain) {
      signals.add(const ScamSignal(
        title: 'Brand Lookalike Domain',
        description: 'The link looks like a real brand but uses a suspicious domain.',
        weight: 30,
        category: ScamCategory.brandImpersonation,
      ));
    }

    if (f.hasUrgencyLanguage) {
      signals.add(const ScamSignal(
        title: 'Urgent Language',
        description: 'Pressure words are used to make you act without thinking.',
        weight: 15,
        category: ScamCategory.unknown,
      ));
    }

    if (f.hasThreatLanguage) {
      signals.add(const ScamSignal(
        title: 'Threat Detected',
        description: 'Mentions of legal action or account suspension are common in scams.',
        weight: 25,
        category: ScamCategory.emergency,
      ));
    }

    if (f.hasRewardLanguage) {
      signals.add(const ScamSignal(
        title: 'Reward Manipulation',
        description: 'Promises of prizes or free money are used to lure victims.',
        weight: 20,
        category: ScamCategory.prize,
      ));
    }

    if (f.hasCredentialRequest) {
      signals.add(const ScamSignal(
        title: 'Credential Request',
        description: 'Asks for sensitive information like passwords or PINs.',
        weight: 30,
        category: ScamCategory.credentialTheft,
      ));
    }

    if (f.hasDeliveryLanguage) {
      signals.add(const ScamSignal(
        title: 'Delivery Theme',
        description: 'Detected language related to shipments or tracking.',
        weight: 15,
        category: ScamCategory.delivery,
      ));
    }

    if (f.hasGovernmentLanguage) {
      signals.add(const ScamSignal(
        title: 'Government Theme',
        description: 'Mentions of tax or official government agencies.',
        weight: 20,
        category: ScamCategory.government,
      ));
    }

    if (f.hasAccountRestrictionLanguage) {
      signals.add(const ScamSignal(
        title: 'Account Warning',
        description: 'Language suggests your account is restricted or limited.',
        weight: 25,
        category: ScamCategory.accountVerification,
      ));
    }

    if (f.hasActionRequest) {
      signals.add(const ScamSignal(
        title: 'Action Request',
        description: 'Specifically asks you to perform an action or call a number.',
        weight: 20,
        category: ScamCategory.unknown,
      ));
    }

    if (f.hasBrandName) {
      signals.add(const ScamSignal(
        title: 'Brand Mention',
        description: 'Mentions a known brand or institution.',
        weight: 10,
        category: ScamCategory.brandImpersonation,
      ));
    }

    // Combination rules
    _applyCombinationRules(f, signals);

    return signals;
  }

  void _applyCombinationRules(ExtractedFeatures f, List<ScamSignal> signals) {
    if (f.hasAccountRestrictionLanguage && f.hasUrl && f.hasActionRequest) {
      signals.add(const ScamSignal(
        title: 'Classic Phishing Pattern',
        description: 'Combines a problem, an action, and a link.',
        weight: 50,
        category: ScamCategory.credentialTheft,
      ));
    }

    if (f.hasBrandName && (f.hasSuspiciousDomainKeyword || f.hasLookalikeBrandDomain)) {
      signals.add(const ScamSignal(
        title: 'Brand Impersonation Phish',
        description: 'Uses a trusted brand name with a suspicious link.',
        weight: 40,
        category: ScamCategory.brandImpersonation,
      ));
    }

    if (f.hasCredentialRequest && f.hasUrl) {
      signals.add(const ScamSignal(
        title: 'Login Theft Attempt',
        description: 'Asks for login details via an external link.',
        weight: 50,
        category: ScamCategory.credentialTheft,
      ));
    }

    if (f.hasRewardLanguage && f.hasUrl && f.hasActionRequest) {
      signals.add(const ScamSignal(
        title: 'Prize Lure Pattern',
        description: 'Combines a reward, an action, and a link.',
        weight: 40,
        category: ScamCategory.prize,
      ));
    }

    if (f.hasGovernmentLanguage && f.hasPhoneNumber) {
      signals.add(const ScamSignal(
        title: 'Official Impersonation',
        description: 'Pretends to be a government agency and asks for a call.',
        weight: 50,
        category: ScamCategory.government,
      ));
    }

    if (f.hasDeliveryLanguage && f.hasUrl && f.hasActionRequest) {
      signals.add(const ScamSignal(
        title: 'Delivery Scam Pattern',
        description: 'Combines a shipping issue with an action and a link.',
        weight: 35,
        category: ScamCategory.delivery,
      ));
    }

    if (f.hasShortenedUrl && (f.hasFinancialLanguage || f.hasAccountRestrictionLanguage || f.hasRewardLanguage)) {
      signals.add(const ScamSignal(
        title: 'Masked Malicious Link',
        description: 'Uses a shortened link combined with sensitive account or reward keywords.',
        weight: 50,
        category: ScamCategory.suspiciousUrl,
      ));
    }
  }

  int calculateConfidence(
    List<ScamSignal> signals, 
    ExtractedFeatures features, 
    String message,
    {Map<String, int> adaptiveWeights = const {}}
  ) {
    if (signals.isEmpty && message.trim().isEmpty) return 0;
    
    // 1. Calculate Base Score from signals
    int baseScore = 0;
    for (final s in signals) {
      baseScore += s.weight;
    }
    
    // Bonus for multiple signals
    if (signals.length > 2) baseScore += 10;
    if (signals.length > 4) baseScore += 15;

    // 2. Calculate Feature Boosts (using central keys)
    int featureBoost = 0;
    final featureMap = features.toMap();
    featureMap.forEach((key, detected) {
      if (detected) {
        featureBoost += adaptiveWeights['feature_$key'] ?? 0;
      }
    });

    // 3. Calculate Fingerprint Boost
    final fingerprint = generateFingerprint(message);
    int fingerprintBoost = adaptiveWeights['fingerprint_$fingerprint'] ?? 0;

    // 4. Return clamped result
    return (baseScore + featureBoost + fingerprintBoost).clamp(0, 100);
  }

  String generateFingerprint(String message) {
    return message.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }

  RiskLevel getRiskLevel(int score) {
    if (score >= 60) return RiskLevel.dangerous;
    if (score >= 25) return RiskLevel.suspicious;
    return RiskLevel.safe;
  }
}
