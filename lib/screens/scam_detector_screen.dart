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

    // Sync controller with viewModel state
    if (_controller.text != viewModel.inputText) {
      _controller.text = viewModel.inputText;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Scam Detector', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _handleReset(viewModel),
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Start Fresh',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                children: [
                  _buildHeroHeader(theme),
                  Padding(
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroHeader(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Check if a message is a scam',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Paste any SMS, email, or link and get a quick safety check.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
            ),
          ),
        ],
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
