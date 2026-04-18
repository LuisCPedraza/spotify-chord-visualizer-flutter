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
    expect(find.text('Resultados de ejemplo'), findsOneWidget);
  });
}
