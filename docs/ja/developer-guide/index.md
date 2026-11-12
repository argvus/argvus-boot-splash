---
title: 開発者ガイド
description: ARGVUSの貢献者向けのアーキテクチャおよび開発ガイダンス。
---
# Argvus ブートスプラッシュ — 開発者ガイド

`argvus-boot-splash` リポジトリ向けの技術文書：Plymouthテーマがどのように構成されているか、Archパッケージがどのように作られるか、リリースがどのように署名され公開されるか。

ここにはコンパイルステップはありません — テーマはデータ（`.plymouth` ディスクリプタ、`.script`、および画像）と Arch パッケージレシピで構成されています。「ビルド」とは再現可能なパッケージを作成することを意味します:

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
make validate
make build      # -> build/dist/argvus-boot-splash-<version>-1-any.pkg.tar.zst
make install    # sudo pacman -U that file
```
変更をコミットする前に: `make validate && make build`、および新しい技術用語を`.cspell/custom-dictionary-workspace.txt`に追加してください。さもなければスペルチェックジョブが失敗します。

テーマを*使用*したいだけの場合は、[ユーザーガイド](/docs/argvus-boot-splash/)を読んでください。このファイルのプロセス指向の対応バージョン（gitフロー、シークレット、リリースプロセス）については、[DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md)および[CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)を参照してください。

## ガイド

| ガイド | 内容 |
| --- | --- |
| [テーマアーキテクチャ](/docs/argvus-boot-splash/developer-guide/theme/) | デスクリプタ、レンダリングモデル、アセットインベントリ、スクリプトウォークスルー、レイアウト定数、デザイントークン、UKIビットマップ、テーマの変更方法 |
| [パッケージング](/docs/argvus-boot-splash/developer-guide/packaging/) | 2つのPKGBUILD、共有`functions.sh`、インストールフック、ローカルビルドパイプライン、Makeターゲット、前提条件 |
| [CIとリリース](/docs/argvus-boot-splash/developer-guide/ci-releases/) | `validate.sh`、`ci.yml`、`release.yml`の手順、チェックサム、署名、秘密情報、公開とバージョニング |
| [規約と既知のギャップ](/docs/argvus-boot-splash/developer-guide/workflow/) | ハウスルール、ドキュメントマップ、リポジトリ監査中に見つかった不一致 |

## クイックリファレンス

| パス | それが何か |
| --- | --- |
| `src/usr/share/plymouth/themes/argvus/` | `/usr` の下にインストールされたテーマペイロード |
| `packaging/arch/{ci,local}/PKGBUILD` | リリースおよびローカルパッケージレシピ |
| `packaging/arch/common/functions.sh` | 共有 `prepare`/`check`/`package` |
| `tools/sh/pkgbuild_local.sh` | 決定論的タールボール + `makepkg` ドライバー |
| `tools/sh/validate.sh` | 必須の検証ゲート |
| `.github/workflows/` | `ci.yml`（検証、ビルド、スペルチェック）、`release.yml`（タグ `v*`） |

## その他の場所

- リポジトリのルート: [README.md](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)
- ユーザー向けドキュメント: [user guide](/docs/argvus-boot-splash/)
- 開発プロセス: [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md)
- 貢献: [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)
- セキュリティポリシー: [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md)
- ライセンス: [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE)
- ポルトガル語版: [Guia do desenvolvedor](/pt/docs/argvus-boot-splash/developer-guide/)
