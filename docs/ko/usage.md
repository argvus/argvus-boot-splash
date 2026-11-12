---
title: 사용법
description: 설치를 확인하고, 재부팅 없이 미리 보고, 테마를 전환하세요.
---

# 사용법

테마를 확인하고, 재부팅 없이 미리 보고, 다른 테마로 전환하는 방법.
설치에 대해서는 [installation](/docs/argvus-boot-splash/installation/)를 참조하십시오.

## 설치 확인

```sh
# theme is present?
ls /usr/share/plymouth/themes/argvus

# which theme is the default?
plymouth-set-default-theme          # prints, e.g.: argvus

# does Plymouth parse the theme without errors?
sudo plymouth --show-splash
```
## 재부팅 없이 미리보기

```sh
sudo plymouth --show-splash   # shows the splash, simulating boot
sudo plymouthquit             # returns to your session
```
미리보기는 일반 사용자로 실행할 때 polkit 인증을 요구할 수 있습니다. 진행률 표시줄은 시뮬레이션된 진행률에 따라 진행되며, 상태를 강제로 설정할 수도 있습니다:

```sh
sudo plymouth --show-details   # verbose boot messages instead of the splash
sudo plymouth --show-splash    # back to the splash
```
스플래시 화면이 표시되는 동안, 다음 화면으로 전환하려면 <kbd>Esc</kbd>를 누르세요
(스플래시 → 세부 정보 → 스플래시).

## 스플래시 화면이 보여주는 내용

| 단계 | 화면 표시 |
| --- | --- |
| 시작 | 로고, 워드마크, 진행 표시줄이 약 1초 동안 서서히 나타납니다 |
| 부팅 | Plymouth가 진행 상황을 보고하면서 막대가 왼쪽에서 채워집니다 |
| 암호화된 볼륨 | 스플래시 화면이 15%로 어두워지고, 막대 아래에 텍스트와 마스킹된 글자가 나타납니다 |
| 암호 문구 승인 | 대화 상자가 사라지고 스플래시 화면이 원래 불투명도로 돌아옵니다 |

## 테마 변경 또는 되돌리기

```sh
# switch theme (any theme name under /usr/share/plymouth/themes)
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme

# then regenerate the initramfs
sudo mkinitcpio -P              # or: sudo dracut --regenerate-all
```
유용한 구성 파일:

| 파일 | 용도 |
| --- | --- |
| `/etc/plymouth/plymouthd.conf` | 패키지에서 작성한 `PLYMOUTH_THEME_NAME=argvus` |
| `/etc/mkinitcpio.conf` | `HOOKS=(... plymouth ...)`는 반드시 `plymouth`를 포함해야 함 |
| `/etc/plymouth/plymouthd.conf` (다시) | `PLYMOUTH_TOGGLE_KEY` 등은 글로벌이며, 테마별이 아님 |

## 명령어 치트 시트

| 명령어 | 효과 |
| --- | --- |
| `sudo plymouth-set-default-theme argvus` | `argvus`를 기본 테마로 설정 |
| `sudo plymouth-update-theme` | 변경 사항을 실행 중인 Plymouth에 적용 |
| `sudo plymouth --show-splash` | 현재 세션에서 스플래시 표시 |
| `sudo plymouth --show-details` | 대신 상세 부팅 메시지 표시 |
| `sudo plymouthquit` | Plymouth를 종료하고 세션 복원 |
| `sudo mkinitcpio -P` | Arch initramfs 재빌드 |
| `sudo dracut --regenerate-all` | dracut으로 initramfs 재빌드 |

## 다음 단계

- [UKI 및 systemd-boot 스플래시](/docs/argvus-boot-splash/uki-splash/)
- [제거](/docs/argvus-boot-splash/uninstallation/)
- [문제 해결](/docs/argvus-boot-splash/troubleshooting/)
