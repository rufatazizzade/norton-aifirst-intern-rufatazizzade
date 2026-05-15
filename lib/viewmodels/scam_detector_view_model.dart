import 'package:flutter/foundation.dart';

import '../models/scam_analysis_result.dart';
import '../services/scam_analyzer_service.dart';

/// ViewModel for the Scam Detector screen.
///
/// Manages input state, analysis lifecycle, and result presentation.
/// Uses [ChangeNotifier] for lightweight state management compatible
/// with Flutter's built-in [ListenableBuilder].
class ScamDetectorViewModel extends ChangeNotifier {
  final ScamAnalyzerService _service;

  ScamDetectorViewModel({ScamAnalyzerService? service})
      : _service = service ?? ScamAnalyzerService();

  // ── State ──

  String _inputText = '';
  String get inputText => _inputText;

  bool _isAnalyzing = false;
  bool get isAnalyzing => _isAnalyzing;

  ScamAnalysisResult? _result;
  ScamAnalysisResult? get result => _result;

  bool get canAnalyze => _inputText.trim().isNotEmpty && !_isAnalyzing;

  /// Predefined example messages for testing
  static const List<ExampleMessage> exampleMessages = [
    ExampleMessage(
      label: 'Banking Scam',
      text: 'Dear BOI customer, your account has been limited. Please follow the steps to reactivate: https://updatedonlinesecurity-banking.com',
    ),
    ExampleMessage(
      label: 'Delivery Scam',
      text: 'FedEx: We attempted to deliver your package today but failed. Schedule redelivery here: http://fedex-delivery-track.info',
    ),
    ExampleMessage(
      label: 'Prize Scam',
      text: 'Congratulations! You are the lucky winner of a free iPhone. Claim your reward now: http://tinyurl.com/reward-prize',
    ),
    ExampleMessage(
      label: 'IRS Scam',
      text: 'IRS notice: You have unpaid taxes. Call this number immediately to avoid arrest: +1 555 0199',
    ),
    ExampleMessage(
      label: 'Login Verification',
      text: 'We detected a login attempt from an unfamiliar location. Secure your account here: https://secure-login-verification.com',
    ),
    ExampleMessage(
      label: 'Safe Message',
      text: 'Hi, are we still meeting at 6 PM for dinner?',
    ),
  ];

  // ── Actions ──

  void updateInput(String value) {
    _inputText = value;
    notifyListeners();
  }

  void setExampleMessage(String text) {
    _inputText = text;
    _result = null;
    notifyListeners();
  }

  /// Runs the analysis with a short simulated delay for UX polish.
  Future<void> analyze() async {
    if (!canAnalyze) return;

    _isAnalyzing = true;
    _result = null;
    notifyListeners();

    // Simulated processing delay for realism
    await Future.delayed(const Duration(milliseconds: 800));

    _result = _service.analyze(_inputText);
    _isAnalyzing = false;
    notifyListeners();
  }

  void reset() {
    _inputText = '';
    _result = null;
    _isAnalyzing = false;
    notifyListeners();
  }
}

/// A labeled example message for the quick-fill chips.
class ExampleMessage {
  final String label;
  final String text;

  const ExampleMessage({required this.label, required this.text});
}
