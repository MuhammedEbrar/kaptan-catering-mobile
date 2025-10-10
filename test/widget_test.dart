// This is a basic Flutter widget test.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kaptancateringmobile/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const KaptanCateringApp());

    // Verify that splash screen appears
    expect(find.text('Kaptan Catering'), findsOneWidget);
  });
}