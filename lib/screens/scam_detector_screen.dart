import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/scam_detector_view_model.dart';
import '../widgets/app_header.dart';
import '../widgets/security_status_card.dart';
import '../widgets/input_message_card.dart';
import '../widgets/example_messages_section.dart';
import '../widgets/risk_result_card.dart';
import '../widgets/privacy_note.dart';

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

    // Sync controller with viewModel state (e.g. when using examples)
    if (_controller.text != viewModel.inputText) {
      _controller.text = viewModel.inputText;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. App Header
                  const AppHeader(),
                  const SizedBox(height: 32),

                  // 2. Main Security Status Card
                  SecurityStatusCard(result: viewModel.result),
                  const SizedBox(height: 24),

                  // 3. Input Card
                  InputMessageCard(
                    controller: _controller,
                    onChanged: viewModel.updateInput,
                    onClear: () => _handleReset(viewModel),
                    onAnalyze: viewModel.analyze,
                    canAnalyze: viewModel.canAnalyze,
                    isAnalyzing: viewModel.isAnalyzing,
                  ),
                  const SizedBox(height: 32),

                  // 4. Example Messages
                  if (viewModel.result == null && !viewModel.isAnalyzing) ...[
                    ExampleMessagesSection(
                      onSelect: (text) {
                        viewModel.useExample(text);
                        // Optional: Scroll to top or just analyze
                      },
                    ),
                    const SizedBox(height: 32),
                  ],

                  // 5. Analysis Results
                  if (viewModel.result != null) ...[
                    RiskResultCard(
                      result: viewModel.result!,
                      feedbackProvided: viewModel.feedbackProvided,
                      onFeedback: viewModel.provideFeedback,
                    ),
                    const SizedBox(height: 32),
                  ],

                  // 6. Privacy Note & Reset
                  const PrivacyNote(),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () => _handleReset(viewModel),
                    icon: const Icon(Icons.refresh_rounded, size: 16),
                    label: const Text('Reset Everything'),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
