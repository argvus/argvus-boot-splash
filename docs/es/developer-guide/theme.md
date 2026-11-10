---
title: Arquitectura del tema
description: Cómo se ensamblan el descriptor, los activos y el guion de Plymouth.
---

# Arquitectura del tema

Cómo se compone el tema Plymouth: el descriptor, el conjunto de recursos, y lo que
`argvus.script` hace, sección por sección.

Para empaquetado y versiones, vea [packaging](/docs/argvus-boot-splash/developer-guide/packaging/)] y
[CI and releases](/docs/argvus-boot-splash/developer-guide/ci-releases/)]. Para uso, vea el
[guía del usuario](/docs/argvus-boot-splash/)].

## Descriptor

Los temas de Plymouth son descriptores declarativos interpretados por el motor de
scripts de Plymouth. Hay dos partes:

`src/usr/share/plymouth/themes/argvus/argvus.plymouth`:

```ini
[Plymouth Theme]
Name=Argvus
Description=Argvus boot splash theme
ModuleName=script

[script]
ImageDir=/usr/share/plymouth/themes/argvus
ScriptFile=/usr/share/plymouth/themes/argvus/argvus.script
```

Notas:

- `ModuleName=script` selecciona el intérprete de scripts incorporado de Plymouth. No hay
  un módulo compilado; `ImageDir` y `ScriptFile` deben ser **rutas absolutas**,
  porque el initramfs tiene un directorio de trabajo diferente al de tu sesión.
- El nombre del archivo es el nombre del tema: `argvus.plymouth` ⇒ tema `argvus`, que es
  lo que `plymouth-set-default-theme argvus` selecciona.
- `argvus.script` es el único archivo de código. Se ejecuta dentro de la VM incrustada de Plymouth
  (vinculada en `plymouthd` y el initramfs). Las restricciones que se derivan de eso: no hay E/S de archivos, no hay hilos, no hay procesos externos, no hay punto flotante,
  `MathInt` es tu única aritmética, y el lenguaje es un pequeño dialecto tipo C
  (los arreglos son objetos indexados, los objetos `Sprite()` deben ser creados antes de usarse).

## Modelo de renderizado

- Un fondo sólido plano (`Window.SetBackgroundTopColor` / `SetBackgroundBottomColor`).  
- **Sprites** son los únicos primitivos de dibujo. Cada `Sprite()` tiene una imagen, una posición `(x, y)`, un **orden z** y una opacidad en `[0, 1]`. Más tarde `SetPosition` llama a win; no hay un grafo de escena.  
- El progreso se dibuja re-`ImageScale`-ando una imagen en cada cuadro y llamando a `SetImage` en el sprite — no hay un primitivo de recorte o dibujo parcial.  
- Plymouth informa el estado mediante callbacks que registra el script: `PlymouthSetBootProgressFunction`, `PlymouthSetDisplayPasswordFunction`, `PlymouthSetDisplayNormalFunction`, `PlymouthSetRefreshFunction`.  
- `Plymouth.SetRefreshRate(20)` hace que el callback de refresco se ejecute a 20 FPS; la única animación temporal del tema (la aparición progresiva) depende de ello.

## Inventario de activos

Todos los activos se encuentran en `src/usr/share/plymouth/themes/argvus/`.

| Archivo | Tamaño | Formato | Rol | Usado por `argvus.script` |
| --- | --- | --- | --- | --- |
| `argvus.plymouth` | — | INI | descriptor de tema | cargado por `plymouthd` |
| `argvus.script` | — | script de Plymouth | lógica de tema | sí |
| `argvus-logo.png` | 256x256 | RGBA 8-bit | logo principal | sí (`logo.base_scale = 0.72`) |
| `argvus-text.png` | 400x53 | RGBA 8-bit | marca de palabra `ARGVUS` | sí (`text.scale = 0.80`) |
| `progress-bar.png` | 400x4 | paleta de 1-bit | barra rellena | sí |
| `progress-bar-track.png` | 400x4 | paleta de 1-bit | pista no rellena | sí |
| `entry-box.png` | 400x48 | RGB 16-bit | campo de entrada de contraseña | sí |
| `bullet.png` | 12x12 | paleta de 4-bit | un carácter enmascarado | sí |
| `entry-line.png` | 300x2 | paleta de 1-bit | regla de entrada/subrayado | no (véase [lagunas conocidas](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)) |
| `logo-glow.png` | 260x300 | paleta de 8-bit | arte de resplandor del logo | no (véase [lagunas conocidas](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)) |
| `argvus-uki-splash.bmp` | 400x400 | BMP de 32 bits | UKI / pantalla de inicio de systemd-boot | no (consumido por el cargador de arranque) |

El ancho de la imagen se usa como unidad de diseño: la marca de palabra es la referencia de ancho
(400 px a escala 1.0) y la pista de progreso, la barra de progreso y el campo de entrada de contraseña
se derivan todos de ella, por lo que la composición se mantiene coherente si el
activo de la marca de palabra se vuelve a exportar.

`arch_check_splash_payload()` en `packaging/arch/common/functions.sh` requiere
que **todos** los archivos anteriores existan; agregar un activo significa agregarlo a esa lista. Véase
[empaquetado](/docs/argvus-boot-splash/developer-guide/packaging/#shared-functions).

## Recorrido del script

`src/usr/share/plymouth/themes/argvus/argvus.script`, de arriba hacia abajo.

### 1. Fondo

```js
Window.SetBackgroundTopColor(0.0667, 0.0745, 0.0863);
Window.SetBackgroundBottomColor(0.0667, 0.0745, 0.0863);
```
Mismo valor arriba y abajo ⇒ un relleno plano, sin degradado. Los componentes son los canales de 8 bits de `#111316` divididos por 255.

### 2. Recursos y escalado

Cada imagen se carga a través de `Image("name")`, que se resuelve relativo a `ImageDir`. El escalado es explícito:

```js
logo.base_scale = 0.72;
logo.base_width = MathInt(logo.original_image.GetWidth() * logo.base_scale);
logo.frame[logo.base_width] = ImageScale(logo.original_image, logo.base_width,
                                         logo.base_height);
logo.image = logo.frame[logo.base_width];
```
La caché `logo.frame[...]` es intencional: `ImageScale` en cada fotograma asignaría una nueva imagen por fotograma; el logotipo se escala una vez y se almacena en caché por ancho objetivo, por lo que un cambio de tamaño solo necesita una nueva entrada.

El logotipo textual sigue la misma idea en `text.scale = 0.80`, pero se escala una vez en línea. La pista de progreso y la barra se escalan entonces a `text.image.GetWidth()` — es decir, la barra siempre coincide con el ancho del logotipo textual, cualquiera que sea el tamaño real en píxeles del logotipo.

### 3. Diseño

Cada elemento está centrado en el eje horizontal de la ventana:

```js
logo.x = Window.GetX() + Window.GetWidth() / 2 - logo.image.GetWidth() / 2;
logo.y = Window.GetY() + Window.GetHeight() / 2 - logo.image.GetHeight() / 2 - 35;
```

Tenga en cuenta el `- 35`: la pila está centrada en toda la composición (logo + marca de palabra + pista), no solo en el logo, por lo que el bloque se sitúa ligeramente por encima del medio vertical de la pantalla. La colocación vertical es entonces relativa al elemento anterior (`text.y = logo.y + logo.image.GetHeight() + 16`, `progress_track.y = text.y + text.image.GetHeight() + 28`, …), lo que significa que la composición se escala como una unidad con la resolución.

Orden Z usado aquí:

| Z | Sprite |
| --- | --- |
| 100 | logo, marca de palabra, pista de progreso |
| 101 | barra de progreso (sobre la pista) |
| 200 | campo de entrada de contraseña |
| 201 | texto de solicitud de contraseña |
| 202 | viñetas de contraseña |

### 4. Progreso de arranque

```js
fun progress_callback(duration, progress)
{
    width = MathInt(progress_bar.original_image.GetWidth() * progress);
    if (width < 1) width = 1;
    if (width > progress_bar.original_image.GetWidth())
        width = progress_bar.original_image.GetWidth();
    progress_bar.image = ImageScale(progress_bar.original_image, width,
                                     progress_bar.original_image.GetHeight());
    progress_bar.sprite.SetImage(progress_bar.image);
}
```
Registrado con `PlymouthSetBootProgressFunction(progress_callback)`. La abrazadera importa: una imagen de ancho cero es inválida en algunas versiones de Plymouth, por lo que la barra nunca desaparece por completo, y el progreso nunca puede superar el ancho de la pista. La posición del sprite está fija; solo cambia el ancho de la imagen — no se utiliza ninguna operación de relleno o recorte.

### 5. Diálogo de contraseña

`display_password_callback(prompt, bullets)`:

1. Atenúa la pantalla de inicio: `logo.opacity = 0.15` y la marca en `0.15`, mientras que la pista y la barra permanecen en `1.0`.
2. Renderiza el aviso con `Image.Text(prompt, 0.72, 0.77, 0.81)`: la única imagen generada en tiempo de ejecución en el tema. Su posición solo se conoce aquí, porque depende de la altura del texto.
3. Coloca el campo de entrada debajo del aviso: password.entry.y = password.prompt.y + password.prompt.image.GetHeight() + 14. Al cargar, `password.entry.y` es `0` con un comentario que la posición real depende del aviso.
4. Dibuja las viñetas con un bucle de crear o reutilizar:

   ```js
   for (index = 0; password.bullet[index] || index < bullets; index++)
   {
       if (!password.bullet[index]) { /* create sprite + image */ }
       /* ...position at entry.x + 16 + index * bullet.width ... */
       if (index < bullets) sprite.SetOpacity(1); else sprite.SetOpacity(0);
   }
   ```
Los sprites se agrupan y reutilizan en distintos prompts en lugar de ser recreados; las balas obsoletas se ocultan con opacidad `0`. Las balas están centradas verticalmente con respecto a la altura del campo de entrada.

`display_normal_callback()` es lo inverso: restaura la opacidad `1.0`, oculta el prompt, la entrada y todas las balas agrupadas. Registrado con `PlymouthSetDisplayNormalFunction`, Plymouth lo llama cuando se acepta o se aborta la contraseña y el arranque continúa.

Consecuencia: `logo.opacity` es una variable, no una constante, porque tanto el desvanecimiento como el estado de la contraseña se multiplican en ella.

### 6. Aparición gradual

```js
Plymouth.SetRefreshRate(20);
fun refresh_callback()
{
    if (!fade.complete) {
        fade.frame += 1;
        fade.opacity = fade.frame / 20;      /* 20 frames @ 20 FPS = 1s */
        if (fade.opacity > 1) fade.opacity = 1;
        text.sprite.SetOpacity(fade.opacity);
        progress_track.sprite.SetOpacity(fade.opacity);
        progress_bar.sprite.SetOpacity(fade.opacity);
        if (fade.frame >= 20) fade.complete = 1;
    }
    logo.sprite.SetOpacity(logo.opacity * fade.opacity);
}
```
El callback de actualización sigue ejecutándose durante todo el arranque (es barato y Plymouth lo llama continuamente); el guardia `fade.complete` lo convierte en una operación nula después de la animación. El logotipo usa `logo.opacity * fade.opacity` en lugar de una asignación simple para que el estado atenuado por la contraseña sobreviva a la transición: después de que la transición se completa, `fade.opacity == 1` y el logotipo muestra `logo.opacity` nuevamente.

Las revisiones anteriores de este tema también tenían animaciones de pulso/spawn; se eliminaron en `0.2.0` ("chore: remove pulse effects"). No se debe reintroducir la animación por fotograma de la barra de progreso: la barra debe seguir siendo una representación fiel del progreso de arranque.

## Constantes de diseño

Fuente única de verdad para ajustar la composición:

| Constante | Valor | Significado |
| --- | --- | --- |
| `logo.base_scale` | `0.72` | escala del logotipo vs. su tamaño nativo 256x256 |
| `logo.y` desplazamiento | `-35` | eleva el bloque centrado por encima de la mitad de la pantalla |
| `text.scale` | `0.80` | escala del texto de marca vs. su tamaño nativo 400x53 |
| `text.y` espacio | `+16` | parte inferior del logotipo → parte superior del texto de marca |
| `progress_track.y` espacio | `+28` | parte inferior del texto de marca → parte superior de la pista |
| `password.prompt.y` espacio | `+24` | parte inferior de la pista → parte superior del texto de solicitud |
| `password.entry.y` espacio | `+14` | parte inferior de la solicitud → parte superior del campo de entrada |
| desplazamiento x de viñeta | `+16` | izquierda del campo de entrada → primera viñeta |
| `logo.opacity` (diálogo) | `0.15` | atenuación del inicio mientras se solicita una frase de contraseña |
| color de solicitud | `0.72, 0.77, 0.81` | `Image.Text` RGB, ~`#B8C4CE` |
| desvanecimiento | 20 fotogramas @ 20 FPS | ~1 s de aparición gradual |

## Tokens de diseño

| Token | Hex | Dónde se encuentra |
| --- | --- | --- |
| Fondo | `#111316` | script (`0.0667, 0.0745, 0.0863`) |
| Acento | `#3590BD` | logotipo / marca de palabra / píxeles de relleno de progreso |
| Barra de progreso | `#262933` | `progress-bar-track.png` |
| Texto indicativo | `#B8C4CE` | script (llamada `Image.Text`) |

Los colores del acento y de la barra están incrustados en los archivos PNG, no se expresan en el script, por lo que cambiar el color significa volver a exportar los archivos (o editar la paleta). El tema es solo oscuro y no tiene variante clara.

## Formato de mapa de bits UKI

`argvus-uki-splash.bmp` es un BMP de Windows de 400x400, 32 bits sin comprimir (`PC bitmap, Windows 98/2000 and newer format, 400 x 400 x 32`). Es un recurso independiente: el script de Plymouth nunca lo carga, y el paquete de Arch no lo registra en ningún lugar; incrustarlo en un UKI es un paso que realiza el usuario (ver la [guía del usuario ](/docs/argvus-boot-splash/uki-splash/)).

Si lo reemplazas, mantenlo como un BMP de 32 bits sin comprimir de tamaño comparable; systemd-boot y `ukify` no escalan formatos arbitrarios y las imágenes grandes consumen mucha memoria en el arranque temprano.

## Modificando el tema

Bucle práctico:

1. Edita `src/usr/share/plymouth/themes/argvus/argvus.script` (y/o los PNG).
2. Instálalo en tu Plymouth en vivo, o prévisualo desde el árbol de origen:

   ```sh
   sudo cp -r src/usr/share/plymouth/themes/argvus/* \
              /usr/share/plymouth/themes/argvus/
   sudo plymouth-set-default-theme argvus
   sudo plymouth --show-splash    # check, then: sudo plymouthquit
   ```
3. `make validate && make build` antes de confirmar.

Reglas que mantienen el funcionamiento del tema:

- Nunca introduzcas APIs que no sean de Plymouth. El motor es un dialecto restringido; verifica la versión objetivo de `plymouth` que soportas antes de usar una API que no hayas usado antes.
- `ImageDir`/`ScriptFile` en `argvus.plymouth` debe permanecer absoluta y debe coincidir con la ruta instalada `/usr/share/plymouth/themes/argvus`.
- Mantén todos los recursos listados en `arch_check_splash_payload()` sincronizados con los archivos que se distribuyen en `src/` — el empaquetado `check()` se ejecuta en CI.
- La anchura de la barra de progreso debe seguir siendo una función fiel del progreso reportado; no se debe eliminar el límite a `[1, track width]`.
- Prueba el diálogo de la contraseña, no solo la pantalla de arranque: es el estado más probable de fallar y el que más notan los usuarios.
- La función de refresco se ejecuta durante todo el arranque; mantén la asignación de trabajo por cuadro libre cuando sea posible.
