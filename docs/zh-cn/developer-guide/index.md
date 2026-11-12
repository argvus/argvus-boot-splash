---
title: 开发者指南
description: ARGVUS 贡献者的架构与开发指南。
---
# Argvus 启动画面 — 开发者指南

`argvus-boot-splash` 仓库的技术文档：介绍 Plymouth 主题的构建方式、Arch 包的构建方法，以及发布版本的签名和发布流程。

这里没有编译步骤——主题本身是数据（一个 `.plymouth` 描述文件、一个 `.script` 文件和图片）加上一个 Arch 包的配方。“构建”意味着生成可复现的包：

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
make validate
make build      # -> build/dist/argvus-boot-splash-<version>-1-any.pkg.tar.zst
make install    # sudo pacman -U that file
```
在提交更改之前：`make validate && make build`，并将新技术术语添加到 `.cspell/custom-dictionary-workspace.txt`，否则拼写检查任务将失败。

如果你只想*使用*该主题，请阅读 [用户指南](/docs/argvus-boot-splash/)。有关此文件的面向流程的对应文件（git 流程、机密、发布流程），请参见 [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md) 和 [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)。

## 指南

| 指南 | 内容 |
| --- | --- |
| [主题架构](/docs/argvus-boot-splash/developer-guide/theme/) | 描述符、渲染模型、资源清单、脚本演练、布局常量、设计令牌、UKI 位图、如何修改主题 |
| [打包](/docs/argvus-boot-splash/developer-guide/packaging/) | 两个 PKGBUILD、共享 `functions.sh`、安装钩子、本地构建管道、Make 目标、前置条件 |
| [CI 和发布](/docs/argvus-boot-splash/developer-guide/ci-releases/) | `validate.sh`、`ci.yml`、`release.yml` 步骤、校验和、签名、机密、发布和版本控制 |
| [约定和已知差距](/docs/argvus-boot-splash/developer-guide/workflow/) | 内部规则、文档地图，以及在审核仓库时发现的不一致之处 |

## 快速参考

| 路径 | 它是什么 |
| --- | --- |
| `src/usr/share/plymouth/themes/argvus/` | 安装在 `/usr` 下的主题负载 |
| `packaging/arch/{ci,local}/PKGBUILD` | 发布和本地包配方 |
| `packaging/arch/common/functions.sh` | 共享 `prepare`/`check`/`package` |
| `tools/sh/pkgbuild_local.sh` | 确定性 tar 包 + `makepkg` 驱动 |
| `tools/sh/validate.sh` | 必需的验证关卡 |
| `.github/workflows/` | `ci.yml`（验证、构建、拼写检查）、`release.yml`（标记 `v*`） |

## 其他地方

- 仓库根目录: [README.md](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)
- 面向用户的文档: [用户指南](/docs/argvus-boot-splash/)
- 开发流程: [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md)
- 贡献指南: [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)
- 安全策略: [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md)
- 许可: [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE)
- 葡萄牙语版本: [开发者指南](/pt/docs/argvus-boot-splash/developer-guide/)
