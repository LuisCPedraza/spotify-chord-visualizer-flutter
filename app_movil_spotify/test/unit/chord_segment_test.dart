import 'package:app_movil_spotify/src/models/chord_segment.dart';
import 'package:app_movil_spotify/src/services/fake_chord_progressions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ChordSegment.labelFor returns expected label by difficulty', () {
    const segment = ChordSegment(
      startSecond: 0,
      endSecond: 16,
      basicLabel: 'C',
      intermediateLabel: 'Cmaj7',
      fullLabel: 'Cmaj9',
    );

    expect(segment.labelFor(ChordDifficulty.basic), 'C');
    expect(segment.labelFor(ChordDifficulty.intermediate), 'Cmaj7');
    expect(segment.labelFor(ChordDifficulty.full), 'Cmaj9');
  });

  test('fake chord progressions contain valid ranges', () {
    expect(fakeChordProgressions, isNotEmpty);

    for (final timeline in fakeChordProgressions.values) {
      expect(timeline, isNotEmpty);

      for (final segment in timeline) {
        expect(segment.endSecond, greaterThan(segment.startSecond));
      }
    }
  });
}
