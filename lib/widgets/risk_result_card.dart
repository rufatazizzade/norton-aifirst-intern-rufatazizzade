import 'package:flutter/material.dart';
import '../models/scam_analysis_result.dart';
import '../models/risk_level.dart';
import '../models/user_feedback.dart';
import 'detected_signals_card.dart';
import 'recommendation_card.dart';
import 'feedback_learning_card.dart';
import 'category_badge.dart';

class RiskResultCard extends StatelessWidget {
  final ScamAnalysisResult result;
  final bool feedbackProvided;
  final Function(UserFeedbackType) onFeedback;

  const RiskResultCard({
    super.key, 
    required this.result,
    required this.feedbackProvided,
    required this.onFeedback,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final level = result.riskLevel;
    final color = _getRiskColor(level);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Category Badges (Top)
        if (result.categories.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: result.categories
                  .map((c) => CategoryBadge(category: c))
                  .toList(),
            ),
          ),
          const SizedBox(height: 20),
        ],

        // Recommendation (Primary Action)
        RecommendationCard(
          recommendation: result.recommendation,
          color: color,
        ),
        const SizedBox(height: 20),

        // Signals (Detailed Evidence)
        DetectedSignalsCard(signals: result.signals),
        const SizedBox(height: 20),

        // Feedback
        FeedbackLearningCard(
          feedbackProvided: feedbackProvided,
          onFeedback: onFeedback,
        ),
      ],
    );
  }

  Color _getRiskColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.safe:
        return Colors.green;
      case RiskLevel.suspicious:
        return Colors.orange;
      case RiskLevel.dangerous:
        return Colors.red;
    }
  }
}
