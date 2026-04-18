# 05. Especificacion API Spotify

## 1. Objetivo

Documentar la integracion con Spotify para autenticacion, busqueda y metadata de reproduccion, definiendo contratos minimos para el MVP.

## 2. Autenticacion

Se recomienda Authorization Code con PKCE para app movil.

## Flujo PKCE

1. Generar code_verifier y code_challenge.
2. Abrir autorizacion de Spotify con scopes requeridos.
3. Recibir callback por redirect URI.
4. Intercambiar authorization code por token.
5. Guardar token de forma segura.

## 3. Scopes Iniciales Sugeridos

- user-read-email
- user-read-private
- user-read-playback-state
- user-modify-playback-state
- user-read-currently-playing

Nota: solicitar solo scopes necesarios para minimizar riesgos.

## 4. Endpoints Principales

### Perfil de usuario

- GET /v1/me
- Uso: validar sesion y mostrar usuario autenticado.

### Busqueda

- GET /v1/search
- Parametros: q, type, limit, offset.
- Uso: buscar canciones y artistas.

### Reproduccion actual

- GET /v1/me/player/currently-playing
- Uso: obtener pista y tiempo de reproduccion.

### Estado de reproductor

- GET /v1/me/player
- Uso: estado general del dispositivo y reproduccion.

## 5. Contratos de Datos (MVP)

## SearchTrackItem

- id: String
- name: String
- artists: List<String>
- albumName: String
- imageUrl: String
- durationMs: int

## CurrentlyPlaying

- trackId: String
- isPlaying: bool
- progressMs: int
- durationMs: int

## UserProfile

- id: String
- displayName: String
- email: String?
- imageUrl: String?

## 6. Manejo de Limites y Errores

- 401 Unauthorized: refrescar sesion o relogin.
- 403 Forbidden: validar scopes.
- 429 Too Many Requests: aplicar backoff exponencial.
- 5xx: reintento limitado con mensaje de estado.

## 7. Politica de Reintentos

- Reintento maximo: 3 intentos.
- Espera sugerida: 1 s, 2 s, 4 s.
- Si falla: mostrar mensaje y accion manual de reintento.

## 8. Seguridad de Credenciales

- No commitear client id/secret en el repo.
- Usar archivo local ignorado para configuracion sensible.
- En cliente movil, evitar uso de client secret cuando aplique PKCE.

## 9. Consideraciones para Acordes

- No depender del audio stream protegido de Spotify.
- Sincronizar acordes con timeline/metadata y fuentes armonicas compatibles.
- Mantener separada la capa que resuelve acordes para facilitar cambios futuros.

## 10. Checklist de Integracion

- Redirect URI registrada.
- Scopes validados.
- Callback funcionando en Android e iOS.
- Endpoint /v1/me operativo.
- Endpoint /v1/search operativo.
- Estado de reproduccion disponible.
