# Guía: Ejecutar Sprint 5 en diferentes plataformas

## 📱 Android/iOS (Mobile)

```bash
cd app_movil_spotify
flutter run
```

**Cómo funciona:**
1. Lee credenciales desde `.env` (archivo local)
2. El cliente ID se usa para OAuth PKCE
3. Deep links capturan el callback de Spotify

---

## 🌐 Flutter Web (Desarrollo local)

```bash
flutter run -d chrome \
  --dart-define=SPOTIFY_CLIENT_ID=6bd405bb29144e76a312217041f2e1df \
  --dart-define=SPOTIFY_REDIRECT_URI=com.example.appmovilspotify://spotify-auth
```

**O de forma más legible en PowerShell:**

```powershell
$env:SPOTIFY_CLIENT_ID = "6bd405bb29144e76a312217041f2e1df"
$env:SPOTIFY_REDIRECT_URI = "com.example.appmovilspotify://spotify-auth"

flutter run -d chrome `
  --dart-define=SPOTIFY_CLIENT_ID=$env:SPOTIFY_CLIENT_ID `
  --dart-define=SPOTIFY_REDIRECT_URI=$env:SPOTIFY_REDIRECT_URI
```

**O crear un script `run-web.ps1`:**

```powershell
# run-web.ps1
param(
    [string]$ClientId = "6bd405bb29144e76a312217041f2e1df",
  [string]$RedirectUri = "com.example.appmovilspotify://spotify-auth"
)

flutter run -d chrome `
  --dart-define=SPOTIFY_CLIENT_ID=$ClientId `
  --dart-define=SPOTIFY_REDIRECT_URI=$RedirectUri
```

Luego ejecutar:
```powershell
.\run-web.ps1
```

---

## 🔧 Cómo funciona en cada plataforma

| Plataforma | Cómo carga credenciales | Dónde se definen |
|-----------|------------------------|-----------------|
| **Android** | `.env` (archivo assets) | Archivo `.env` en raíz |
| **iOS** | `.env` (archivo assets) | Archivo `.env` en raíz |
| **Web** | `--dart-define` (compile-time) | Parámetros en `flutter run` |

---

## ⚠️ Nota importante para Flutter Web

En web, **no se puede usar `.env` como asset** (error 404) porque:
- Los assets en web se sirven desde un servidor
- El archivo `.env` está en `.gitignore` (no en el repo)
- Se necesita pasar credenciales en **tiempo de compilación** con `--dart-define`

---

## 🔒 Seguridad

- **Nunca** commitees `.env` a Git
- `.env` solo existe en máquinas de desarrolladores
- Para CI/CD, usar secrets en GitHub Actions / Azure Pipelines
- En producción web, las credenciales vienen del backend seguro

---

## 🚀 Próximos pasos

1. **Para mobile real**: Conectar dispositivo Android/iOS y ejecutar `flutter run`
2. **Para web**: Usar `flutter run -d chrome --dart-define=...` con credenciales
3. **Validar**: Presionar "Iniciar sesion con Spotify" y confirmar flujo OAuth

