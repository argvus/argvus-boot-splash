---
title: 慣例と既知のギャップ
description: ハウスルール、ドキュメントマップ、リポジトリ監査の結果。
---

# 慣例と既知のギャップ

このリポジトリでの変更に関するハウスルール、および監査時に見つかった不整合 — コピーするより修正する価値があります。

技術的な参照については、[テーマアーキテクチャ](/docs/argvus-boot-splash/developer-guide/theme/)、[パッケージング](/docs/argvus-boot-splash/developer-guide/packaging/)、および[CIおよびリリース](/docs/argvus-boot-splash/developer-guide/ci-releases/)を参照してください。

## 慣例

- シェル: `set -euo pipefail`、インデントにはタブを使用、`printf`/`error`は標準エラー出力へのメッセージ、`command -v`は機能チェック、shellcheckでクリーン (`.editorconfig`を参照)。
- 決して`sha256sums=('SKIP')`を書かないこと。`sha256sums=()`はgitで空のままにする。
- ビルド出力(`build/`)、パッケージファイル、または生成された`.PKGBUILD.local.*`のコピーをコミットしないこと。
- 履歴で使用されるスコープを持つConventional Commits: `splash`、`layout`、`pkgbuild`、`release`、`chore`、`ci`、`build`、`docs`。
- ブランチ命名: `feat/…`、`fix/…`、`docs/…`、`chore/…`、`refactor/…`。
- マージ前にはレビューアの承認1件が必要、スクワッシュマージ。
- ライセンス: GPL-3.0-only。`/usr/share/licenses/argvus-boot-splash/LICENSE`として出荷。
- [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md) と [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md) のプロセスに従うこと。

## 既知のギャップ

リポジトリを監査する際に発見された文書化された不整合:

- `README.md` は直接 Plymouth プレビュー用に `make test` を宣伝していますが、[Makefile](https://github.com/argvus/argvus-boot-splash/blob/main/Makefile) 内にそのようなターゲットは存在しません。実際のコマンドは `sudo plymouth --show-splash` / `sudo plymouthquit` です。
- `entry-line.png` と `logo-glow.png` はペイロードに含まれており、`arch_check_splash_payload()` により必要とされますが、`argvus.script` はこれらをロードしません。スクリプトに組み込むか、ペイロードとチェックリストから削除してください。
- `src/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp` はインストールされていますが、何にも登録されていません。[ユーザーガイド](/docs/argvus-boot-splash/uki-splash/) では手動での `bootctl`/`ukify` ステップを文書化しています。
- 正規のドキュメントはリポジトリのルート (`README.md`, `DEVELOPMENT.md`) にあり、`docs/` のガイドと重複しています。一貫性を保ってください。
  どちらかを変更する際。貢献ポリシー（`CONTRIBUTING.md`、`SECURITY.md`）は、組織`.github`のリポジトリにあります。

## ドキュメントマップ

| ドキュメント | 対象 | 範囲 |
| --- | --- | --- |
| `README.md` | 全員 | 1段落の概要とレイアウト |
| `DEVELOPMENT.md` | メンテナ | ビルド、署名、リリースプロセス |
| [`CONTRIBUTING.md`](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md) (組織 `.github`) | 貢献者 | gitフロー、PRルール、秘密保持ポリシー |
| [`docs/user-guide.md`](/docs/argvus-boot-splash/) | エンドユーザー | インストール、使用方法、トラブルシューティング |
| [`docs/developer-guide.md`](/docs/argvus-boot-splash/developer-guide/) | 開発者 | テーマの内部構造、パッケージング、CI |
