import 'package:app_movil_spotify/src/models/chord_segment.dart';

const Map<String, List<ChordSegment>> fakeChordProgressions =
    <String, List<ChordSegment>>{
      '1': <ChordSegment>[
        ChordSegment(
          startSecond: 0,
          endSecond: 32,
          basicLabel: 'G',
          intermediateLabel: 'G',
          fullLabel: 'Gadd9',
        ),
        ChordSegment(
          startSecond: 32,
          endSecond: 64,
          basicLabel: 'Em',
          intermediateLabel: 'Em7',
          fullLabel: 'Em9',
        ),
        ChordSegment(
          startSecond: 64,
          endSecond: 96,
          basicLabel: 'C',
          intermediateLabel: 'Cmaj7',
          fullLabel: 'Cmaj9',
        ),
        ChordSegment(
          startSecond: 96,
          endSecond: 128,
          basicLabel: 'D',
          intermediateLabel: 'Dsus4',
          fullLabel: 'D7sus4',
        ),
      ],
      '2': <ChordSegment>[
        ChordSegment(
          startSecond: 0,
          endSecond: 36,
          basicLabel: 'B',
          intermediateLabel: 'Bm',
          fullLabel: 'Bm11',
        ),
        ChordSegment(
          startSecond: 36,
          endSecond: 72,
          basicLabel: 'A',
          intermediateLabel: 'A',
          fullLabel: 'Aadd9',
        ),
        ChordSegment(
          startSecond: 72,
          endSecond: 108,
          basicLabel: 'G',
          intermediateLabel: 'G',
          fullLabel: 'G6',
        ),
        ChordSegment(
          startSecond: 108,
          endSecond: 144,
          basicLabel: 'D',
          intermediateLabel: 'D',
          fullLabel: 'Dsus2',
        ),
      ],
      '3': <ChordSegment>[
        ChordSegment(
          startSecond: 0,
          endSecond: 40,
          basicLabel: 'E',
          intermediateLabel: 'E',
          fullLabel: 'E5',
        ),
        ChordSegment(
          startSecond: 40,
          endSecond: 80,
          basicLabel: 'A',
          intermediateLabel: 'A',
          fullLabel: 'Aadd9',
        ),
        ChordSegment(
          startSecond: 80,
          endSecond: 120,
          basicLabel: 'E',
          intermediateLabel: 'E',
          fullLabel: 'Emaj9',
        ),
        ChordSegment(
          startSecond: 120,
          endSecond: 160,
          basicLabel: 'B',
          intermediateLabel: 'B',
          fullLabel: 'Bsus4',
        ),
      ],
    };
