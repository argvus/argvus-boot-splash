---
title: 包装
description: Arch 包元数据、构建管道和 Make 目标。
---
# 打包

Arch 包的定义和生成方式：两个 PKGBUILDs、共享函数、安装钩子、本地构建管道和 Make 目标。

有关主题本身，请参见 [主题架构](/docs/argvus-boot-splash/developer-guide/theme/)]；有关验证、CI 和发布，请参见 [CI 和发布](/docs/argvus-boot-splash/developer-guide/ci-releases/)]。

## 两个 PKGBUILDs，一个负载

`packaging/arch/remote/PKGBUILD` 和 `packaging/arch/local/PKGBUILD` 是相同的，
除了 `source=`：

| | `local` | `ci` |
| --- | --- | --- |
| 来源 | `${pkgname}-${pkgver}.tar.gz`（由 `make build` 构建） | `${url}/archive/refs/tags/v${pkgver}.tar.gz` |
| 使用者 | 开发者, `make build` | GitHub Actions 发布 |

两者都调用来自 `packaging/arch/common/functions.sh` 的相同函数，并且 `tools/sh/validate.sh` 断言它们的元数据（`pkgname`、`pkgver`、`pkgrel`、`pkgdesc`、`arch`、`license`、`depends`、`makedepends`、`options`）是相同的，因此两者不会悄然偏移。

共享元数据：

```bash
pkgname=argvus-boot-splash
pkgver=0.2.0
pkgrel=1
arch=('any')                 # pure data package
depends=('plymouth')
optdepends=('mkinitcpio: rebuild initramfs (Arch Linux)'
            'dracut: rebuild initramfs (alternative)')
options=('!debug')
conflicts=('argvus-plymouth') # renamed predecessor
replaces=('argvus-plymouth')
```
## 共享功能

`packaging/arch/common/functions.sh` 提供了三个由 PKGBUILDs 共同使用的功能：

- `arch_normalize_source_tree` (`prepare()`) — GitHub 标签存档解压到 `<repo>-v<version>`，而本地 tar 包解压到 `<pkgname>-<pkgver>`。这会将单个顶级目录重命名为 `${srcdir}/${pkgname}-${pkgver}`，如果源目录缺失、模糊或目标已存在，则会报错。
- `arch_check_splash_payload` (`check()`) — 断言每个主题资产都存在于解压的源中。这是包的唯一“测试套件”；所需文件列表在 [asset inventory](/docs/argvus-boot-splash/developer-guide/theme/#asset-inventory)。
- `arch_package_splash_payload` (`package()`) — 使用 find -print0 遍历 `src/usr`，并将每个文件用  `find -print0` `install -Dm644` 安装到 `$pkgdir`（支持 NUL 安全，支持名称中包含空格），然后将 `LICENSE` 安装到 `/usr/share/licenses/argvus-boot-splash/LICENSE`。

请注意，在 package() 内没有 `make install` 调用：一切都是  `package()` `install -Dm*`，因此该包是自包含的，并且支持无根构建。这是有意为之 — 一个旧的 `package()` 调用 `make install` 会导致 `sudo`/`libfakeroot.so` 失败。

## 安装钩子

`packaging/arch/{ci,local}/argvus-boot-splash.install`（相同）：

- `post_install()` / `post_upgrade()` → `plymouth-set-default-theme argvus`，
  然后如果可用执行 `mkinitcpio -P`，否则执行 `dracut --regenerate-all`，否则给用户一个警告，提示手动重建。
- `post_remove()` → 仅信息性消息；主题不会自动切换回原来的样式（比猜测更安全）。

## 本地构建流程

`tools/sh/pkgbuild_local.sh`（由 `make build` 调用）：

1. 验证 `makepkg`、`sha256sum`、`tar`、`awk`、`find` 并确保 PKGBUILD 存在；获取 PKGBUILD 源代码以读取 `pkgname`/`pkgver` 并验证两者
   针对允许列表的正则表达式（`^[a-z0-9@._+-]+$` 用于名称，版本的点分格式模式）。
2. 使用  `build/artifacts/${pkgname}-${pkgver}.tar.gz` `tar --sort=name --mtime='UTC 1970-01-01' --owner=0 --group=0 --numeric-owner` 和 `--transform "s#^\./#${pkgname}-${pkgver}/#"` 构建 build/artifacts/${pkgname}-${pkgver}.tar.gz —— 一个确定性、可重现的归档。它排除了 `.git`、`build/`、`dist/`、`target/`、`tools/`、`release`/`packages-repo` 草稿目录，以及打包目录中任何 `src/`、`pkg/` 或包的残留物。
3. 计算归档的 `sha256`，并将其与 `sed` 注入到本地 PKGBUILD 的**临时副本**（`.PKGBUILD.local.XXXXXX`，由 `EXIT` 陷阱删除）中。仓库始终保持 `sha256sums=()` 为空；`SKIP` 从未被使用。
4. 删除 build/dist/ 中的任何预先存在的 `${pkgname}-${pkgver}-*.pkg.tar.zst`，这样陈旧的包就不会被误认为是此次构建。
5. 运行 `build/dist/` with ` with `/`/` in ` in ` 和 `PKGDEST` 在 `build/dist/` 中。额外的参数会转发到 `makepkg`；`MAKEPKG_FLAGS` 会覆盖默认的标志集（刻意进行单词分割）。
6. 除非恰好有一个 `.pkg.tar.zst` 匹配，否则会失败，然后如果已安装，则在其上运行 `namcap`。

输出:

```text
build/dist/argvus-boot-splash-0.2.0-1-any.pkg.tar.zst   installable package
build/artifacts/argvus-boot-splash-0.2.0.tar.gz          source snapshot
build/artifacts/argvus-boot-splash/{src,pkg}/            makepkg work dirs
```
## Make 目标

| 目标 | 功能 |
| --- | --- |
| `make build` (别名 `make package`) | 运行 `tools/sh/pkgbuild_local.sh` → `build/` |
| `make install` (别名 `make install-package`) | 在 build/dist/ 中 `sudo pacman -U` 单个包；如果数量不正好为 1 则报错 |
|  `build/dist/` `make validate` | `tools/sh/validate.sh`: shellcheck + `bash -n` + PKGBUILD 元数据同步 + 每个 PKGBUILD 的 `makepkg --printsrcinfo` + `git diff --check` |
| `make lint` (别名 `make lint-shell`) | 对 `tools`、`packaging/arch/common`、`src`（`SC1090`、`SC2034`、`SC2154` 已禁用）、`bash -n`、`git diff --check` 进行 shellcheck |
| `make spellcheck` | 如果已安装 cspell，则执行 `cspell --config cspell.json .`，否则跳过 |
|  `cspell` `make clean` | `rm -rf build/` |
| `make help` | 目标列表（默认目标） |

CI 运行 `make validate` 和 `make build`；CI 中没有运行 `make install` 的内容
(参见 [已知差距](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps))。

## 前提条件

一个基于 Arch 的系统，拥有 `make`、`git`、`gnupg` 以及 `base-devel` 组：

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
```

- `pacman-contrib` 提供 `updpkgsums`（重新生成 PKGBUILD 校验和）。
- `shellcheck` 验证仓库的 shell 脚本和共享的 Arch 打包函数。
- 可选：`namcap`（包检查）和 cspell（本地拼写检查）。CI 会安装它们全部。
