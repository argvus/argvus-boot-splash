---
title: Convenciones y brechas conocidas
description: Reglas de la casa, mapa de documentación y hallazgos de la auditoría del repositorio.
---

# Convenciones y brechas conocidas

Reglas internas para cambios en este repositorio, además de las inconsistencias encontradas durante
su auditoría — vale más corregirlas que copiarlas.

Para referencia técnica, ver [arquitectura del tema](/docs/argvus-boot-splash/developer-guide/theme/)],
[empaquetado](/docs/argvus-boot-splash/developer-guide/packaging/) y [CI y lanzamientos](/docs/argvus-boot-splash/developer-guide/ci-releases/).

## Convenciones

- Shell: `set -euo pipefail`, tabulaciones para la indentación, `printf`/`error` mensajes a stderr, `command -v` verificaciones de capacidad, shellcheck limpio (ver `.editorconfig`).  
- Nunca escriba `sha256sums=('SKIP')`; mantenga `sha256sums=()` vacío en git.  
- No comprometa salidas de compilación (`build/`), archivos de paquete o copias generadas de `.PKGBUILD.local.*`.  
- Commits Convencionales con los alcances usados en el historial: `splash`, `layout`, `pkgbuild`, `release`, `chore`, `ci`, `build`, `docs`.  
- Nombres de ramas: `feat/…`, `fix/…`, `docs/…`, `chore/…`, `refactor/…`.  
- Aprobación de un revisor antes de fusionar, merge con squash.  
- Licencia: GPL-3.0-only. Distribuido como `/usr/share/licenses/argvus-boot-splash/LICENSE`.  
- Siga el proceso en [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)] y [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md)].  

## Brechas conocidas

Inconsistencias documentadas encontradas al auditar el repositorio:

- `README.md` anuncia `make test` para una vista previa directa de Plymouth, pero no existe tal objetivo en el [Makefile](https://github.com/argvus/argvus-boot-splash/blob/main/Makefile). Los comandos reales son `sudo plymouth --show-splash` / `sudo plymouthquit`.
- `entry-line.png` y `logo-glow.png` se incluyen en la carga útil y son necesarios para `arch_check_splash_payload()`, pero `argvus.script` nunca los carga. Conéctelos al script o elimínelos de la carga útil y de la lista de verificación.
- `src/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp` está instalado pero nunca se registra con nada; la [guía del usuario](/docs/argvus-boot-splash/uki-splash/) documenta el paso manual `bootctl`/`ukify`.
- La documentación canónica se encuentra en la raíz del repositorio (`README.md`, `DEVELOPMENT.md`) y se superpone con las guías en `docs/`. Manténgalas consistentes
  al cambiar cualquiera de las políticas de contribución (`CONTRIBUTING.md`, `SECURITY.md`)
  residen en el repositorio de la organización `.github`.

## Mapa de documentación

| Documento | Audiencia | Alcance |
| --- | --- | --- |
| `README.md` | todos | descripción y diseño de un párrafo |
| `DEVELOPMENT.md` | mantenedores | proceso de construcción, firma y lanzamiento |
| [`CONTRIBUTING.md`](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md) (org `.github`) | contribuyentes | flujo de git, reglas de PR, política de secretos |
| [`docs/user-guide.md`](/docs/argvus-boot-splash/) | usuarios finales | instalación, uso, solución de problemas |
| [`docs/developer-guide.md`](/docs/argvus-boot-splash/developer-guide/) | desarrolladores | internos de temas, empaquetado, CI |
