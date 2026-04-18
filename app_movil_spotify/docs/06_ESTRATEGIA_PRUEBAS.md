# 06. Estrategia de Pruebas

## 1. Objetivo

Garantizar que el MVP sea funcional, estable y demostrable mediante una estrategia de pruebas por capas.

## 2. Alcance de Calidad

- Flujo critico: login -> busqueda -> seleccion -> acordes.
- Servicios criticos: autenticacion, red, sincronizacion temporal.
- UX critica: estados de carga/error, legibilidad de acordes.

## 3. Piramide de Pruebas

- Unit tests: base mayoritaria.
- Widget tests: capa intermedia.
- Integration tests: capa final orientada al flujo.

## 4. Tipos de Pruebas

## Unit tests

Cobertura:

- AuthService
- SpotifyApiClient (con mocks)
- ChordEngine
- Mappers y validaciones

Casos clave:

- Token expirado.
- Parseo de respuesta de busqueda.
- Seleccion de acorde activo por timestamp.

## Widget tests

Cobertura:

- LoginScreen
- SearchScreen
- PlayerScreen
- ChordScreen

Casos clave:

- Render de listas.
- Cambio de estados loading/error/success.
- Interacciones de botones.

## Integration tests

Cobertura:

- Flujo principal de negocio.

Casos clave:

- Login simulado exitoso.
- Busqueda y seleccion de pista.
- Visualizacion de acordes sincronizados.

## Pruebas manuales

- Permisos de dispositivo.
- Comportamiento de deep links.
- Prueba en al menos 1 dispositivo fisico Android.

## 5. Matriz de Casos Minimos

- TC-01: Login exitoso.
- TC-02: Login con fallo de red.
- TC-03: Sesion expirada y recuperacion.
- TC-04: Busqueda con resultados.
- TC-05: Busqueda sin resultados.
- TC-06: Error 429 y reintento.
- TC-07: Render de acordes en timeline.
- TC-08: Cambio de estado play/pause.
- TC-09: Mensajes de error entendibles.
- TC-10: Estabilidad en navegacion entre pantallas.

## 6. Criterios de Aceptacion de Calidad

- Sin errores bloqueantes en flujo principal.
- Cobertura de codigo en modulos criticos >= 70%.
- Tiempo de respuesta de interacciones clave < 300 ms.
- Documentacion de pruebas disponible para evaluacion.

## 7. Herramientas

- flutter_test
- integration_test
- mocktail/mockito
- CI local con comandos Flutter

## 8. Estrategia de Datos de Prueba

- Datos mock para respuestas API.
- Usuario de prueba para validacion manual.
- Tracks de ejemplo con progresiones conocidas para verificar acordes.

## 9. Reporte de Defectos

Cada bug debe registrar:

- ID
- Prioridad
- Entorno
- Pasos para reproducir
- Resultado esperado
- Resultado actual
- Evidencia (captura/video)
- Estado
