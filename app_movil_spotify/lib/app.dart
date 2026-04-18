import 'package:app_movil_spotify/src/controller/sprint1_controller.dart';
import 'package:app_movil_spotify/src/ui/app_theme.dart';
import 'package:app_movil_spotify/src/ui/sprint1_home_page.dart';
import 'package:flutter/material.dart';

class SpotifyChordVisualizerApp extends StatefulWidget {
  const SpotifyChordVisualizerApp({super.key});

  @override
  State<SpotifyChordVisualizerApp> createState() =>
      _SpotifyChordVisualizerAppState();
}

class _SpotifyChordVisualizerAppState extends State<SpotifyChordVisualizerApp> {
  late final Sprint1Controller controller;

  @override
  void initState() {
    super.initState();
    controller = Sprint1Controller()..bootstrap();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
