# 16. Plan de Sprints - Etapa Spotify Real

## 1. Objetivo del plan

Transformar el MVP cerrado en una app conectada a Spotify de forma real, con un flujo incremental controlado por Scrum.

## 2. Sprint 5 - Autenticacion y sesion

### Objetivo

Conectar al usuario con Spotify de forma segura y recuperar su sesion correctamente.

### Historias

- HU-10: login seguro con OAuth2 PKCE.
- HU-11: recuperación y renovación de sesión.

### Entregable demo

- Usuario entra, se autentica y la app reconoce la sesión al reabrirse.

### Criterios de salida

- Login funcional.
- Logout funcional.
- Token persistido de forma segura.
- Pruebas básicas del flujo.

## 3. Sprint 6 - Catalogo real Spotify

### Objetivo

Reemplazar los resultados mock por búsqueda real contra Spotify API.

### Historias

- HU-12: búsqueda real de contenido.
- HU-13: vista de metadata real de pista.

### Entregable demo

- Usuario busca una canción, ve resultados reales y abre metadata.

### Criterios de salida

- Estados loading, empty y error.
- Resultados navegables.
- UI estable y responsive.

## 4. Sprint 7 - Reproduccion y contexto

### Objetivo

Habilitar el control de reproducción o el contexto equivalente soportado por la plataforma.

### Historias

- HU-14: reproducción/estado de reproducción.

### Entregable demo

- La app muestra el estado de reproducción y sincroniza la UI.

### Criterios de salida

- Progress visible.
- Play/pause o equivalente funcional.
- Manejo de restricciones por plataforma.

## 5. Sprint 8 - Robustez y entrega final

### Objetivo

Estabilizar la integración, aumentar calidad y preparar la entrega profesional.

### Historias

- HU-15: pruebas y hardening.

### Entregable demo

- App estable, segura y con evidencia final.

### Criterios de salida

- Suite de pruebas consistente.
- CI pasando.
- Documento de cierre y release final.

## 6. Cadencia de trabajo sugerida

- Sprint planning: inicio de cada sprint.
- Daily: seguimiento corto de bloqueos.
- Review: demo con evidencia.
- Retrospective: ajustes del proceso.

## 7. Control de avance

Cada sprint debe dejar:

- Rama por HU.
- Commit por HU.
- PR por HU o por sprint.
- Evidencia documental.
- Estado actualizado del roadmap.

## 8. Métrica de éxito

- Menos mock y más datos reales.
- Menos bloqueos por entorno.
- Más validación automatizada.
- Mejor trazabilidad para revisión académica.
