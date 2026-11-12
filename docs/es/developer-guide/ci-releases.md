---
title: CI y Lanzamientos
description: Validación, integración continua, firma y flujo de trabajo de lanzamiento.
---

# CI y lanzamientos

La puerta de validación, los trabajos de integración continua, la canalización de lanzamiento y
las reglas de versionado.

Para el paquete en sí, ver [packaging](/docs/argvus-boot-splash/developer-guide/packaging/); para el tema, ver
[theme architecture](/docs/argvus-boot-splash/developer-guide/theme/).

## Validación

`tools/sh/validate.sh` es la puerta requerida:

- requiere `bash`, `makepkg`, `shellcheck`;
- `shellcheck` + `bash -n` en `tools/sh/*.sh` y `packaging/arch/common/*.sh`;
- toma fuentes de ambos PKGBUILDs y compara metadatos extraídos — los remotos y locales deben coincidir;
- `makepkg -p PKGBUILD --printsrcinfo` dentro de `ci/` y `local/` (analiza el archivo de la misma manera que makepkg);
- `git diff --check` (espacios/marcadores de conflicto).

## Integración continua

`.github/workflows/ci.yml` (push/PR a `main`, contenedor `archlinux:latest`):

1. instalar `base-devel git namcap pacman-contrib shellcheck sudo`;
2. `make validate`;
3. compilar como un usuario `builder` **no privilegiado**
   (`sudo -u builder env HOME=/home/builder make build`) — makepkg se niega a ejecutarse
   como root, y el espacio de trabajo se `chown` primero;
4. un trabajo `spellcheck` separado ejecuta `cspell-action@v6` con `cspell.json`.

`namcap` se ejecuta dentro de `pkgbuild_local.sh` cuando se instala, por lo que las compilaciones locales muestran
el mismo lint que CI. La configuración de corrector ortográfico es `cspell.json` con el diccionario del espacio de trabajo en `.cspell/custom-dictionary-workspace.txt` — los nuevos términos técnicos
(banderas de shell, nombres de herramientas) pertenecen a ese diccionario, de lo contrario CI falla.

## Pipeline de lanzamiento

`.github/workflows/release.yml` — disparadores: push de una etiqueta `v*`, o
`workflow_dispatch` con una etiqueta existente (reconstrucción controlada). Grupo de concurrencia
`release-<ref>`, sin cancelación.

Pasos:

1. **Clonar** la etiqueta (dispatch usa `inputs.tag`).
2. **Paso de versión**: valida la etiqueta contra `^v[0-9]+(\.[0-9]+)*([._+-][A-Za-z0-9]+)*$`, falla si `url` está vacío en `packaging/arch/remote/PKGBUILD`, luego reescribe `pkgver` desde la etiqueta.
3. **Validar**: `make validate`.
4. **Construir** como `builder` sin privilegios: `updpkgsums` (resuelve y valida el `sha256sums` real) luego `makepkg --nodeps --noconfirm --needed --cleanbuild --clean --check`.
   Localiza el `.pkg.tar.zst` y falla si no existe ninguno.
5. **namcap** en el paquete.
6. **Firmar**: importa `GPG_PRIVATE_KEY` en un `GNUPGHOME` desechable (`mktemp -d`, modo 700), verifica que la clave secreta importada coincida con `GPG_KEY_ID` (ID corto o huella digital), y crea un `.sig` separado con `--pinentry-mode loopback --passphrase-fd 0`.
7. **Verificar firma** en un `GNUPGHOME` nuevo — la versión falla si la firma no se verifica.
8. **Subir artefacto** (`upload-artifact@v4`, `retention-days: 1`, paquete +)
   firma, `if-no-files-found: error`).
9. **Publicar**: consulta `argvus/packages` con `PACKAGES_REPO_TOKEN`, copia el paquete y `.sig` en `public/arch/x86_64`, ejecuta `repo-add -R argvus.db.tar.gz <pkg>`, firma `argvus.db.tar.gz`, `argvus.files.tar.gz`, `argvus.db` y `argvus.files`, luego haz commit como `github-actions[bot]` y push. Un diff sin cambios sale 0 sin hacer commit.
10. **Lanzamiento en GitHub**: `softprops/action-gh-release@v2` con notas generadas y el paquete + firma como recursos.

## Sumatorios de verificación, firma y secretos

- No hay `SKIP`: `sha256sums` es siempre un resumen real, calculado en el momento de la construcción (local) o mediante `updpkgsums` (CI de lanzamiento).
- Mantén `sha256sums=()` **vacío** en el repositorio.
- Los lanzamientos están firmados con GPG (paquete `.sig`, `argvus.db.tar.gz`, `argvus.files.tar.gz`, `argvus.db`, `argvus.files`).
- `GPG_PASSPHRASE` debe no estar vacío; el flujo de trabajo rechaza una frase de paso vacía.

Prepara la clave:

```sh
gpg --full-generate-key            # RSA 4096, no expiry recommended
gpg --list-secret-keys --with-colons | grep ^sec:   # note the KEY_ID
gpg --armor --export-secret-keys KEY_ID            # what the workflow imports
```
En **Configuración → Secretos y variables → Acciones** del repositorio:

| Secreto | Valor |
| --- | --- |
| `GPG_PRIVATE_KEY` | salida `gpg --armor --export-secret-keys KEY_ID` |
| `GPG_KEY_ID` | ID de clave o huella digital esperada |
| `GPG_PASSPHRASE` | frase de paso no vacía de la clave de firma |
| `PACKAGES_REPO_TOKEN` | PAT con `contents:write` en `argvus/packages` |

## Publicación de un lanzamiento

Antes de etiquetar:

1. Rellene `url` en `packaging/arch/remote/PKGBUILD` con el repositorio real:
   - GitHub: `url="https://github.com/argvus/argvus-boot-splash"` (la fuente utiliza `${url}/archive/refs/tags/v${pkgver}.tar.gz`);
   - GitLab: ajuste `source=` a `https://gitlab.com/argvus/argvus-boot-splash/-/archive/v${pkgver}/argvus-boot-splash-v${pkgver}.tar.gz`;
   - sin `url`, la versión **falla a propósito** con un mensaje claro.
2. Sincronice versiones/metadatos en `packaging/arch/local/PKGBUILD` y `packaging/arch/remote/PKGBUILD`.
3. Etiquete y envíe:

   ```sh
   git tag v0.1.0
   git push origin v0.1.0
   ```
El flujo de trabajo también se puede iniciar manualmente con una etiqueta `v*` existente como su
   Entrada `tag`, que es útil para una reconstrucción controlada.

## Versionado

- SemVer en `pkgver`, recuento de lanzamientos en `pkgrel`.

## Solución de problemas del desarrollador

**La versión falla en "Recuperar fuentes".** `url` vacío, falta la etiqueta `v*` o una
formato de URL de archivo que no coincide con el host (GitHub vs GitLab tarball
disposición). El flujo de trabajo valida el patrón de etiquetas y falla tempranamente en una etiqueta vacía.
`url`.

**`updpkgsums` no puede encontrar la fuente.** La etiqueta debe existir y enviarse antes
se ejecuta el trabajo de liberación; El envío con una etiqueta que solo existe localmente falla aquí.

**`make validate` informa que "los metadatos PKGBUILD remotos y locales no están sincronizados".**
Copie los campos de metadatos (no `source=`) de un PKGBUILD al otro.

**El corrector ortográfico falla en un término nuevo.** Agréguelo a
`.cspell/custom-dictionary-workspace.txt` (el diccionario `argvus`, `addWords:
true`), not to `ignorePaths`.

**`sudo` solicitado dentro de `make install`, o errores de `libfakeroot.so … LD_PRELOAD`.** Un `package()` que llama a `make install` en lugar de usar `install -Dm*`. Ambos PKGBUILD llaman a `arch_package_splash_payload`, lo cual no; asegúrese de que nadie haya reintroducido una llamada a `make`.

**`makepkg` se niega a ejecutarse.** No debe ejecutarse como root. Ejecute la compilación como un usuario normal, o `sudo -u <user> make build`.

**El paquete se instala pero la pantalla de inicio no cambia.** El initramfs no se reconstruyó. Para pruebas locales, llame a `sudo plymouth --show-splash` en lugar de reiniciar, o reconstruya con `sudo mkinitcpio -P` / `sudo dracut --regenerate-all`.
