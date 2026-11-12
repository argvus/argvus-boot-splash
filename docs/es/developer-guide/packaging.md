---
title: Empaque
description: Metadatos del paquete Arch, canal de compilación y objetivos de Make.
---

# Empaquetado

Cómo se define y produce el paquete Arch: los dos PKGBUILDs, las funciones compartidas, los hooks de instalación, la tubería de compilación local y los objetivos de Make.

Para el tema en sí, ver [arquitectura del tema](/docs/argvus-boot-splash/developer-guide/theme/); para la validación, CI y lanzamientos, ver [CI y lanzamientos](/docs/argvus-boot-splash/developer-guide/ci-releases/).

## Dos PKGBUILDs, una carga útil

`packaging/arch/remote/PKGBUILD` y `packaging/arch/local/PKGBUILD` son idénticos, excepto por `source=`:

| | `local` | `ci` |
| --- | --- | --- |
| fuente | `${pkgname}-${pkgver}.tar.gz` (construido por `make build`) | `${url}/archive/refs/tags/v${pkgver}.tar.gz` |
| usado por | desarrolladores, `make build` | lanzamiento de GitHub Actions |

Ambos llaman a las mismas funciones de `packaging/arch/common/functions.sh`, y `tools/sh/validate.sh` afirma que sus metadatos (`pkgname`, `pkgver`, `pkgrel`, `pkgdesc`, `arch`, `license`, `depends`, `makedepends`, `options`) son idénticos, por lo que los dos no pueden desviarse silenciosamente.

Metadatos compartidos:

```bash
pkgname=argvus-boot-splash
pkgver=0.2.0
pkgrel=1
arch=('any')                 # pure data package
depends=('plymouth')
optdepends=('mkinitcpio: rebuild initramfs (Arch Linux)'
            'dracut: rebuild initramfs (alternative)')
options=('!debug')
conflicts=('argvus-plymouth') # renamed predecessor
replaces=('argvus-plymouth')
```
## Funciones compartidas

`packaging/arch/common/functions.sh` proporciona tres funciones utilizadas por ambos
PKGBUILDs:

- `arch_normalize_source_tree` (`prepare()`) — Los archivos de la etiqueta de GitHub se extraen a `<repo>-v<version>`, mientras que el tarball local se extrae a `<pkgname>-<pkgver>`. Esto renombra el directorio principal único a `${srcdir}/${pkgname}-${pkgver}`, generando un error si el directorio de origen falta, es ambiguo o el destino ya existe.
- `arch_check_splash_payload` (`check()`) — asegura que cada recurso del tema exista en la fuente extraída. Esta es la única "suite de pruebas" del paquete; la lista de archivos requeridos está en el [inventario de recursos](/docs/argvus-boot-splash/developer-guide/theme/#asset-inventory).
- `arch_package_splash_payload` (`package()`) — recorre `src/usr` con `find -print0` e instala cada archivo con `install -Dm644` en `$pkgdir` (seguro para NUL, funciona con espacios en los nombres), luego instala `LICENSE` en `/usr/share/licenses/argvus-boot-splash/LICENSE`.

Tenga en cuenta que no hay ninguna llamada a `make install` dentro de `package()`: todo está `install -Dm*`, por lo que el paquete es autosuficiente y compatible con compilaciones sin root. Eso es deliberado: un antiguo `package()` que llamaba a `make install` producía fallos `sudo`/`libfakeroot.so`.

## Instalar hooks

`packaging/arch/{ci,local}/argvus-boot-splash.install` (idéntico):

- `post_install()` / `post_upgrade()` → `plymouth-set-default-theme argvus`, luego `mkinitcpio -P` si está disponible, sino `dracut --regenerate-all`, sino una advertencia indicando al usuario que reconstruya manualmente.
- `post_remove()` → solo mensaje informativo; el tema no se cambia automáticamente (más seguro que adivinar).

## Pipeline de compilación local

`tools/sh/pkgbuild_local.sh` (invocado por `make build`):

1. Verifica `makepkg`, `sha256sum`, `tar`, `awk`, `find` y que exista el PKGBUILD; procesa el PKGBUILD para leer `pkgname`/`pkgver` y valida ambos
   contra expresiones regulares de lista blanca (`^[a-z0-9@._+-]+$` para el nombre, un patrón de versión con puntos para la versión).
2. Construye `build/artifacts/${pkgname}-${pkgver}.tar.gz` con
   `tar --sort=name --mtime='UTC 1970-01-01' --owner=0 --group=0 --numeric-owner`
   y `--transform "s#^\./#${pkgname}-${pkgver}/#"` — un archivo determinista,
   reproducible. Excluye `.git`, `build/`, `dist/`, `target/`,
   `tools/`, `release`/`packages-repo` directorios temporales, y cualquier `src/`, `pkg/` o
   restos de paquetes dentro de los directorios de empaquetado.
3. Calcula el `sha256` del archivo e lo inyecta con `sed` en una **copia temporal** del PKGBUILD local (`.PKGBUILD.local.XXXXXX`, eliminado por una trampa `EXIT`). El repositorio siempre mantiene `sha256sums=()` vacío; `SKIP` nunca se usa.
4. Elimina cualquier `${pkgname}-${pkgver}-*.pkg.tar.zst` preexistente de
   `build/dist/` para que un paquete obsoleto no pueda confundirse con esta compilación.
5. Ejecuta ` with ` with `/`/` in ` in build/artifacts/ y `PKGDEST` en `build/dist/`. Los argumentos adicionales se reenvían a `makepkg`; `MAKEPKG_FLAGS` anula el conjunto de banderas predeterminado (separación por palabras intencional).
6. Falla a menos que exactamente un `.pkg.tar.zst` coincida, luego ejecuta `namcap` en él si está instalado.

Salidas:

```text
build/dist/argvus-boot-splash-0.2.0-1-any.pkg.tar.zst   installable package
build/artifacts/argvus-boot-splash-0.2.0.tar.gz          source snapshot
build/artifacts/argvus-boot-splash/{src,pkg}/            makepkg work dirs
```
## Hacer objetivos

| Objetivo | Efecto |
| --- | --- |
| `make build` (alias `make package`) | ejecutar `tools/sh/pkgbuild_local.sh` → `build/` |
| `make install` (alias `make install-package`) | `sudo pacman -U` el único paquete en `build/dist/`; errores si la cantidad no es exactamente 1 |
| `make validate` | `tools/sh/validate.sh`: shellcheck + `bash -n` + sincronización de metadatos de PKGBUILD + `makepkg --printsrcinfo` por PKGBUILD + `git diff --check` |
| `make lint` (alias `make lint-shell`) | shellcheck sobre `tools`, `packaging/arch/common`, `src` (`SC1090`, `SC2034`, `SC2154` deshabilitados), `bash -n`, `git diff --check` |
| `make spellcheck` | `cspell --config cspell.json .` si `cspell` está instalado, de lo contrario se omite |
| `make clean` | `rm -rf build/` |
| `make help` | lista de objetivos (meta predeterminada) |

CI ejecuta `make validate` y `make build`; nada en CI ejecuta `make install`
(ver [gaps](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps) conocidos).

## Prerrequisitos

Un sistema basado en Arch con `make`, `git`, `gnupg` y el grupo `base-devel`:

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
```

- `pacman-contrib` proporciona `updpkgsums` (regenera las sumas de verificación de PKGBUILD).
- `shellcheck` valida los scripts de shell del repositorio y las funciones compartidas de empaquetado de Arch.
- Opcional: `namcap` (linting de paquetes) y cspell (corrector ortográfico local). CI instala todos ellos.
