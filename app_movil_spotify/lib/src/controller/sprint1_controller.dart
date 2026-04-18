import 'package:app_movil_spotify/src/models/song.dart';
import 'package:app_movil_spotify/src/models/user_session.dart';
import 'package:app_movil_spotify/src/services/fake_spotify_catalog.dart';
import 'package:flutter/foundation.dart';

enum Sprint1ConnectionState { disconnected, connected }

class Sprint1Controller extends ChangeNotifier {
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

  List<Song> get visibleSongs => fakeSpotifyCatalog;

  Future<void> bootstrap() async {
    notifyListeners();
  }

  Future<void> connect() async {
    _connectionState = Sprint1ConnectionState.connected;
    _session = UserSession(
      displayName: 'Luis Carlos',
      connectedAt: DateTime.now(),
    );
    notifyListeners();
  }

  Future<void> disconnect() async {
    _connectionState = Sprint1ConnectionState.disconnected;
    _session = null;
    _searchQuery = '';
    notifyListeners();
  }

  void updateSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }
}
