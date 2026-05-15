import 'package:flutter/material.dart';
import '../models/scam_analysis_result.dart';
import '../models/risk_level.dart';

class SecurityStatusCard extends StatelessWidget {
  final ScamAnalysisResult? result;

  const SecurityStatusCard({super.key, this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSafe = result?.riskLevel == RiskLevel.safe;
    final isSuspicious = result?.riskLevel == RiskLevel.suspicious;
    final isDangerous = result?.riskLevel == RiskLevel.dangerous;

    Color statusColor = theme.colorScheme.primary;
    IconData statusIcon = Icons.security_rounded;
    String statusTitle = 'Ready to check';
    String statusSubtitle = 'Paste a message below to start.';

    if (result != null) {
      if (isSafe) {
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_outline_rounded;
        statusTitle = 'Likely Safe';
        statusSubtitle = 'No common scam patterns detected.';
      } else if (isSuspicious) {
        statusColor = Colors.orange;
        statusIcon = Icons.warning_amber_rounded;
        statusTitle = 'Suspicious';
        statusSubtitle = 'Proceed with caution.';
      } else if (isDangerous) {
        statusColor = Colors.red;
        statusIcon = Icons.report_gmailerrorred_rounded;
        statusTitle = 'Dangerous';
        statusSubtitle = 'High risk of scam detected.';
      }
    }

    return Card(
      elevation: 0,
      color: statusColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(color: statusColor.withOpacity(0.2), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                statusIcon,
                color: statusColor,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              statusTitle,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              statusSubtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (result != null) ...[
              const SizedBox(height: 24),
              _buildConfidenceIndicator(context, result!.confidenceScore, statusColor),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildConfidenceIndicator(BuildContext context, int score, Color color) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Risk Confidence',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '$score%',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: score / 100,
            minHeight: 10,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
