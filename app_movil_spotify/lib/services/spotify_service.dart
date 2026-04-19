import 'dart:convert';

import 'package:http/http.dart' as http;

import '../src/services/spotify_auth_service.dart';

class SpotifyService {
  static final SpotifyAuthGateway _authService = SpotifyAuthService();

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
      return json.decode(response.body);
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
}
