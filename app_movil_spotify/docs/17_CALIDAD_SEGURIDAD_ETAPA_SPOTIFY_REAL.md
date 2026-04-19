# 17. Calidad, Seguridad y Riesgos - Etapa Spotify Real

## 1. Objetivo

Definir reglas de calidad, seguridad y mitigación de riesgos para la nueva etapa que consume Spotify API real.

## 2. Calidad mínima exigida

- `flutter analyze` sin errores.
- `flutter test` sin fallos.
- Pruebas unitarias para lógica de sesión, búsqueda y formateo.
- Pruebas widget para estados de UI críticos.
- Integration test del flujo principal cuando el entorno lo permita.

## 3. Seguridad

### 3.1 Secretos

- No guardar client secrets en el repositorio.
- Usar variables de entorno o almacenamiento seguro.
- Separar configuración de desarrollo, prueba y producción.

### 3.2 Tokens

- Almacenar access token y refresh token con cifrado o storage seguro.
- No exponer tokens en logs.
- Invalidar sesión al cerrar sesión o si expira.

### 3.3 Permisos

- Pedir solo los scopes necesarios.
- Documentar los permisos requeridos por cada HU.

## 4. Riesgos principales

### R-10. Restricciones de Spotify por plataforma

- Impacto: alto.
- Mitigación: definir comportamiento degradado por sistema operativo y usar fallback de demo cuando aplique.

### R-11. Fallos de autenticación

- Impacto: alto.
- Mitigación: PKCE, mensajes de error claros, reintentos controlados.

### R-12. Cambios de API o rate limit

- Impacto: medio.
- Mitigación: manejo de error HTTP, caché temporal y reintentos con backoff.

### R-13. Dependencias y plugins en CI

- Impacto: medio.
- Mitigación: validar build matrix y documentar prerequisitos.

### R-14. Degradación del flujo por plataforma

- Impacto: medio.
- Mitigación: diseño de UX con fallback visible y documentación de compatibilidad.

## 5. Controles de calidad por sprint

### Sprint 5

- Revisar autenticación y sesión.
- Asegurar persistencia segura.

### Sprint 6

- Validar búsqueda real y estados vacíos.
- Probar navegación de metadata.

### Sprint 7

- Verificar reproducción y sincronización de UI.
- Revisar límites por plataforma.

### Sprint 8

- Cerrar riesgos abiertos.
- Revisar cobertura y release notes.

## 6. Entregables de evidencia

- Reporte de pruebas.
- Capturas o video demo.
- PRs por sprint.
- Notas de release.
- Documento de cierre de riesgos.

## 7. Recomendación operativa

Antes de cada sprint nuevo:

1. Confirmar alcance.
2. Revalidar prerequisitos de Spotify.
3. Revisar CI.
4. Congelar criterios de aceptación.
5. Registrar riesgos abiertos.
