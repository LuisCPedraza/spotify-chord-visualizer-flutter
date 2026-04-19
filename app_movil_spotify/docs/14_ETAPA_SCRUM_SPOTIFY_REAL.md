# 14. Etapa Scrum: Integracion Real con Spotify API

## 1. Proposito

Esta etapa inicia despues del cierre del MVP v1.0.0 y tiene como objetivo convertir el prototipo funcional en una aplicacion conectada con Spotify de forma productiva, segura y demostrable.

El enfoque deja de ser solo demostrativo y pasa a ser:

- autenticacion real con Spotify,
- consumo de API Web de Spotify,
- control de reproduccion donde el entorno lo permita,
- robustez operativa,
- evidencia academica y tecnica para evaluacion.

## 2. Alcance de la nueva etapa

### Incluye

- Autenticacion OAuth 2.0 con PKCE.
- Manejo seguro de access token y refresh token.
- Recuperacion de sesion valida al abrir la app.
- Busqueda real de tracks, albums y artistas.
- Seleccion de pista con metadata real.
- Reproduccion o control de sesion de reproduccion, segun disponibilidad del SDK y plataforma.
- Integracion con estados de error, reintentos y rate limit.
- Cobertura de pruebas para componentes criticos.
- Documentacion y evidencia por sprint.

### No incluye inicialmente

- Funciones no soportadas por Spotify en todas las plataformas.
- Analisis de audio crudo directo desde el reproductor de Spotify.
- Features de gamificacion o social no necesarias para el flujo principal.
- Funcionalidades premium o dependientes de permisos avanzados no garantizados.

## 3. Objetivos de negocio y producto

- Hacer que la app consuma datos reales de Spotify.
- Reducir el uso de mocks en el flujo principal.
- Garantizar una experiencia estable al usuario.
- Mantener la interfaz minimalista y la navegacion ya aprobada.
- Preparar una base seria para una demo profesional.

## 4. Roles Scrum para esta etapa

- Product Owner: valida valor, prioridades y alcance del backlog.
- Scrum Master: controla el flujo de sprints, dependencias y bloqueos.
- Development Team: implementa, prueba, documenta y prepara evidencia.

## 5. Ceremonias

### Planning

- Duracion: 60 a 90 minutos.
- Salida: sprint backlog con historias priorizadas.
- Criterio: cada HU debe poder completarse dentro del sprint.

### Daily

- Duracion: 10 a 15 minutos.
- Salida: bloqueos, avance y plan del dia.

### Review

- Se presenta demo funcional con evidencia de PRs, tests y cambios.

### Retrospective

- Se registran mejoras en calidad, velocidad y validacion.

## 6. Definition of Ready

Una historia entra al sprint cuando:

- Tiene objetivo claro.
- Tiene criterios de aceptacion medibles.
- Tiene dependencias identificadas.
- Tiene riesgo tecnico descrito.
- Tiene salida de QA esperada.

## 7. Definition of Done

Una historia se considera terminada cuando:

- El codigo compila sin errores.
- `flutter analyze` pasa.
- Las pruebas aplicables pasan.
- La historia esta documentada.
- Existe evidencia en PR/commit y, si aplica, captura o demo.
- No hay secretos expuestos en el repositorio.

## 8. Epicas de la nueva etapa

### E5. Autenticacion y sesion productiva

Objetivo: conectar la cuenta real del usuario con seguridad.

### E6. Consumo de catalogo Spotify

Objetivo: buscar y seleccionar contenido real del API.

### E7. Reproduccion y contexto del track

Objetivo: gestionar pista actual, contexto de reproduccion y metadata ampliada.

### E8. Robustez, seguridad y calidad

Objetivo: endurecer la app para uso real y entrega profesional.

## 9. Plan de alto nivel por sprints

### Sprint 5 - Autenticacion real

- OAuth2 PKCE.
- Persistencia segura.
- Logout y expiracion de sesion.
- Manejo basico de errores.

### Sprint 6 - Catalogo real Spotify

- Busqueda real.
- Listado de resultados.
- Navegacion a metadata de pista.
- Estados loading/empty/error.

### Sprint 7 - Reproduccion y contexto

- Integracion de playback donde sea soportado.
- Metadata extendida.
- Control de estado y actualizacion de UI.

### Sprint 8 - Hardening final

- Pruebas mas completas.
- Revisiones de seguridad.
- Preparacion de release y evidencia final.

## 10. Riesgos especificos

- Limitaciones del SDK de Spotify por plataforma.
- Necesidad de permisos o configuraciones de desarrollador.
- Expiracion de tokens.
- Rate limits o respuestas inestables de la API.
- Diferencias entre desktop, mobile y web.

## 11. Mitigaciones

- Usar PKCE y almacenamiento seguro.
- Centralizar manejo de errores y reintentos.
- Mantener mocks de respaldo para demos y pruebas.
- Definir comportamiento degradado por plataforma.
- Versionar el contrato de datos usado por la UI.

## 12. Entregables de la etapa

- Backlog priorizado por sprint.
- PRs por historia de usuario.
- CI con pruebas automatizadas.
- Documento de evidencia por sprint.
- Release final de la nueva fase.

## 13. Resultado esperado

Una app que ya no solo simule Spotify, sino que consuma Spotify de forma real y profesional, manteniendo el enfoque en una experiencia musical clara, estable y demostrable.
