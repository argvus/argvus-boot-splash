---
title: Упаковка
description: Метаданные пакета Arch, конвейер сборки и цели Make.
---
# Упаковка

Как определяется и создаётся пакет Arch: два PKGBUILD, общие функции, хуки установки, локальный конвейер сборки и цели Make.

Для самой темы смотрите [архитектура темы](/docs/argvus-boot-splash/developer-guide/theme/); для проверки, CI и выпусков смотрите [CI и выпуски](/docs/argvus-boot-splash/developer-guide/ci-releases/).

## Два PKGBUILD, одна нагрузка

`packaging/arch/remote/PKGBUILD` и `packaging/arch/local/PKGBUILD` идентичны, за исключением `source=`:

| | `local` | `ci` |
| --- | --- | --- |
| источник | `${pkgname}-${pkgver}.tar.gz` (создаётся `make build`) | `${url}/archive/refs/tags/v${pkgver}.tar.gz` |
| используется | разработчиками, `make build` | выпуск GitHub Actions |

Оба вызывают одни и те же функции из `packaging/arch/common/functions.sh`, и `tools/sh/validate.sh` утверждает, что их метаданные (`pkgname`, `pkgver`, `pkgrel`, `pkgdesc`, `arch`, `license`, `depends`, `makedepends`, `options`) идентичны, поэтому они не могут тихо расходиться.

Общие метаданные:

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
## Общие функции

`packaging/arch/common/functions.sh` предоставляет три функции, используемые обоими PKGBUILDs:

- `arch_normalize_source_tree` (`prepare()`) — архивы тегов GitHub извлекаются в `<repo>-v<version>`, в то время как локальный tarball извлекается в `<pkgname>-<pkgver>`. Это переименовывает единственный каталог верхнего уровня в `${srcdir}/${pkgname}-${pkgver}`, выдавая ошибку, если исходный каталог отсутствует, неоднозначен или если назначение уже существует.
- `arch_check_splash_payload` (`check()`) — проверяет, что каждый ресурс темы существует в извлечённом исходном коде. Это единственный «тестовый набор» пакета; список необходимых файлов находится в [inventory ресурсов](/docs/argvus-boot-splash/developer-guide/theme/#asset-inventory).
- `arch_package_splash_payload` (`package()`) — проходит по `src/usr` с помощью `find -print0` и устанавливает каждый файл с помощью `install -Dm644` в `$pkgdir` (безопасно для NUL, работает с пробелами в названиях), затем устанавливает `LICENSE` в `/usr/share/licenses/argvus-boot-splash/LICENSE`.

Обратите внимание, что внутри package() нет вызова `make install`: все  `package()` `install -Dm*`, поэтому пакет является автономным и удобным для сборки без root-доступа. Это сделано намеренно — старый `package()`, который вызывал `make install`, вызывал ошибки `sudo`/`libfakeroot.so`.

## Установочные хуки

`packaging/arch/{ci,local}/argvus-boot-splash.install` (идентично):

- `post_install()` / `post_upgrade()` → `plymouth-set-default-theme argvus`, затем `mkinitcpio -P`, если доступно, иначе `dracut --regenerate-all`, иначе предупреждение пользователю о необходимости собрать вручную.
- `post_remove()` → только информационное сообщение; тема не переключается обратно автоматически (безопаснее, чем гадать).

## Локальный конвейер сборки

`tools/sh/pkgbuild_local.sh` (вызывается `make build`):

1. Проверяет `makepkg`, `sha256sum`, `tar`, `awk`, `find` и то, что PKGBUILD существует; подключает PKGBUILD для чтения `pkgname`/`pkgver` и проверяет оба
   против допускаемых регулярных выражений (`^[a-z0-9@._+-]+$` для имени, версионный шаблон с точками для версии).
2. Собирает `build/artifacts/${pkgname}-${pkgver}.tar.gz` с `tar --sort=name --mtime='UTC 1970-01-01' --owner=0 --group=0 --numeric-owner` и `--transform "s#^\./#${pkgname}-${pkgver}/#"` — детерминированный, воспроизводимый архив. Исключает `.git`, `build/`, `dist/`, `target/`, `tools/`, `release`/`packages-repo` временные директории и любые `src/`, `pkg/` или остатки пакетов в каталогах упаковки.
3. Вычисляет `sha256` архива и внедряет его с `sed` в **временную копию** локального PKGBUILD (`.PKGBUILD.local.XXXXXX`, удаляемую ловушкой `EXIT`). Репозиторий всегда держит `sha256sums=()` пустым; `SKIP` никогда не используется.
4. Удаляет любые ранее существовавшие `${pkgname}-${pkgver}-*.pkg.tar.zst` из `build/dist/`, чтобы устаревший пакет не был принят за эту сборку.
5. Выполняет `makepkg -p <generated PKGBUILD> --nodeps --noconfirm --needed
   --cleanbuild --force --check` with `BUILDDIR`/`SRCDEST` in `build/artifacts/`
   и `PKGDEST` в `build/dist/`. Дополнительные аргументы передаются `makepkg`;
   `MAKEPKG_FLAGS` переопределяет набор флагов по умолчанию (разделение слов сделано намеренно).
6. Ошибка, если точно один `.pkg.tar.zst` не совпадает, затем выполняет `namcap` на нём, если
   он установлен.

Вывод:

```text
build/dist/argvus-boot-splash-0.2.0-1-any.pkg.tar.zst   installable package
build/artifacts/argvus-boot-splash-0.2.0.tar.gz          source snapshot
build/artifacts/argvus-boot-splash/{src,pkg}/            makepkg work dirs
```
## Цели Make

| Цель | Эффект |
| --- | --- |
| `make build` (псевдоним `make package`) | выполнить `tools/sh/pkgbuild_local.sh` → `build/` |
| `make install` (псевдоним `make install-package`) | `sudo pacman -U` один пакет в `build/dist/`; ошибка, если количество не ровно 1 |
| `make validate` | `tools/sh/validate.sh`: shellcheck + `bash -n` + синхронизация метаданных PKGBUILD + `makepkg --printsrcinfo` для каждого PKGBUILD + `git diff --check` |
| `make lint` (псевдоним `make lint-shell`) | shellcheck для `tools`, `packaging/arch/common`, `src` (`SC1090`, `SC2034`, `SC2154` отключены), `bash -n`, `git diff --check` |
| `make spellcheck` | `cspell --config cspell.json .`, если `cspell` установлен, иначе пропускается |
| `make clean` | `rm -rf build/` |
| `make help` | список целей (цель по умолчанию) |

CI выполняет `make validate` и `make build`; ничего в CI не выполняет `make install` (см. [известные пробелы](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)).

## Предварительные требования

Система на базе Arch с `make`, `git`, `gnupg` и группой `base-devel`:

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
```
- `pacman-contrib` предоставляет `updpkgsums` (регенерирует контрольные суммы PKGBUILD).
- `shellcheck` проверяет скрипты оболочки репозитория и общие функции упаковки Arch.
- По желанию: `namcap` (проверка пакетов) и cspell (локальная проверка орфографии). CI устанавливает все их.
