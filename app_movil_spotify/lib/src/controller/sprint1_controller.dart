import 'package:app_movil_spotify/src/models/song.dart';
import 'package:app_movil_spotify/src/models/user_session.dart';
import 'package:app_movil_spotify/src/services/fake_spotify_catalog.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Sprint1ConnectionState { disconnected, connected }

class Sprint1Controller extends ChangeNotifier {
  static const String _connectedKey = 'sprint1_connected';
  static const String _displayNameKey = 'sprint1_display_name';
  static const String _connectedAtKey = 'sprint1_connected_at';

  SharedPreferences? _storage;

  Sprint1ConnectionState _connectionState = Sprint1ConnectionState.disconnected;
  UserSession? _session;
  String _searchQuery = '';

  Sprint1ConnectionState get connectionState => _connectionState;
  UserSession? get session => _session;
  String get searchQuery => _searchQuery;

  String get connectionLabel =>
      _connectionState == Sprint1ConnectionState.connected
      ? 'Sesión lista'
      : 'Sin sesión';

  String get sessionSummary {
    final currentSession = _session;
    if (_connectionState != Sprint1ConnectionState.connected ||
        currentSession == null) {
      return 'Aún no has iniciado sesión con Spotify.';
    }

    return 'Sesión conectada como ${currentSession.displayName} desde ${_formatDateTime(currentSession.connectedAt)}.';
  }

  List<Song> get visibleSongs => fakeSpotifyCatalog;

  Future<SharedPreferences> _preferences() async {
    return _storage ??= await SharedPreferences.getInstance();
  }

  Future<void> bootstrap() async {
    final preferences = await _preferences();
    final isConnected = preferences.getBool(_connectedKey) ?? false;
    if (!isConnected) {
      notifyListeners();
      return;
    }

    final displayName = preferences.getString(_displayNameKey) ?? 'Luis Carlos';
    final connectedAtMillis = preferences.getInt(_connectedAtKey);

    _connectionState = Sprint1ConnectionState.connected;
    _session = UserSession(
      displayName: displayName,
      connectedAt: DateTime.fromMillisecondsSinceEpoch(
        connectedAtMillis ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
    notifyListeners();
  }

  Future<void> connect() async {
    final session = UserSession(
      displayName: 'Luis Carlos',
      connectedAt: DateTime.now(),
    );
    final preferences = await _preferences();

    _connectionState = Sprint1ConnectionState.connected;
    _session = session;

    await Future.wait([
      preferences.setBool(_connectedKey, true),
      preferences.setString(_displayNameKey, session.displayName),
      preferences.setInt(
        _connectedAtKey,
        session.connectedAt.millisecondsSinceEpoch,
      ),
    ]);

    notifyListeners();
  }

  Future<void> disconnect() async {
    final preferences = await _preferences();

    _connectionState = Sprint1ConnectionState.disconnected;
    _session = null;
    _searchQuery = '';

    await Future.wait([
      preferences.setBool(_connectedKey, false),
      preferences.remove(_displayNameKey),
      preferences.remove(_connectedAtKey),
    ]);

    notifyListeners();
  }

  void updateSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }
}
