# Guía: Configurar credenciales reales de Spotify para Sprint 5

## 1. Registrar la aplicación en Spotify Developer Dashboard

### Paso 1.1: Crear cuenta o acceder
1. Ve a [Spotify Developer Dashboard](https://developer.spotify.com/dashboard)
2. Inicia sesión con tu cuenta de Spotify o crea una nueva

### Paso 1.2: Crear una aplicación nueva
1. Haz clic en "Create an App"
2. Completa el nombre: `App Movil Spotify` (o el que prefieras)
3. Acepta los términos de servicio
4. Haz clic en "Create"

### Paso 1.3: Obtener el Client ID
1. En la página de la aplicación, verás un panel con los datos
2. **Copia el `Client ID`** (un string similar a `abc123def456ghi789...`)
3. Guárdalo en un lugar seguro (por ahora en un archivo de notas privado)

### Paso 1.4: Obtener el Client Secret (opcional, no lo necesitamos ahora)
- Haz clic en "Show Client Secret" si lo necesitas después
- **Nunca lo expongas en código público**

## 2. Configurar los Redirect URIs en Spotify

### Paso 2.1: Ir a Configuración de la App
1. En el dashboard de tu aplicación, haz clic en "Edit Settings"

### Paso 2.2: Agregar los Redirect URIs
En la sección "Redirect URIs", agrega los siguientes:

#### Para Android:
```
com.example.app_movil_spotify://spotify-auth
```

#### Para iOS:
```
com.example.app_movil_spotify://spotify-auth
```

#### Para Web (si pruebas en escritorio):
```
http://localhost:8080/callback
```

### Paso 2.3: Guardar cambios
1. Haz clic en "Save"
2. Confirma si hay un popup de confirmación

## 3. Pasar las credenciales a la aplicación Flutter

### Opción A: Variables de entorno (recomendado para desarrollo)

#### En Windows (PowerShell):
```powershell
cd C:\Users\carlo\Proyectos\appMovilSpotify\app_movil_spotify
$env:SPOTIFY_CLIENT_ID = "TU_CLIENT_ID_AQUI"
$env:SPOTIFY_REDIRECT_URI = "com.example.app_movil_spotify://spotify-auth"
flutter run
```

#### En Windows (CMD):
```cmd
cd C:\Users\carlo\Proyectos\appMovilSpotify\app_movil_spotify
set SPOTIFY_CLIENT_ID=TU_CLIENT_ID_AQUI
set SPOTIFY_REDIRECT_URI=com.example.app_movil_spotify://spotify-auth
flutter run
```

### Opción B: Archivo .env (mejor práctica a largo plazo)

1. Crea un archivo `.env` en la raíz del proyecto:
```
SPOTIFY_CLIENT_ID=TU_CLIENT_ID_AQUI
SPOTIFY_REDIRECT_URI=com.example.app_movil_spotify://spotify-auth
```

2. Agrega `flutter_dotenv` al `pubspec.yaml`:
```yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

3. En `main.dart`:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  runApp(const SpotifyChordVisualizerApp());
}
```

4. En `spotify_auth_service.dart`, reemplaza la lectura de `const String.fromEnvironment()` por:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

final clientId = dotenv.env['SPOTIFY_CLIENT_ID'] ?? '';
final redirectUri = dotenv.env['SPOTIFY_REDIRECT_URI'] ?? _defaultRedirectUri;
```

5. Ejecuta con:
```
flutter run
```

## 4. Información que debes proporcionarme

Una vez que hayas completado los pasos anteriores, proporcióname:

```
SPOTIFY_CLIENT_ID: [copia aquí el Client ID de Spotify]
Redirect URI configurado: com.example.app_movil_spotify://spotify-auth
Plataforma de prueba: [Android / iOS / Web]
Estado de la app en el dashboard: [registrada y funcionando]
```

## 5. Consideraciones de seguridad

⚠️ **Importante**: 
- **Nunca** hagas commit del `.env` o variables de entorno con Client ID en Git
- Agrega `.env` al `.gitignore`:
  ```
  .env
  .env.local
  ```
- El Client ID se puede compartir, pero el Client Secret nunca
- En producción, usa un backend seguro para manejar tokens

## 6. Troubleshooting

### Si obtienes "Spotify rechazo el acceso"
- Verifica que el Redirect URI en Spotify Dashboard coincida exactamente con:
  ```
  com.example.app_movil_spotify://spotify-auth
  ```
- Revisa que el Client ID sea correcto (sin espacios)

### Si la app no abre el navegador de Spotify
- En Android: verifica que el deep link esté registrado en AndroidManifest.xml ✓ (ya configurado)
- En iOS: verifica que el URL scheme esté en Info.plist ✓ (ya configurado)

### Si el token expira sin renovarse
- Verifica que el `refresh_token` está siendo guardado
- Revisa los logs de stderr en la terminal de Flutter

## 7. Próximas etapas después de validar el login

Una vez que el login funcione:
1. Crear rama `hu-10-login-oauth-pkce` con cambios de configuración
2. Validar que la búsqueda real usa el token del usuario (HU-12)
3. Confirmar que los metadatos de pista vienen de Spotify (HU-13)
4. Documentar el flujo en Sprint 5 y hacer commit

---

**¿Necesitas ayuda con alguno de estos pasos?** Cuéntame:
- ¿Dónde estás atascado?
- ¿Qué Client ID obtuviste? (para validar el formato)
- ¿En qué plataforma quieres probar primero? (Android/iOS/Web)
