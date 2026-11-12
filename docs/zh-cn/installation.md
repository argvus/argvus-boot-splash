---
title: 安装
description: 要求、安装选项以及包钩子的功能。
---

# 安装

在基于 Arch 的系统上获取 Argvus 启动画面的所有内容。

有关主题的外观和内容，请参见 [reference](/docs/argvus-boot-splash/reference/)。如果要从源代码重新构建，请参见 [developer guide](/docs/argvus-boot-splash/developer-guide/)。

## 要求

- 使用 `plymouth` 的基于 Arch 的系统（该软件包依赖它）。
- 一个 initramfs 生成器：**mkinitcpio**（Arch 默认）或 **dracut**。安装程序会检测已存在的生成器并为您重建 initramfs。
- 必须在 initramfs 配置中启用 Plymouth。对于 mkinitcpio，确保 `plymouth` 在 `HOOKS` 的 `/etc/mkinitcpio.conf` 列表中：

  ```ini
  HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont plymouth)
  ```
如果您刚刚更改了此设置，请重启。

- 对于普通的图形会话无需任何操作；主题只在启动路径中运行。

## 选项 1：官方软件包仓库（推荐）

签名的软件包已发布到 Argvus 软件包仓库（`argvus/packages`，路径 `public/arch/$arch`）。将其添加到 `/etc/pacman.conf`：

```ini
[argvus]
SigLevel = Required DatabaseOptional
Server = <PACKAGES_REPO_BASE_URL>/argvus/packages/raw/branch/main/public/arch/$arch
```
将 `<PACKAGES_REPO_BASE_URL>` 替换为项目发布仓库的主机（GitHub、GitLab 或 Gitea）。首先导入仓库签名密钥，否则 `pacman` 会拒绝下载：

```sh
# 1. import the project's public signing key into your pacman keyring
pacman-key --add /path/to/argvus-signing-key.asc
pacman-key --lsign <key-id>

# 2. refresh and install
sudo pacman -Sy
sudo pacman -S argvus-boot-splash
```
## 选项 2：发布包文件

每个有标签的发布都会将 `.pkg.tar.zst`（及其 `.sig`）作为发布资产发布。直接安装它：

```sh
sudo pacman -U ./argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```
如果您关心供应链的安全性，请在安装之前使用项目的公钥验证分离签名：

```sh
gpg --verify argvus-boot-splash-0.2.0-1-any.pkg.tar.zst.sig \
        argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```
## 选项 3：手动安装

适用于非 Arch 系统，或者如果你只是想在不打包的情况下试用主题。将主题目录复制到 Plymouth 的主题路径中：

```sh
sudo cp -r src/usr/share/plymouth/themes/argvus \
           /usr/share/plymouth/themes/argvus

sudo plymouth-set-default-theme argvus
sudo update-initramfs -u        # Debian/Ubuntu
# or: sudo mkinitcpio -P        # Arch
# or: sudo dracut --regenerate-all
```
普利茅斯（Plymouth）也可以在 `/etc/default/grub` 中通过包含 `GRUB_CMDLINE_LINUX` 的 `splash` 启用，而 `quiet` 提供经典的最小启动体验。

## 安装程序的操作

在安装或升级后，包钩子会自动运行：

1. `plymouth-set-default-theme argvus` — 将 `argvus` 写入 `/etc/plymouth/plymouthd.conf`。
2. 如果存在 mkinitcpio 则执行 `mkinitcpio -P`，否则执行 `dracut --regenerate-all`。

如果找不到生成器，安装程序会打印警告，并且必须自己重建 initramfs。只有在重新生成 initramfs 后，主题更改才会在启动时可见——不执行此步骤直接重启是“启动画面未更改”的最常见原因。

在删除时，包只打印提醒：选择不同的主题并重建 initramfs 由你自行处理。参见 [卸载 ](/docs/argvus-boot-splash/uninstallation/)。

## 下一步

- [Usage](/docs/argvus-boot-splash/usage/) — 验证安装，重启前预览，切换主题。
- [UKI and systemd-boot splash](/docs/argvus-boot-splash/uki-splash/) — 在 UKI 中使用位图。
- [Troubleshooting](/docs/argvus-boot-splash/troubleshooting/) — 如果启动画面没有改变。
