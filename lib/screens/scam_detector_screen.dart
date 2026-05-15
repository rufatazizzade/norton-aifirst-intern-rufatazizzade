import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../viewmodels/scam_detector_view_model.dart';
import '../widgets/app_header.dart';
import '../widgets/empty_result_card.dart';
import '../widgets/example_message_card.dart';
import '../widgets/input_message_card.dart';
import '../widgets/risk_result_card.dart';

class ScamDetectorScreen extends StatefulWidget {
  const ScamDetectorScreen({super.key});

  @override
  State<ScamDetectorScreen> createState() => _ScamDetectorScreenState();
}

class _ScamDetectorScreenState extends State<ScamDetectorScreen> {
  final _viewModel = ScamDetectorViewModel();
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    setState(() {
      // Sync text controller when example is tapped
      if (_textController.text != _viewModel.inputText) {
        _textController.text = _viewModel.inputText;
        _textController.selection = TextSelection.fromPosition(
          TextPosition(offset: _textController.text.length),
        );
      }
    });
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleAnalyze() async {
    FocusScope.of(context).unfocus();
    await _viewModel.analyze();
    
    // Scroll to result after a short delay to allow UI to update
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutQuart,
        );
      }
    });
  }

  void _handleReset() {
    _textController.clear();
    _viewModel.reset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFEEF2FF), // Very light indigo
              const Color(0xFFF8FAFC), // Slate white
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Header ──
              const SliverToBoxAdapter(child: AppHeader()),

              // ── Input Message Section (Steps 1 & 2 integrated) ──
              SliverToBoxAdapter(
                child: InputMessageCard(
                  controller: _textController,
                  onChanged: _viewModel.updateInput,
                  onClear: _handleReset,
                  onAnalyze: _handleAnalyze,
                  canAnalyze: _viewModel.canAnalyze,
                  isAnalyzing: _viewModel.isAnalyzing,
                ),
              ),

              // ── Example Messages ──
              SliverToBoxAdapter(child: _buildExamplesSection(theme)),

              // ── Result Section (Step 3) ──
              const SliverToBoxAdapter(child: SizedBox(height: 48)),
              
              if (_viewModel.result != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 60 + bottomPadding),
                    child: RiskResultCard(
                      key: ValueKey(_viewModel.result.hashCode),
                      result: _viewModel.result!,
                    ),
                  ),
                )
              else if (!_viewModel.isAnalyzing)
                const SliverToBoxAdapter(
                  child: EmptyResultCard(),
                ),

              // Bottom spacer
              SliverToBoxAdapter(
                child: SizedBox(height: bottomPadding + 60),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExamplesSection(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 48, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tips_and_updates_rounded,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Try an example',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.primary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemCount: ScamDetectorViewModel.exampleMessages.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final ex = ScamDetectorViewModel.exampleMessages[index];
                return ExampleMessageCard(
                  label: ex.label,
                  onTap: () => _viewModel.setExampleMessage(ex.text),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
