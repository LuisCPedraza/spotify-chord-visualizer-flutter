# 01. Producto y Alcance

## 1. Resumen Ejecutivo

AppMovilSpotify es una app movil en Flutter enfocada en una experiencia musical educativa e interactiva: el usuario autentica su cuenta de Spotify, busca y reproduce contenido, y visualiza acordes sincronizados para practicar instrumento.

El objetivo academico es demostrar dominio de integracion API, arquitectura movil, diseno de producto y ejecucion agile.

## 2. Problema a Resolver

Usuarios que practican guitarra o piano necesitan:

- Una forma rapida de encontrar canciones.
- Apoyo visual de acordes durante la reproduccion.
- Interfaz simple para practicar sin cambiar entre multiples apps.

Las soluciones actuales suelen fragmentar la experiencia (reproductor en una app, acordes en otra, y notas en documentos externos).

## 3. Propuesta de Valor

- Experiencia unificada: reproduccion + acordes + control de sesion.
- Curva de aprendizaje simple para estudiantes.
- Base tecnica escalable para funciones avanzadas futuras.

## 4. Objetivo General

Construir una app Flutter funcional para Android/iOS que integre Spotify y ofrezca visualizacion de acordes sincronizados como feature diferencial.

## 5. Objetivos Especificos

- Implementar autenticacion segura con Spotify.
- Permitir busqueda de canciones y consulta de metadata.
- Mostrar estado de reproduccion y controles base.
- Renderizar acordes sincronizados por timeline.
- Entregar una base probada con documentacion y plan de crecimiento.

## 6. Personas

### Persona 1: Estudiante de guitarra

- Edad: 16 a 24.
- Necesidad: practicar canciones actuales con acordes visibles.
- Dolor: pierde tiempo cambiando entre apps o tabs.

### Persona 2: Profesor de musica

- Edad: 25 a 45.
- Necesidad: mostrar progresiones en clase de forma clara.
- Dolor: falta de herramienta simple para demostraciones rapidas.

### Persona 3: Usuario casual

- Edad: 18 a 35.
- Necesidad: explorar canciones y entender su estructura armonica.
- Dolor: no encuentra apps didacticas con buena UX movil.

## 7. Alcance Funcional

### En alcance (MVP)

- Login/Logout con Spotify.
- Home con estado de cuenta y acceso a busqueda.
- Busqueda por nombre de cancion/artista.
- Pantalla de detalle de cancion.
- Visualizador de acordes sincronizados por segmentos.

### Fuera de alcance inicial

- Deteccion perfecta de acordes en tiempo real para cualquier pista.
- Social features (salas colaborativas, votaciones en vivo).
- Exportacion avanzada multi-formato.
- Modo offline completo de reproduccion.

## 8. Requisitos Funcionales

- RF-01: El usuario debe poder autenticarse con Spotify.
- RF-02: El sistema debe conservar estado de sesion de manera segura.
- RF-03: El sistema debe permitir busqueda de contenido musical.
- RF-04: El sistema debe mostrar datos basicos de la pista actual.
- RF-05: El sistema debe mostrar acordes sincronizados.
- RF-06: El sistema debe manejar errores de red y permisos con mensajes claros.

## 9. Requisitos No Funcionales

- RNF-01: Tiempo de respuesta en UI menor a 300 ms para interacciones comunes.
- RNF-02: La pantalla de acordes debe actualizarse de forma fluida (objetivo 60 FPS).
- RNF-03: El almacenamiento local de tokens debe ser seguro.
- RNF-04: La app debe soportar orientacion vertical en MVP.
- RNF-05: La app debe ser accesible con tipografia legible y contraste adecuado.

## 10. KPI y Criterios de Exito

- KPI-01: Login exitoso en primer intento en al menos 90% de pruebas.
- KPI-02: Flujo buscar -> abrir cancion -> ver acordes completado en menos de 60 segundos.
- KPI-03: 0 crashes bloqueantes en demo de evaluacion.
- KPI-04: Cobertura de pruebas de modulos criticos mayor o igual a 70%.

## 11. Supuestos y Restricciones

- Se cuenta con cuenta Spotify Developer y credenciales validas.
- Spotify no expone audio crudo del stream protegido para analisis libre.
- El equipo de desarrollo es pequeno, por lo que se prioriza MVP robusto.

## 12. Definicion de Exito Academico

El proyecto se considera exitoso si:

- Demuestra integracion real con Spotify.
- Presenta una arquitectura clara y defendible.
- Entrega una experiencia funcional de acordes sincronizados.
- Incluye evidencia de pruebas, planificacion y control de riesgos.
