# app_movil_spotify

Aplicación móvil en Flutter y Dart para trabajar con Spotify y, como feature principal, mostrar acordes sincronizados con una experiencia visual pensada para música y práctica instrumental.

## Documentacion del proyecto

La documentacion completa y separada por entregables esta en [docs/00_INDICE_DOCUMENTAL.md](docs/00_INDICE_DOCUMENTAL.md).

Tambien puedes revisar el resumen ejecutivo en [docs/PROJECT_DOCUMENTATION.md](docs/PROJECT_DOCUMENTATION.md).

## Resumen rápido

- Base técnica: Flutter, Dart, Spotify SDK y Spotify Web API.
- Feature principal: detector y visualizador de acordes.
- Alcance inicial: autenticación, búsqueda, reproducción y pantalla de acordes.
- Riesgo clave: Spotify no expone el audio crudo del reproductor para analizarlo directamente; el diseño debe usar sincronización permitida, metadatos y análisis local cuando aplique.
