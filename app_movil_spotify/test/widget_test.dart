import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_movil_spotify/app.dart';
import 'package:app_movil_spotify/src/controller/sprint1_controller.dart';
import 'package:app_movil_spotify/src/models/chord_segment.dart';
import 'package:app_movil_spotify/src/services/fake_spotify_catalog.dart';
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
    addTearDown(controller.dispose);
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

  testWidgets('updates selected track metadata from catalog tap', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final controller = Sprint1Controller();
    addTearDown(controller.dispose);
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

    controller.selectSong(fakeSpotifyCatalog[1]);
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('selected-track-title')),
      findsOneWidget,
    );
    expect(find.text('Yellow'), findsAtLeastNWidgets(1));
    expect(find.textContaining('Parachutes'), findsAtLeastNWidgets(1));
    expect(
      find.byKey(const ValueKey<String>('selected-track-link')),
      findsOneWidget,
    );
  });

  testWidgets('updates playback controls with play pause', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final controller = Sprint1Controller();
    addTearDown(controller.dispose);
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

    await tester.drag(find.byType(ListView), const Offset(0, -900));
    await tester.pumpAndSettle();

    expect(find.text('Reproducir'), findsOneWidget);
    controller.togglePlayback();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Pausar'), findsOneWidget);

    final progress = tester.widget<LinearProgressIndicator>(
      find.byKey(const ValueKey<String>('playback-progress')),
    );
    expect(progress.value! > 0, isTrue);

    final timeText = tester.widget<Text>(
      find.byKey(const ValueKey<String>('playback-time-label')),
    );
    expect(timeText.data, isNot(contains('0:00 /')));

    controller.togglePlayback();
    await tester.pumpAndSettle();
  });

  testWidgets('shows synchronized active chord and difficulty', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final controller = Sprint1Controller();
    addTearDown(controller.dispose);
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

    controller.selectSong(fakeSpotifyCatalog.first);
    controller.seekPlayback(48);
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -1200));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('chord-active-label')),
      findsOneWidget,
    );
    expect(find.text('Em7'), findsAtLeastNWidgets(1));

    controller.setChordDifficulty(ChordDifficulty.basic);
    await tester.pumpAndSettle();

    expect(find.text('Em'), findsAtLeastNWidgets(1));
    expect(
      find.byKey(const ValueKey<String>('chord-timeline-container')),
      findsOneWidget,
    );
  });
}
