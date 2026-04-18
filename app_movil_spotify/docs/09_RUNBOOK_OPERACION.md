# 09. Runbook de Operacion

## 1. Objetivo

Guia operativa para preparar entorno, configurar Spotify y ejecutar la app de forma consistente.

## 2. Prerrequisitos

- Flutter SDK instalado y funcional.
- Android Studio con emulador o dispositivo fisico.
- Cuenta Spotify y cuenta Spotify Developer.
- Git y editor (VS Code recomendado).

## 3. Validacion de Entorno

Comandos sugeridos:

```bash
flutter doctor
flutter --version
```

Resultado esperado:

- Toolchain Android sin errores bloqueantes.
- Flutter estable disponible.

## 4. Instalacion de Dependencias

Desde la raiz del proyecto:

```bash
cd app_movil_spotify
flutter pub get
```

## 5. Configuracion Spotify Developer

1. Crear app en Spotify Developer Dashboard.
2. Registrar redirect URI para movil.
3. Guardar client id.
4. Definir scopes del MVP.

## 6. Variables y Secretos

- Mantener configuracion sensible fuera del repositorio.
- Usar archivo local ignorado por git para credenciales.
- No incluir tokens en logs.

Ejemplo de claves necesarias:

- SPOTIFY_CLIENT_ID
- SPOTIFY_REDIRECT_URI

## 7. Ejecucion de la App

```bash
flutter run
```

Opcional con dispositivo especifico:

```bash
flutter devices
flutter run -d <device-id>
```

## 8. Troubleshooting Rapido

## Error de login/callback

- Verificar redirect URI exacta en Spotify y app.
- Verificar package/bundle segun plataforma.

## Error de red/API

- Verificar conectividad.
- Revisar scopes y expiracion de sesion.

## App no inicia en emulador

- Ejecutar flutter clean.
- Ejecutar flutter pub get.
- Reiniciar emulador/dispositivo.

## 9. Comandos Utiles de Calidad

```bash
flutter analyze
flutter test
```

## 10. Protocolo de Demo

1. Abrir app y validar estado inicial.
2. Login con Spotify.
3. Buscar cancion.
4. Abrir detalle y player.
5. Mostrar visualizador de acordes.
6. Cerrar con breve explicacion de arquitectura y pruebas.

## 11. Checklist Pre-Entrega

- Build y analisis sin errores criticos.
- Flujo principal comprobado.
- Documentacion actualizada.
- Evidencias (capturas/video) listas.
