---
title: ARGVUS 부트 스플래시
description: ARGVUS 데스크톱 환경용 Plymouth 테마 및 설치 가이드
---

# ARGVUS 부트 스플래시

Argvus 부트 스플래시는 Argvus 데스크톱 생태계를 위한 [Plymouth](https://www.freedesktop.org/wiki/Software/Plymouth/) 테마입니다. 컴퓨터를 켠 순간부터 그래픽 세션이 시작될 때까지 보는 화면입니다.

## 문서

이 문서는 두 개의 주요 섹션으로 구성되어 있습니다:

### 사용자 가이드
최종 사용자 및 시스템 관리자를 위한 설치 및 사용 가이드.

| 가이드 | 내용 |
| --- | --- |
| [설치](/docs/argvus-boot-splash/installation/) | 요구 사항, 세 가지 설치 옵션, 패키지 훅의 기능 |
| [사용법](/docs/argvus-boot-splash/usage/) | 설치 확인, 재부팅 없이 미리보기, 테마 전환 또는 되돌리기, 명령어 치트 시트 |
| [UKI 및 systemd-boot 스플래시](/docs/argvus-boot-splash/uki-splash/) | UKI 부트 흐름에서 `argvus-uki-splash.bmp` 사용 |
| [제거](/docs/argvus-boot-splash/uninstallation/) | 패키지 제거 및 이전 테마 복원 |
| [문제 해결](/docs/argvus-boot-splash/troubleshooting/) | 일반적인 증상과 그 원인 |
| [참고](/docs/argvus-boot-splash/reference/) | 설치된 파일, 패키지 메타데이터, 색상 값 |

### [개발자 가이드](/docs/argvus-boot-splash/developer-guide/)
기여자 및 유지보수자를 위한 기술 문서.

- [Theme Architecture](/docs/argvus-boot-splash/developer-guide/theme/) — Plymouth 설명자, 렌더링 모델 및 사용자 정의
- [Packaging](/docs/argvus-boot-splash/developer-guide/packaging/) — 빌드 파이프라인 및 패키지 레시피
- [CI and Releases](/docs/argvus-boot-splash/developer-guide/ci-releases/) — 검증, 테스트 및 릴리스 워크플로우

## 빠른 시작

Arch 기반 시스템용:

```sh
sudo pacman -S argvus-boot-splash   # or: sudo pacman -U ./argvus-boot-splash-<version>-1-any.pkg.tar.zst
```
설치 프로그램은 테마를 기본값으로 설정하고 initramfs를 자동으로 재생성합니다.

---

- **저장소:** [github.com/argvus/argvus-boot-splash](https://github.com/argvus/argvus-boot-splash)
- **라이센스:** GPL-3.0 전용
- **버그 신고:** [GitHub 문제](https://github.com/argvus/argvus-boot-splash/issues)
