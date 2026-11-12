---
title: 惯例和已知缺口
description: 房屋规则、文档地图和存储库审计结果。
---

# 约定和已知缺口

此仓库变更的内部规则，以及在审计过程中发现的不一致之处——值得修复而不是复制。

技术参考请参见 [主题架构](/docs/argvus-boot-splash/developer-guide/theme/)、[打包](/docs/argvus-boot-splash/developer-guide/packaging/) 和 [CI 与发布](/docs/argvus-boot-splash/developer-guide/ci-releases/)。

## 约定

- Shell：`set -euo pipefail`，缩进使用制表符，`printf`/`error` 消息输出到 stderr，`command -v` 能力检查，shellcheck 清理（参见 `.editorconfig`）。
- 永远不要写 `sha256sums=('SKIP')`；在 git 中保持 `sha256sums=()` 为空。
- 不要提交构建输出（`build/`）、包文件或生成的 `.PKGBUILD.local.*` 副本。
- 使用历史记录中使用的范围的约定提交（Conventional Commits）：`splash`、`layout`、`pkgbuild`、`release`、`chore`、`ci`、`build`、`docs`。
- 分支命名：`feat/…`、`fix/…`、`docs/…`、`chore/…`、`refactor/…`。
- 合并前需一个审阅者批准，使用 squash-merge。
- 许可：GPL-3.0-only。随 `/usr/share/licenses/argvus-boot-splash/LICENSE` 发布。
- 遵循 [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md) 和 [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md) 中的流程。

## 已知缺口

在审计代码库时发现的已记录不一致问题：

- `README.md` 宣传 `make test` 可用于直接预览 Plymouth，但在 [Makefile](https://github.com/argvus/argvus-boot-splash/blob/main/Makefile) 中不存在此目标。实际命令是 `sudo plymouth --show-splash` / `sudo plymouthquit`。
- `entry-line.png` 和 `logo-glow.png` 会随 payload 一起发布，并且被 `arch_check_splash_payload()` 需要，但 `argvus.script` 从未加载它们。要么将它们接入脚本，要么从 payload 和检查列表中删除它们。
- `src/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp` 已安装但从未注册到任何内容；[用户指南](/docs/argvus-boot-splash/uki-splash/) 记录了手动 `bootctl`/`ukify` 步骤。
- 官方文档位于代码库根目录（`README.md`, `DEVELOPMENT.md`），并与 `docs/` 中的指南重叠。保持它们一致
  在更改任何一项时。贡献政策（`CONTRIBUTING.md`, `SECURITY.md`）存放在组织 `.github` 仓库中。

## 文档地图

| 文档 | 受众 | 范围 |
| --- | --- | --- |
| `README.md` | 所有人 | 一段概述和布局 |
| `DEVELOPMENT.md` | 维护者 | 构建、签名、发布流程 |
| [`CONTRIBUTING.md`](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md) (组织 `.github`) | 贡献者 | git 流程、PR 规则、保密政策 |
| [`docs/user-guide.md`](/docs/argvus-boot-splash/) | 终端用户 | 安装、使用、故障排除 |
| [`docs/developer-guide.md`](/docs/argvus-boot-splash/developer-guide/) | 开发者 | 主题内部、打包、CI |
