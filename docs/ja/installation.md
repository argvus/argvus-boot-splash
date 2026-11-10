---
title: インストール
description: 要件、インストールオプション、およびパッケージフックが何をするか。
---

# インストール

ArchベースのシステムでArgvusのブートスプラッシュを表示するために必要なすべて。

テーマの見た目や内容については、
[reference](/docs/argvus-boot-splash/reference/)]を参照してください。ソースから再構築する場合は、
[developer guide](/docs/argvus-boot-splash/developer-guide/)]を参照してください。

## 必要条件

- `plymouth`を使用しているArchベースのシステム（このパッケージはそれに依存します）。
- initramfsジェネレーター：**mkinitcpio**（Archのデフォルト）または**dracut**。
  インストーラーは存在する方を検出し、initramfsを再構築します。
- Plymouthはinitramfsの設定で有効にする必要があります。mkinitcpioを使用する場合、
  `plymouth`が`HOOKS`の`/etc/mkinitcpio.conf`リストに含まれていることを確認してください。

  ```ini
  HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont plymouth)
  ```
これを変更した場合は再起動してください。

- 通常のグラフィカルセッションでは何も必要ありません；テーマはブートパスでのみ実行されます。

## オプション1：公式パッケージリポジトリ（推奨）

署名付きパッケージはArgvusパッケージリポジトリ（`argvus/packages`、パス`public/arch/$arch`）に公開されています。`/etc/pacman.conf`に追加してください：

```ini
[argvus]
SigLevel = Required DatabaseOptional
Server = <PACKAGES_REPO_BASE_URL>/argvus/packages/raw/branch/main/public/arch/$arch
```
`<PACKAGES_REPO_BASE_URL>` を、プロジェクトがリポジトリを公開しているホスト（GitHub、GitLab、または Gitea）に置き換えてください。まずリポジトリの署名キーをインポートしてください。さもないと `pacman` がダウンロードを拒否します:

```sh
# 1. import the project's public signing key into your pacman keyring
pacman-key --add /path/to/argvus-signing-key.asc
pacman-key --lsign <key-id>

# 2. refresh and install
sudo pacman -Sy
sudo pacman -S argvus-boot-splash
```
## オプション2：パッケージファイルのリリース

各タグ付きリリースは、リリースアセットとして`.pkg.tar.zst`（およびその`.sig`）を公開します。直接インストールしてください:

```sh
sudo pacman -U ./argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```
サプライチェーンの衛生管理を重視する場合は、インストールする前に、プロジェクトの公開鍵を使って分離済みの署名を検証してください:

```sh
gpg --verify argvus-boot-splash-0.2.0-1-any.pkg.tar.zst.sig \
        argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```
## オプション3: 手動インストール

Arch以外のシステムで有用、またはテーマをパッケージ化せずに試してみたい場合に便利です。テーマディレクトリをPlymouthのテーマパスにコピーしてください:

```sh
sudo cp -r src/usr/share/plymouth/themes/argvus \
           /usr/share/plymouth/themes/argvus

sudo plymouth-set-default-theme argvus
sudo update-initramfs -u        # Debian/Ubuntu
# or: sudo mkinitcpio -P        # Arch
# or: sudo dracut --regenerate-all
```
Plymouthは、`/etc/default/grub`で`GRUB_CMDLINE_LINUX`を使用して`splash`を含む形で有効にすることもでき、`quiet`はクラシックな最小ブート感を提供します。

## インストーラーが行うこと

インストールやアップグレードの後、パッケージのフックは自動的に実行されます：

1. `plymouth-set-default-theme argvus` — `argvus` を `/etc/plymouth/plymouthd.conf` に書き込みます。
2. mkinitcpio が存在する場合は `mkinitcpio -P`、存在しない場合は `dracut --regenerate-all`。

どちらのジェネレーターも見つからない場合、インストーラーは警告を表示し、initramfs を自分で再構築する必要があります。テーマの変更は initramfs が再生成された後にのみブート時に反映されます — このステップをスキップして再起動することが「スプラッシュが変更されなかった」最も一般的な原因です。

パッケージの削除時には、単にリマインダーを表示します：異なるテーマを選択して initramfs を再構築する作業はユーザーに委ねられます。詳細は [uninstallation](/docs/argvus-boot-splash/uninstallation/) を参照してください。

## 次のステップ

- [Usage](/docs/argvus-boot-splash/usage/) — インストールを確認し、再起動せずにプレビューし、テーマを切り替えます。
- [UKI and systemd-boot splash](/docs/argvus-boot-splash/uki-splash/) — UKIでビットマップを使用します。
- [Troubleshooting](/docs/argvus-boot-splash/troubleshooting/) — スプラッシュが変更されなかった場合。
