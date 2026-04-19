import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_movil_spotify/app.dart';
import 'package:app_movil_spotify/src/controller/sprint1_controller.dart';
import 'package:app_movil_spotify/src/models/chord_segment.dart';
import 'package:app_movil_spotify/src/services/fake_spotify_catalog.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app boots and renders title', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    await tester.pumpWidget(const SpotifyChordVisualizerApp());
    await tester.pumpAndSettle();

    expect(find.text('Spotify Chord Visualizer'), findsOneWidget);
  });

  test('filters songs by query in controller', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final controller = Sprint1Controller();
    addTearDown(controller.dispose);
    await controller.bootstrap();

    controller.updateSearchQuery('coldplay');

    expect(controller.visibleSongs, isNotEmpty);
    expect(
      controller.visibleSongs.every((song) =>
          song.artist.toLowerCase().contains('coldplay') ||
          song.album.toLowerCase().contains('coldplay') ||
          song.title.toLowerCase().contains('coldplay')),
      isTrue,
    );
  });

  test('toggles favorite songs in controller', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final controller = Sprint1Controller();
    addTearDown(controller.dispose);
    await controller.bootstrap();

    expect(controller.isFavorite('1'), isFalse);
    await controller.toggleFavorite('1');
    expect(controller.isFavorite('1'), isTrue);
    await controller.toggleFavorite('1');
    expect(controller.isFavorite('1'), isFalse);
  });

  test('updates metadata and playback state in controller', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final controller = Sprint1Controller();
    addTearDown(controller.dispose);
    await controller.bootstrap();

    controller.selectSong(fakeSpotifyCatalog[1]);
    expect(controller.selectedSong?.title, 'Yellow');
    expect(controller.playbackPositionSeconds, 0);

    controller.togglePlayback();
    expect(controller.isPlaying, isTrue);
    controller.togglePlayback();
    expect(controller.isPlaying, isFalse);
  });

  test('shows synchronized active chord and difficulty', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final controller = Sprint1Controller();
    addTearDown(controller.dispose);
    await controller.bootstrap();

    controller.selectSong(fakeSpotifyCatalog.first);
    controller.seekPlayback(48);

    expect(controller.activeChordLabel, 'Em7');

    controller.setChordDifficulty(ChordDifficulty.basic);
    expect(controller.activeChordLabel, 'Em');
    expect(controller.chordTimeline, isNotEmpty);
  });

  test('applies readable chord view settings', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final controller = Sprint1Controller();
    addTearDown(controller.dispose);
    await controller.bootstrap();

    controller.setChordHighContrast(true);
    controller.setChordFontScale(1.5);
    controller.setChordFocusMode(true);

    expect(controller.chordHighContrast, isTrue);
    expect(controller.chordFocusMode, isTrue);
    expect(controller.chordFontScale, 1.5);
  });
}
