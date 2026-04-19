import 'package:app_movil_spotify/src/controller/sprint1_controller.dart';
import 'package:app_movil_spotify/src/ui/app_theme.dart';
import 'package:app_movil_spotify/src/ui/sprint1_home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SpotifyChordVisualizerApp extends StatefulWidget {
  const SpotifyChordVisualizerApp({super.key});

  @override
  State<SpotifyChordVisualizerApp> createState() =>
      _SpotifyChordVisualizerAppState();
}

class _SpotifyChordVisualizerAppState extends State<SpotifyChordVisualizerApp> {
  late final Sprint1Controller controller;
  String? initializationError;

  @override
  void initState() {
    super.initState();
    try {
      controller = Sprint1Controller()..bootstrap();
    } catch (e) {
      initializationError = e.toString();
      if (kDebugMode) {
        print('❌ Error inicializando controlador: $e');
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (initializationError != null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Spotify Chord Visualizer - Error',
        theme: AppTheme.light(),
        home: Scaffold(
          appBar: AppBar(title: const Text('Error de inicialización')),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '❌ Error al inicializar',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    initializationError!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spotify Chord Visualizer',
      theme: AppTheme.light(),
      home: AnimatedBuilder(
        animation: controller,
        builder: (context, _) => Sprint1HomePage(controller: controller),
      ),
    );
  }
}
