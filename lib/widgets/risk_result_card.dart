import 'package:flutter/material.dart';
import '../models/scam_analysis_result.dart';
import '../models/risk_level.dart';
import 'confidence_bar.dart';
import 'recommendation_card.dart';
import 'signal_chip.dart';
import 'category_badge.dart';

class RiskResultCard extends StatelessWidget {
  final ScamAnalysisResult result;

  const RiskResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final level = result.riskLevel;
    final colors = _getRiskColors(level, theme);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _stepLabel(theme, '3'),
              const SizedBox(width: 12),
              Text(
                'Review the result',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: colors.accent.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section with large icon and badge
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colors.accent.withValues(alpha: 0.04),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colors.accent.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getRiskIcon(level),
                              color: colors.accent,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          _buildRiskBadge(level, colors, theme),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        result.explanation,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          height: 1.3,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      if (result.categories.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: result.categories
                              .map((c) => CategoryBadge(category: c))
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Confidence Section
                      ConfidenceBar(
                        score: result.confidenceScore,
                        color: colors.accent,
                      ),
                      const SizedBox(height: 32),

                      // Recommendation Section
                      RecommendationCard(
                        recommendation: result.recommendation,
                        color: colors.accent,
                      ),

                      // Why we flagged this Section
                      if (result.signals.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Icon(Icons.info_outline_rounded, size: 18, color: theme.colorScheme.onSurfaceVariant),
                            const SizedBox(width: 8),
                            Text(
                              'Why we flagged this',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: result.signals.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return SignalChip(signal: result.signals[index]);
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepLabel(ThemeData theme, String text) {
    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: Text(
        text,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRiskBadge(RiskLevel level, _RiskColors colors, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colors.accent,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getRiskIcon(level),
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            level.name.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getRiskIcon(RiskLevel level) {
    switch (level) {
      case RiskLevel.safe:
        return Icons.check_circle_rounded;
      case RiskLevel.suspicious:
        return Icons.warning_rounded;
      case RiskLevel.dangerous:
        return Icons.report_gmailerrorred_rounded;
    }
  }

  _RiskColors _getRiskColors(RiskLevel level, ThemeData theme) {
    switch (level) {
      case RiskLevel.safe:
        return const _RiskColors(accent: Color(0xFF2E7D32));
      case RiskLevel.suspicious:
        return const _RiskColors(accent: Color(0xFFF57C00));
      case RiskLevel.dangerous:
        return const _RiskColors(accent: Color(0xFFD32F2F));
    }
  }
}

class _RiskColors {
  final Color accent;
  const _RiskColors({required this.accent});
}
