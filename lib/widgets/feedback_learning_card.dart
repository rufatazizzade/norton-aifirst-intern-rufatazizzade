import 'package:flutter/material.dart';
import '../models/user_feedback.dart';

class FeedbackLearningCard extends StatelessWidget {
  final bool feedbackProvided;
  final Function(UserFeedbackType) onFeedback;

  const FeedbackLearningCard({
    super.key,
    required this.feedbackProvided,
    required this.onFeedback,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: feedbackProvided
            ? Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Thanks — your feedback helps improve future checks on this device.',
                      style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Was this result helpful?',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _feedbackBtn(context, 'Correct', Icons.thumb_up_alt_outlined, UserFeedbackType.correct),
                      const SizedBox(width: 8),
                      _feedbackBtn(context, 'Actually safe', Icons.shield_outlined, UserFeedbackType.actuallySafe),
                      const SizedBox(width: 8),
                      _feedbackBtn(context, 'Actually scam', Icons.warning_amber_rounded, UserFeedbackType.actuallyScam),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _feedbackBtn(BuildContext context, String label, IconData icon, UserFeedbackType type) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () => onFeedback(type),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 10), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
