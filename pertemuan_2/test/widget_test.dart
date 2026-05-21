import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pertemuan_2/main.dart';

void main() {
  testWidgets('App load smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app shows the profile info.
    expect(find.text('Profil Saya'), findsOneWidget);
    expect(find.text('Raihan'), findsOneWidget);
    expect(find.text('Mahasiswa Teknik Informatika'), findsOneWidget);

    // Verify that the floating action button is present.
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
