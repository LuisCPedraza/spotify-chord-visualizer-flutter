import 'package:app_movil_spotify/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('main flow renders and reaches playback controls', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SpotifyChordVisualizerApp());
    await tester.pumpAndSettle();

    expect(find.text('Spotify Chord Visualizer'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -1000));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('playback-toggle-button')), findsOneWidget);
  });
}
