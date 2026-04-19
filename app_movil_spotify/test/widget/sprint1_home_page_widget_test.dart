import 'package:app_movil_spotify/src/controller/sprint1_controller.dart';
import 'package:app_movil_spotify/src/models/spotify_auth_session.dart';
import 'package:app_movil_spotify/src/services/spotify_auth_service.dart';
import 'package:app_movil_spotify/src/ui/sprint1_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeSpotifyAuthGateway implements SpotifyAuthGateway {
  @override
  Future<SpotifyAuthSession?> restoreSession() async => null;

  @override
  Future<SpotifyAuthSession> login() async {
    throw UnsupportedError('login not used in widget tests');
  }

  @override
  Future<void> logout() async {}

  @override
  Future<String?> getValidAccessToken() async => null;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('renders selected track metadata and Spotify link', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final controller = Sprint1Controller(authService: FakeSpotifyAuthGateway());
    addTearDown(controller.dispose);
    await controller.bootstrap();

    await tester.pumpWidget(
      MaterialApp(
        home: AnimatedBuilder(
          animation: controller,
          builder: (context, _) => Sprint1HomePage(controller: controller),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey<String>('selected-track-title')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('selected-track-title')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('selected-track-meta')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('selected-track-link')), findsOneWidget);
  });

  testWidgets('playback button toggles between play and pause labels', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final controller = Sprint1Controller(authService: FakeSpotifyAuthGateway());
    addTearDown(controller.dispose);
    await controller.bootstrap();

    await tester.pumpWidget(
      MaterialApp(
        home: AnimatedBuilder(
          animation: controller,
          builder: (context, _) => Sprint1HomePage(controller: controller),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey<String>('playback-toggle-button')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    final toggleButton = find.byKey(const ValueKey<String>('playback-toggle-button'));
    expect(toggleButton, findsOneWidget);
    expect(find.text('Reproducir'), findsOneWidget);

    await tester.tap(toggleButton);
    await tester.pump();

    expect(find.text('Pausar'), findsOneWidget);

    await tester.tap(toggleButton);
    await tester.pump();

    expect(find.text('Reproducir'), findsOneWidget);
  });
}
