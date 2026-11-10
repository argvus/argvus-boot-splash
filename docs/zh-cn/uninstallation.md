---
title: 卸载
description: 移除该软件包并恢复你之前的启动主题。
---
# 卸载

```sh
sudo pacman -Rns argvus-boot-splash
```
然后选择另一个主题并重建，否则旧的启动画面将保留在 initramfs 中：

```sh
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme
sudo mkinitcpio -P        # or: sudo dracut --regenerate-all
```

`pacman -Rns` 如果没有其他程序创建它，也会删除 `/etc/plymouth/plymouthd.conf`。

该软件包的卸载钩子仅打印提醒——它不会猜测您想要的主题，也不会修改您的 initramfs。

## 下一步

- [故障排除](/docs/argvus-boot-splash/troubleshooting/) —— 恢复之前的启动画面。
- [安装](/docs/argvus-boot-splash/installation/) —— 稍后重新安装。
