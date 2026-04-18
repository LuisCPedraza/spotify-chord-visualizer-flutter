class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final int durationSeconds;
  final String coverArtUrl;
  final String spotifyTrackUrl;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.durationSeconds,
    required this.coverArtUrl,
    required this.spotifyTrackUrl,
  });

  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    final seconds = (durationSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
