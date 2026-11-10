---
title: 故障排除
description: 常见启动画面故障及修复方法
---
# 故障排除

**安装后启动画面没有变化。**
initramfs 没有重新生成。运行 `sudo mkinitcpio -P`（或 `sudo dracut --regenerate-all`）并重启。如果系统使用多个内核，请确保启动的内核使用了新的 initramfs。

**完全没有启动画面；屏幕黑屏或仅显示文字。**
`plymouth` 在 initramfs 钩子中缺失。检查 `/etc/mkinitcpio.conf` 是否存在，`HOOKS=(...)` 是否包含 `plymouth`，然后重建并重启。在 Ubuntu/Debian 上，还要确认 `plymouth` 和 `plymouth-x11`/`plymouth-themes` 已安装，并且 `GRUB_CMDLINE_LINUX` 包含 `splash quiet`。

**只有标志，没有进度。**
某些启动步骤没有被 init 报告，或进度回调从未被调用——你这边没有任何故障。进度条根据 Plymouth 报告的进度填充，但在一些设置中没有进度（例如使用 systemd 的 `plymouth-spawn`-less 序列或某些 dracut 模块）。

**密码提示框位置错误或不可见。**
对话框是根据标志文字和轨迹几何位置放置的，因此极端分辨率（非常小的文本模式）可能会将其推到屏幕之外。请使用正常分辨率，如果在常见分辨率下仍然发生，请报告。

**Plymouth 提前退出 / 你看到的是文本控制台。**
某些设置禁用了 Plymouth：带有 `quiet` 且没有 `splash` 的启动参数，`plymouth` 钩子被移除，或者 Plymouth 无法使用的驱动程序。Plymouth 会退出到文本控制台，而不是冻结机器——这是预期行为。

**从 `argvus-plymouth` 升级后主题未应用。**
新软件包会替换旧软件包；请确认 `/etc/plymouth/plymouthd.conf` 显示 `PLYMOUTH_THEME_NAME=argvus`，并重建 initramfs。

**安装失败，签名验证不通过。**
你的密钥环中缺少存储库密钥或密钥已过期。重新导入当前公钥，然后 `sudo pacman -Sy`。

**锁屏 / 暂停看起来没有变化。**
该主题仅覆盖启动。休眠/恢复屏幕由其他方式单独控制
(`systemd-homed`，屏幕锁定器，`plymouth` 在 initramfs 的睡眠目标中的使用)。

**预览后仍有一个孤立的 Plymouth 进程在运行。**
`sudo plymouthquit` 会恢复你的会话。如果屏幕保持黑屏，请切换到
另一个虚拟终端 (`Ctrl+Alt+F2`) — 你的会话是完整的。

## 下一步

- [安装 ](/docs/argvus-boot-splash/installation/) — 尝试使用不同的方法重试。
- [使用 ](/docs/argvus-boot-splash/usage/) — 命令速查表。
