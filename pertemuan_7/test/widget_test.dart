import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pertemuan_6/main.dart';

void main() {
  testWidgets('App load smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Note: This test might fail if the API call in initState takes time or fails.
    // In a real scenario, we would mock ApiClient.
    await tester.pumpWidget(const MyApp());

    // Verify that our app shows the title.
    expect(find.text('Catatan Mahasiswa'), findsOneWidget);

    // Verify that the floating action button is present.
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
