---
title: 使用
description: 验证安装，预览而无需重启，并切换主题。
---

# 使用方法

如何验证主题，在不重启的情况下预览它，以及切换主题。
有关安装，请参见 [installation](/docs/argvus-boot-splash/installation/)]。

## 验证安装

```sh
# theme is present?
ls /usr/share/plymouth/themes/argvus

# which theme is the default?
plymouth-set-default-theme          # prints, e.g.: argvus

# does Plymouth parse the theme without errors?
sudo plymouth --show-splash
```
## 在不重启的情况下预览

```sh
sudo plymouth --show-splash   # shows the splash, simulating boot
sudo plymouthquit             # returns to your session
```
当以普通用户身份运行时，预览可能会要求 polkit 认证。进度条会随着模拟进度前进；你也可以强制状态：

```sh
sudo plymouth --show-details   # verbose boot messages instead of the splash
sudo plymouth --show-splash    # back to the splash
```
在启动画面显示时，按 <kbd>Esc</kbd> 可以切换到下一个屏幕（启动画面 → 详情 → 启动画面）。

## 启动画面显示内容

| 阶段 | 外观 |
| --- | --- |
| 启动 | 所有内容在约 1 秒内淡入：徽标、文字标识、进度条 |
| 启动中 | 进度条从左侧填充，同时 Plymouth 报告进度 |
| 加密卷 | 启动画面变暗至 15%，提示文本和掩码字符显示在进度条下方 |
| 密码接受 | 对话框消失，启动画面恢复全不透明 |

## 更改或恢复主题

```sh
# switch theme (any theme name under /usr/share/plymouth/themes)
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme

# then regenerate the initramfs
sudo mkinitcpio -P              # or: sudo dracut --regenerate-all
```
有用的配置文件：

| 文件 | 目的 |
| --- | --- |
| `/etc/plymouth/plymouthd.conf` | 由软件包编写的 `PLYMOUTH_THEME_NAME=argvus` |
| `/etc/mkinitcpio.conf` | `HOOKS=(... plymouth ...)` 必须包含 `plymouth` |
| `/etc/plymouth/plymouthd.conf`（再次） | `PLYMOUTH_TOGGLE_KEY` 等是全局的，而非每个主题 |

## 命令速查表

| 命令 | 作用 |
| --- | --- |
| `sudo plymouth-set-default-theme argvus` | 使 `argvus` 成为默认主题 |
| `sudo plymouth-update-theme` | 将更改应用到正在运行的 Plymouth |
| `sudo plymouth --show-splash` | 在当前会话中显示启动画面 |
| `sudo plymouth --show-details` | 改为显示详细的启动信息 |
| `sudo plymouthquit` | 退出 Plymouth 并恢复你的会话 |
| `sudo mkinitcpio -P` | 重新构建 Arch initramfs |
| `sudo dracut --regenerate-all` | 用 dracut 重新构建 initramfs |

## 下一步

- [UKI 和 systemd-boot 启动画面](/docs/argvus-boot-splash/uki-splash/)
- [卸载](/docs/argvus-boot-splash/uninstallation/)
- [故障排除](/docs/argvus-boot-splash/troubleshooting/)
