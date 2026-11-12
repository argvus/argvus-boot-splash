---
title: 包装
description: Archパッケージのメタデータ、ビルドパイプライン、およびMakeターゲット。
---
# パッケージング

Arch パッケージがどのように定義され、作成されるか：2つの PKGBUILD、共有関数、インストールフック、ローカルビルドパイプライン、および Make ターゲット。

テーマ自体については [theme architecture](/docs/argvus-boot-splash/developer-guide/theme/) を参照；検証、CI、およびリリースについては [CI and releases](/docs/argvus-boot-splash/developer-guide/ci-releases/) を参照。

## 2つの PKGBUILD、1つのペイロード

`packaging/arch/remote/PKGBUILD` と `packaging/arch/local/PKGBUILD` は `source=` を除いて同一である：

| | `local` | `ci` |
| --- | --- | --- |
| ソース | `${pkgname}-${pkgver}.tar.gz`（`make build` によってビルド） | `${url}/archive/refs/tags/v${pkgver}.tar.gz` |
| 使用者 | 開発者、`make build` | GitHub Actions リリース |

両方とも `packaging/arch/common/functions.sh` から同じ関数を呼び出し、`tools/sh/validate.sh` はそのメタデータ（`pkgname`、`pkgver`、`pkgrel`、`pkgdesc`、`arch`、`license`、`depends`、`makedepends`、`options`）が同一であることをアサートするため、両者は静かにずれることはできません。

共有メタデータ:

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
## 共有関数

`packaging/arch/common/functions.sh` は、両方の PKGBUILD で使用される三つの関数を提供します:

- `arch_normalize_source_tree`（`prepare()`）— GitHubのタグアーカイブを`<repo>-v<version>`に展開します。一方、ローカルのtarballは`<pkgname>-<pkgver>`に展開されます。これは、単一のトップレベルディレクトリを`${srcdir}/${pkgname}-${pkgver}`に名前変更し、ソースディレクトリが存在しない、曖昧である、または宛先が既に存在する場合にエラーを出します。
- `arch_check_splash_payload`（`check()`）— 抽出されたソース内のすべてのテーマアセットが存在することを確認します。これはパッケージ唯一の「テストスイート」です。必要なファイルのリストは[asset inventory](/docs/argvus-boot-splash/developer-guide/theme/#asset-inventory)にあります。
- `arch_package_splash_payload`（`package()`）— `src/usr`を`find -print0`とともに走査し、各ファイルを`install -Dm644`で`$pkgdir`にインストールします（NULセーフで、名前にスペースがあっても動作します）、その後`LICENSE`を`/usr/share/licenses/argvus-boot-splash/LICENSE`にインストールします。

package() 内には `make install` の呼び出しがないことに注意してください：すべてが  `package()` `install -Dm*` ですので、このパッケージは自己完結型で rootless ビルドに優しいです。これは意図的です — 以前の `package()` は `make install` を呼び出しており、`sudo`/`libfakeroot.so` の失敗を引き起こしていました。

## インストールフック

`packaging/arch/{ci,local}/argvus-boot-splash.install`（同一）：

- `post_install()` / `post_upgrade()` → `plymouth-set-default-theme argvus`、次に利用可能であれば `mkinitcpio -P`、さもなければ `dracut --regenerate-all`、どちらもなければ手動で再ビルドするようユーザーに警告。
- `post_remove()` → 情報メッセージのみ；テーマは自動で元に戻されません（推測より安全です）。

## ローカルビルドパイプライン

`tools/sh/pkgbuild_local.sh`（`make build` によって呼び出される）：

1. `makepkg`、`sha256sum`、`tar`、`awk`、`find` が存在すること、および PKGBUILD が存在することを確認；PKGBUILD をソースとして読み取り、`pkgname`/`pkgver` を検証する
   許可リスト正規表現に対して（名前には `^[a-z0-9@._+-]+$`、バージョンにはドット区切りのパターン）。
2. `build/artifacts/${pkgname}-${pkgver}.tar.gz` を `tar --sort=name --mtime='UTC 1970-01-01' --owner=0 --group=0 --numeric-owner` と `--transform "s#^\./#${pkgname}-${pkgver}/#"` で構築 — 決定的で再現可能なアーカイブ。`.git`、`build/`、`dist/`、`target/`、`tools/`、`release`/`packages-repo` のスクラッチディレクトリ、およびパッケージングディレクトリ内の `src/`、`pkg/` またはパッケージの残骸を除外する。
3. アーカイブの `sha256` を計算し、`sed` と共にローカル PKGBUILD の **一時コピー**（`.PKGBUILD.local.XXXXXX`、`EXIT` トラップで削除）に注入する。リポジトリは常に `sha256sums=()` を空に保つ；`SKIP` は決して使用されない。
4. build/dist/ から既存の `${pkgname}-${pkgver}-*.pkg.tar.zst` を削除し、古いパッケージがこのビルドと誤認されないようにする。
5. 次のコマンドを実行します `build/dist/` with ` with `/`/` in ` in ` および `PKGDEST` を `build/dist/` で。追加の引数は `makepkg` に転送されます；`MAKEPKG_FLAGS` はデフォルトのフラグセットを上書きします（意図的に単語分割されています）。
6. 正確に1つの `.pkg.tar.zst` が一致しない場合は失敗し、インストールされている場合はそれに `namcap` を実行します。

出力:

```text
build/dist/argvus-boot-splash-0.2.0-1-any.pkg.tar.zst   installable package
build/artifacts/argvus-boot-splash-0.2.0.tar.gz          source snapshot
build/artifacts/argvus-boot-splash/{src,pkg}/            makepkg work dirs
```
## Makeターゲット

| ターゲット | 効果 |
| --- | --- |
| `make build` (別名 `make package`) | `tools/sh/pkgbuild_local.sh` を実行 → `build/` |
| `make install` (別名 `make install-package`) | build/dist/ 内の単一パッケージを `sudo pacman -U`; カウントが正確に1でない場合はエラー |
|  `build/dist/` `make validate` | `tools/sh/validate.sh`: shellcheck + `bash -n` + PKGBUILD メタデータ同期 + PKGBUILD ごとの `makepkg --printsrcinfo` + `git diff --check` |
| `make lint` (別名 `make lint-shell`) | `tools`、`packaging/arch/common`、`src` に対する shellcheck（`SC1090`、`SC2034`、`SC2154` は無効）、`bash -n`、`git diff --check` |
| `make spellcheck` | cspell がインストールされていれば `cspell --config cspell.json .`、そうでなければスキップ |
|  `cspell` `make clean` | `rm -rf build/` |
| `make help` | ターゲットリスト (デフォルトゴール) |

CI は `make validate` と `make build` を実行; CI 内では `make install` は実行されない
(詳細は [known gaps](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps) を参照)

## 前提条件

`make`、`git`、`gnupg`、および`base-devel`グループを持つArchベースのシステム:

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
```
- `pacman-contrib` は `updpkgsums` を提供します（PKGBUILD のチェックサムを再生成します）。
- `shellcheck` はリポジトリのシェルスクリプトおよび共有の Arch パッケージング関数を検証します。
- 任意: `namcap`（パッケージのリンティング）および cspell（ローカルのスペルチェック）。CI はこれらすべてをインストールします。
