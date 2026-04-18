# 11. Guia de Styles Minimalista tipo Apple (Flutter)

## 1. Objetivo visual

Definir una configuracion de estilo minimalista, limpia y premium para AppMovilSpotify, inspirada en principios de diseno de Apple: claridad, jerarquia visual, espacio en blanco y tipografia elegante.

## 2. Principios de estilo

- Menos elementos, mas intencion.
- Superficies limpias con baja saturacion de color.
- Tipografia con jerarquias claras y peso moderado.
- Animaciones suaves, cortas y funcionales.
- Componentes con bordes redondeados discretos.

## 3. Paleta de color recomendada

Base clara:

- Fondo principal: #F5F5F7
- Superficie: #FFFFFF
- Texto principal: #111111
- Texto secundario: #6E6E73
- Borde suave: #D2D2D7
- Accent primario: #0071E3
- Accent exito: #34C759
- Accent alerta: #FF9F0A
- Accent error: #FF3B30

Base oscura opcional:

- Fondo principal: #000000
- Superficie: #1C1C1E
- Texto principal: #F5F5F7
- Texto secundario: #AEAEB2
- Borde suave: #3A3A3C
- Accent primario: #0A84FF

## 4. Tipografia

Familia sugerida:

- SF Pro (si esta disponible en plataforma).
- Alternativa multiplataforma: Inter o Roboto con pesos bien controlados.

Escala tipografica sugerida:

- Display: 34, peso semibold.
- Titulo principal: 28, peso semibold.
- Titulo de seccion: 22, peso semibold.
- Body principal: 17, peso regular.
- Body secundario: 15, peso regular.
- Caption: 13, peso regular.

## 5. Espaciado y layout

Sistema de espaciado base:

- 4, 8, 12, 16, 20, 24, 32.

Reglas:

- Padding horizontal general: 20.
- Separacion entre bloques: 16 o 24.
- Separacion entre titulo y subtitulo: 8.
- Altura minima tactil de controles: 44.

## 6. Bordes y elevacion

- Radio pequeno: 10.
- Radio medio: 14.
- Radio grande: 20.
- Elevacion: minima o nula.
- Sombras: suaves y con baja opacidad.

## 7. Componentes visuales clave

Boton primario:

- Fondo accent primario.
- Texto blanco semibold.
- Altura 48.
- Radio 12.

Boton secundario:

- Fondo superficie.
- Borde suave.
- Texto principal.

Card de cancion:

- Fondo superficie.
- Radio 16.
- Borde suave.
- Espaciado interno 16.

Timeline de acordes:

- Fondo neutro suave.
- Acorde activo con accent primario.
- Acordes siguientes en texto secundario.

## 8. Movimiento y transiciones

Duraciones sugeridas:

- Rapida: 120 ms.
- Normal: 200 ms.
- Lenta: 280 ms.

Curvas sugeridas:

- Entrada: easeOut.
- Salida: easeIn.
- Cambio de estado: easeInOut.

Animaciones recomendadas:

- Fade + slide corto al entrar en pantalla.
- Cambio suave de acorde activo.
- Feedback tactil visual en botones.

## 9. Configuracion de ThemeData (referencia)

Definir en la app:

- ColorScheme con fondo claro y accent azul.
- Scaffold background en #F5F5F7.
- Cards y dialogos blancos.
- AppBar sin sombra y fondo transparente o muy claro.
- Tipografia con jerarquia definida.
- InputDecoration con bordes redondeados y borde tenue.

## 10. Tokens de diseno propuestos

- color.background.primary = #F5F5F7
- color.surface.primary = #FFFFFF
- color.text.primary = #111111
- color.text.secondary = #6E6E73
- color.accent.primary = #0071E3
- radius.sm = 10
- radius.md = 14
- radius.lg = 20
- spacing.1 = 4
- spacing.2 = 8
- spacing.3 = 12
- spacing.4 = 16
- spacing.5 = 20
- spacing.6 = 24
- spacing.7 = 32

## 11. Checklist de consistencia visual

- Colores usados solo desde tokens.
- Tipografias con escala consistente.
- Botones y cards con radios uniformes.
- Espaciado sin saltos arbitrarios.
- Estados de error/exito claros y discretos.
- Contraste apto para lectura prolongada.

## 12. Aplicacion practica en AppMovilSpotify

Pantalla Login:

- Hero visual limpio.
- Boton principal unico de accion.
- Mensaje secundario discreto.

Pantalla Busqueda:

- Barra de busqueda prominente y limpia.
- Resultados en cards de baja saturacion.

Pantalla Acordes:

- Acorde actual con alto contraste.
- Progresion siguiente de forma sutil.
- Controles esenciales, sin ruido visual.

## 13. Recomendacion de implementacion

- Crear archivo de tokens y tema global.
- Aplicar estilos desde componentes compartidos.
- Evitar estilos inline para mantener consistencia.

## 14. Boceto asociado

Para visualizar este estilo aplicado a pantallas concretas del MVP, revisar:

- [12_BOCETO_VISUAL_APP.md](12_BOCETO_VISUAL_APP.md)
