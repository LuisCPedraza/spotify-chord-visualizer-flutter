import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_movil_spotify/app.dart';
import 'package:app_movil_spotify/src/controller/sprint1_controller.dart';
import 'package:app_movil_spotify/src/ui/sprint1_home_page.dart';

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

  testWidgets('toggles favorite songs', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final controller = Sprint1Controller();
    await controller.bootstrap();

    await tester.pumpWidget(
      MaterialApp(
        home: AnimatedBuilder(
          animation: controller,
          builder: (context, _) => Sprint1HomePage(controller: controller),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await controller.toggleFavorite('1');
    await tester.pumpAndSettle();

    final favoriteButton = find.byKey(const ValueKey<String>('favorite-1'));
    final toggledButton = tester.widget<IconButton>(favoriteButton);
    expect(toggledButton.tooltip, 'Quitar de favoritos');
  });
}
