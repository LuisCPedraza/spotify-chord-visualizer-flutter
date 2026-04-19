import 'dart:async';

import 'package:app_movil_spotify/src/models/chord_segment.dart';
import 'package:app_movil_spotify/src/models/song.dart';
import 'package:app_movil_spotify/src/models/user_session.dart';
import 'package:app_movil_spotify/src/services/fake_chord_progressions.dart';
import 'package:app_movil_spotify/src/services/fake_spotify_catalog.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Sprint1ConnectionState { disconnected, connected }

enum PlaybackState { paused, playing }

class Sprint1Controller extends ChangeNotifier {
  static const String _connectedKey = 'sprint1_connected';
  static const String _displayNameKey = 'sprint1_display_name';
  static const String _connectedAtKey = 'sprint1_connected_at';
  static const String _favoriteSongIdsKey = 'sprint1_favorite_song_ids';

  SharedPreferences? _storage;

  Sprint1ConnectionState _connectionState = Sprint1ConnectionState.disconnected;
  UserSession? _session;
  String _searchQuery = '';
  final Set<String> _favoriteSongIds = <String>{};
  Song? _selectedSong;
  ChordDifficulty _chordDifficulty = ChordDifficulty.intermediate;
  bool _chordHighContrast = false;
  bool _chordFocusMode = false;
  double _chordFontScale = 1.0;
  PlaybackState _playbackState = PlaybackState.paused;
  int _playbackPositionSeconds = 0;
  Timer? _playbackTimer;

  Sprint1ConnectionState get connectionState => _connectionState;
  UserSession? get session => _session;
  String get searchQuery => _searchQuery;
  int get favoriteCount => _favoriteSongIds.length;
  Song? get selectedSong => _selectedSong;
  ChordDifficulty get chordDifficulty => _chordDifficulty;
  bool get chordHighContrast => _chordHighContrast;
  bool get chordFocusMode => _chordFocusMode;
  double get chordFontScale => _chordFontScale;
  PlaybackState get playbackState => _playbackState;
  int get playbackPositionSeconds => _playbackPositionSeconds;

  bool get isPlaying => _playbackState == PlaybackState.playing;
  int get currentTrackDurationSeconds => _selectedSong?.durationSeconds ?? 0;

  String get playbackPositionLabel => _formatSeconds(
    _playbackPositionSeconds.clamp(0, currentTrackDurationSeconds),
  );

  String get playbackDurationLabel =>
      _formatSeconds(currentTrackDurationSeconds);

  double get playbackProgress {
    final duration = currentTrackDurationSeconds;
    if (duration <= 0) {
      return 0;
    }

    return (_playbackPositionSeconds / duration).clamp(0, 1);
  }

  List<ChordSegment> get chordTimeline {
    final trackId = _selectedSong?.id;
    if (trackId == null) {
      return const <ChordSegment>[];
    }

    return fakeChordProgressions[trackId] ?? const <ChordSegment>[];
  }

  ChordSegment? get activeChordSegment {
    final timeline = chordTimeline;
    if (timeline.isEmpty) {
      return null;
    }

    for (final segment in timeline) {
      if (_playbackPositionSeconds >= segment.startSecond &&
          _playbackPositionSeconds < segment.endSecond) {
        return segment;
      }
    }

    return timeline.last;
  }

  List<ChordSegment> get upcomingChordSegments {
    final timeline = chordTimeline;
    final active = activeChordSegment;
    if (timeline.isEmpty || active == null) {
      return const <ChordSegment>[];
    }

    final activeIndex = timeline.indexOf(active);
    if (activeIndex < 0 || activeIndex == timeline.length - 1) {
      return const <ChordSegment>[];
    }

    final nextEnd = (activeIndex + 4).clamp(0, timeline.length);
    return timeline.sublist(activeIndex + 1, nextEnd);
  }

  String get activeChordLabel {
    final active = activeChordSegment;
    if (active == null) {
      return '-';
    }

    return active.labelFor(_chordDifficulty);
  }

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

  List<Song> get visibleSongs {
    final normalizedQuery = _searchQuery.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return fakeSpotifyCatalog;
    }

    return fakeSpotifyCatalog
        .where((song) {
          final haystack = '${song.title} ${song.artist} ${song.album}'
              .toLowerCase();
          return haystack.contains(normalizedQuery);
        })
        .toList(growable: false);
  }

  bool isFavorite(String songId) => _favoriteSongIds.contains(songId);

  Future<SharedPreferences> _preferences() async {
    return _storage ??= await SharedPreferences.getInstance();
  }

  Future<void> bootstrap() async {
    if (_selectedSong == null && fakeSpotifyCatalog.isNotEmpty) {
      _selectedSong = fakeSpotifyCatalog.first;
    }

    final preferences = await _preferences();
    final isConnected = preferences.getBool(_connectedKey) ?? false;
    if (!isConnected) {
      notifyListeners();
      return;
    }

    final displayName = preferences.getString(_displayNameKey) ?? 'Luis Carlos';
    final connectedAtMillis = preferences.getInt(_connectedAtKey);
    final favoriteSongIds =
        preferences.getStringList(_favoriteSongIdsKey) ?? const <String>[];

    _connectionState = Sprint1ConnectionState.connected;
    _session = UserSession(
      displayName: displayName,
      connectedAt: DateTime.fromMillisecondsSinceEpoch(
        connectedAtMillis ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
    _favoriteSongIds
      ..clear()
      ..addAll(favoriteSongIds);
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

    final results = visibleSongs;
    if (results.isNotEmpty &&
        (_selectedSong == null ||
            !results.any((song) => song.id == _selectedSong!.id))) {
      _selectedSong = results.first;
    }

    notifyListeners();
  }

  void selectSong(Song song) {
    _selectedSong = song;
    _playbackPositionSeconds = 0;
    _setPlaybackState(PlaybackState.paused);
    notifyListeners();
  }

  void setChordDifficulty(ChordDifficulty difficulty) {
    _chordDifficulty = difficulty;
    notifyListeners();
  }

  void setChordHighContrast(bool value) {
    _chordHighContrast = value;
    notifyListeners();
  }

  void setChordFocusMode(bool value) {
    _chordFocusMode = value;
    notifyListeners();
  }

  void setChordFontScale(double value) {
    _chordFontScale = value.clamp(0.8, 1.8);
    notifyListeners();
  }

  void togglePlayback() {
    if (_selectedSong == null) {
      return;
    }

    if (isPlaying) {
      _setPlaybackState(PlaybackState.paused);
    } else {
      _setPlaybackState(PlaybackState.playing);
    }
    notifyListeners();
  }

  void seekPlayback(int seconds) {
    final duration = currentTrackDurationSeconds;
    if (duration <= 0) {
      _playbackPositionSeconds = 0;
      _setPlaybackState(PlaybackState.paused);
      notifyListeners();
      return;
    }

    _playbackPositionSeconds = seconds.clamp(0, duration);
    if (_playbackPositionSeconds >= duration) {
      _setPlaybackState(PlaybackState.paused);
    }
    notifyListeners();
  }

  void _setPlaybackState(PlaybackState state) {
    _playbackState = state;
    if (state == PlaybackState.playing) {
      _playbackTimer?.cancel();
      _playbackTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        final duration = currentTrackDurationSeconds;
        if (duration <= 0) {
          _setPlaybackState(PlaybackState.paused);
          notifyListeners();
          return;
        }

        if (_playbackPositionSeconds >= duration) {
          _playbackPositionSeconds = duration;
          _setPlaybackState(PlaybackState.paused);
          notifyListeners();
          return;
        }

        _playbackPositionSeconds += 1;
        notifyListeners();
      });
    } else {
      _playbackTimer?.cancel();
      _playbackTimer = null;
    }
  }

  Future<void> toggleFavorite(String songId) async {
    final preferences = await _preferences();

    if (_favoriteSongIds.contains(songId)) {
      _favoriteSongIds.remove(songId);
    } else {
      _favoriteSongIds.add(songId);
    }

    await preferences.setStringList(
      _favoriteSongIdsKey,
      _favoriteSongIds.toList(growable: false),
    );

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

  String _formatSeconds(int seconds) {
    final safeSeconds = seconds.clamp(0, 36000);
    final minutes = safeSeconds ~/ 60;
    final remaining = (safeSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remaining';
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    super.dispose();
  }
}
