// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:scam_detector/main.dart';

void main() {
  testWidgets('Scam Detector smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ScamDetectorApp());

    // Verify that the header title exists
    expect(find.text('Check if a message is a scam'), findsOneWidget);
    
    // Verify that the analyze button exists
    expect(find.text('Analyze message'), findsOneWidget);
  });
}
