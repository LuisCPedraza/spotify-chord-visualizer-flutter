import 'spotify_auth_session.dart';

class UserSession {
  final String displayName;
  final DateTime connectedAt;
  final String? userId;
  final String? email;
  final DateTime? accessTokenExpiresAt;
  final List<String> scopes;

  const UserSession({
    required this.displayName,
    required this.connectedAt,
    this.userId,
    this.email,
    this.accessTokenExpiresAt,
    this.scopes = const <String>[],
  });

  factory UserSession.fromAuthSession(SpotifyAuthSession session) {
    return UserSession(
      displayName: session.displayName,
      connectedAt: session.connectedAt,
      userId: session.userId,
      email: session.email,
      accessTokenExpiresAt: session.expiresAt,
      scopes: session.scopes,
    );
  }

  bool get hasTokenExpiry => accessTokenExpiresAt != null;
}
