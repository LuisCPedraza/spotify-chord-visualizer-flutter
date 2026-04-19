import 'dart:convert';

import 'package:http/http.dart' as http;

import '../src/models/song.dart';
import '../src/services/spotify_auth_service.dart';

class SpotifyService {
  static final SpotifyAuthGateway _authService = SpotifyAuthService();

  static const String _fallbackCoverArt =
      'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=600';

  static List<Song> mapSearchResponse(Map<String, dynamic> payload) {
    final tracks = payload['tracks'];
    if (tracks is! Map<String, dynamic>) {
      return const <Song>[];
    }

    final items = tracks['items'];
    if (items is! List) {
      return const <Song>[];
    }

    return items
        .whereType<Map<String, dynamic>>()
        .map(_mapTrackToSong)
        .whereType<Song>()
        .toList(growable: false);
  }

  static Song? mapTrackToSong(Map<String, dynamic> track) {
    return _mapTrackToSong(track);
  }

  static Future<List<Song>> searchSongs(String query) async {
    final token = await getAccessToken();
    final normalized = query.trim();
    if (token == null || normalized.isEmpty) {
      return const <Song>[];
    }

    final response = await http.get(
      Uri.https('api.spotify.com', '/v1/search', <String, String>{
        'q': normalized,
        'type': 'track',
        'limit': '10',
      }),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final payload = json.decode(response.body);
      if (payload is! Map<String, dynamic>) {
        return const <Song>[];
      }
      return mapSearchResponse(payload);
    }

    if (response.statusCode == 429) {
      throw StateError('Spotify reporto rate limit. Intenta de nuevo en unos segundos.');
    }

    throw StateError(
      'No se pudo completar la busqueda en Spotify (${response.statusCode}).',
    );
  }

  static Song? _mapTrackToSong(Map<String, dynamic> track) {
    final id = track['id']?.toString();
    final title = track['name']?.toString();
    if (id == null || id.isEmpty || title == null || title.isEmpty) {
      return null;
    }

    final albumMap = track['album'] as Map<String, dynamic>?;
    final albumName = albumMap?['name']?.toString() ?? 'Album desconocido';

    final artists = track['artists'] as List<dynamic>?;
    final artistNames = (artists ?? const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map((artist) => artist['name']?.toString())
        .whereType<String>()
        .where((name) => name.isNotEmpty)
        .toList(growable: false);

    final images = albumMap?['images'] as List<dynamic>?;
    String? cover;
    for (final item in images ?? const <dynamic>[]) {
      if (item is Map<String, dynamic>) {
        final url = item['url']?.toString();
        if (url != null && url.isNotEmpty) {
          cover = url;
          break;
        }
      }
    }
    cover ??= _fallbackCoverArt;

    final durationMs = track['duration_ms'];
    final durationSeconds = durationMs is num ? (durationMs / 1000).round() : 0;

    final externalUrls = track['external_urls'] as Map<String, dynamic>?;
    final spotifyUrl = externalUrls?['spotify']?.toString() ??
        'https://open.spotify.com/track/$id';

    return Song(
      id: id,
      title: title,
      artist: artistNames.isEmpty ? 'Artista desconocido' : artistNames.join(', '),
      album: albumName,
      durationSeconds: durationSeconds,
      coverArtUrl: cover,
      spotifyTrackUrl: spotifyUrl,
    );
  }

  static Future<String?> getAccessToken() async {
    return _authService.getValidAccessToken();
  }

  static Future<Map<String, dynamic>> searchTrack(String query) async {
    final token = await getAccessToken();
    if (token == null || query.trim().isEmpty) {
      return <String, dynamic>{};
    }

    final response = await http.get(
      Uri.https('api.spotify.com', '/v1/search', <String, String>{
        'q': query,
        'type': 'track',
        'limit': '5',
      }),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final payload = json.decode(response.body);
      if (payload is Map<String, dynamic>) {
        return payload;
      }
    }
    return {};
  }

  static Future<Map<String, dynamic>> getAudioAnalysis(String trackId) async {
    final token = await getAccessToken();
    if (token == null || trackId.trim().isEmpty) {
      return <String, dynamic>{};
    }

    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/audio-analysis/$trackId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return {};
  }

  static Future<Map<String, dynamic>> getAudioFeatures(String trackId) async {
    final token = await getAccessToken();
    if (token == null || trackId.trim().isEmpty) {
      return <String, dynamic>{};
    }

    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/audio-features/$trackId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return {};
  }

  static Future<SpotifyPlaybackSnapshot?> getPlaybackSnapshot() async {
    final token = await getAccessToken();
    if (token == null) {
      return null;
    }

    final response = await http.get(
      Uri.https('api.spotify.com', '/v1/me/player'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 204) {
      return null;
    }

    if (response.statusCode == 200) {
      final payload = json.decode(response.body);
      if (payload is! Map<String, dynamic>) {
        return null;
      }

      final isPlaying = payload['is_playing'] == true;
      final progressMs = (payload['progress_ms'] as num?)?.toInt() ?? 0;
      final item = payload['item'];
      Song? song;
      if (item is Map<String, dynamic>) {
        song = mapTrackToSong(item);
      }

      return SpotifyPlaybackSnapshot(
        isPlaying: isPlaying,
        progressSeconds: (progressMs / 1000).floor(),
        track: song,
      );
    }

    _throwPlaybackError(response.statusCode);
  }

  static Future<void> playTrack({String? trackId}) async {
    final token = await getAccessToken();
    if (token == null) {
      throw StateError('No hay sesion activa con Spotify.');
    }

    final body = trackId == null || trackId.trim().isEmpty
        ? null
        : json.encode(<String, dynamic>{'uris': <String>['spotify:track:$trackId']});

    final response = await http.put(
      Uri.https('api.spotify.com', '/v1/me/player/play'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        if (body != null) 'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 204) {
      return;
    }

    _throwPlaybackError(response.statusCode);
  }

  static Future<void> pausePlayback() async {
    final token = await getAccessToken();
    if (token == null) {
      throw StateError('No hay sesion activa con Spotify.');
    }

    final response = await http.put(
      Uri.https('api.spotify.com', '/v1/me/player/pause'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 204) {
      return;
    }

    _throwPlaybackError(response.statusCode);
  }

  static Future<void> seekPlayback(int positionSeconds) async {
    final token = await getAccessToken();
    if (token == null) {
      throw StateError('No hay sesion activa con Spotify.');
    }

    final positionMs = (positionSeconds.clamp(0, 86400)) * 1000;
    final response = await http.put(
      Uri.https('api.spotify.com', '/v1/me/player/seek', <String, String>{
        'position_ms': positionMs.toString(),
      }),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 204) {
      return;
    }

    _throwPlaybackError(response.statusCode);
  }

  static Never _throwPlaybackError(int statusCode) {
    if (statusCode == 401) {
      throw StateError('Sesion expirada. Vuelve a iniciar sesion en Spotify.');
    }
    if (statusCode == 403) {
      throw StateError(
        'Spotify limita este control para tu cuenta. En movil normalmente requiere Premium.',
      );
    }
    if (statusCode == 404) {
      throw StateError(
        'No hay un dispositivo Spotify activo. Abre Spotify y reproduce algo primero.',
      );
    }

    throw StateError('No se pudo sincronizar la reproduccion (${statusCode.toString()}).');
  }
}

class SpotifyPlaybackSnapshot {
  final bool isPlaying;
  final int progressSeconds;
  final Song? track;

  const SpotifyPlaybackSnapshot({
    required this.isPlaying,
    required this.progressSeconds,
    required this.track,
  });
}
