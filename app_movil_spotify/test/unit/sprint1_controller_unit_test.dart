import 'package:app_movil_spotify/src/controller/sprint1_controller.dart';
import 'package:app_movil_spotify/src/models/chord_segment.dart';
import 'package:app_movil_spotify/src/services/fake_spotify_catalog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('bootstrap initializes selected song', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final controller = Sprint1Controller();
    addTearDown(controller.dispose);

    await controller.bootstrap();

    expect(controller.selectedSong, isNotNull);
  });

  test('selectSong resets playback and pauses player', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final controller = Sprint1Controller();
    addTearDown(controller.dispose);

    await controller.bootstrap();
    controller.togglePlayback();
    expect(controller.isPlaying, isTrue);

    controller.selectSong(fakeSpotifyCatalog[1]);

    expect(controller.isPlaying, isFalse);
    expect(controller.playbackPositionSeconds, 0);
    expect(controller.selectedSong?.id, fakeSpotifyCatalog[1].id);
  });

  test('chord difficulty changes active chord label', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final controller = Sprint1Controller();
    addTearDown(controller.dispose);

    await controller.bootstrap();
    controller.selectSong(fakeSpotifyCatalog.first);
    controller.seekPlayback(48);

    controller.setChordDifficulty(ChordDifficulty.intermediate);
    final intermediateLabel = controller.activeChordLabel;

    controller.setChordDifficulty(ChordDifficulty.basic);
    final basicLabel = controller.activeChordLabel;

    expect(intermediateLabel, isNot(equals(basicLabel)));
  });
}
