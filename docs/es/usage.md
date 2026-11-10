---
title: Uso
description: Verifica la instalación, previsualiza sin reiniciar y cambia de temas.
---

# Uso

Cómo verificar el tema, previsualizarlo sin reiniciar y cambiar a otro.
Para la instalación, consulte [installation](/docs/argvus-boot-splash/installation/)].

## Verificación de la instalación

```sh
# theme is present?
ls /usr/share/plymouth/themes/argvus

# which theme is the default?
plymouth-set-default-theme          # prints, e.g.: argvus

# does Plymouth parse the theme without errors?
sudo plymouth --show-splash
```
## Vista previa sin reiniciar

```sh
sudo plymouth --show-splash   # shows the splash, simulating boot
sudo plymouthquit             # returns to your session
```
La vista previa puede solicitar autenticación de polkit cuando se ejecuta como un usuario habitual. La barra de progreso avanza con el progreso simulado; también puedes forzar estados:

```sh
sudo plymouth --show-details   # verbose boot messages instead of the splash
sudo plymouth --show-splash    # back to the splash
```
Mientras la pantalla de presentación esté activa, presiona <kbd>Esc</kbd> para pasar a la siguiente pantalla
(pantalla de presentación → detalles → pantalla de presentación).

## Lo que muestra la pantalla de presentación

| Etapa | Apariencia |
| --- | --- |
| Inicio | Todo aparece gradualmente en ~1 segundo: logotipo, palabra marca, barra de progreso |
| Arranque | La barra se llena de izquierda a derecha mientras Plymouth reporta el progreso |
| Volumen encriptado | La pantalla de presentación se atenúa al 15%, el texto del aviso y los puntos enmascarados aparecen debajo de la barra |
| Contraseña aceptada | El diálogo desaparece, la pantalla de presentación vuelve a opacidad completa |

## Cambiar o revertir el tema

```sh
# switch theme (any theme name under /usr/share/plymouth/themes)
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme

# then regenerate the initramfs
sudo mkinitcpio -P              # or: sudo dracut --regenerate-all
```
Archivos de configuración útiles:

| Archivo | Propósito |
| --- | --- |
| `/etc/plymouth/plymouthd.conf` | `PLYMOUTH_THEME_NAME=argvus` escrito por el paquete |
| `/etc/mkinitcpio.conf` | `HOOKS=(... plymouth ...)` debe incluir `plymouth` |
| `/etc/plymouth/plymouthd.conf` (otra vez) | `PLYMOUTH_TOGGLE_KEY` etc. son globales, no por tema |

## Hoja de trucos de comandos

| Comando | Efecto |
| --- | --- |
| `sudo plymouth-set-default-theme argvus` | hacer de `argvus` el tema predeterminado |
| `sudo plymouth-update-theme` | aplicar el cambio al Plymouth en ejecución |
| `sudo plymouth --show-splash` | mostrar la pantalla de inicio en la sesión actual |
| `sudo plymouth --show-details` | mostrar mensajes de arranque detallados en su lugar |
| `sudo plymouthquit` | salir de Plymouth y restaurar tu sesión |
| `sudo mkinitcpio -P` | reconstruir el initramfs de Arch |
| `sudo dracut --regenerate-all` | reconstruir el initramfs con dracut |

## Próximos pasos

- [UKI y animación de inicio de systemd-boot](/docs/argvus-boot-splash/uki-splash/)
- [Desinstalación](/docs/argvus-boot-splash/uninstallation/)
- [Resolución de problemas](/docs/argvus-boot-splash/troubleshooting/)
