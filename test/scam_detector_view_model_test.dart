import 'package:flutter_test/flutter_test.dart';
import 'package:scam_detector/viewmodels/scam_detector_view_model.dart';
import 'package:scam_detector/models/risk_level.dart';

void main() {
  late ScamDetectorViewModel viewModel;

  setUp(() {
    viewModel = ScamDetectorViewModel();
  });

  group('ScamDetectorViewModel', () {
    test('analyze updates state with result', () async {
      viewModel.updateInput('Test message');
      
      final future = viewModel.analyze();
      expect(viewModel.isAnalyzing, true);
      
      await future;
      
      expect(viewModel.isAnalyzing, false);
      expect(viewModel.result, isNotNull);
    });

    test('analyze with safe message returns safe result', () async {
      viewModel.updateInput('Hi, are we still meeting at 6 PM for dinner?');
      await viewModel.analyze();
      
      expect(viewModel.result?.riskLevel, RiskLevel.safe);
    });

    test('reset clears all state', () async {
      viewModel.updateInput('Phish me');
      await viewModel.analyze();
      
      viewModel.reset();
      
      expect(viewModel.inputText, '');
      expect(viewModel.result, isNull);
      expect(viewModel.isAnalyzing, false);
    });

    test('canAnalyze is false for empty/whitespace input', () {
      viewModel.updateInput('');
      expect(viewModel.canAnalyze, false);
      
      viewModel.updateInput('   ');
      expect(viewModel.canAnalyze, false);
    });

    test('exampleMessages contains at least 6 entries', () {
      expect(ScamDetectorViewModel.exampleMessages.length, greaterThanOrEqualTo(6));
    });
  });
}
