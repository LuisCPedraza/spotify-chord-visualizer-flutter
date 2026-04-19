import 'package:app_movil_spotify/src/controller/sprint1_controller.dart';
import 'package:app_movil_spotify/src/models/chord_segment.dart';
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
    final focusMode = controller.chordFocusMode;

    final children = <Widget>[
      Text(
        focusMode
            ? 'Sprint 3 - Chord Viewer (Modo enfoque)'
            : 'Sprint 3 - Chord Viewer',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const SizedBox(height: 6),
      Text(
        focusMode
            ? 'Vista enfocada para practicar acordes sin distracciones.'
            : 'Base de autenticación, sesión y búsqueda para el MVP musical.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: 20),
      _ChordAccessibilityCard(controller: controller),
      const SizedBox(height: 16),
    ];

    if (!focusMode) {
      children.addAll([
        _StatusCard(
          controller: controller,
          currentSession: currentSession,
          isConnected: isConnected,
        ),
        const SizedBox(height: 16),
        _SearchCard(controller: controller, isConnected: isConnected),
        const SizedBox(height: 16),
        _CatalogCard(
          controller: controller,
          songs: controller.visibleSongs,
          searchQuery: controller.searchQuery,
        ),
        const SizedBox(height: 16),
      ]);
    }

    children.addAll([
      _TrackMetadataCard(controller: controller),
      const SizedBox(height: 16),
      _PlayerControlsCard(controller: controller),
      const SizedBox(height: 16),
      _ChordViewerCard(controller: controller),
      const SizedBox(height: 16),
      const _FooterCard(),
    ]);

    return Scaffold(
      appBar: AppBar(title: const Text('Spotify Chord Visualizer')),
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(20), children: children),
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
              controller.sessionSummary,
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
  final Sprint1Controller controller;
  final List<Song> songs;
  final String searchQuery;

  const _CatalogCard({
    required this.controller,
    required this.songs,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              songs.isEmpty
                  ? 'Sin coincidencias'
                  : 'Resultados de ejemplo (${songs.length})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              '${controller.favoriteCount} favorito${controller.favoriteCount == 1 ? '' : 's'} guardado${controller.favoriteCount == 1 ? '' : 's'}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            if (songs.isEmpty)
              _EmptySearchState(searchQuery: searchQuery)
            else
              ...songs.map(
                (song) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _SongTile(
                    controller: controller,
                    song: song,
                    isSelected: controller.selectedSong?.id == song.id,
                    isFavorite: controller.isFavorite(song.id),
                    onFavoriteToggle: () => controller.toggleFavorite(song.id),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  final String searchQuery;

  const _EmptySearchState({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD2D2D7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No encontramos resultados para "$searchQuery".',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'Prueba con otro artista, álbum o canción del catálogo de ejemplo.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _SongTile extends StatelessWidget {
  final Sprint1Controller controller;
  final Song song;
  final bool isSelected;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const _SongTile({
    required this.controller,
    required this.song,
    required this.isSelected,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ValueKey<String>('song-tile-${song.id}'),
      onTap: () => controller.selectSong(song),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0071E3)
                : const Color(0xFFD2D2D7),
          ),
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
            IconButton(
              key: ValueKey<String>('favorite-${song.id}'),
              onPressed: onFavoriteToggle,
              tooltip: isFavorite
                  ? 'Quitar de favoritos'
                  : 'Marcar como favorito',
              icon: Icon(
                isFavorite ? Icons.favorite_rounded : Icons.favorite_border,
                color: isFavorite
                    ? const Color(0xFF0071E3)
                    : const Color(0xFF6E6E73),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackMetadataCard extends StatelessWidget {
  final Sprint1Controller controller;

  const _TrackMetadataCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    Song? currentTrack = controller.selectedSong;
    if (currentTrack == null && controller.visibleSongs.isNotEmpty) {
      currentTrack = controller.visibleSongs.first;
    }

    if (currentTrack == null) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pista seleccionada',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    currentTrack.coverArtUrl,
                    width: 78,
                    height: 78,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 78,
                        height: 78,
                        color: const Color(0xFFF5F5F7),
                        alignment: Alignment.center,
                        child: const Icon(Icons.album_rounded),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentTrack.title,
                        key: const ValueKey<String>('selected-track-title'),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        currentTrack.artist,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${currentTrack.album} • ${currentTrack.formattedDuration}',
                        key: const ValueKey<String>('selected-track-meta'),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SelectableText(
              currentTrack.spotifyTrackUrl,
              key: const ValueKey<String>('selected-track-link'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerControlsCard extends StatelessWidget {
  final Sprint1Controller controller;

  const _PlayerControlsCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Controles de reproducción',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton.icon(
                  key: const ValueKey<String>('playback-toggle-button'),
                  onPressed: controller.togglePlayback,
                  icon: Icon(
                    controller.isPlaying
                        ? Icons.pause_circle_outline
                        : Icons.play_circle_outline,
                  ),
                  label: Text(controller.isPlaying ? 'Pausar' : 'Reproducir'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${controller.playbackPositionLabel} / ${controller.playbackDurationLabel}',
                    key: const ValueKey<String>('playback-time-label'),
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                key: const ValueKey<String>('playback-progress'),
                value: controller.playbackProgress,
                minHeight: 8,
                backgroundColor: const Color(0xFFD2D2D7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChordViewerCard extends StatelessWidget {
  final Sprint1Controller controller;

  const _ChordViewerCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final active = controller.activeChordSegment;
    final timeline = controller.chordTimeline;
    final upcoming = controller.upcomingChordSegments;
    final isHighContrast = controller.chordHighContrast;
    final isFocusMode = controller.chordFocusMode;
    final chordScale = controller.chordFontScale;

    final activeBackgroundColor = isHighContrast
        ? const Color(0xFF111111)
        : const Color(0xFFF5F5F7);
    final activeTextColor = isHighContrast
        ? const Color(0xFFFFFFFF)
        : const Color(0xFF111111);

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
                    'Acordes sincronizados',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                DropdownButton<ChordDifficulty>(
                  key: const ValueKey<String>('chord-difficulty-dropdown'),
                  value: controller.chordDifficulty,
                  onChanged: (difficulty) {
                    if (difficulty != null) {
                      controller.setChordDifficulty(difficulty);
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: ChordDifficulty.basic,
                      child: Text('Básico'),
                    ),
                    DropdownMenuItem(
                      value: ChordDifficulty.intermediate,
                      child: Text('Intermedio'),
                    ),
                    DropdownMenuItem(
                      value: ChordDifficulty.full,
                      child: Text('Completo'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              key: const ValueKey<String>('chord-active-container'),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              decoration: BoxDecoration(
                color: activeBackgroundColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isHighContrast
                      ? const Color(0xFFFFFFFF)
                      : const Color(0xFFD2D2D7),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Acorde activo',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: activeTextColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.activeChordLabel,
                    key: const ValueKey<String>('chord-active-label'),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: activeTextColor,
                      fontSize: 34 * chordScale,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    active == null
                        ? 'Sin progresión para esta pista.'
                        : 'Ventana ${active.startSecond}s - ${active.endSecond}s',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: activeTextColor),
                  ),
                ],
              ),
            ),
            if (!isFocusMode) ...[
              const SizedBox(height: 12),
              Text('Próximos', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                key: const ValueKey<String>('chord-upcoming-wrap'),
                spacing: 8,
                runSpacing: 8,
                children: upcoming.isEmpty
                    ? [
                        Chip(
                          label: Text(
                            timeline.isEmpty
                                ? 'No disponible'
                                : 'Fin de sección',
                          ),
                        ),
                      ]
                    : upcoming
                          .map(
                            (segment) => Chip(
                              label: Text(
                                segment.labelFor(controller.chordDifficulty),
                              ),
                            ),
                          )
                          .toList(growable: false),
              ),
              const SizedBox(height: 12),
              Text(
                'Timeline armónico',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                key: const ValueKey<String>('chord-timeline-container'),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: timeline.isEmpty
                      ? [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFD2D2D7),
                              ),
                            ),
                            child: Text(
                              'Sin timeline',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ]
                      : timeline
                            .map((segment) {
                              final isActive = identical(segment, active);
                              return Container(
                                key: ValueKey<String>(
                                  'chord-segment-${segment.startSecond}-${segment.endSecond}',
                                ),
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? const Color(0xFFEFF6FF)
                                      : const Color(0xFFF5F5F7),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isActive
                                        ? const Color(0xFF0071E3)
                                        : const Color(0xFFD2D2D7),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      segment.labelFor(
                                        controller.chordDifficulty,
                                      ),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleSmall,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${segment.startSecond}s-${segment.endSecond}s',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              );
                            })
                            .toList(growable: false),
                ),
              ),
            ] else ...[
              const SizedBox(height: 12),
              Container(
                key: const ValueKey<String>('chord-focus-banner'),
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Modo enfoque activo: mostrando solo el acorde principal.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ChordAccessibilityCard extends StatelessWidget {
  final Sprint1Controller controller;

  const _ChordAccessibilityCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vista legible',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              key: const ValueKey<String>('chord-high-contrast-switch'),
              contentPadding: EdgeInsets.zero,
              title: const Text('Alto contraste'),
              value: controller.chordHighContrast,
              onChanged: controller.setChordHighContrast,
            ),
            SwitchListTile(
              key: const ValueKey<String>('chord-focus-mode-switch'),
              contentPadding: EdgeInsets.zero,
              title: const Text('Modo enfoque'),
              value: controller.chordFocusMode,
              onChanged: controller.setChordFocusMode,
            ),
            const SizedBox(height: 6),
            Text(
              'Escala de acorde x${controller.chordFontScale.toStringAsFixed(1)}',
              key: const ValueKey<String>('chord-font-scale-label'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Slider(
              key: const ValueKey<String>('chord-font-scale-slider'),
              value: controller.chordFontScale,
              min: 0.8,
              max: 1.8,
              divisions: 10,
              label: controller.chordFontScale.toStringAsFixed(1),
              onChanged: controller.setChordFontScale,
            ),
          ],
        ),
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
          'Sprint 3 listo para evolucionar hacia visualización de acordes avanzada y práctica guiada.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
