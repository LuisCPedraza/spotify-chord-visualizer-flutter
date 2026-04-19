import 'package:app_movil_spotify/app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // En web, no cargar .env (no está disponible)
  // En mobile, intentar cargar .env
  if (!kIsWeb) {
    try {
      await dotenv.load(fileName: '.env');
      if (kDebugMode) {
        print('✓ .env cargado correctamente en dispositivo');
        print(
          '  SPOTIFY_CLIENT_ID: ${dotenv.env['SPOTIFY_CLIENT_ID']?.substring(0, 8)}***',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠ Error cargando .env: $e');
        print('  Usando variables de entorno como fallback...');
      }
    }
  } else {
    if (kDebugMode) {
      print('ℹ Ejecutando en Flutter Web');
      print('  Usando String.fromEnvironment() para credenciales');
      print('  Para web, define variables al compilar:');
      print('  flutter run -d chrome --dart-define=SPOTIFY_CLIENT_ID=tu_id');
    }
  }

  runApp(const SpotifyChordVisualizerApp());
}
