---
title: 参照
description: インストールされたファイル、パッケージのメタデータ、色の値。
---

# 参照

パッケージがインストールするものや使用する値に関する技術的な参照。

## 取得できるもの

| コンポーネント | 説明 |
| --- | --- |
| Argvusロゴ | センターマーク、ワードマークの上に描画される |
| ワードマーク | ロゴの下の`ARGVUS`テキスト |
| プログレスバー | Plymouthの起動進行状況を反映した細いバー |
| パスワードダイアログ | マスクされた入力フィールド（`•`の弾丸）付きLUKSプロンプト |
| フェードイン | Plymouth起動時に約1秒かけてスプラッシュがフェードイン |
| UKIビットマップ | UKI / systemd-bootベースの起動用`argvus-uki-splash.bmp` |

パッケージ名は`argvus-boot-splash`で、以前インストールしていた場合は古い`argvus-plymouth`パッケージを置き換えます。

## インストールされたファイル

`/usr/share/plymouth/themes/argvus/`の下:

| ファイル | サイズ | 用途 |
| --- | --- | --- |
| `argvus.plymouth` | — | テーマの記述子（名前、説明、モジュール） |
| `argvus.script` | — | テーマスクリプト（Plymouth独自のスクリプト言語） |
| `argvus-logo.png` | 256x256 | ロゴ、RGBA |
| `argvus-text.png` | 400x53 | ワードマーク、RGBA |
| `progress-bar.png` | 400x4 | プログレスバーの塗りつぶされた部分 |
| `progress-bar-track.png` | 400x4 | 塗りつぶされていないトラック |
| `entry-box.png` | 400x48 | パスワード入力フィールド |
| `entry-line.png` | 300x2 | パスワードフィールドのルール/下線 |
| `bullet.png` | 12x12 | マスクされた文字 |
| `logo-glow.png` | 260x300 | ロゴのグローアートワーク |
| `argvus-uki-splash.bmp` | 400x400, 32ビット | UKI/systemd-boot スプラッシュビットマップ |

さらに `/usr/share/licenses/argvus-boot-splash/LICENSE` にライセンスがあります。

## パッケージメタデータ

| フィールド | 値 |
| --- | --- |
| 名前 | `argvus-boot-splash` |
| アーキテクチャ | `any` |
| 依存関係 | `plymouth` |
| 任意の依存関係 | `mkinitcpio`, `dracut` |
| 競合 / 置換 | `argvus-plymouth` |
| ライセンス | GPL-3.0-only |

## 色

| 要素 | 色 |
| --- | --- |
| 背景 | `#111316` |
| アクセント（ロゴ、ワードマーク、進捗バーの塗りつぶし） | `#3590BD` |
| 進捗トラック | `#262933` |
| パスワード入力テキスト | ライトグレー青 (`#B8C4CE`) |

このテーマは任意の解像度で濃いソリッド背景を使用するため、
ライトとダークのバリアントを自動的に切り替えることはありません。

## ヘルプを得る

- バグを報告し、機能のリクエストをプロジェクトのイシュートラッカーで行ってください。
- セキュリティの問題: [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md) に従ってください — 脆弱性については公開のイシューを開かないでください。
- ソース、ビルド、リリース: リポジトリのルート ([README](https://github.com/argvus/argvus-boot-splash/blob/main/README.md))。
- 貢献: [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)。
- ライセンス: [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE)。

## 次のステップ

- [インストール](/docs/argvus-boot-splash/installation/)
- [使用方法](/docs/argvus-boot-splash/usage/)
- [トラブルシューティング](/docs/argvus-boot-splash/troubleshooting/)
