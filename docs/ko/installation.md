---
title: 설치
description: 요구 사항, 설치 옵션, 그리고 패키지 후크가 하는 일.
---
# 설치

Arch 기반 시스템에서 Argvus 부트 스플래시를 설정하는 데 필요한 모든 것.

테마가 어떻게 생겼는지와 무엇이 포함되어 있는지 보려면
[reference](/docs/argvus-boot-splash/reference/)를 참조하십시오. 대신 소스에서 다시 빌드하려면
[developer guide](/docs/argvus-boot-splash/developer-guide/)를 참조하십시오.

## 요구 사항

- `plymouth`을 사용하는 Arch 기반 시스템(패키지가 이에 의존함).
- initramfs 생성기: **mkinitcpio**(Arch 기본) 또는 **dracut**.
  설치 프로그램이 존재하는 것을 감지하고 initramfs를 재빌드합니다.
- Plymouth는 initramfs 구성에서 활성화되어 있어야 합니다. mkinitcpio를 사용할 경우,
  `plymouth`가 `HOOKS` 목록의 `/etc/mkinitcpio.conf`에 포함되어 있는지 확인하십시오:

  ```ini
  HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont plymouth)
  ```
이 항목을 방금 변경한 경우 재부팅하십시오.

- 일반 그래픽 세션에는 아무 것도 필요하지 않습니다; 테마는 부팅 경로에서만 실행됩니다.

## 옵션 1: 공식 패키지 저장소 (권장)

서명된 패키지는 Argvus 패키지 저장소(`argvus/packages`, 경로 `public/arch/$arch`)에 게시됩니다. 이를 `/etc/pacman.conf`에 추가하십시오:

```ini
[argvus]
SigLevel = Required DatabaseOptional
Server = <PACKAGES_REPO_BASE_URL>/argvus/packages/raw/branch/main/public/arch/$arch
```
`<PACKAGES_REPO_BASE_URL>`를 프로젝트가 저장소를 게시하는 호스트(GitHub, GitLab 또는 Gitea)로 교체하세요. 먼저 저장소 서명 키를 가져오지 않으면 `pacman`가 다운로드를 거부합니다:

```sh
# 1. import the project's public signing key into your pacman keyring
pacman-key --add /path/to/argvus-signing-key.asc
pacman-key --lsign <key-id>

# 2. refresh and install
sudo pacman -Sy
sudo pacman -S argvus-boot-splash
```
## 옵션 2: 패키지 파일 릴리스

각 태그된 릴리스는 `.pkg.tar.zst`(및 그 `.sig`)를 릴리스 자산으로 게시합니다. 이를 직접 설치하십시오:

```sh
sudo pacman -U ./argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```
공급망 위생에 신경을 쓴다면 설치하기 전에 프로젝트의 공개 키로 분리된 서명을 확인하세요:

```sh
gpg --verify argvus-boot-splash-0.2.0-1-any.pkg.tar.zst.sig \
        argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```
## 옵션 3: 수동 설치

Arch가 아닌 시스템에서 유용하며, 패키징 없이 테마를 시도해보고 싶을 때 좋습니다. 테마 디렉토리를 Plymouth의 테마 경로에 복사하세요:

```sh
sudo cp -r src/usr/share/plymouth/themes/argvus \
           /usr/share/plymouth/themes/argvus

sudo plymouth-set-default-theme argvus
sudo update-initramfs -u        # Debian/Ubuntu
# or: sudo mkinitcpio -P        # Arch
# or: sudo dracut --regenerate-all
```
플리머스(Plymouth)는 `/etc/default/grub`에서 `GRUB_CMDLINE_LINUX`를 포함하는 `splash`와 함께 활성화할 수 있으며, `quiet`는 클래식 최소 부팅 느낌을 제공합니다.

## 설치 프로그램이 수행하는 작업

설치 또는 업그레이드 후 패키지 훅은 자동으로 실행됩니다:

1. `plymouth-set-default-theme argvus` — `argvus`를 `/etc/plymouth/plymouthd.conf`에 씁니다.
2. mkinitcpio가 존재하면 `mkinitcpio -P`, 그렇지 않으면 `dracut --regenerate-all`.

둘 중 어떤 생성기(generator)도 발견되지 않으면 설치 프로그램은 경고를 출력하며 사용자가 직접 initramfs를 재빌드해야 합니다. 테마 변경은 initramfs가 재생성된 후에만 부팅 시 표시됩니다 — 이 단계를 생략하고 재부팅하는 것이 "스플래시가 변경되지 않았다"는 가장 일반적인 원인입니다.

제거 시 패키지는 단순히 알림을 출력합니다: 다른 테마를 선택하고 initramfs를 재빌드하는 것은 사용자의 몫입니다. 자세한 내용은 [uninstallation](/docs/argvus-boot-splash/uninstallation/)를 참조하십시오.

## 다음 단계

- [Usage](/docs/argvus-boot-splash/usage/) — 설치를 확인하고, 재부팅 없이 미리보기하며, 테마를 전환합니다.
- [UKI 및 systemd-boot splash](/docs/argvus-boot-splash/uki-splash/) — UKI에서 비트맵을 사용합니다.
- [Troubleshooting](/docs/argvus-boot-splash/troubleshooting/) — 스플래시가 변경되지 않은 경우.
