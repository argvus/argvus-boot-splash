---
title: Instalación
description: Requisitos, opciones de instalación y lo que hacen los ganchos del paquete.
---

# Instalación

Todo lo que necesitas para obtener la pantalla de arranque Argvus en un sistema basado en Arch.

Para ver cómo se ve el tema y lo que contiene, consulta el
[referencia](/docs/argvus-boot-splash/reference/). Para reconstruirlo desde el código fuente, consulta la
[guía de desarrollador](/docs/argvus-boot-splash/developer-guide/).

## Requisitos

- Un sistema basado en Arch que use `plymouth` (el paquete depende de él).
- Un generador de initramfs: **mkinitcpio** (por defecto en Arch) o **dracut**. El
  instalador detecta el que esté presente y reconstruye el initramfs por ti.
- Plymouth debe estar habilitado en la configuración de tu initramfs. Con mkinitcpio,
  asegúrate de que `plymouth` esté en la lista `HOOKS` de `/etc/mkinitcpio.conf`:

  ```ini
  HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont plymouth)
  ```
Reinicie si acaba de cambiar esto.

- No se necesita nada para una sesión gráfica normal; el tema solo se ejecuta en la ruta de arranque.

## Opción 1: repositorio de paquetes oficial (recomendado)

Los paquetes firmados se publican en el repositorio de paquetes de Argvus
(`argvus/packages`, ruta `public/arch/$arch`). Agréguelo a `/etc/pacman.conf`:

```ini
[argvus]
SigLevel = Required DatabaseOptional
Server = <PACKAGES_REPO_BASE_URL>/argvus/packages/raw/branch/main/public/arch/$arch
```
Reemplace `<PACKAGES_REPO_BASE_URL>` con el host donde el proyecto publica el repositorio (GitHub, GitLab o Gitea). Importe primero la clave de firma del repositorio, de lo contrario `pacman` rechazará la descarga:

```sh
# 1. import the project's public signing key into your pacman keyring
pacman-key --add /path/to/argvus-signing-key.asc
pacman-key --lsign <key-id>

# 2. refresh and install
sudo pacman -Sy
sudo pacman -S argvus-boot-splash
```
## Opción 2: archivo de paquete de lanzamiento

Cada lanzamiento etiquetado publica un `.pkg.tar.zst` (más su `.sig`) como un recurso de lanzamiento. Instálalo directamente:

```sh
sudo pacman -U ./argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```
Si te importa la higiene de la cadena de suministro, verifica la firma adjunta con la clave pública del proyecto antes de instalar:

```sh
gpg --verify argvus-boot-splash-0.2.0-1-any.pkg.tar.zst.sig \
        argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```
## Opción 3: instalación manual

Útil en sistemas que no son Arch, o si solo quieres probar el tema sin
empaquetarlo. Copia el directorio del tema en la ruta de temas de Plymouth:

```sh
sudo cp -r src/usr/share/plymouth/themes/argvus \
           /usr/share/plymouth/themes/argvus

sudo plymouth-set-default-theme argvus
sudo update-initramfs -u        # Debian/Ubuntu
# or: sudo mkinitcpio -P        # Arch
# or: sudo dracut --regenerate-all
```
Plymouth también se puede habilitar en `/etc/default/grub` con `GRUB_CMDLINE_LINUX` que contiene `splash`, y `quiet` ofrece la sensación clásica de arranque mínimo.

## Qué hace el instalador

Después de la instalación o actualización, los ganchos del paquete se ejecutan automáticamente:

1. `plymouth-set-default-theme argvus` — escribe `argvus` en `/etc/plymouth/plymouthd.conf`.
2. `mkinitcpio -P` si mkinitcpio existe, de lo contrario `dracut --regenerate-all`.

Si no se encuentra ningún generador, el instalador imprime una advertencia y debe reconstruir el initramfs usted mismo. Un cambio de tema solo se hace visible al arrancar después de regenerar el initramfs; reiniciar sin ese paso es la razón más común de que "la pantalla de inicio no cambió".

Al eliminar el paquete solo imprime un recordatorio: elegir un tema diferente y reconstruir el initramfs queda a su criterio. Vea [uninstallation](/docs/argvus-boot-splash/uninstallation/).

## Próximos pasos

- [Usage](/docs/argvus-boot-splash/usage/) — verificar la instalación, previsualizar sin reiniciar, cambiar de temas.
- [UKI y pantalla de inicio de systemd-boot](/docs/argvus-boot-splash/uki-splash/) — usar el mapa de bits en un UKI.
- [Solución de problemas](/docs/argvus-boot-splash/troubleshooting/) — si la pantalla de inicio no cambió.
