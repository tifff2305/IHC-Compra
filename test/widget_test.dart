// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:ihc_inscripciones/main.dart';

void main() {
  testWidgets('App builds and shows home app bar', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const GlobyApp());

    // Expect to find the app title from the custom app bar on HomePage.
    expect(find.text('Globy'), findsOneWidget);
  });
}
