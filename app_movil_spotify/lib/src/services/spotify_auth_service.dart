import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;

import '../models/spotify_auth_session.dart';

abstract class SpotifyAuthGateway {
  Future<SpotifyAuthSession?> restoreSession();

  Future<SpotifyAuthSession> login();

  Future<void> logout();

  Future<String?> getValidAccessToken();
}

class SpotifyAuthService implements SpotifyAuthGateway {
  static const String _defaultRedirectUri =
      'com.example.app_movil_spotify://spotify-auth';
  static const List<String> _defaultScopes = <String>[
    'user-read-email',
    'user-read-private',
    'user-read-playback-state',
    'user-modify-playback-state',
    'streaming',
  ];

  static const String _accessTokenKey = 'spotify_access_token';
  static const String _refreshTokenKey = 'spotify_refresh_token';
  static const String _expiresAtKey = 'spotify_expires_at';
  static const String _userIdKey = 'spotify_user_id';
  static const String _displayNameKey = 'spotify_display_name';
  static const String _emailKey = 'spotify_email';
  static const String _connectedAtKey = 'spotify_connected_at';
  static const String _scopesKey = 'spotify_scopes';

  final http.Client _client;
  final FlutterSecureStorage _storage;
  final String clientId;
  final String redirectUri;
  final List<String> scopes;

  SpotifyAuthService({
    http.Client? client,
    FlutterSecureStorage? storage,
    String? clientId,
    String? redirectUri,
    List<String>? scopes,
  }) : _client = client ?? http.Client(),
       _storage = storage ?? const FlutterSecureStorage(),
       clientId = clientId ?? _loadClientId(),
       redirectUri = redirectUri ?? _loadRedirectUri(),
       scopes = List.unmodifiable(scopes ?? _defaultScopes) {
    // Validación de credenciales
    if (this.clientId.isEmpty) {
      throw StateError(
        'SPOTIFY_CLIENT_ID no configurado. '
        'Verifica que .env exista en la raíz del proyecto con:\n'
        '  SPOTIFY_CLIENT_ID=tu_client_id_aqui\n'
        'O define la variable de entorno SPOTIFY_CLIENT_ID.',
      );
    }
    if (this.redirectUri == _defaultRedirectUri) {
      // Está bien, es el valor por defecto
    }
  }

  static String _loadClientId() {
    try {
      if (dotenv.isInitialized) {
        final value = dotenv.env['SPOTIFY_CLIENT_ID'];
        if (value != null && value.isNotEmpty) return value;
      }
    } catch (_) {
      // dotenv no inicializado
    }
    return const String.fromEnvironment(
      'SPOTIFY_CLIENT_ID',
      defaultValue: '',
    );
  }

  static String _loadRedirectUri() {
    try {
      if (dotenv.isInitialized) {
        final value = dotenv.env['SPOTIFY_REDIRECT_URI'];
        if (value != null && value.isNotEmpty) return value;
      }
    } catch (_) {
      // dotenv no inicializado
    }
    return const String.fromEnvironment(
      'SPOTIFY_REDIRECT_URI',
      defaultValue: _defaultRedirectUri,
    );
  }

  @override
  Future<SpotifyAuthSession?> restoreSession() async {
    try {
      final stored = await _readStoredSession();
      if (stored == null) {
        return null;
      }

      if (!stored.isExpired) {
        return stored;
      }

      if (!stored.canRefresh) {
        return null;
      }

      final refreshed = await _refreshSession(stored);
      final updatedSession = SpotifyAuthSession(
        accessToken: refreshed.accessToken,
        refreshToken: refreshed.refreshToken,
        userId: stored.userId,
        displayName: stored.displayName,
        email: stored.email,
        connectedAt: stored.connectedAt,
        expiresAt: DateTime.now().add(refreshed.expiresIn),
        scopes: refreshed.scopes,
      );
      await _persistSession(updatedSession);
      return updatedSession;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<SpotifyAuthSession> login() async {
    if (clientId.trim().isEmpty) {
      throw StateError(
        'SPOTIFY_CLIENT_ID no esta configurado. Define una variable de entorno para iniciar sesion.',
      );
    }

    final codeVerifier = _generateCodeVerifier();
    final codeChallenge = _generateCodeChallenge(codeVerifier);
    final authorizeUrl =
        Uri.https('accounts.spotify.com', '/authorize', <String, String>{
          'response_type': 'code',
          'client_id': clientId,
          'scope': scopes.join(' '),
          'redirect_uri': redirectUri,
          'code_challenge_method': 'S256',
          'code_challenge': codeChallenge,
          'show_dialog': 'true',
        });

    final callbackUrl = await FlutterWebAuth2.authenticate(
      url: authorizeUrl.toString(),
      callbackUrlScheme: Uri.parse(redirectUri).scheme,
    );
    final callbackUri = Uri.parse(callbackUrl);

    final authError = callbackUri.queryParameters['error'];
    if (authError != null && authError.isNotEmpty) {
      throw StateError('Spotify rechazo el acceso: $authError');
    }

    final code = callbackUri.queryParameters['code'];
    if (code == null || code.isEmpty) {
      throw StateError('No se recibio el codigo de autorizacion de Spotify.');
    }

    final tokenData = await _exchangeCodeForTokens(
      code: code,
      codeVerifier: codeVerifier,
    );
    final profileData = await _fetchCurrentProfile(tokenData.accessToken);
    final session = SpotifyAuthSession(
      accessToken: tokenData.accessToken,
      refreshToken: tokenData.refreshToken,
      userId: profileData.userId,
      displayName: profileData.displayName,
      email: profileData.email,
      connectedAt: DateTime.now(),
      expiresAt: DateTime.now().add(tokenData.expiresIn),
      scopes: tokenData.scopes,
    );

    await _persistSession(session);
    return session;
  }

  @override
  Future<void> logout() async {
    try {
      await _clearStoredSession();
    } catch (_) {
      // Best effort cleanup.
    }
  }

  @override
  Future<String?> getValidAccessToken() async {
    final session = await restoreSession();
    return session?.accessToken;
  }

  Future<_TokenBundle> _exchangeCodeForTokens({
    required String code,
    required String codeVerifier,
  }) async {
    final response = await _client.post(
      Uri.https('accounts.spotify.com', '/api/token'),
      headers: const <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri,
        'client_id': clientId,
        'code_verifier': codeVerifier,
      },
    );

    if (response.statusCode != 200) {
      throw StateError(
        'No se pudo intercambiar el codigo por tokens (${response.statusCode}).',
      );
    }

    final payload = json.decode(response.body) as Map<String, dynamic>;
    final expiresInSeconds = (payload['expires_in'] as num?)?.toInt() ?? 3600;
    final accessToken = payload['access_token'] as String?;
    if (accessToken == null || accessToken.isEmpty) {
      throw StateError('Spotify no devolvio access_token.');
    }

    return _TokenBundle(
      accessToken: accessToken,
      refreshToken: payload['refresh_token'] as String?,
      expiresIn: Duration(seconds: expiresInSeconds),
      scopes: _parseScopes(payload['scope'] as String?),
    );
  }

  Future<_TokenBundle> _refreshSession(SpotifyAuthSession session) async {
    final response = await _client.post(
      Uri.https('accounts.spotify.com', '/api/token'),
      headers: const <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{
        'grant_type': 'refresh_token',
        'refresh_token': session.refreshToken ?? '',
        'client_id': clientId,
      },
    );

    if (response.statusCode != 200) {
      throw StateError(
        'No se pudo renovar la sesion (${response.statusCode}).',
      );
    }

    final payload = json.decode(response.body) as Map<String, dynamic>;
    final expiresInSeconds = (payload['expires_in'] as num?)?.toInt() ?? 3600;
    final accessToken = payload['access_token'] as String?;
    if (accessToken == null || accessToken.isEmpty) {
      throw StateError('Spotify no devolvio un token renovado.');
    }

    return _TokenBundle(
      accessToken: accessToken,
      refreshToken:
          (payload['refresh_token'] as String?) ?? session.refreshToken,
      expiresIn: Duration(seconds: expiresInSeconds),
      scopes: session.scopes,
    );
  }

  Future<_ProfileData> _fetchCurrentProfile(String accessToken) async {
    final response = await _client.get(
      Uri.https('api.spotify.com', '/v1/me'),
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode != 200) {
      throw StateError(
        'No se pudo leer el perfil de Spotify (${response.statusCode}).',
      );
    }

    final payload = json.decode(response.body) as Map<String, dynamic>;
    final images = payload['images'];
    String? imageUrl;
    if (images is List && images.isNotEmpty) {
      final firstImage = images.first;
      if (firstImage is Map<String, dynamic>) {
        imageUrl = firstImage['url'] as String?;
      }
    }

    return _ProfileData(
      userId: (payload['id'] as String?) ?? 'spotify-user',
      displayName: (payload['display_name'] as String?) ?? 'Spotify User',
      email: payload['email'] as String?,
      imageUrl: imageUrl,
    );
  }

  Future<SpotifyAuthSession?> _readStoredSession() async {
    final accessToken = await _storage.read(key: _accessTokenKey);
    if (accessToken == null || accessToken.isEmpty) {
      return null;
    }

    final expiresAtMillis = int.tryParse(
      await _storage.read(key: _expiresAtKey) ?? '',
    );
    final connectedAtMillis = int.tryParse(
      await _storage.read(key: _connectedAtKey) ?? '',
    );
    final expiresAt = DateTime.fromMillisecondsSinceEpoch(
      expiresAtMillis ?? DateTime.now().millisecondsSinceEpoch,
    );
    final connectedAt = DateTime.fromMillisecondsSinceEpoch(
      connectedAtMillis ?? DateTime.now().millisecondsSinceEpoch,
    );

    return SpotifyAuthSession(
      accessToken: accessToken,
      refreshToken: await _storage.read(key: _refreshTokenKey),
      userId: (await _storage.read(key: _userIdKey)) ?? 'spotify-user',
      displayName:
          (await _storage.read(key: _displayNameKey)) ?? 'Spotify User',
      email: await _storage.read(key: _emailKey),
      connectedAt: connectedAt,
      expiresAt: expiresAt,
      scopes: _parseScopes(await _storage.read(key: _scopesKey)),
    );
  }

  Future<void> _persistSession(SpotifyAuthSession session) async {
    await Future.wait(<Future<void>>[
      _storage.write(key: _accessTokenKey, value: session.accessToken),
      _storage.write(key: _refreshTokenKey, value: session.refreshToken),
      _storage.write(
        key: _expiresAtKey,
        value: session.expiresAt.millisecondsSinceEpoch.toString(),
      ),
      _storage.write(key: _userIdKey, value: session.userId),
      _storage.write(key: _displayNameKey, value: session.displayName),
      _storage.write(key: _emailKey, value: session.email),
      _storage.write(
        key: _connectedAtKey,
        value: session.connectedAt.millisecondsSinceEpoch.toString(),
      ),
      _storage.write(key: _scopesKey, value: session.scopes.join(' ')),
    ]);
  }

  Future<void> _clearStoredSession() async {
    await Future.wait(<Future<void>>[
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
      _storage.delete(key: _expiresAtKey),
      _storage.delete(key: _userIdKey),
      _storage.delete(key: _displayNameKey),
      _storage.delete(key: _emailKey),
      _storage.delete(key: _connectedAtKey),
      _storage.delete(key: _scopesKey),
    ]);
  }

  String _generateCodeVerifier() {
    final random = Random.secure();
    final bytes = List<int>.generate(96, (_) => random.nextInt(256));
    return base64UrlEncode(bytes).replaceAll('=', '');
  }

  String _generateCodeChallenge(String verifier) {
    final digest = sha256.convert(utf8.encode(verifier)).bytes;
    return base64UrlEncode(digest).replaceAll('=', '');
  }

  List<String> _parseScopes(String? rawScopes) {
    if (rawScopes == null || rawScopes.trim().isEmpty) {
      return const <String>[];
    }

    return rawScopes
        .split(RegExp(r'\s+'))
        .where((scope) => scope.trim().isNotEmpty)
        .toList(growable: false);
  }
}

class _TokenBundle {
  final String accessToken;
  final String? refreshToken;
  final Duration expiresIn;
  final List<String> scopes;

  const _TokenBundle({
    required this.accessToken,
    required this.expiresIn,
    required this.scopes,
    this.refreshToken,
  });
}

class _ProfileData {
  final String userId;
  final String displayName;
  final String? email;
  final String? imageUrl;

  const _ProfileData({
    required this.userId,
    required this.displayName,
    required this.email,
    required this.imageUrl,
  });
}
