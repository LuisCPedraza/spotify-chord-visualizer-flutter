# 02. Scrum Plan

## 1. Marco de Trabajo

Se utiliza Scrum con sprints cortos, backlog priorizado por valor y enfoque incremental para llegar a un MVP demostrable.

- Duracion de sprint sugerida: 1 semana.
- Cadencia: planning, daily, review y retrospectiva.
- Artefactos: product backlog, sprint backlog, increment y definition of done.

## 2. Roles

- Product Owner: define valor, alcance y prioridades.
- Scrum Master: facilita ceremonias y remueve bloqueos.
- Dev Team: implementa, prueba y documenta.

## 3. Epicas

- E1: Integracion Spotify (auth, sesion, busqueda).
- E2: Reproductor y metadata musical.
- E3: Visualizacion de acordes.
- E4: Calidad, hardening y entrega.

## 4. Product Backlog (Epicas -> HU -> Subtareas)

## E1. Integracion Spotify

### HU-01
Como usuario, quiero iniciar sesion con Spotify para conectar mi cuenta.

Subtareas:

- Crear flujo de autenticacion PKCE.
- Manejar callback/deep link de retorno.
- Persistir token de forma segura.
- Implementar logout y limpieza de sesion.

### HU-02
Como usuario, quiero saber si mi sesion esta activa para no autenticarme en cada uso.

Subtareas:

- Validar expiracion de token.
- Recuperar sesion al abrir la app.
- Mostrar estado de sesion en Home.

### HU-03
Como usuario, quiero buscar canciones para elegir que practicar.

Subtareas:

- Integrar endpoint de busqueda.
- Renderizar lista de resultados.
- Manejar estados vacio/error/loading.

## E2. Reproductor y Metadata

### HU-04
Como usuario, quiero ver la informacion de la pista seleccionada.

Subtareas:

- Mostrar titulo, artista, album, duracion.
- Mostrar portada y enlace de reproduccion.

### HU-05
Como usuario, quiero controlar reproduccion basica.

Subtareas:

- Play/pause.
- Obtener posicion de reproduccion.
- Sincronizar UI con estado del player.

## E3. Visualizacion de Acordes

### HU-06
Como usuario, quiero ver acordes sincronizados para tocar junto a la cancion.

Subtareas:

- Definir modelo de progresion de acordes.
- Construir timeline armonico.
- Pintar acorde activo y proximos acordes.
- Agregar selector de dificultad de visualizacion.

### HU-07
Como usuario, quiero una vista legible para practicar sin distraerme.

Subtareas:

- Diseñar UI con alto contraste.
- Añadir escala tipografica para lectura a distancia.
- Incorporar modo de enfoque en acordes.

## E4. Calidad y Entrega

### HU-08
Como equipo, queremos pruebas para asegurar estabilidad del MVP.

Subtareas:

- Unit tests de servicios.
- Widget tests de pantallas criticas.
- Integration tests del flujo principal.

### HU-09
Como equipo, queremos evidencia de calidad para presentacion final.

Subtareas:

- Preparar reporte de cobertura.
- Preparar demo script.
- Cerrar riesgos abiertos.

## 5. Plan de Sprints

## Sprint 0 (Preparacion)

Objetivo: base documental y tecnica lista.

Entregables:

- Documentacion del proyecto.
- Lista de credenciales y configuraciones.
- Estructura inicial del codigo.

## Sprint 1 (Spotify Core)

Objetivo: autenticacion y busqueda funcional.

Historias: HU-01, HU-02, HU-03.

Entregable demo:

- Usuario inicia sesion y busca canciones.

## Sprint 2 (Player)

Objetivo: mostrar y controlar reproduccion.

Historias: HU-04, HU-05.

Entregable demo:

- Usuario ve cancion y controla play/pause.

## Sprint 3 (Chord Viewer)

Objetivo: visualizacion sincronizada de acordes.

Historias: HU-06, HU-07.

Entregable demo:

- Pantalla de acordes funcionando sobre una cancion seleccionada.

## Sprint 4 (Hardening)

Objetivo: estabilizar y preparar entrega final.

Historias: HU-08, HU-09.

Entregable demo:

- MVP estable, probado y documentado.

## 6. Estimacion (Story Points sugeridos)

- HU-01: 8
- HU-02: 3
- HU-03: 5
- HU-04: 3
- HU-05: 5
- HU-06: 13
- HU-07: 5
- HU-08: 8
- HU-09: 3

Total estimado: 53 puntos.

## 7. Definition of Done

Una historia se considera terminada cuando:

- El codigo compila y pasa analisis estatico.
- Hay pruebas minimas segun criticidad.
- Se cubren estados de error.
- La funcionalidad esta documentada.
- Se puede demostrar en review.

## 8. Riesgos de Sprint

- Bloqueo por credenciales Spotify.
- Cambios de alcance por tiempo.
- Dependencias externas no estables.

Mitigacion:

- Definir datos mock para pruebas.
- Priorizar MVP por valor.
- Mantener backlog refinado cada semana.
