import '../models/risk_level.dart';
import '../models/scam_signal.dart';
import '../models/scam_category.dart';

enum UserFeedbackType {
  correct,
  actuallySafe,
  actuallyScam;

  String toJson() => name;
  static UserFeedbackType fromJson(String name) => UserFeedbackType.values.byName(name);
}

class UserFeedback {
  final String message;
  final RiskLevel predictedRiskLevel;
  final int predictedConfidence;
  final UserFeedbackType feedbackType;
  final DateTime createdAt;
  final List<ScamSignal> detectedSignals;
  final List<ScamCategory> categories;

  UserFeedback({
    required this.message,
    required this.predictedRiskLevel,
    required this.predictedConfidence,
    required this.feedbackType,
    required this.createdAt,
    required this.detectedSignals,
    required this.categories,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'predictedRiskLevel': predictedRiskLevel.name,
      'predictedConfidence': predictedConfidence,
      'feedbackType': feedbackType.toJson(),
      'createdAt': createdAt.toIso8601String(),
      // In a real app we would serialize signals/categories fully
      'signals': detectedSignals.map((s) => s.title).toList(),
      'categories': categories.map((c) => c.name).toList(),
    };
  }
}
