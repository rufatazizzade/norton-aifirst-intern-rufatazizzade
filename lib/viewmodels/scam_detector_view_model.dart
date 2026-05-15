import 'package:flutter/material.dart';
import '../models/scam_analysis_result.dart';
import '../models/user_feedback.dart';
import '../services/scam_analyzer_service.dart';

class ScamDetectorViewModel extends ChangeNotifier {
  final ScamAnalyzerService _analyzerService = ScamAnalyzerService();
  
  String _inputText = '';
  ScamAnalysisResult? _result;
  bool _isAnalyzing = false;
  bool _feedbackProvided = false;

  String get inputText => _inputText;
  ScamAnalysisResult? get result => _result;
  bool get isAnalyzing => _isAnalyzing;
  bool get feedbackProvided => _feedbackProvided;

  void updateInput(String text) {
    _inputText = text;
    notifyListeners();
  }

  bool get canAnalyze => _inputText.trim().isNotEmpty && !_isAnalyzing;

  Future<void> analyze() async {
    if (!canAnalyze) return;

    _isAnalyzing = true;
    _result = null;
    _feedbackProvided = false;
    notifyListeners();

    try {
      _result = await _analyzerService.analyze(_inputText);
    } catch (e) {
      debugPrint('Analysis error: $e');
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  Future<void> provideFeedback(UserFeedbackType type) async {
    if (_result == null || _feedbackProvided) return;

    final feedback = UserFeedback(
      message: _inputText,
      predictedRiskLevel: _result!.riskLevel,
      predictedConfidence: _result!.confidenceScore,
      feedbackType: type,
      createdAt: DateTime.now(),
      detectedSignals: _result!.signals,
      categories: _result!.categories,
    );

    await _analyzerService.submitFeedback(feedback);
    _feedbackProvided = true;
    notifyListeners();
  }

  Future<void> resetLearning() async {
    await _analyzerService.resetLearning();
    reset(); // Clear current results too
    notifyListeners();
  }

  void reset() {
    _inputText = '';
    _result = null;
    _isAnalyzing = false;
    _feedbackProvided = false;
    notifyListeners();
  }

  void useExample(String text) {
    updateInput(text);
    analyze();
  }

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
}

class ExampleMessage {
  final String label;
  final String text;
  const ExampleMessage({required this.label, required this.text});
}
