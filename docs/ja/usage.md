---
title: 使用法
description: インストールを確認し、再起動せずにプレビューし、テーマを切り替えます。
---
# 使用方法

テーマの確認方法、再起動せずにプレビューする方法、およびテーマの切り替え方法。
インストールについては、[installation](/docs/argvus-boot-splash/installation/) を参照してください。

## インストールの確認

```sh
# theme is present?
ls /usr/share/plymouth/themes/argvus

# which theme is the default?
plymouth-set-default-theme          # prints, e.g.: argvus

# does Plymouth parse the theme without errors?
sudo plymouth --show-splash
```
## 再起動せずにプレビュー

```sh
sudo plymouth --show-splash   # shows the splash, simulating boot
sudo plymouthquit             # returns to your session
```
プレビューは、通常のユーザーとして実行する場合、polkit認証を求めることがあります。進行状況バーはシミュレートされた進行状況に応じて進みます。状態を強制することもできます:

```sh
sudo plymouth --show-details   # verbose boot messages instead of the splash
sudo plymouth --show-splash    # back to the splash
```
スプラッシュが表示されている間に、<kbd>Esc</kbd> を押して次の画面に切り替えます（スプラッシュ → 詳細 → スプラッシュ）。

## スプラッシュが表示するもの

| ステージ | 外観 |
| --- | --- |
| 起動 | ロゴ、ワードマーク、進行状況バーが約1秒でフェードインする |
| ブート中 | Plymouthが進行状況を報告するにつれてバーが左から埋まる |
| 暗号化ボリューム | スプラッシュが15%に暗くなり、バーの下にプロンプトテキストとマスクされた点が表示される |
| パスフレーズ承認 | ダイアログが消え、スプラッシュが元の不透明度に戻る |

## テーマの変更または元に戻す方法

```sh
# switch theme (any theme name under /usr/share/plymouth/themes)
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme

# then regenerate the initramfs
sudo mkinitcpio -P              # or: sudo dracut --regenerate-all
```
便利な設定ファイル:

| ファイル | 目的 |
| --- | --- |
| `/etc/plymouth/plymouthd.conf` | パッケージによって書き込まれた`PLYMOUTH_THEME_NAME=argvus` |
| `/etc/mkinitcpio.conf` | `HOOKS=(... plymouth ...)`には`plymouth`を必ず含める必要がある |
| `/etc/plymouth/plymouthd.conf`（再度） | `PLYMOUTH_TOGGLE_KEY`などはテーマごとではなくグローバルである |

## コマンドチートシート

| コマンド | 効果 |
| --- | --- |
| `sudo plymouth-set-default-theme argvus` | `argvus`をデフォルトテーマにする |
| `sudo plymouth-update-theme` | 実行中のPlymouthに変更を適用する |
| `sudo plymouth --show-splash` | 現在のセッションでスプラッシュを表示する |
| `sudo plymouth --show-details` | 代わりに詳細なブートメッセージを表示する |
| `sudo plymouthquit` | Plymouthを退出してセッションを復元する |
| `sudo mkinitcpio -P` | Archのinitramfsを再構築する |
| `sudo dracut --regenerate-all` | dracutでinitramfsを再構築する |

## 次のステップ

- [UKIとsystemd-bootのスプラッシュ](/docs/argvus-boot-splash/uki-splash/)
- [アンインストール](/docs/argvus-boot-splash/uninstallation/)
- [トラブルシューティング](/docs/argvus-boot-splash/troubleshooting/)
