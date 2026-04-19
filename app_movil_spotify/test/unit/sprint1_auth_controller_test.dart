import 'package:app_movil_spotify/src/controller/sprint1_controller.dart';
import 'package:app_movil_spotify/src/models/spotify_auth_session.dart';
import 'package:app_movil_spotify/src/services/spotify_auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeSpotifyAuthGateway implements SpotifyAuthGateway {
  FakeSpotifyAuthGateway({this.restoredSession, this.loginSession});

  SpotifyAuthSession? restoredSession;
  SpotifyAuthSession? loginSession;
  bool logoutCalled = false;

  @override
  Future<SpotifyAuthSession?> restoreSession() async => restoredSession;

  @override
  Future<SpotifyAuthSession> login() async {
    final session = loginSession;
    if (session == null) {
      throw StateError('No login session configured');
    }

    return session;
  }

  @override
  Future<void> logout() async {
    logoutCalled = true;
  }

  @override
  Future<String?> getValidAccessToken() async => restoredSession?.accessToken ?? loginSession?.accessToken;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('bootstrap restores a remote Spotify session', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'sprint1_favorite_song_ids': <String>['1', '2'],
    });

    final gateway = FakeSpotifyAuthGateway(
      restoredSession: SpotifyAuthSession(
        accessToken: 'token-1',
        refreshToken: 'refresh-1',
        userId: 'user-1',
        displayName: 'Spotify User',
        email: 'user@example.com',
        connectedAt: DateTime(2026, 4, 18, 10, 0),
        expiresAt: DateTime(2026, 4, 18, 11, 0),
        scopes: const <String>['user-read-email'],
      ),
    );
    final controller = Sprint1Controller(authService: gateway);
    addTearDown(controller.dispose);

    await controller.bootstrap();

    expect(controller.connectionState, Sprint1ConnectionState.connected);
    expect(controller.session?.displayName, 'Spotify User');
    expect(controller.favoriteCount, 2);
    expect(controller.isAuthenticating, isFalse);
  });

  test('connect stores the authenticated session and disconnect clears it',
      () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    final gateway = FakeSpotifyAuthGateway(
      loginSession: SpotifyAuthSession(
        accessToken: 'token-2',
        refreshToken: 'refresh-2',
        userId: 'user-2',
        displayName: 'Luis Carlos',
        email: 'luis@example.com',
        connectedAt: DateTime(2026, 4, 18, 10, 0),
        expiresAt: DateTime(2026, 4, 18, 11, 0),
        scopes: const <String>['user-read-email', 'streaming'],
      ),
    );
    final controller = Sprint1Controller(authService: gateway);
    addTearDown(controller.dispose);

    await controller.connect();

    expect(controller.connectionState, Sprint1ConnectionState.connected);
    expect(controller.session?.userId, 'user-2');
    expect(controller.session?.email, 'luis@example.com');
    expect(controller.lastAuthError, isNull);
    expect(controller.isAuthenticating, isFalse);

    await controller.disconnect();

    expect(gateway.logoutCalled, isTrue);
    expect(controller.connectionState, Sprint1ConnectionState.disconnected);
    expect(controller.session, isNull);
  });
}
