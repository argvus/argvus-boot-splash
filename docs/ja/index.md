---
title: ARGVUS ブートスプラッシュ
description: ARGVUSデスクトップ環境のPlymouthテーマとインストールガイド
---

# ARGVUS ブートスプラッシュ

Argvus ブートスプラッシュは、Argvus デスクトップエコシステム用の [Plymouth](https://www.freedesktop.org/wiki/Software/Plymouth/) テーマ] です。マシンの電源を入れてからグラフィカルセッションが始まるまでに表示されるものです。

## ドキュメント

このドキュメントは、主に二つのセクションに分かれています。

### ユーザーガイド
エンドユーザーやシステム管理者向けのインストールおよび使用ガイドです。

| ガイド | 内容 |
| --- | --- |
| [インストール](/docs/argvus-boot-splash/installation/) | 要件、3つのインストールオプション、パッケージフックの役割 |
| [使用法](/docs/argvus-boot-splash/usage/) | インストールの確認、再起動せずにプレビュー、テーマの切り替えや元に戻す、コマンドチートシート |
| [UKI と systemd-boot スプラッシュ](/docs/argvus-boot-splash/uki-splash/) | UKI ブートフローで `argvus-uki-splash.bmp` を使用する方法 |
| [アンインストール](/docs/argvus-boot-splash/uninstallation/) | パッケージの削除と以前のテーマの復元 |
| [トラブルシューティング](/docs/argvus-boot-splash/troubleshooting/) | よくある症状とその原因 |
| [リファレンス](/docs/argvus-boot-splash/reference/) | インストール済みファイル、パッケージメタデータ、カラーバリュー |

### [開発者向けガイド](/docs/argvus-boot-splash/developer-guide/)
コントリビューターおよびメンテナ向けの技術文書。

- [テーマ Architecture](/docs/argvus-boot-splash/developer-guide/theme/) — Plymouth ディスクリプタ、レンダリングモデル、カスタマイズ  
- [パッケージング](/docs/argvus-boot-splash/developer-guide/packaging/) — ビルドパイプラインとパッケージレシピ  
- [CI とリリース](/docs/argvus-boot-splash/developer-guide/ci-releases/) — 検証、テスト、およびリリースワークフロー  

## クイックスタート

Archベースのシステムの場合:

```sh
sudo pacman -S argvus-boot-splash   # or: sudo pacman -U ./argvus-boot-splash-<version>-1-any.pkg.tar.zst
```
インストーラーはテーマをデフォルトとして設定し、自動的にinitramfsを再生成します。

---

- **リポジトリ:** [github.com/argvus/argvus-boot-splash](https://github.com/argvus/argvus-boot-splash)
- **ライセンス:** GPL-3.0-only
- **バグ報告:** [GitHub Issues](https://github.com/argvus/argvus-boot-splash/issues)
