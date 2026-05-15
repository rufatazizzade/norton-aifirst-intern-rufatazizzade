import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/scam_detector_view_model.dart';
import '../widgets/input_message_card.dart';
import '../widgets/risk_result_card.dart';
import '../widgets/example_list.dart';

class ScamDetectorScreen extends StatefulWidget {
  const ScamDetectorScreen({super.key});

  @override
  State<ScamDetectorScreen> createState() => _ScamDetectorScreenState();
}

class _ScamDetectorScreenState extends State<ScamDetectorScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleReset(ScamDetectorViewModel viewModel) {
    _controller.clear();
    viewModel.reset();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScamDetectorViewModel>();
    final theme = Theme.of(context);

    // Sync controller with viewModel state if needed (e.g. when using examples)
    if (_controller.text != viewModel.inputText) {
      _controller.text = viewModel.inputText;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(theme),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  InputMessageCard(
                    controller: _controller,
                    onChanged: viewModel.updateInput,
                    onClear: () => _handleReset(viewModel),
                    onAnalyze: viewModel.analyze,
                    canAnalyze: viewModel.canAnalyze,
                    isAnalyzing: viewModel.isAnalyzing,
                  ),
                  
                  if (viewModel.result != null) ...[
                    const SizedBox(height: 32),
                    RiskResultCard(
                      result: viewModel.result!,
                      feedbackProvided: viewModel.feedbackProvided,
                      onFeedback: viewModel.provideFeedback,
                    ),
                  ],

                  if (viewModel.result == null && !viewModel.isAnalyzing) ...[
                    const SizedBox(height: 40),
                    ExampleList(
                      onSelect: viewModel.useExample,
                    ),
                  ],
                  
                  const SizedBox(height: 60),
                  _buildFooter(viewModel, theme),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(ThemeData theme) {
    return SliverAppBar(
      expandedHeight: 180,
      floating: false,
      pinned: true,
      backgroundColor: theme.colorScheme.primary,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scam Detector',
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            if (true) // Keep it small on scroll
              Text(
                'AI-First Safety Check',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.7),
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(
                  Icons.shield_rounded,
                  size: 160,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(ScamDetectorViewModel viewModel, ThemeData theme) {
    return Column(
      children: [
        Text(
          'Private • Local • AI-First',
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: viewModel.resetLearning,
          icon: const Icon(Icons.refresh_rounded, size: 16),
          label: const Text('Reset Learning Data'),
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
            textStyle: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
