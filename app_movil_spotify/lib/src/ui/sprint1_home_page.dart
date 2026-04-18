import 'package:app_movil_spotify/src/controller/sprint1_controller.dart';
import 'package:app_movil_spotify/src/models/song.dart';
import 'package:app_movil_spotify/src/models/user_session.dart';
import 'package:flutter/material.dart';

class Sprint1HomePage extends StatelessWidget {
  final Sprint1Controller controller;

  const Sprint1HomePage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final currentSession = controller.session;
    final isConnected =
        controller.connectionState == Sprint1ConnectionState.connected;

    return Scaffold(
      appBar: AppBar(title: const Text('Spotify Chord Visualizer')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Sprint 1 - Spotify Core',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            Text(
              'Base de autenticación, sesión y búsqueda para el MVP musical.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            _StatusCard(
              controller: controller,
              currentSession: currentSession,
              isConnected: isConnected,
            ),
            const SizedBox(height: 16),
            _SearchCard(controller: controller, isConnected: isConnected),
            const SizedBox(height: 16),
            _CatalogCard(songs: controller.visibleSongs),
            const SizedBox(height: 16),
            const _FooterCard(),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final Sprint1Controller controller;
  final bool isConnected;
  final UserSession? currentSession;

  const _StatusCard({
    required this.controller,
    required this.currentSession,
    required this.isConnected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    controller.connectionLabel,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Chip(label: Text(isConnected ? 'Activo' : 'Pendiente')),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              isConnected && currentSession != null
                  ? 'Sesión conectada como ${currentSession!.displayName}'
                  : 'Aún no has iniciado sesión con Spotify.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton(
                  onPressed: controller.connect,
                  child: const Text('Conectar con Spotify'),
                ),
                OutlinedButton(
                  onPressed: controller.disconnect,
                  child: const Text('Cerrar sesión'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchCard extends StatelessWidget {
  final Sprint1Controller controller;
  final bool isConnected;

  const _SearchCard({required this.controller, required this.isConnected});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Buscar canciones',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            TextField(
              enabled: isConnected,
              onChanged: controller.updateSearchQuery,
              decoration: const InputDecoration(
                hintText: 'Escribe una canción, artista o álbum',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              isConnected
                  ? 'Escribe para filtrar el catálogo de demostración.'
                  : 'Conecta tu sesión para habilitar la búsqueda.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _CatalogCard extends StatelessWidget {
  final List<Song> songs;

  const _CatalogCard({required this.songs});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resultados de ejemplo',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ...songs.map(
              (song) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _SongTile(song: song),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SongTile extends StatelessWidget {
  final Song song;

  const _SongTile({required this.song});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD2D2D7)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.music_note_rounded),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  '${song.artist} • ${song.album}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterCard extends StatelessWidget {
  const _FooterCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'Sprint 1 listo para evolucionar hacia autenticación real con Spotify SDK y búsqueda Web API.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
