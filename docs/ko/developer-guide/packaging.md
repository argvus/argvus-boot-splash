---
title: 포장
description: Arch 패키지 메타데이터, 빌드 파이프라인, 및 Make 타겟.
---
# 패키징

Arch 패키지가 정의되고 만들어지는 방법: 두 개의 PKGBUILD, 공유 함수, 설치 훅, 로컬 빌드 파이프라인 및 Make 타겟.

테마 자체에 대해서는 [theme architecture](/docs/argvus-boot-splash/developer-guide/theme/)를 참조하고, 검증, CI 및 릴리스에 대해서는 [CI and releases](/docs/argvus-boot-splash/developer-guide/ci-releases/)를 참조.

## 두 개의 PKGBUILD, 하나의 페이로드

`packaging/arch/remote/PKGBUILD`와 `packaging/arch/local/PKGBUILD`은 동일하며, `source=`만 다릅니다:

| | `local` | `ci` |
| --- | --- | --- |
| 소스 | `${pkgname}-${pkgver}.tar.gz` (`make build`에 의해 빌드됨) | `${url}/archive/refs/tags/v${pkgver}.tar.gz` |
| 사용 대상 | 개발자, `make build` | GitHub Actions 릴리스 |

두 가지 모두 `packaging/arch/common/functions.sh`에서 동일한 함수를 호출하며, `tools/sh/validate.sh`는 그들의 메타데이터(`pkgname`, `pkgver`, `pkgrel`, `pkgdesc`, `arch`, `license`, `depends`, `makedepends`, `options`)가 동일함을 확인하므로, 두 가지가 조용히 불일치할 수 없습니다.

공유 메타데이터:

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
## 공유 함수

`packaging/arch/common/functions.sh`는 두 PKGBUILD에서 모두 사용되는 세 가지 함수를 제공합니다:

- `arch_normalize_source_tree` (`prepare()`) — GitHub 태그 아카이브를 `<repo>-v<version>`에 추출하는 반면, 로컬 tarball은 `<pkgname>-<pkgver>`에 추출됩니다. 이는 최상위 디렉토리를 `${srcdir}/${pkgname}-${pkgver}`로 이름을 변경하며, 소스 디렉토리가 없거나 모호하거나 대상이 이미 존재하면 오류를 발생시킵니다.
- `arch_check_splash_payload` (`check()`) — 추출된 소스에 모든 테마 자산이 존재하는지 확인합니다. 이것은 패키지의 유일한 "테스트 스위트"이며, 필요한 파일 목록은 [자산 목록](/docs/argvus-boot-splash/developer-guide/theme/#asset-inventory)에 있습니다.
- `arch_package_splash_payload` (`package()`) — `src/usr`를 `find -print0`로 순회하고, 각 파일을 `install -Dm644`로 `$pkgdir`에 설치합니다 (NUL 안전, 이름에 공백이 있어도 작동), 그 후 `LICENSE`를 `/usr/share/licenses/argvus-boot-splash/LICENSE`에 설치합니다.

package() 내부에는 make install 호출이 없음을 주의하세요: 모든 것이 install -Dm*이므로, 패키지는 자급자족이며 루트 없는 빌드에 적합합니다. 이것은 의도된 것입니다 — `make install`를 호출하던 오래된 `package()`는  `install -Dm*` `package()` `make install` `sudo`/`libfakeroot.so` 오류를 발생시켰습니다.

## 설치 후크

`packaging/arch/{ci,local}/argvus-boot-splash.install` (동일):

- `post_install()` / `post_upgrade()` → `plymouth-set-default-theme argvus`, 그런 다음 `mkinitcpio -P`가 가능하면 실행하고, 그렇지 않으면 `dracut --regenerate-all`를 실행하거나, 그렇지 않으면 사용자가 수동으로 다시 빌드하도록 경고를 표시합니다.
- `post_remove()` → 정보 메시지만 표시; 테마는 자동으로 다시 전환되지 않습니다 (추측하는 것보다 안전합니다).

## 로컬 빌드 파이프라인

`tools/sh/pkgbuild_local.sh` (`make build`에서 호출됨):

1. `makepkg`, `sha256sum`, `tar`, `awk`, `find`를 확인하고 PKGBUILD가 존재하는지 확인합니다; PKGBUILD를 소싱하여 `pkgname`/`pkgver`를 읽고 둘 다 검증합니다.
   허용 목록 정규식(이름에는 `^[a-z0-9@._+-]+$`, 버전에는 점이 포함된 버전 패턴)에 대비하여).
2. `build/artifacts/${pkgname}-${pkgver}.tar.gz`를 `tar --sort=name --mtime='UTC 1970-01-01' --owner=0 --group=0 --numeric-owner` 및 `--transform "s#^\./#${pkgname}-${pkgver}/#"`와 함께 빌드 — 결정적이고 재현 가능한 아카이브. `.git`, `build/`, `dist/`, `target/`, `tools/`, `release`/`packages-repo` 스크래치 디렉토리와 패키징 디렉토리 안의 `src/`, `pkg/` 또는 패키지 잔여물을 제외합니다.
3. 아카이브의 `sha256`를 계산하고 `sed`로 로컬 PKGBUILD의 **임시 복사본**(`.PKGBUILD.local.XXXXXX`, `EXIT` 트랩에 의해 제거됨)에 주입합니다. 저장소는 항상 `sha256sums=()`을 비워둡니다; `SKIP`은 절대 사용되지 않습니다.
4. 기존의 `${pkgname}-${pkgver}-*.pkg.tar.zst`을 `build/dist/`에서 삭제하여 오래된 패키지가 이번 빌드로 오인되지 않도록 합니다.
5. ` with ` with `/`/` in ` in build/artifacts/ 명령을 실행하고 `PKGDEST`를 `build/dist/`에 실행합니다. 추가 인수는 `makepkg`로 전달됩니다; `MAKEPKG_FLAGS`는 기본 플래그 세트를 재정의합니다(의도적으로 단어 분할됨).
6. 정확히 한 개의 `.pkg.tar.zst`가 일치하지 않으면 실패하며, 설치된 경우 `namcap`를 실행합니다.

출력:

```text
build/dist/argvus-boot-splash-0.2.0-1-any.pkg.tar.zst   installable package
build/artifacts/argvus-boot-splash-0.2.0.tar.gz          source snapshot
build/artifacts/argvus-boot-splash/{src,pkg}/            makepkg work dirs
```
## Make 목표

| 목표 | 효과 |
| --- | --- |
| `make build` (별칭 `make package`) | `tools/sh/pkgbuild_local.sh` → `build/` 실행 |
| `make install` (별칭 `make install-package`) | build/dist/에서 단일 패키지 `sudo pacman -U`; 개수가 정확히 1이 아니면 오류 발생 |
|  `build/dist/` `make validate` | `tools/sh/validate.sh`: shellcheck + `bash -n` + PKGBUILD 메타데이터 동기화 + PKGBUILD별 `makepkg --printsrcinfo` + `git diff --check` |
| `make lint` (별칭 `make lint-shell`) | `tools`, `packaging/arch/common`, `src`(`SC1090`, `SC2034`, `SC2154` 비활성화), `bash -n`, `git diff --check`에 대한 shellcheck |
| `make spellcheck` | cspell가 설치되어 있으면 `cspell --config cspell.json .`, 그렇지 않으면 건너뜀 |
|  `cspell` `make clean` | `rm -rf build/` |
| `make help` | 목표 목록 (기본 목표) |

CI는 `make validate` 및 `make build`를 실행; CI에서 `make install`는 실행하지 않음
([known gaps](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps) 참조).

## 전제 조건

`make`, `git`, `gnupg` 및 `base-devel` 그룹이 있는 Arch 기반 시스템:

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
```
- `pacman-contrib`는 `updpkgsums`를 제공합니다 (PKGBUILD 체크섬을 재생성합니다).
- `shellcheck`는 저장소 셸 스크립트와 공유 Arch 패키징 기능을 검증합니다.
- 선택 사항: `namcap` (패키지 린팅) 및 cspell (로컬 맞춤법 검사). CI는 이 모든 것을 설치합니다.
