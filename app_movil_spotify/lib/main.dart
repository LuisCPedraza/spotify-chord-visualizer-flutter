import 'package:app_movil_spotify/app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await dotenv.load(fileName: '.env');
    if (kDebugMode) {
      print('✓ .env cargado correctamente');
      print('  SPOTIFY_CLIENT_ID: ${dotenv.env['SPOTIFY_CLIENT_ID']?.substring(0, 8)}***');
    }
  } catch (e) {
    if (kDebugMode) {
      print('⚠ Error cargando .env: $e');
      print('  Usando variables de entorno como fallback...');
    }
  }
  
  runApp(const SpotifyChordVisualizerApp());
}
