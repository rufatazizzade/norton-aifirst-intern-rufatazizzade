import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scam_detector/main.dart';
import 'package:scam_detector/viewmodels/scam_detector_view_model.dart';

void main() {
  testWidgets('Scam Detector smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ScamDetectorViewModel(),
        child: const ScamDetectorApp(),
      ),
    );

    // Verify that the header title exists
    expect(find.text('Message Safety'), findsOneWidget);
    
    // Verify that the analyze button exists
    expect(find.text('Analyze Message'), findsOneWidget);
  });
}
