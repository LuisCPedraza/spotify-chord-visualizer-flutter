import 'package:app_movil_spotify/services/spotify_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('mapTrackToSong maps full Spotify track payload', () {
    final track = <String, dynamic>{
      'id': 'track-123',
      'name': 'Song Title',
      'duration_ms': 183000,
      'artists': <Map<String, dynamic>>[
        <String, dynamic>{'name': 'Artist A'},
        <String, dynamic>{'name': 'Artist B'},
      ],
      'album': <String, dynamic>{
        'name': 'Album Name',
        'images': <Map<String, dynamic>>[
          <String, dynamic>{'url': 'https://cdn.example.com/cover.jpg'},
        ],
      },
      'external_urls': <String, dynamic>{
        'spotify': 'https://open.spotify.com/track/track-123',
      },
    };

    final song = SpotifyService.mapTrackToSong(track);

    expect(song, isNotNull);
    expect(song!.id, 'track-123');
    expect(song.title, 'Song Title');
    expect(song.artist, 'Artist A, Artist B');
    expect(song.album, 'Album Name');
    expect(song.durationSeconds, 183);
    expect(song.coverArtUrl, 'https://cdn.example.com/cover.jpg');
    expect(song.spotifyTrackUrl, 'https://open.spotify.com/track/track-123');
  });

  test('mapTrackToSong applies safe defaults when optional fields are missing', () {
    final track = <String, dynamic>{
      'id': 'track-456',
      'name': 'Fallback Song',
      'duration_ms': null,
      'artists': <dynamic>[],
      'album': <String, dynamic>{
        'name': null,
        'images': <dynamic>[],
      },
      'external_urls': <String, dynamic>{},
    };

    final song = SpotifyService.mapTrackToSong(track);

    expect(song, isNotNull);
    expect(song!.artist, 'Artista desconocido');
    expect(song.album, 'Album desconocido');
    expect(song.durationSeconds, 0);
    expect(song.coverArtUrl, isNotEmpty);
    expect(song.spotifyTrackUrl, 'https://open.spotify.com/track/track-456');
  });
}
