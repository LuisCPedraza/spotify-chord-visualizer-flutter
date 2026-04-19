import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class SpotifyService {
  static const String _clientId = 'TU_SPOTIFY_CLIENT_ID_AQUI';
  static const String _clientSecret = 'TU_CLIENT_SECRET_AQUI';
  static const _storage = FlutterSecureStorage();

  static Future<String?> getAccessToken() async {
    String? token = await _storage.read(key: 'spotify_token');
    if (token != null) return token;

    // Client Credentials para demo (no user auth)
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'client_credentials',
        'client_id': _clientId,
        'client_secret': _clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      token = data['access_token'];
      await _storage.write(key: 'spotify_token', value: token!);
      return token;
    }
    return null;
  }

  static Future<Map<String, dynamic>> searchTrack(String query) async {
    final token = await getAccessToken();
    final response = await http.get(
      Uri.parse(
        'https://api.spotify.com/v1/search?q=$query&type=track&limit=5',
      ),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return {};
  }

  static Future<Map<String, dynamic>> getAudioAnalysis(String trackId) async {
    final token = await getAccessToken();
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
