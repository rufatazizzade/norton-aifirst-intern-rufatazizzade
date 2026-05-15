import '../models/extracted_features.dart';

class FeatureExtractorService {
  ExtractedFeatures extract(String input) {
    if (input.isEmpty) return ExtractedFeatures(messageLength: 0);

    final lower = input.toLowerCase();
    final urls = _extractUrls(input);
    final brands = _extractBrands(lower);
    
    // Feature detection
    final hasUrl = urls.isNotEmpty;
    final hasShortenedUrl = _detectShortenedUrls(urls);
    final hasHttpUrl = urls.any((u) => u.startsWith('http://'));
    final hasSuspiciousDomainKeyword = _detectSuspiciousDomainKeywords(urls);
    final hasLookalikeBrandDomain = _detectLookalikeBrandDomain(urls, brands);
    
    final detectedKeywords = <String>[];
    
    final hasUrgency = _checkKeywords(lower, [
      'urgent', 'immediately', 'act now', 'last chance', 
      'today only', 'within 24 hours', 'final notice'
    ], detectedKeywords);

    final hasThreat = _checkKeywords(lower, [
      'account suspended', 'account limited', 'account locked', 
      'arrest', 'legal action', 'financial ruin', 'penalty', 
      'blocked', 'restricted', 'suspended', 'limited', 'locked'
    ], detectedKeywords);

    final hasReward = _checkKeywords(lower, [
      'prize', 'winner', 'reward', 'free', 'bonus', 
      'gift card', 'refund', 'cashback', 'claim now', 'congratulations', 'won'
    ], detectedKeywords);

    final hasCredentialRequest = _checkKeywords(lower, [
      'password', 'otp', 'pin', 'card number', 'ssn', 
      'login', 'verify account', 'confirm identity', 'secure your account'
    ], detectedKeywords);

    final hasDelivery = _checkKeywords(lower, [
      'delivery failed', 'failed delivery', 'package', 
      'parcel', 'shipment', 'tracking', 'redelivery', 'courier'
    ], detectedKeywords);

    final hasGovernment = _checkKeywords(lower, [
      'irs', 'tax', 'government', 'fine', 'penalty', 'court', 'police'
    ], detectedKeywords);

    final hasActionRequest = _checkKeywords(lower, [
      'click the link', 'tap the link', 'follow the steps', 
      'call this number', 'login to continue', 'verify now', 
      'reactivate', 'schedule redelivery', 'register here', 'claim your reward'
    ], detectedKeywords);

    final hasAccountRestriction = _checkKeywords(lower, [
      'limited', 'suspended', 'locked', 'restricted', 'blocked'
    ], detectedKeywords);

    return ExtractedFeatures(
      hasUrl: hasUrl,
      hasShortenedUrl: hasShortenedUrl,
      hasHttpUrl: hasHttpUrl,
      hasSuspiciousDomainKeyword: hasSuspiciousDomainKeyword,
      hasLookalikeBrandDomain: hasLookalikeBrandDomain,
      hasPhoneNumber: _detectPhoneNumber(input),
      hasUrgencyLanguage: hasUrgency,
      hasThreatLanguage: hasThreat,
      hasRewardLanguage: hasReward,
      hasCredentialRequest: hasCredentialRequest,
      hasFinancialLanguage: lower.contains('bank') || lower.contains('money') || lower.contains('cash') || lower.contains('account') || lower.contains('reward') || lower.contains('bonus'),
      hasDeliveryLanguage: hasDelivery,
      hasGovernmentLanguage: hasGovernment,
      hasAccountRestrictionLanguage: hasAccountRestriction,
      hasActionRequest: hasActionRequest,
      hasBrandName: brands.isNotEmpty,
      suspiciousWordCount: detectedKeywords.length,
      messageLength: input.length,
      detectedKeywords: detectedKeywords,
      detectedUrls: urls,
      detectedBrands: brands,
    );
  }

  List<String> _extractUrls(String input) {
    // Detects http/https URLs and also raw domains like bit.ly/xyz or tinyurl.com/abc
    final pattern = RegExp(r'(https?://[^\s]+)|((?:bit\.ly|tinyurl\.com|t\.co|goo\.gl|is\.gd|cutt\.ly|rebrand.ly)/[^\s]+)');
    return pattern.allMatches(input).map((m) {
      final match = m.group(0)!;
      return match.startsWith('http') ? match : 'http://$match';
    }).toList();
  }

  bool _detectShortenedUrls(List<String> urls) {
    final shorteners = [
      'bit.ly', 'tinyurl.com', 't.co', 'goo.gl', 
      'is.gd', 'cutt.ly', 'rebrand.ly'
    ];
    return urls.any((url) => shorteners.any((s) => url.contains(s)));
  }

  bool _detectSuspiciousDomainKeywords(List<String> urls) {
    final keywords = [
      'secure', 'security', 'verify', 'login', 'update', 
      'account', 'banking', 'bank', 'support', 'wallet', 
      'tracking', 'delivery', 'prize', 'reward', 'claim'
    ];
    for (final url in urls) {
      try {
        final domain = url.split('/')[2].toLowerCase();
        if (keywords.any((k) => domain.contains(k)) && 
            !domain.contains('norton.com') && !domain.contains('gen.com')) {
          return true;
        }
      } catch (_) {}
    }
    return false;
  }

  bool _detectLookalikeBrandDomain(List<String> urls, List<String> brands) {
    if (brands.isEmpty || urls.isEmpty) return false;
    for (final url in urls) {
      try {
        final domain = url.split('/')[2].toLowerCase();
        for (final brand in brands) {
          final b = brand.toLowerCase();
          if (domain.contains(b) && domain != '$b.com' && domain != '$b.net' && domain != '$b.org') {
            return true;
          }
        }
      } catch (_) {}
    }
    return false;
  }

  List<String> _extractBrands(String text) {
    final brands = [
      'Amazon', 'FedEx', 'DHL', 'UPS', 'USPS', 'PayPal', 
      'Apple', 'Google', 'Microsoft', 'Netflix', 'Meta', 
      'Instagram', 'Facebook', 'IRS', 'Bank', 'BOI', 'Revolut', 'Wise'
    ];
    return brands.where((b) => text.contains(b.toLowerCase())).toList();
  }

  bool _detectPhoneNumber(String input) {
    final pattern = RegExp(r'(\+?\d{1,3}[\s-]?)?\(?\d{3}\)?[\s-]?\d{3,4}[\s-]?\d{4}|(\+?\d{1,3}[\s-]?)?\d{3}[\s-]?\d{4}');
    return pattern.hasMatch(input);
  }

  bool _checkKeywords(String text, List<String> keywords, List<String> out) {
    bool found = false;
    for (final k in keywords) {
      if (text.contains(k)) {
        if (!out.contains(k)) out.add(k);
        found = true;
      }
    }
    return found;
  }
}
