# 13. Evidencia Sprint 4 (Calidad y Entrega)

## 1. Objetivo

Consolidar evidencia de calidad del MVP al cierre de Sprint 4 (HU-08 y HU-09), incluyendo estado de pruebas, guion de demo y cierre de riesgos abiertos.

## 2. Resultado de HU-08 (Pruebas)

### 2.1 Cobertura funcional de pruebas

- Unit tests: validaciones de progresiones de acordes y controlador principal.
- Widget tests: flujo visual principal de la app y estado de UI.
- Integration test: flujo principal definido en `integration_test/app_flow_test.dart`.

### 2.2 Ejecucion local

- `flutter analyze`: OK
- `flutter test`: OK

### 2.3 Nota de entorno (integration test)

El integration test en Windows requiere Developer Mode para soporte de symlinks cuando hay plugins.

- Bloqueo observado: `Building with plugins requires symlink support`.
- Accion recomendada para laboratorio/PC final:
  1. Activar Developer Mode en Windows (`ms-settings:developers`).
  2. Reintentar `flutter test integration_test/app_flow_test.dart` sobre dispositivo desktop.

Esta condicion es de entorno de sistema operativo, no de lógica de aplicación.

## 3. Resultado de HU-09 (Evidencia de entrega)

### 3.1 Script de demo (5-7 min)

1. Abrir app y mostrar pantalla principal.
2. Buscar canción en catálogo de demo.
3. Seleccionar pista y revisar metadata (portada, duración y enlace).
4. Activar play/pause y observar progreso de reproducción.
5. Mostrar acordes sincronizados y cambiar dificultad (Básico/Intermedio/Completo).
6. Activar vista legible: alto contraste, escala tipográfica y modo enfoque.
7. Cerrar con estado de pruebas y PRs mergeados por sprint.

### 3.2 Checklist de evidencia para presentación

- PR de Sprint 1: mergeado.
- PR de Sprint 2: mergeado.
- PR de Sprint 3: mergeado.
- PR de Sprint 4: listo para revisión/merge.
- Branches HU mantenidas como evidencia histórica.

## 4. Cierre de riesgos (actualización)

### Riesgo R-01: dependencia de credenciales Spotify

- Estado: mitigado parcialmente.
- Mitigación aplicada: catálogo y progresiones fake para continuidad de desarrollo.

### Riesgo R-02: inestabilidad en pruebas de UI

- Estado: mitigado.
- Mitigación aplicada: pruebas deterministas orientadas a controlador y claves estables en widgets.

### Riesgo R-03: bloqueo de integration test por entorno

- Estado: abierto con workaround definido.
- Mitigación aplicada: prerequisito explícito de Developer Mode en Windows para ejecución final.

## 5. Estado de entrega Sprint 4

- HU-08: completada (suite de pruebas ampliada).
- HU-09: completada (evidencia de calidad, demo script y cierre de riesgos).
- Resultado esperado: MVP estable y documentado para evaluación académica.
