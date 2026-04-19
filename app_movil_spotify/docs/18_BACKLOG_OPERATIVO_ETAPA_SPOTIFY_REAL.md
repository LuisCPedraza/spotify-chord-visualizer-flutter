# 18. Backlog Operativo - Etapa Spotify Real

## 1. Objetivo

Convertir la etapa documental "Spotify Real" en un plan ejecutable por Scrum, con historias de usuario, ramas sugeridas, criterios de aceptacion y orden de implementacion.

Este backlog se construye despues del cierre del MVP v1.0.0 y define el camino tecnico para pasar de datos mock a consumo real de Spotify API.

## 2. Principios de ejecución

- Una historia de usuario por rama.
- Un commit principal por historia terminada.
- Un Pull Request por historia o por bloque de sprint.
- Validación obligatoria antes de fusionar.
- Evidencia visible para revisión académica y técnica.

## 3. Convenciones de ramas

Formato sugerido:

- `hu-10-login-oauth-pkce`
- `hu-11-refresh-session-secure`
- `hu-12-real-search-api`
- `hu-13-track-metadata-real`
- `hu-14-playback-context-real`
- `hu-15-quality-hardening`

Convención de commits:

- `feat: ...` para nueva funcionalidad.
- `test: ...` para pruebas.
- `docs: ...` para documentación.
- `fix: ...` para correcciones.

## 4. Plan de sprints

### Sprint 5 - Autenticacion y sesion productiva

Objetivo: conectar la cuenta real del usuario con Spotify de forma segura.

Historias:

- HU-10: login seguro con OAuth2 PKCE.
- HU-11: recuperación y renovación de sesión.

Entregable demo:

- El usuario inicia sesión, la app persiste el estado y recupera la sesión al abrirse nuevamente.

Criterios de salida:

- Login funcional.
- Logout funcional.
- Refresh token o revalidación implementada.
- CI en verde.
- Evidencia de prueba y PR.

### Sprint 6 - Catalogo real Spotify

Objetivo: reemplazar los resultados mock por búsqueda real.

Historias:

- HU-12: búsqueda real de contenido.
- HU-13: vista de metadata real de pista.

Entregable demo:

- El usuario busca una canción real, navega entre resultados y abre metadata completa.

Criterios de salida:

- Estados loading, empty y error.
- Resultados navegables.
- Portada, duración y enlace disponibles.
- Manejo de rate limit y fallos.

### Sprint 7 - Reproduccion y contexto

Objetivo: habilitar reproducción o estado de reproducción donde la plataforma lo soporte.

Historias:

- HU-14: reproducción/estado de reproducción.

Entregable demo:

- El usuario ve el estado real o equivalente soportado por la plataforma.

Criterios de salida:

- Progress visible.
- Play/pause o equivalente funcional.
- UI sincronizada con el estado.
- Restricciones de plataforma documentadas.

### Sprint 8 - Robustez y entrega final

Objetivo: cerrar calidad, riesgos y evidencia final.

Historias:

- HU-15: pruebas y hardening.

Entregable demo:

- La app funciona de forma estable, con evidencia de pruebas y documentación final.

Criterios de salida:

- Suite de pruebas consistente.
- CI pasando.
- Riesgos revisados.
- Release final de la nueva etapa preparado.

## 5. Historias de usuario detalladas

### HU-10 - Login seguro con OAuth2 PKCE

Como usuario, quiero iniciar sesión con Spotify de forma segura para acceder a mi cuenta.

#### Criterios de aceptación

- La app autentica mediante OAuth2 PKCE.
- El flujo de retorno está controlado por redirect URI o deep link.
- El token se guarda de forma segura.
- El usuario puede cerrar sesión.

#### Rama sugerida

- `hu-10-login-oauth-pkce`

#### Orden de ejecución

1. Crear rama desde `develop`.
2. Implementar flujo PKCE.
3. Guardar tokens en storage seguro.
4. Agregar tests de servicio y widget.
5. Validar con `flutter analyze` y `flutter test`.
6. Commit HU-10.
7. PR y merge a `develop`.

### HU-11 - Recuperación y renovación de sesión

Como usuario, quiero que la sesión se recupere automáticamente si sigue vigente.

#### Criterios de aceptación

- La app detecta token válido al abrir.
- La app renueva o revalida la sesión.
- La UI muestra estado de autenticación.

#### Rama sugerida

- `hu-11-refresh-session-secure`

#### Orden de ejecución

1. Crear rama desde `develop`.
2. Implementar bootstrap de sesión.
3. Manejar expiración y refresh.
4. Probar estados iniciales y logout.
5. Validar y fusionar.

### HU-12 - Búsqueda real de contenido

Como usuario, quiero buscar canciones reales en Spotify para practicar con contenido actualizado.

#### Criterios de aceptación

- La búsqueda consulta la API real.
- La interfaz muestra loading, empty y error.
- Los resultados son navegables.

#### Rama sugerida

- `hu-12-real-search-api`

#### Orden de ejecución

1. Crear rama desde `develop`.
2. Integrar endpoint real de búsqueda.
3. Introducir capa de mapeo de respuesta.
4. Probar estados de UI.
5. Validar y fusionar.

### HU-13 - Metadata real de pista

Como usuario, quiero ver la información real de una pista para identificarla rápido.

#### Criterios de aceptación

- La vista muestra título, artista, álbum, duración y portada.
- La información coincide con la pista seleccionada.

#### Rama sugerida

- `hu-13-track-metadata-real`

#### Orden de ejecución

1. Crear rama desde `develop`.
2. Consumir metadata real de la pista.
3. Renderizar portada y enlace.
4. Probar selección desde catálogo.
5. Validar y fusionar.

### HU-14 - Reproducción o estado de reproducción

Como usuario, quiero controlar o visualizar la reproducción para seguir mi práctica.

#### Criterios de aceptación

- La UI refleja play/pause o estado equivalente.
- El progreso se sincroniza con el estado real disponible.
- Se manejan límites de plataforma.

#### Rama sugerida

- `hu-14-playback-context-real`

#### Orden de ejecución

1. Crear rama desde `develop`.
2. Conectar playback/contexto real.
3. Sincronizar UI.
4. Agregar pruebas del flujo.
5. Validar y fusionar.

### HU-15 - Pruebas y hardening

Como equipo, queremos asegurar calidad y estabilidad en la nueva integración.

#### Criterios de aceptación

- Existen pruebas unitarias y widget para componentes críticos.
- Se documenta evidencia de ejecución.
- El pipeline CI valida los cambios.

#### Rama sugerida

- `hu-15-quality-hardening`

#### Orden de ejecución

1. Crear rama desde `develop`.
2. Reforzar pruebas.
3. Revisar seguridad y manejo de errores.
4. Documentar evidencia de cierre.
5. Validar y fusionar.

## 6. Definition of Ready

Antes de iniciar una HU:

- Objetivo claro.
- Criterios de aceptación definidos.
- Dependencias conocidas.
- Riesgos identificados.
- Plan de prueba definido.

## 7. Definition of Done

Cada historia queda lista cuando:

- El código compila.
- `flutter analyze` pasa.
- `flutter test` pasa.
- La funcionalidad está documentada.
- Existe PR o merge trazable.
- No hay secretos expuestos.

## 8. Priorizacion recomendada

1. HU-10.
2. HU-11.
3. HU-12.
4. HU-13.
5. HU-14.
6. HU-15.

## 9. Riesgos operativos

- Restricciones de Spotify por plataforma.
- Expiración de tokens.
- Rate limits.
- Dependencias de entorno en CI.
- Diferencias entre mobile, desktop y web.

## 10. Mitigaciones

- Usar mocks de respaldo mientras se prueba la integración.
- Centralizar manejo de errores.
- Documentar restricciones de plataforma.
- Mantener el CI simple y reproducible.
- Registrar evidencia por sprint.

## 11. Evidencia esperada

- PRs por HU.
- Commits por HU.
- Checks verdes.
- Video o capturas de demo.
- Documento de sprint y release notes.
