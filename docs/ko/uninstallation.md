---
title: 제거
description: 패키지를 제거하고 이전 부트 테마를 복원하세요.
---
# 제거

```sh
sudo pacman -Rns argvus-boot-splash
```
그럼 다른 테마를 선택하고 다시 빌드하세요, 그렇지 않으면 기존 스플래시는 initramfs 안에 그대로 남아 있습니다:

```sh
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme
sudo mkinitcpio -P        # or: sudo dracut --regenerate-all
```
`pacman -Rns`는 다른 무엇도 그것을 생성하지 않았다면 `/etc/plymouth/plymouthd.conf`도 제거합니다.

패키지 제거 후킹은 단지 알림을 출력할 뿐이며 — 어떤 테마를 원하는지 추측하지 않으며, initramfs도 건드리지 않습니다.

## 다음 단계

- [문제 해결](/docs/argvus-boot-splash/troubleshooting/) — 이전 스플래시 복원.
- [설치](/docs/argvus-boot-splash/installation/) — 나중에 다시 설치.
