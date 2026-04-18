import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_movil_spotify/app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('shows Sprint 1 scaffold', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    await tester.pumpWidget(const SpotifyChordVisualizerApp());
    await tester.pumpAndSettle();

    expect(find.text('Spotify Chord Visualizer'), findsOneWidget);
    expect(find.text('Conectar con Spotify'), findsOneWidget);
    expect(find.textContaining('Resultados de ejemplo'), findsOneWidget);
  });

  testWidgets('filters songs by query', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    await tester.pumpWidget(const SpotifyChordVisualizerApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Conectar con Spotify'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'coldplay');
    await tester.pumpAndSettle();

    expect(find.textContaining('Coldplay'), findsWidgets);
    expect(find.text('Hotel California • Eagles'), findsNothing);
  });
}
