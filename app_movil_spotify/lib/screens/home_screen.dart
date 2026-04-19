import 'package:flutter/material.dart';
import '../services/spotify_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  List tracks = [];
  Map<String, dynamic>? currentAnalysis;
  bool isLoading = false;
  String? errorMessage;

  Future<void> _searchTracks(String query) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    final results = await SpotifyService.searchTrack(query);
    setState(() {
      final tracksMap = results['tracks'];
      tracks = tracksMap is Map<String, dynamic>
          ? (tracksMap['items'] as List? ?? <dynamic>[])
          : <dynamic>[];
      isLoading = false;
      if (tracks.isEmpty) {
        errorMessage = 'No hay resultados o la sesion no esta autenticada.';
      }
    });
  }

  Future<void> _loadAnalysis(String trackId) async {
    final analysis = await SpotifyService.getAudioAnalysis(trackId);
    final features = await SpotifyService.getAudioFeatures(trackId);

    setState(() {
      currentAnalysis = {'analysis': analysis, 'features': features};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chord Detector Spotify'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Buscar canción...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _searchTracks(_searchController.text),
                ),
              ],
            ),
          ),
          if (isLoading) CircularProgressIndicator(),
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(errorMessage!),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: tracks.length,
              itemBuilder: (context, index) {
                final track = tracks[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      track['album']['images'][0]['url'],
                    ),
                  ),
                  title: Text(track['name']),
                  subtitle: Text(track['artists'][0]['name']),
                  trailing: IconButton(
                    icon: Icon(Icons.music_note),
                    onPressed: () => _loadAnalysis(track['id']),
                  ),
                  onTap: () => _loadAnalysis(track['id']),
                );
              },
            ),
          ),
          if (currentAnalysis != null)
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.green[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🎸 Análisis Listo!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 8),
                  Text('Key: ${currentAnalysis!['features']['key']}'),
                  Text(
                    'Tempo: ${currentAnalysis!['features']['tempo'].toStringAsFixed(0)} BPM',
                  ),
                  Text(
                    'Segments: ${currentAnalysis!['analysis']['segments'].length}',
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navegar a Chord Detector Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChordDetectorScreen(),
                        ),
                      );
                    },
                    child: Text('Detectar Acordes en Vivo'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class ChordDetectorScreen extends StatelessWidget {
  const ChordDetectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chord Detector')),
      body: const Center(
        child: Text('🎤 Mic + ML Chord Recognition\nPróximamente en Sprint 2!'),
      ),
    );
  }
}
