enum ScamCategory {
  banking,
  delivery,
  accountVerification,
  prize,
  emergency,
  government,
  brandImpersonation,
  credentialTheft,
  suspiciousUrl,
  unknown;

  String get displayName {
    switch (this) {
      case ScamCategory.banking: return 'Banking';
      case ScamCategory.delivery: return 'Delivery';
      case ScamCategory.accountVerification: return 'Account Verification';
      case ScamCategory.prize: return 'Prize & Reward';
      case ScamCategory.emergency: return 'Emergency';
      case ScamCategory.government: return 'Government/Tax';
      case ScamCategory.brandImpersonation: return 'Brand Impersonation';
      case ScamCategory.credentialTheft: return 'Credential Theft';
      case ScamCategory.suspiciousUrl: return 'Suspicious URL';
      case ScamCategory.unknown: return 'Unknown';
    }
  }
}
