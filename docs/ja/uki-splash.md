---
title: UKI と systemd-boot スプラッシュ
description: UKIブートフローでARGVUSスプラッシュビットマップを使用します。
---
# UKI と systemd-boot のスプラッシュ

このパッケージには、`argvus-uki-splash.bmp`（400x400、32ビット非圧縮BMP）も含まれています。これは UKI / systemd-boot のブートフロー向けで、スプラッシュ画像が initramfs から読み込まれるのではなく、統合カーネルイメージに埋め込まれることを目的としています。

このビットマップは Plymouth テーマでは使用されず、自動的に登録されるものもありません：埋め込みは UKI の構築方法に依存します。典型的な利用者は次の通りです:

```sh
# systemd: set the splash for the next boot (systemd >= 254)
bootctl --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp

# ukify, while building the UKI
ukify build --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp \
           --linux=... --initrd=... --microcode=...
```
画像が変更されるたびに UKI ビルド（または `bootctl set-splash`）を再実行し、別の場所でビルドする場合はファイルを ESP にコピーすることを忘れないでください。systemd-boot はビットマップをコンソールにスケーリングするため、正方形の画像は中央に表示されます。

mkinitcpio または dracut のみを使用する場合は、このファイルは完全に無視できます — 通常の [installation](/docs/argvus-boot-splash/installation/)] がそのパスをカバーしています。

## 次のステップ

- [Usage](/docs/argvus-boot-splash/usage/)]
- [Troubleshooting](/docs/argvus-boot-splash/troubleshooting/)]
