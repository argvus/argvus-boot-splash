---
title: UKI 和 systemd-boot 启动画面
description: 在 UKI 启动流程中使用 ARGVUS 启动画面位图。
---
# UKI 和 systemd-boot 启动画面

该软件包还提供了 `argvus-uki-splash.bmp`（400x400，32 位未压缩 BMP）。它用于 UKI / systemd-boot 的启动流程，其中启动画面嵌入到统一内核映像中，而不是从 initramfs 中读取。

该位图 *不* 被 Plymouth 主题使用，并且不会自动为你注册：是否嵌入取决于你如何构建 UKI。典型的使用者有：

```sh
# systemd: set the splash for the next boot (systemd >= 254)
bootctl --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp

# ukify, while building the UKI
ukify build --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp \
           --linux=... --initrd=... --microcode=...
```
每当镜像更改时，请重新运行 UKI 构建（或 `bootctl set-splash`），并且记得如果你在其他地方构建，要将文件复制到 ESP。systemd-boot 会将位图缩放到控制台，因此方形图像会居中显示。

如果你只使用 mkinitcpio 或 dracut，可以完全忽略此文件——常规的 [installation](/docs/argvus-boot-splash/installation/) 覆盖了该路径。

## 接下来的步骤

- [Usage](/docs/argvus-boot-splash/usage/)
- [Troubleshooting](/docs/argvus-boot-splash/troubleshooting/)
