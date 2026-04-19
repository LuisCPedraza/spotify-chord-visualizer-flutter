enum ChordDifficulty { basic, intermediate, full }

class ChordSegment {
  final int startSecond;
  final int endSecond;
  final String basicLabel;
  final String intermediateLabel;
  final String fullLabel;

  const ChordSegment({
    required this.startSecond,
    required this.endSecond,
    required this.basicLabel,
    required this.intermediateLabel,
    required this.fullLabel,
  });

  String labelFor(ChordDifficulty difficulty) {
    switch (difficulty) {
      case ChordDifficulty.basic:
        return basicLabel;
      case ChordDifficulty.intermediate:
        return intermediateLabel;
      case ChordDifficulty.full:
        return fullLabel;
    }
  }
}
