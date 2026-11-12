---
title: CI와 릴리즈
description: 검증, 지속적인 통합, 서명 및 릴리스 워크플로우.
---

# CI 및 릴리스

검증 게이트, 지속적 통합 작업, 릴리스 파이프라인 및 버전 규칙.

패키지 자체에 대해서는 [packaging](/docs/argvus-boot-splash/developer-guide/packaging/), 테마에 대해서는 [theme architecture](/docs/argvus-boot-splash/developer-guide/theme/)를 참조하십시오.

## 검증

`tools/sh/validate.sh`는 필수 게이트입니다:

- `bash`, `makepkg`, `shellcheck` 필요;
- `shellcheck` + `bash -n` on `tools/sh/*.sh` 및 `packaging/arch/common/*.sh`;
- 두 PKGBUILDs를 소스하고 추출된 메타데이터 비교 — 원격과 로컬이 일치해야 함;
- `makepkg -p PKGBUILD --printsrcinfo` inside `ci/` 및 `local/` (makepkg 방식으로 파일 파싱);
- `git diff --check` (공백/충돌 마커).

## 지속적 통합

`.github/workflows/ci.yml` (`main`, `archlinux:latest` 컨테이너에 push/PR):

1. `base-devel git namcap pacman-contrib shellcheck sudo`를 설치합니다;
2. `make validate`;
3. **권한 없는** `builder` 사용자로 빌드합니다
   (`sudo -u builder env HOME=/home/builder make build`) — makepkg는 root로 실행할 수 없으며, 작업 공간은 먼저 `chown`됩니다;
4. 별도의 `spellcheck` 작업이 cspell.json와 함께 `cspell-action@v6`를 실행합니다.

 `cspell.json` `namcap`는 설치 시 `pkgbuild_local.sh` 내에서 실행되므로, 로컬 빌드는 CI와 동일한 lint를 보여줍니다. 맞춤법 검사 구성은 `cspell.json`이며, 작업 공간 사전은 `.cspell/custom-dictionary-workspace.txt`에 있습니다 — 새로운 기술 용어(쉘 플래그, 도구 이름)는 해당 사전에 포함되어야 하며, 그렇지 않으면 CI가 실패합니다.

## 배포 파이프라인

`.github/workflows/release.yml` — 트리거: `v*` 태그 푸시 또는 기존 태그를 사용한 `workflow_dispatch`(제어 재빌드). 동시성 그룹 `release-<ref>`, 취소 없음.

단계:

1. 태그 **체크아웃** (디스패치는 `inputs.tag` 사용).
2. **버전 단계**: 태그를 `^v[0-9]+(\.[0-9]+)*([._+-][A-Za-z0-9]+)*$`과 비교하여 검증하고, packaging/arch/remote/PKGBUILD에서 `url`가 비어 있으면 실패하며, 그 후 태그에서  `packaging/arch/remote/PKGBUILD` `pkgver`를 다시 작성합니다.
3. **검증**: `make validate`.
4. **비권한 `builder`로 빌드**: `updpkgsums` (실제 `sha256sums`를 확인하고 검증) 후 `makepkg --nodeps --noconfirm --needed --cleanbuild --clean --check`.
   `.pkg.tar.zst`를 찾고, 존재하지 않으면 실패합니다.
5. 패키지에 대해 **namcap** 수행.
6. **서명**: `GPG_PRIVATE_KEY`를 임시 `GNUPGHOME`(`mktemp -d`, 모드 700)로 가져오고, 가져온 비밀 키가 `GPG_KEY_ID`(짧은 ID 또는 지문)과 일치하는지 확인하며, --pinentry-mode loopback --passphrase-fd 0로 `.sig` 분리 서명을 생성합니다.
7. 신선한  `--pinentry-mode loopback --passphrase-fd 0` `GNUPGHOME`에서 **서명 검증** — 서명이 검증되지 않으면 릴리스가 실패합니다.
8. **아티팩트 업로드** (`upload-artifact@v4`, `retention-days: 1`, 패키지 +
   서명, `if-no-files-found: error`).
9. **배포**: `argvus/packages`를 `PACKAGES_REPO_TOKEN`와 확인하고, 패키지와 `.sig`를 `public/arch/x86_64`에 복사하고, `repo-add -R argvus.db.tar.gz <pkg>`를 실행하고, `argvus.db.tar.gz`, `argvus.files.tar.gz`, `argvus.db` 및 `argvus.files`에 서명한 후 `github-actions[bot]`으로 커밋하고 푸시합니다. 변경 사항이 없는 diff는 커밋 없이 0으로 종료됩니다.
10. **GitHub 릴리스**: 생성된 노트와 패키지 + 서명을 자산으로 `softprops/action-gh-release@v2`에 배포합니다.

## 체크섬, 서명 및 비밀 정보

- `SKIP`는 없습니다: `sha256sums`는 항상 실제 다이제스트이며, 빌드 시점(로컬) 또는 `updpkgsums`(릴리스 CI)를 통해 계산됩니다.
- 저장소에서 `sha256sums=()`를 **비워둡니다**.
- 릴리스는 GPG 서명됨(패키지 `.sig`, `argvus.db.tar.gz`, `argvus.files.tar.gz`, `argvus.db`, `argvus.files`).
- `GPG_PASSPHRASE`는 비어있지 않아야 합니다; 워크플로우는 비어있는 패스프레이즈를 거부합니다.

키를 준비하세요:

```sh
gpg --full-generate-key            # RSA 4096, no expiry recommended
gpg --list-secret-keys --with-colons | grep ^sec:   # note the KEY_ID
gpg --armor --export-secret-keys KEY_ID            # what the workflow imports
```
저장소의 **설정 → 시크릿 및 변수 → 액션**에서:

| 시크릿 | 값 |
| --- | --- |
| `GPG_PRIVATE_KEY` | `gpg --armor --export-secret-keys KEY_ID` 출력 |
| `GPG_KEY_ID` | 예상 키 ID 또는 지문 |
| `GPG_PASSPHRASE` | 서명 키의 비어 있지 않은 암호문 |
| `PACKAGES_REPO_TOKEN` | `contents:write`가 있는 `argvus/packages`의 PAT |

## 릴리스 게시

태그를 지정하기 전에:

1. 실제 저장소로 `url`를 `packaging/arch/remote/PKGBUILD`에 입력하세요:
   - GitHub: `url="https://github.com/argvus/argvus-boot-splash"` (소스는 `${url}/archive/refs/tags/v${pkgver}.tar.gz` 사용);
   - GitLab: `source=`를 `https://gitlab.com/argvus/argvus-boot-splash/-/archive/v${pkgver}/argvus-boot-splash-v${pkgver}.tar.gz`로 조정;
   - `url` 없이는, 릴리스가 명확한 메시지와 함께 **의도적으로 실패**합니다.
2. `packaging/arch/local/PKGBUILD` 및 `packaging/arch/remote/PKGBUILD`의 버전/메타데이터를 동기화하십시오.
3. 태그를 지정하고 푸시하세요:

   ```sh
   git tag v0.1.0
   git push origin v0.1.0
   ```
워크플로우는 기존 `v*` 태그를 사용하여 수동으로 시작할 수도 있습니다.
   제어된 재구축에 유용한 `tag` 입력입니다.

## 버전 관리

- `pkgver`의 SemVer, `pkgrel`의 릴리스 횟수.

## 개발자 문제 해결

**"소스 검색 중"에서 릴리스가 실패합니다.** 비어 있는 `url`, 누락된 `v*` 태그 또는
호스트와 일치하지 않는 아카이브 URL 형식(GitHub vs GitLab tarball)
레이아웃). 워크플로는 태그 패턴의 유효성을 검사하고 비어 있으면 조기에 실패합니다.
`url`.

**`updpkgsums`는 소스를 찾을 수 없습니다.** 태그가 존재해야 하며 이전에 푸시되어야 합니다.
릴리스 작업이 실행됩니다. 여기서는 로컬에만 존재하는 태그를 사용한 디스패치가 실패합니다.

**`make validate`는 "원격 및 로컬 PKGBUILD 메타데이터가 동기화되지 않았습니다"라고 보고합니다.**
한 PKGBUILD에서 다른 PKGBUILD로 메타데이터 필드(`source=` 아님)를 복사합니다.

**새 용어에 대한 맞춤법 검사가 실패합니다.** 다음에 추가하세요.
`.cspell/custom-dictionary-workspace.txt`(`argvus` 사전, `addWords:
true`), not to `ignorePaths`.

**`sudo`가 `make install` 또는 `libfakeroot.so … LD_PRELOAD` 내부에서 요청됨, 오류 발생.** `package()`가 install -Dm*를 사용하지 않고 대신 `make install`로 셸을 실행함. 두 PKGBUILD 모두  `install -Dm*` `arch_package_splash_payload`를 호출하며, 이는 호출하지 않음; 아무도 `make` 호출을 다시 도입하지 않았는지 확인할 것.

**`makepkg`가 실행을 거부함.** 루트로 실행해서는 안 됨. 빌드를 일반 사용자 또는 `sudo -u <user> make build`로 실행할 것.

**패키지가 설치되었지만 스플래시는 변경되지 않음.** initramfs가 재빌드되지 않았음. 로컬 테스트의 경우, 재부팅 대신 `sudo plymouth --show-splash`를 호출하거나, `sudo mkinitcpio -P` / `sudo dracut --regenerate-all`로 재빌드할 것.
