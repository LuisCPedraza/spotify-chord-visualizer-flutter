# 07. Riesgos y Cumplimiento

## 1. Matriz de Riesgos

## Riesgo R1

- Descripcion: limitaciones del stream protegido de Spotify para analisis directo.
- Probabilidad: alta.
- Impacto: alto.
- Mitigacion: diseno basado en metadata y sincronizacion permitida; no prometer captura del stream.

## Riesgo R2

- Descripcion: cambios de API o scopes en Spotify.
- Probabilidad: media.
- Impacto: alto.
- Mitigacion: encapsular cliente API, revisar changelog y mantener fallback controlado.

## Riesgo R3

- Descripcion: retrasos por complejidad de modulo de acordes.
- Probabilidad: media.
- Impacto: alto.
- Mitigacion: dividir en milestones y priorizar visualizador sincronizado antes de deteccion avanzada.

## Riesgo R4

- Descripcion: errores por configuracion de credenciales/redirect.
- Probabilidad: media.
- Impacto: medio.
- Mitigacion: checklist de setup, validaciones tempranas y runbook.

## Riesgo R5

- Descripcion: deuda tecnica por desarrollo acelerado.
- Probabilidad: media.
- Impacto: medio.
- Mitigacion: Definition of Done estricta y cobertura minima por sprint.

## 2. Cumplimiento Tecnico

- Usar PKCE para autenticacion en cliente movil.
- Almacenar tokens en almacenamiento seguro.
- No exponer credenciales en repositorio.
- Minimizar scopes solicitados.

## 3. Cumplimiento de Privacidad

- No recolectar datos personales innecesarios.
- Mostrar aviso claro de uso de cuenta Spotify.
- Limitar logs para no incluir informacion sensible.

## 4. Cumplimiento de Politicas de Plataforma

- Revisar terminos de uso de Spotify Developer.
- No almacenar o redistribuir contenido protegido en forma no autorizada.
- Respetar limitaciones de reproduccion y uso de metadata.

## 5. Plan de Contingencia

Si falla la integracion de reproduccion en demo:

- Activar modo demo con datos mock de pista.
- Mantener visualizador de acordes operativo con timeline simulado.
- Explicar claramente limite de API y diseno aplicado.

## 6. Monitoreo de Riesgos

- Revisar riesgos al inicio de cada sprint.
- Etiquetar riesgos criticos abiertos.
- Cerrar mitigaciones como subtareas verificables.
