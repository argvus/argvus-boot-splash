---
title: アンインストール
description: パッケージを削除して、以前の起動テーマを復元してください。
---
# アンインストール

```sh
sudo pacman -Rns argvus-boot-splash
```
それから別のテーマを選んで再構築してください。そうしないと、古いスプラッシュがinitramfsの中に残ります:

```sh
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme
sudo mkinitcpio -P        # or: sudo dracut --regenerate-all
```
`pacman -Rns` は、他に作成したものがなければ `/etc/plymouth/plymouthd.conf` も削除します。

パッケージの削除フックはリマインダーを表示するだけで、どのテーマを代わりに使用するかを推測したり、initramfs に手を加えたりはしません。

## 次のステップ

- [トラブルシューティング](/docs/argvus-boot-splash/troubleshooting/) — 以前のスプラッシュを復元する。
- [インストール](/docs/argvus-boot-splash/installation/) — 後で再インストールする。
