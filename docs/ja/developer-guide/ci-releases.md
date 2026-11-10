---
title: CIとリリース
description: 検証、継続的インテグレーション、署名、リリースワークフロー。
---
# CI とリリース

バリデーションゲート、継続的インテグレーションジョブ、リリースパイプライン、およびバージョニングルール。

パッケージ自体については [packaging](/docs/argvus-boot-splash/developer-guide/packaging/)] を参照してください。テーマについては [theme architecture](/docs/argvus-boot-splash/developer-guide/theme/)] を参照してください。

## バリデーション

`tools/sh/validate.sh` が必須ゲートです:

- `bash`、`makepkg`、`shellcheck` が必要;
- `shellcheck` + `bash -n` が `tools/sh/*.sh` および `packaging/arch/common/*.sh` 上で;
- 両方の PKGBUILDs のソースを取得し、抽出されたメタデータを比較 — リモートとローカルが一致する必要があります;
- `makepkg -p PKGBUILD --printsrcinfo` を `ci/` および `local/` 内で実行（makepkg が行う方法でファイルを解析）;
- `git diff --check` (空白/コンフリクトマーカー).

## 継続的インテグレーション

`.github/workflows/ci.yml`（`main`、`archlinux:latest` コンテナへの push/PR）:

1. `base-devel git namcap pacman-contrib shellcheck sudo`をインストールします;
2. `make validate`;
3. **権限のない**`builder`ユーザーとしてビルドします
   (`sudo -u builder env HOME=/home/builder make build`) — makepkgはrootでは実行できず、作業スペースは最初に`chown`されます;
4. 別の`spellcheck`ジョブがcspell.jsonとともに`cspell-action@v6`を実行します。

 `cspell.json` `namcap`はインストール時に`pkgbuild_local.sh`内で実行されるため、ローカルビルドでもCIと同じlintが表れます。スペルチェックの設定は`cspell.json`で、作業スペース辞書は`.cspell/custom-dictionary-workspace.txt`にあります — 新しい技術用語（シェルフラグ、ツール名）はその辞書に含める必要があり、そうでない場合はCIが失敗します。

## リリースパイプライン

`.github/workflows/release.yml` — トリガー: `v*`タグのプッシュ、または
t`workflow_dispatch`既存のタグ付き（制御された再ビルド）。同時実行グループ`release-<ref>`、キャンセルなし。

手順:

1. **タグのチェックアウト**（dispatchは`inputs.tag`を使用します）。
2. **バージョンステップ**: タグを `^v[0-9]+(\.[0-9]+)*([._+-][A-Za-z0-9]+)*$` に対して検証し、packaging/arch/remote/PKGBUILD 内の `url` が空の場合は失敗し、その後タグから  `packaging/arch/remote/PKGBUILD` `pkgver` を書き換えます。
3. **検証**: `make validate`。
4. 権限のない `builder` として **ビルド**: `updpkgsums`（実際の `sha256sums` を解決して検証）その後 `makepkg --nodeps --noconfirm --needed --cleanbuild --clean --check`。
   `.pkg.tar.zst` を探し、存在しない場合は失敗します。
5. パッケージに対して **namcap** を実行。
6. **署名**: `GPG_PRIVATE_KEY` を使い捨ての `GNUPGHOME` にインポート（`mktemp -d`、モード 700）、インポートされた秘密鍵が `GPG_KEY_ID`（短いIDまたはフィンガープリント）と一致することを検証し、--pinentry-mode loopback --passphrase-fd 0 で切り離された `.sig` を作成。
7. 新しい  `--pinentry-mode loopback --passphrase-fd 0` `GNUPGHOME` 内で署名を **検証** — 署名が検証されなければリリースは失敗します。
8. アーティファクトを **アップロード**（`upload-artifact@v4`、`retention-days: 1`、パッケージ +
   署名、`if-no-files-found: error`。
9. **公開**: `argvus/packages`を`PACKAGES_REPO_TOKEN`と確認し、パッケージと`.sig`を`public/arch/x86_64`にコピーし、`repo-add -R argvus.db.tar.gz <pkg>`を実行し、`argvus.db.tar.gz`、`argvus.files.tar.gz`、`argvus.db`および`argvus.files`に署名してから、`github-actions[bot]`としてコミットし、プッシュします。変更のない差分はコミットせずに0で終了します。
10. **GitHubリリース**: 生成されたノートおよびパッケージ + 署名をアセットとして`softprops/action-gh-release@v2`に。

## チェックサム、署名、および秘密

- `SKIP`はありません: `sha256sums`は常に実際のダイジェストであり、ビルド時（ローカル）または`updpkgsums`（リリースCI）経由で計算されます。
- リポジトリ内で`sha256sums=()`は**空**のままにしてください。
- リリースはGPGで署名されます（パッケージ`.sig`、`argvus.db.tar.gz`、`argvus.files.tar.gz`、`argvus.db`、`argvus.files`）。
- `GPG_PASSPHRASE`は空であってはならず、ワークフローは空のパスフレーズを拒否します。

キーを準備してください:

```sh
gpg --full-generate-key            # RSA 4096, no expiry recommended
gpg --list-secret-keys --with-colons | grep ^sec:   # note the KEY_ID
gpg --armor --export-secret-keys KEY_ID            # what the workflow imports
```
リポジトリの **設定 → シークレットと変数 → Actions** で:

| シークレット | 値 |
| --- | --- |
| `GPG_PRIVATE_KEY` | `gpg --armor --export-secret-keys KEY_ID` 出力 |
| `GPG_KEY_ID` | 予期されるキーIDまたはフィンガープリント |
| `GPG_PASSPHRASE` | サイニングキーの空でないパスフレーズ |
| `PACKAGES_REPO_TOKEN` | argvus/packages 上で `contents:write` を持つ PAT |

## リリースの公開

タグ付けする前に:

1. 実際のリポジトリで`argvus/packages`に`url`を入力してください:
   - GitHub:  `packaging/arch/remote/PKGBUILD` `url="https://github.com/argvus/argvus-boot-splash"` （ソースは`${url}/archive/refs/tags/v${pkgver}.tar.gz`を使用しています）;
   - GitLab: `source=`を`https://gitlab.com/argvus/argvus-boot-splash/-/archive/v${pkgver}/argvus-boot-splash-v${pkgver}.tar.gz`に調整してください;
   - `url`がない場合、リリースは**意図的に失敗**し、明確なメッセージが表示されます。
2. `packaging/arch/local/PKGBUILD`および`packaging/arch/remote/PKGBUILD`のバージョン/メタデータを同期してください。
3. タグを付けてプッシュしてください:

   ```sh
   git tag v0.1.0
   git push origin v0.1.0
   ```
ワークフローは、既存の `v*` タグを使用して手動で開始することもできます。
   `tag` 入力。制御された再構築に役立ちます。

## バージョン管理

- SemVer は `pkgver`、リリース数は `pkgrel` です。

## 開発者のトラブルシューティング

**「ソースの取得」でリリースが失敗します。** 空の `url`、`v*` タグが欠落している、または
ホストと一致しないアーカイブ URL 形式 (GitHub と GitLab tarball)
レイアウト）。ワークフローはタグパターンを検証し、空のタグの初期段階で失敗します。
`url`。

**`updpkgsums` はソースが見つかりません。** タグが存在し、前にプッシュされている必要があります。
リリースジョブが実行されます。ここで、ローカルにのみ存在するタグを使用したディスパッチは失敗します。

**`make validate` は「リモートとローカルの PKGBUILD メタデータが同期していません」と報告します。**
メタデータ フィールド (`source=` ではない) を 1 つの PKGBUILD から別の PKGBUILD にコピーします。

**新しい用語のスペルチェックが失敗します。** に追加します。
`.cspell/custom-dictionary-workspace.txt` (`argvus` 辞書、`addWords:
true`), not to `ignorePaths`。

**`sudo` が `make install` 内、または `libfakeroot.so … LD_PRELOAD` エラーで要求されました。** `package()` は install -Dm* を使用せずに `make install` を呼び出します。両方の PKGBUILD は `install -Dm*` を呼び出しますが、`arch_package_splash_payload` は呼び出しません；誰も `make` の呼び出しを再導入していないことを確認してください。

**`makepkg` は実行を拒否します。** ルートとして実行してはいけません。ビルドは通常のユーザーか `sudo -u <user> make build` として実行してください。

**パッケージはインストールされますが、スプラッシュは変更されません。** initramfs が再構築されていません。ローカルテストでは、再起動の代わりに `sudo plymouth --show-splash` を呼び出すか、`sudo mkinitcpio -P` / `sudo dracut --regenerate-all` で再構築してください。
