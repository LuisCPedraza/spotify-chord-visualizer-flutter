class SpotifyAuthSession {
  final String accessToken;
  final String? refreshToken;
  final String userId;
  final String displayName;
  final String? email;
  final DateTime connectedAt;
  final DateTime expiresAt;
  final List<String> scopes;

  const SpotifyAuthSession({
    required this.accessToken,
    required this.userId,
    required this.displayName,
    required this.connectedAt,
    required this.expiresAt,
    this.refreshToken,
    this.email,
    this.scopes = const <String>[],
  });

  bool get isExpired =>
      DateTime.now().isAfter(expiresAt.subtract(const Duration(seconds: 30)));

  bool get canRefresh =>
      refreshToken != null && refreshToken!.trim().isNotEmpty;
}
