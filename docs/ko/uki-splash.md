---
title: UKI 및 systemd-boot 스플래시
description: UKI 부트 플로우에서 ARGVUS 스플래시 비트맵을 사용하세요.
---
# UKI 및 systemd-boot 스플래시

이 패키지는 또한 `argvus-uki-splash.bmp` (400x400, 32비트 비압축 BMP)를 포함합니다. 이는 UKI / systemd-boot 부팅 흐름에서 사용되며, 스플래시 이미지는 initramfs에서 읽히는 대신 통합 커널 이미지에 내장됩니다.

이 비트맵은 Plymouth 테마에서 *사용되지 않으며*, 자동으로 등록되는 항목도 없습니다. 내장 여부는 UKI를 어떻게 빌드하느냐에 따라 달라집니다. 일반적인 사용자는:

```sh
# systemd: set the splash for the next boot (systemd >= 254)
bootctl --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp

# ukify, while building the UKI
ukify build --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp \
           --linux=... --initrd=... --microcode=...
```
이미지가 변경될 때마다 UKI 빌드(또는 `bootctl set-splash`)를 다시 실행하고, 다른 곳에서 빌드하는 경우 파일을 ESP에 복사하는 것을 잊지 마십시오. systemd-boot는 비트맵을 콘솔 크기에 맞게 조정하므로, 정사각형 이미지는 중앙에 표시됩니다.

만약 mkinitcpio 또는 dracut만 사용한다면, 이 파일은 완전히 무시해도 됩니다 — 일반 [installation](/docs/argvus-boot-splash/installation/)이 그 경로를 다룹니다.

## 다음 단계

- [Usage](/docs/argvus-boot-splash/usage/)
- [Troubleshooting](/docs/argvus-boot-splash/troubleshooting/)
