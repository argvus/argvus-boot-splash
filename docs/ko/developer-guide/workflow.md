---
title: 관습과 알려진 격차
description: 하우스 규칙, 문서화 지도, 그리고 저장소 감사지 결과.
---
# 규칙과 알려진 간극

이 저장소에서의 변경에 대한 내부 규칙과, 감사를 수행하면서 발견된 불일치 — 복사하기보다는 수정할 가치가 있습니다.

기술적 참조는 [theme architecture](/docs/argvus-boot-splash/developer-guide/theme/)], [packaging](/docs/argvus-boot-splash/developer-guide/packaging/)] 및 [CI and releases](/docs/argvus-boot-splash/developer-guide/ci-releases/)]를 참조하세요.

## 규칙

- 쉘: `set -euo pipefail`, 들여쓰기는 탭 사용, stderr로 `printf`/`error` 메시지, `command -v` 기능 체크, shellcheck 정리 (`.editorconfig` 참고).
- `sha256sums=('SKIP')`를 절대 작성하지 않음; git에서 `sha256sums=()`는 비워 둠.
- 빌드 출력물(`build/`), 패키지 파일, 또는 생성된 `.PKGBUILD.local.*` 복사본은 커밋하지 않음.
- 기록에 사용된 범위를 가진 Conventional Commits: `splash`, `layout`, `pkgbuild`, `release`, `chore`, `ci`, `build`, `docs`.
- 브랜치 네이밍: `feat/…`, `fix/…`, `docs/…`, `chore/…`, `refactor/…`.
- 병합 전 리뷰어 1명 승인, squash-merge 방법.
- 라이선스: GPL-3.0-only. `/usr/share/licenses/argvus-boot-splash/LICENSE`로 배포.
- [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md) 및 [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md)에서 과정 준수.

## 알려진 갭

저장소를 감사하는 동안 발견된 문서화된 불일치 사항:

- `README.md`는 Plymouth 직접 미리보기용으로 `make test`를 광고하지만, [Makefile](https://github.com/argvus/argvus-boot-splash/blob/main/Makefile)]에는 그런 대상이 존재하지 않습니다. 실제 명령은 `sudo plymouth --show-splash` / `sudo plymouthquit`입니다.
- `entry-line.png`와 `logo-glow.png`는 페이로드에 포함되어 있으며 `arch_check_splash_payload()`에서 필요하지만, `argvus.script`는 결코 이를 로드하지 않습니다. 스크립트에 이를 연결하거나, 페이로드 및 체크리스트에서 제거하십시오.
- `src/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp`가 설치되었지만 아무 것도 등록되지 않았습니다; [사용자 가이드](/docs/argvus-boot-splash/uki-splash/)]에는 수동 `bootctl`/`ukify` 단계가 문서화되어 있습니다.
- 정식 문서는 저장소 루트(`README.md`, `DEVELOPMENT.md`)에 있으며, `docs/`의 가이드와 겹칩니다. 일관성을 유지하십시오.
  둘 중 하나를 변경할 때. 기여 정책(`CONTRIBUTING.md`, `SECURITY.md`)은 조직 `.github` 리포지토리에 있습니다.

## 문서 맵

| 문서 | 대상 | 범위 |
| --- | --- | --- |
| `README.md` | 모두 | 한 단락 개요 및 레이아웃 |
| `DEVELOPMENT.md` | 유지 관리자 | 빌드, 서명, 릴리스 프로세스 |
| [`CONTRIBUTING.md`](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md) (조직 `.github`) | 기여자 | git 흐름, PR 규칙, 비밀 정책 |
| [`docs/user-guide.md`](/docs/argvus-boot-splash/) | 최종 사용자 | 설치, 사용, 문제 해결 |
| [`docs/developer-guide.md`](/docs/argvus-boot-splash/developer-guide/) | 개발자 | 테마 내부, 패키징, CI |
