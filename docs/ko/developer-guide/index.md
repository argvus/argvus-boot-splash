---
title: 개발자 가이드
description: ARGVUS 기여자를 위한 아키텍처 및 개발 안내.
---
# Argvus 부트 스플래시 — 개발자 가이드

`argvus-boot-splash` 저장소에 대한 기술 문서: Plymouth 테마가 어떻게 구성되는지, Arch 패키지가 어떻게 빌드되는지, 릴리스가 어떻게 서명되고 배포되는지에 대한 내용입니다.

여기에는 컴파일 단계가 없습니다 — 테마는 데이터(`.plymouth` 설명자, `.script`, 이미지)와 Arch 패키지 레시피로 구성됩니다. "빌드"란 재현 가능한 패키지를 생성하는 것을 의미합니다:

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
make validate
make build      # -> build/dist/argvus-boot-splash-<version>-1-any.pkg.tar.zst
make install    # sudo pacman -U that file
```
변경 사항을 커밋하기 전에: `make validate && make build`, 그리고 새 기술 용어를 `.cspell/custom-dictionary-workspace.txt`에 추가하지 않으면 맞춤법 검사 작업이 실패합니다.

테마를 *사용*만 하고 싶다면 [사용자 가이드](/docs/argvus-boot-splash/)를 읽으세요. 이 파일의 프로세스 중심 대응 버전(git 흐름, 비밀, 릴리스 프로세스)은 [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md) 및 [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)를 참고하세요.

## 가이드

| 가이드 | 내용 |
| --- | --- |
| [테마 아키텍처](/docs/argvus-boot-splash/developer-guide/theme/) | 디스크립터, 렌더링 모델, 자산 인벤토리, 스크립트 워크스루, 레이아웃 상수, 디자인 토큰, UKI 비트맵, 테마 수정 방법 |
| [패키징](/docs/argvus-boot-splash/developer-guide/packaging/) | 두 개의 PKGBUILD, 공유 `functions.sh`, 설치 훅, 로컬 빌드 파이프라인, Make 타겟, 사전 요구사항 |
| [CI 및 릴리스](/docs/argvus-boot-splash/developer-guide/ci-releases/) | `validate.sh`, `ci.yml`, 단계별 `release.yml`, 체크섬, 서명, 비밀, 게시 및 버전 관리 |
| [규칙 및 알려진 공백](/docs/argvus-boot-splash/developer-guide/workflow/) | 내부 규칙, 문서 지도, 저장소 감사 중 발견된 불일치 |

## 빠른 참조

| 경로 | 내용 |
| --- | --- |
| `src/usr/share/plymouth/themes/argvus/` | `/usr` 아래 설치된 테마 페이로드 |
| `packaging/arch/{ci,local}/PKGBUILD` | 릴리스 및 로컬 패키지 레시피 |
| `packaging/arch/common/functions.sh` | 공유 `prepare`/`check`/`package` |
| `tools/sh/pkgbuild_local.sh` | 결정적 타르볼 + `makepkg` 드라이버 |
| `tools/sh/validate.sh` | 필수 검증 게이트 |
| `.github/workflows/` | `ci.yml` (검증, 빌드, 맞춤법 검사), `release.yml` (태그 `v*`) |

## 기타 장소

- 저장소 루트: [README.md](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)
- 사용자용 문서: [사용자 가이드](/docs/argvus-boot-splash/)
- 개발 프로세스: [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md)
- 기여: [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)
- 보안 정책: [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md)
- 라이선스: [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE)
- 포르투갈어 버전: [개발자 가이드](/pt/docs/argvus-boot-splash/developer-guide/)
