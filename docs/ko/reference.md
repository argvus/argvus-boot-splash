---
title: 참조
description: 설치된 파일, 패키지 메타데이터 및 색상 값.
---

# 참고

패키지가 설치하는 항목과 사용하는 값들에 대한 기술적 참고 자료입니다.

## 제공 항목

| 구성 요소 | 설명 |
| --- | --- |
| Argvus 로고 | 중앙에 배치된 마크, 워드마크 위에 그려짐 |
| 워드마크 | 로고 아래의 `ARGVUS` 텍스트 |
| 진행 바 | Plymouth 부팅 진행 상황을 반영하는 가느다란 바 |
| 비밀번호 대화상자 | 마스킹된 입력 필드(`•` 총알 사용)가 있는 LUKS 프롬프트 |
| 페이드 인 | Plymouth 시작 시 약 1초 동안 스플래시가 페이드 인됨 |
| UKI 비트맵 | UKI / systemd-boot 기반 부팅용 `argvus-uki-splash.bmp` |

패키지 이름은 `argvus-boot-splash`이며, 이전에 설치된
`argvus-plymouth` 패키지를 대체합니다.

## 설치된 파일들

`/usr/share/plymouth/themes/argvus/` 아래:

| 파일 | 크기 | 용도 |
| --- | --- | --- |
| `argvus.plymouth` | — | 테마 설명자(이름, 설명, 모듈) |
| `argvus.script` | — | 테마 스크립트(Plymouth 고유 스크립트 언어) |
| `argvus-logo.png` | 256x256 | 로고, RGBA |
| `argvus-text.png` | 400x53 | 워드마크, RGBA |
| `progress-bar.png` | 400x4 | 진행 표시줄 채워진 부분 |
| `progress-bar-track.png` | 400x4 | 채워지지 않은 트랙 |
| `entry-box.png` | 400x48 | 비밀번호 입력란 |
| `entry-line.png` | 300x2 | 비밀번호 필드 규칙/밑줄 |
| `bullet.png` | 12x12 | 마스킹된 문자 |
| `logo-glow.png` | 260x300 | 로고 글로우 아트워크 |
| `argvus-uki-splash.bmp` | 400x400, 32비트 | UKI/systemd-boot 스플래시 비트맵 |

`/usr/share/licenses/argvus-boot-splash/LICENSE`에 있는 라이선스도 포함됩니다.

## 패키지 메타데이터

| 필드 | 값 |
| --- | --- |
| 이름 | `argvus-boot-splash` |
| 아키텍처 | `any` |
| 의존 | `plymouth` |
| 선택적 의존 | `mkinitcpio`, `dracut` |
| 충돌 / 대체 | `argvus-plymouth` |
| 라이선스 | GPL-3.0-only |

## 색상

| 요소 | 색상 |
| --- | --- |
| 배경 | `#111316` |
| 강조 (로고, 워드마크, 진행률 채우기) | `#3590BD` |
| 진행률 트랙 | `#262933` |
| 비밀번호 입력 텍스트 | 연회색-파랑 (`#B8C4CE`) |

이 테마는 모든 해상도에서 단색 어두운 배경을 사용하므로, 밝은 및 어두운 변형을 자동으로 전환하지 않습니다.

## 도움말 받기

- 프로젝트의 이슈 트래커에 버그를 보고하고 기능을 요청하세요.
- 보안 문제: [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md)를 따르세요 — 취약점에 대해 공개 이슈를 열지 마세요.
- 소스, 빌드 및 릴리스: 리포지토리 루트([README](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)).
- 기여: [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md).
- 라이선스: [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE).

## 다음 단계

- [설치](/docs/argvus-boot-splash/installation/)
- [사용법](/docs/argvus-boot-splash/usage/)
- [문제 해결](/docs/argvus-boot-splash/troubleshooting/)
