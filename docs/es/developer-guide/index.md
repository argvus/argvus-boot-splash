---
title: Guía del desarrollador
description: Orientación de arquitectura y desarrollo para los contribuyentes de ARGVUS.
---

# Pantalla de Inicio de Argvus — Guía del Desarrollador

Documentación técnica para el repositorio `argvus-boot-splash`: cómo se construye el tema de Plymouth, cómo se crea el paquete de Arch y cómo se firman y publican las versiones.

No hay un paso de compilación aquí: el tema son datos (un descriptor `.plymouth`, un `.script` y imágenes) más una receta de paquete de Arch. "Construir" significa producir un paquete reproducible:

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
make validate
make build      # -> build/dist/argvus-boot-splash-<version>-1-any.pkg.tar.zst
make install    # sudo pacman -U that file
```
Antes de comprometer un cambio: `make validate && make build`, y agregue nuevos términos técnicos a `.cspell/custom-dictionary-workspace.txt` o el trabajo de revisión ortográfica fallará.

Si solo desea *usar* el tema, lea la [guía del usuario](/docs/argvus-boot-splash/). Para la contraparte orientada al proceso de este archivo (git flow, secretos, proceso de lanzamiento) vea [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md) y [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md).

## Guías

| Guía | Contenidos |
| --- | --- |
| [Arquitectura del tema](/docs/argvus-boot-splash/developer-guide/theme/) | Descriptor, modelo de renderizado, inventario de recursos, recorrido del script, constantes de diseño, tokens de diseño, mapa de bits UKI, cómo modificar el tema |
| [Empaquetado](/docs/argvus-boot-splash/developer-guide/packaging/) | Los dos PKGBUILDs, `functions.sh` compartido, ganchos de instalación, canal de construcción local, objetivos de Make, prerrequisitos |
| [CI y versiones](/docs/argvus-boot-splash/developer-guide/ci-releases/) | `validate.sh`, `ci.yml`, `release.yml` paso a paso, sumas de verificación, firma, secretos, publicación y versionado |
| [Convenciones y brechas conocidas](/docs/argvus-boot-splash/developer-guide/workflow/) | Reglas internas, mapa de documentación y inconsistencias encontradas durante la auditoría del repositorio |

## Referencia rápida

| Ruta | Qué es |
| --- | --- |
| `src/usr/share/plymouth/themes/argvus/` | carga temática instalada bajo `/usr` |
| `packaging/arch/{ci,local}/PKGBUILD` | recetas de lanzamiento y paquete local |
| `packaging/arch/common/functions.sh` | compartido `prepare`/`check`/`package` |
| `tools/sh/pkgbuild_local.sh` | tarball determinístico + controlador `makepkg` |
| `tools/sh/validate.sh` | puerta de validación requerida |
| `.github/workflows/` | `ci.yml` (validar, construir, corrector ortográfico), `release.yml` (etiquetas `v*`) |

## En otros lugares

- Raíz del repositorio: [README.md](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)
- Documentación para usuarios: [guía del usuario](/docs/argvus-boot-splash/)
- Proceso de desarrollo: [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md)
- Contribuyendo: [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)
- Política de seguridad: [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md)
- Licencia: [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE)
- Versión en portugués: [Guia do desenvolvedor](/pt/docs/argvus-boot-splash/developer-guide/)
