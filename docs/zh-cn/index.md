---
title: ARGVUS 启动画面
description: ARGVUS 桌面环境的 Plymouth 主题和安装指南
---

# ARGVUS 启动画面

Argvus 启动画面是 Argvus 桌面生态系统的 [Plymouth](https://www.freedesktop.org/wiki/Software/Plymouth/) 主题]。它显示在开机到图形会话启动之间的时间。

## 文档

本文档主要分为两个部分：

### 用户指南
面向终端用户和系统管理员的安装与使用指南。

| 指南 | 内容 |
| --- | --- |
| [安装](/docs/argvus-boot-splash/installation/) | 要求，三种安装选项，软件包挂钩的作用 |
| [使用](/docs/argvus-boot-splash/usage/) | 验证安装，重启前预览，切换或恢复主题，命令速查表 |
| [UKI 和 systemd-boot 启动画面](/docs/argvus-boot-splash/uki-splash/) | 在 UKI 启动流程中使用 `argvus-uki-splash.bmp` |
| [卸载](/docs/argvus-boot-splash/uninstallation/) | 移除软件包并恢复之前的主题 |
| [故障排除](/docs/argvus-boot-splash/troubleshooting/) | 常见症状及其原因 |
| [参考](/docs/argvus-boot-splash/reference/) | 已安装文件、软件包元数据、颜色值 |

### [开发者指南](/docs/argvus-boot-splash/developer-guide/)
供贡献者和维护者使用的技术文档。

- [主题 Architecture](/docs/argvus-boot-splash/developer-guide/theme/) — Plymouth 描述符、渲染模型和自定义
- [打包 Packaging](/docs/argvus-boot-splash/developer-guide/packaging/) — 构建管道和包配方
- [CI 和发布 Releases](/docs/argvus-boot-splash/developer-guide/ci-releases/) — 验证、测试和发布工作流

## 快速开始

对于基于 Arch 的系统：

```sh
sudo pacman -S argvus-boot-splash   # or: sudo pacman -U ./argvus-boot-splash-<version>-1-any.pkg.tar.zst
```
安装程序将主题设置为默认，并自动重新生成您的 initramfs。

---

- **仓库：** [github.com/argvus/argvus-boot-splash](https://github.com/argvus/argvus-boot-splash)
- **许可证：** GPL-3.0-only
- **错误报告：** [GitHub Issues](https://github.com/argvus/argvus-boot-splash/issues)
