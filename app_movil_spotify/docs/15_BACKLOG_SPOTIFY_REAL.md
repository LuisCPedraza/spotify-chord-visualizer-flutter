# 15. Backlog de la Etapa Spotify Real

## 1. Visión del backlog

Este backlog define la siguiente fase de evolución del proyecto despues del MVP cerrado. Se enfoca en convertir el producto en una aplicación que consuma Spotify API de forma real, con seguridad, trazabilidad y evidencia por sprint.

## 2. Epicas

### E5. Autenticacion y sesion productiva

- Conectar usuario con Spotify mediante OAuth2 PKCE.
- Persistir credenciales de forma segura.
- Renovar sesión cuando el token expire.

### E6. Consumo de catalogo Spotify

- Buscar contenido real.
- Mostrar resultados con paginación o carga progresiva.
- Manejar vacíos, errores y rate limits.

### E7. Reproduccion y contexto

- Mostrar metadata real de la pista.
- Controlar reproducción cuando el SDK y plataforma lo permitan.
- Sincronizar la UI con el estado activo.

### E8. Robustez, seguridad y calidad

- Pruebas automatizadas.
- Mejoras de observabilidad y manejo de errores.
- Revisión de cumplimiento y release.

## 3. Historias de usuario propuestas

### HU-10
Como usuario, quiero iniciar sesión con Spotify de forma segura para acceder a mi cuenta.

#### Criterios de aceptación
- La app autentica mediante OAuth2 PKCE.
- El token se almacena de forma segura.
- El usuario puede cerrar sesión.

### HU-11
Como usuario, quiero que la sesión se recupere automáticamente si sigue vigente.

#### Criterios de aceptación
- La app detecta token válido al abrir.
- La app renueva o revalida la sesión según corresponda.
- La UI muestra estado de autenticación.

### HU-12
Como usuario, quiero buscar canciones reales en Spotify para practicar con contenido actualizado.

#### Criterios de aceptación
- La búsqueda consulta la API real.
- Se muestran estados loading, empty y error.
- Los resultados son navegables.

### HU-13
Como usuario, quiero ver la información real de una pista para identificarla rápido.

#### Criterios de aceptación
- La vista muestra título, artista, álbum, duración y portada.
- La información coincide con la pista seleccionada.

### HU-14
Como usuario, quiero controlar la reproducción o sesión de reproducción para seguir mi práctica.

#### Criterios de aceptación
- La UI refleja play/pause o estado equivalente.
- El progreso se sincroniza con el estado real disponible.
- Se manejan límites de plataforma si aplica.

### HU-15
Como equipo, queremos asegurar calidad y estabilidad en la nueva integración.

#### Criterios de aceptación
- Existen pruebas de servicios y UI.
- Se documentan evidencias de ejecución.
- El pipeline CI valida el cambio.

## 4. Priorizacion recomendada

1. HU-10
2. HU-11
3. HU-12
4. HU-13
5. HU-14
6. HU-15

## 5. Orden de construcción sugerido

- Primero autenticacion.
- Luego recuperación de sesión.
- Después consumo de catálogo real.
- Luego metadata y reproducción.
- Finalmente endurecimiento, pruebas y evidencia.

## 6. Dependencias técnicas

- Spotify Developer Dashboard.
- Redirect URI configurado.
- Claves y secretos seguros por entorno.
- Consideración de plataforma objetivo.
- Mecanismo de pruebas desacoplado para no romper CI.

## 7. Riesgos por historia

- HU-10: configuración incorrecta de OAuth.
- HU-11: expiración y refresco de token.
- HU-12: límites de API y cambios de schema.
- HU-13: datos incompletos o nulos.
- HU-14: restricciones del SDK por sistema operativo.
- HU-15: deuda de pruebas o cobertura insuficiente.

## 8. Recomendación de criterio de cierre

Cada HU debe cerrar con:

- Código.
- Pruebas.
- Documentación.
- PR individual.
- Evidencia visual o de consola si aplica.
