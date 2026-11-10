---
title: 参考
description: 已安装的文件、软件包元数据和颜色值。
---

# 参考

该技术参考说明了该软件包安装的内容以及使用的值。

## 你得到的内容

| 组件 | 描述 |
| --- | --- |
| Argvus 标志 | 居中的标记，绘制在文字标识上方 |
| 文字标识 | 位于标志下方的 `ARGVUS` 文本 |
| 进度条 | 薄条，其宽度反映 Plymouth 的启动进度 |
| 密码对话框 | 带掩码输入字段的 LUKS 提示（`•` 项） |
| 淡入效果 | 当 Plymouth 启动时，启动画面在约 1 秒内淡入 |
| UKI 位图 | 用于基于 UKI / systemd-boot 启动的 `argvus-uki-splash.bmp` |

该软件包名称为 `argvus-boot-splash`，如果你已经安装了旧的 `argvus-plymouth` 软件包，它将替换该旧包。

## 已安装的文件

位于 `/usr/share/plymouth/themes/argvus/` 下：

| 文件 | 大小 | 用途 |
| --- | --- | --- |
| `argvus.plymouth` | — | 主题描述符（名称、描述、模块） |
| `argvus.script` | — | 主题脚本（Plymouth 自有的脚本语言） |
| `argvus-logo.png` | 256x256 | 标志，RGBA |
| `argvus-text.png` | 400x53 | 字标，RGBA |
| `progress-bar.png` | 400x4 | 进度条已填充部分 |
| `progress-bar-track.png` | 400x4 | 未填充轨道 |
| `entry-box.png` | 400x48 | 密码输入字段 |
| `entry-line.png` | 300x2 | 密码字段规则/下划线 |
| `bullet.png` | 12x12 | 遮掩字符 |
| `logo-glow.png` | 260x300 | 标志发光艺术 |
| `argvus-uki-splash.bmp` | 400x400, 32位 | UKI/systemd-boot 启动画位图 |

以及 `/usr/share/licenses/argvus-boot-splash/LICENSE` 的许可证。

## 软件包元数据

| 字段 | 值 |
| --- | --- |
| 名称 | `argvus-boot-splash` |
| 架构 | `any` |
| 依赖 | `plymouth` |
| 可选依赖 | `mkinitcpio`, `dracut` |
| 冲突 / 替换 | `argvus-plymouth` |
| 许可证 | GPL-3.0-only |

## 颜色

| 元素 | 颜色 |
| --- | --- |
| 背景 | `#111316` |
| 强调（徽标、字标、进度填充） | `#3590BD` |
| 进度轨道 | `#262933` |
| 密码提示文字 | 浅灰蓝色 (`#B8C4CE`) |

该主题在任何分辨率下均使用纯深色背景，因此它从不
在浅色与深色变体之间自动切换。

## 获取帮助

- 在项目的问题追踪器中报告错误和请求功能。
- 安全问题：请遵循 [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md) — 不要为漏洞公开创建问题。
- 源代码、构建和发布：仓库根目录 ([README](https://github.com/argvus/argvus-boot-splash/blob/main/README.md))。
- 贡献： [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)。
- 许可证： [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE)。

## 下一步

- [安装](/docs/argvus-boot-splash/installation/)
- [使用](/docs/argvus-boot-splash/usage/)
- [故障排除](/docs/argvus-boot-splash/troubleshooting/)
