---
title: テーマ建築
description: Plymouthのディスクリプタ、アセット、スクリプトがどのように組み合わされるか。
---

# テーマアーキテクチャ

Plymouthテーマの構成方法：ディスクリプタ、アセットセット、そして
`argvus.script` が各セクションで何をするか。

パッケージ化とリリースについては [packaging](/docs/argvus-boot-splash/developer-guide/packaging/) および
[CI and releases](/docs/argvus-boot-splash/developer-guide/ci-releases/) を参照してください。使用方法については
[user guide](/docs/argvus-boot-splash/) を参照してください。

## ディスクリプタ

Plymouthテーマは、Plymouthのスクリプトエンジンによって解釈される宣言型ディスクリプタです。構成は2つの部分に分かれています：

`src/usr/share/plymouth/themes/argvus/argvus.plymouth`:

```ini
[Plymouth Theme]
Name=Argvus
Description=Argvus boot splash theme
ModuleName=script

[script]
ImageDir=/usr/share/plymouth/themes/argvus
ScriptFile=/usr/share/plymouth/themes/argvus/argvus.script
```
ノート:

- `ModuleName=script` は Plymouth の組み込みスクリプトインタプリタを選択します。コンパイル済みモジュールはありません；`ImageDir` と `ScriptFile` は **絶対パス** である必要があります。なぜなら initramfs の作業ディレクトリはセッションのものとは異なるためです。
- ファイル名はテーマ名です：`argvus.plymouth` ⇒ テーマ `argvus`、これは `plymouth-set-default-theme argvus` が選択するものです。
- `argvus.script` が唯一のコードファイルです。これは Plymouth の埋め込み VM 内で実行されます（`plymouthd` と initramfs にリンクされています）。これにより生じる制約は以下の通りです：ファイル I/O は不可、スレッド不可、外部プロセス不可、浮動小数点不可、`MathInt` が唯一の算術演算であり、言語は小さな C ライクの方言です（配列はキー付きオブジェクトで、`Sprite()` オブジェクトは使用前に作成する必要があります）。

## レンダリングモデル

- 一つの平坦な単色背景（`Window.SetBackgroundTopColor` / `SetBackgroundBottomColor`）。
- **スプライト** は唯一の描画プリミティブです。各 `Sprite()` には画像、`(x, y)` の位置、**Zオーダー**、および `[0, 1]` における不透明度があります。後で `SetPosition` が win を呼びます；シーングラフはありません。
- 進行状況は、毎フレーム画像を再 `ImageScale` してスプライトで `SetImage` を呼び出すことで描画されます — クリッピングや部分描画プリミティブはありません。
- Plymouth は、スクリプトが登録するコールバックを通じて状態を報告します：`PlymouthSetBootProgressFunction`、`PlymouthSetDisplayPasswordFunction`、`PlymouthSetDisplayNormalFunction`、`PlymouthSetRefreshFunction`。
- `Plymouth.SetRefreshRate(20)` はリフレッシュコールバックを 20 FPS で実行させます；テーマの唯一のタイムアニメーション（フェードイン）はこれに依存しています。

## アセット一覧

すべてのアセットは `src/usr/share/plymouth/themes/argvus/` に存在します。

| ファイル | サイズ | フォーマット | 役割 | 使用者 `argvus.script` |
| --- | --- | --- | --- | --- |
| `argvus.plymouth` | — | INI | テーマ記述子 | `plymouthd` によって読み込まれる |
| `argvus.script` | — | プリマススクリプト | テーマロジック | はい |
| `argvus-logo.png` | 256x256 | RGBA 8ビット | メインロゴ | はい (`logo.base_scale = 0.72`) |
| `argvus-text.png` | 400x53 | RGBA 8ビット | `ARGVUS` ワードマーク | はい (`text.scale = 0.80`) |
| `progress-bar.png` | 400x4 | 1ビットパレット | 塗りつぶしバー | はい |
| `progress-bar-track.png` | 400x4 | 1ビットパレット | 未塗りトラック | はい |
| `entry-box.png` | 400x48 | RGB 16ビット | パスワード入力フィールド | はい |
| `bullet.png` | 12x12 | 4ビットパレット | マスクされた文字1つ | はい |
| `entry-line.png` | 300x2 | 1ビットパレット | 入力ルール/下線 | いいえ ([既知のギャップ](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)を参照]) |
| `logo-glow.png` | 260x300 | 8ビットパレット | ロゴ光彩アートワーク | いいえ ([既知のギャップ](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)を参照]) |
| `argvus-uki-splash.bmp` | 400x400 | BMP 32ビット | UKI / systemd-boot スプラッシュ | なし（ブートローダーによって使用される） |

画像の幅はレイアウト単位として使用されます：ワードマークが基準幅です
（スケール1.0で400px）、進行トラック、プログレスバー、およびパスワード入力フィールドはすべてそこから派生しているため、
ワードマークのアセットが再エクスポートされても構成が一貫します。

`arch_check_splash_payload()` は `packaging/arch/common/functions.sh` において
上記の**すべて**のファイルが存在する必要があります；アセットを追加する場合は、そのリストに追加してください。詳細は
[packaging](/docs/argvus-boot-splash/developer-guide/packaging/#shared-functions) を参照してください。

## スクリプトのウォークスルー

`src/usr/share/plymouth/themes/argvus/argvus.script`、上から下へ。

### 1. 背景

```js
Window.SetBackgroundTopColor(0.0667, 0.0745, 0.0863);
Window.SetBackgroundBottomColor(0.0667, 0.0745, 0.0863);
```
上と下の値が同じ ⇒ グラデーションなしのフラットな塗り。コンポーネントは、`#111316` の 8 ビットチャンネルを 255 で割ったものです。

### 2. アセットとスケーリング

すべての画像は `Image("name")` を通じて読み込まれ、`ImageDir` に対して相対的に解決されます。スケーリングは明示的です:

```js
logo.base_scale = 0.72;
logo.base_width = MathInt(logo.original_image.GetWidth() * logo.base_scale);
logo.frame[logo.base_width] = ImageScale(logo.original_image, logo.base_width,
                                         logo.base_height);
logo.image = logo.frame[logo.base_width];
```
`logo.frame[...]` キャッシュは意図的です：`ImageScale` を毎フレーム実行すると、フレームごとに新しい画像が割り当てられます。ロゴは一度スケーリングされ、ターゲット幅でキャッシュされるため、リサイズする場合は新しいエントリーが必要になるだけです。

ワードマークも同じ考えで `text.scale = 0.80` に従いますが、一度だけインラインでスケーリングされます。進行トラックとバーは次に `text.image.GetWidth()` にスケーリングされます — つまりバーは常にワードマークの幅と一致し、ワードマークの実際のピクセルサイズに関わらず一致します。

### 3. レイアウト

すべての要素はウィンドウの水平軸の中央に配置されます：

```js
logo.x = Window.GetX() + Window.GetWidth() / 2 - logo.image.GetWidth() / 2;
logo.y = Window.GetY() + Window.GetHeight() / 2 - logo.image.GetHeight() / 2 - 35;
```
`- 35`に注意してください：スタックはロゴだけでなく、全体の構成（ロゴ + ワードマーク + トラック）を中心に配置されているため、ブロックは画面の垂直中央より少し上に位置しています。垂直方向の配置は次の要素（`text.y = logo.y + logo.image.GetHeight() + 16`、`progress_track.y = text.y + text.image.GetHeight() + 28`、…）に相対して決定されるため、構成全体が解像度に応じて一つの単位としてスケールします。

ここで使用されるZ順序:

| Z | スプライト |
| --- | --- |
| 100 | ロゴ、ワードマーク、進捗トラック |
| 101 | 進捗バー（トラックの上） |
| 200 | パスワード入力フィールド |
| 201 | パスワードプロンプトテキスト |
| 202 | パスワードの弾丸 |

### 4. 起動進行

```js
fun progress_callback(duration, progress)
{
    width = MathInt(progress_bar.original_image.GetWidth() * progress);
    if (width < 1) width = 1;
    if (width > progress_bar.original_image.GetWidth())
        width = progress_bar.original_image.GetWidth();
    progress_bar.image = ImageScale(progress_bar.original_image, width,
                                     progress_bar.original_image.GetHeight());
    progress_bar.sprite.SetImage(progress_bar.image);
}
```
`PlymouthSetBootProgressFunction(progress_callback)` に登録済み。クランプが重要です：いくつかの Plymouth バージョンでは幅ゼロの画像は無効であるため、バーが完全に消えることはなく、進行状況がトラックの幅を超えることはありません。スプライトの位置は固定されており、画像の幅のみが変わります — 塗りつぶしやクリップ操作は使用されません。

### 5. パスワードダイアログ

`display_password_callback(prompt, bullets)`:

1. スプラッシュを暗くする: `logo.opacity = 0.15` とワードマークを `0.15` に配置し、トラックとバーは `1.0` のままにします。
2. `Image.Text(prompt, 0.72, 0.77, 0.81)` でプロンプトをレンダリングします — テーマ内で唯一ランタイム生成された画像です。その位置はここでのみわかります。なぜならテキストの高さに依存するからです。
3. プロンプトの下に入力欄を配置します: password.entry.y = password.prompt.y + password.prompt.image.GetHeight() + 14。ロード時には `password.entry.y` は `0` で、実際の位置はプロンプトを待つというコメントがあります。
4. 作成または再利用ループで弾丸を描画します:

   ```js
   for (index = 0; password.bullet[index] || index < bullets; index++)
   {
       if (!password.bullet[index]) { /* create sprite + image */ }
       /* ...position at entry.x + 16 + index * bullet.width ... */
       if (index < bullets) sprite.SetOpacity(1); else sprite.SetOpacity(0);
   }
   ```
スプライトは再作成されるのではなく、プロンプト間でプールされ再利用されます;
古い弾は不透明度`0`で非表示にされます。弾は入力フィールドの高さに対して垂直方向に中央揃えされています。

`display_normal_callback()`はその逆で: 不透明度`1.0`を復元し、プロンプト、入力およびすべてのプールされた弾を非表示にします。`PlymouthSetDisplayNormalFunction`に登録され、パスフレーズが承認または中止されたときにPlymouthが呼び出し、起動が続行されます。

結果として: `logo.opacity`は定数ではなく変数であり、フェードとパスワード状態の両方がこれに乗算されます。

### 6. フェードイン

```js
Plymouth.SetRefreshRate(20);
fun refresh_callback()
{
    if (!fade.complete) {
        fade.frame += 1;
        fade.opacity = fade.frame / 20;      /* 20 frames @ 20 FPS = 1s */
        if (fade.opacity > 1) fade.opacity = 1;
        text.sprite.SetOpacity(fade.opacity);
        progress_track.sprite.SetOpacity(fade.opacity);
        progress_bar.sprite.SetOpacity(fade.opacity);
        if (fade.frame >= 20) fade.complete = 1;
    }
    logo.sprite.SetOpacity(logo.opacity * fade.opacity);
}
```
リフレッシュコールバックはブート中ずっと動作し続けます（これは負荷が少なく、Plymouth が継続的に呼び出します）；`fade.complete` ガードはアニメーション後にこれを無効化します。ロゴは単純な代入ではなく `logo.opacity * fade.opacity` を使用して、パスワードによる暗転状態がフェード後も保持されるようにしています：フェード完了後、`fade.opacity == 1` が実行され、ロゴは再び `logo.opacity` を表示します。

このテーマの以前のバージョンにはパルス／スポーンアニメーションもありました；これらは `0.2.0`（"chore: remove pulse effects"）で削除されました。プログレスバーのフレームごとのアニメーションを再導入しないでください — バーはブート進行の忠実な表現でなければなりません。

## レイアウト定数

構成の調整のための唯一の真実の情報源:

| 定数 | 値 | 意味 |
| --- | --- | --- |
| `logo.base_scale` | `0.72` | ロゴのスケール（元の256x256に対して） |
| `logo.y` offset | `-35` | 中央ブロックを画面中央より上に持ち上げる |
| `text.scale` | `0.80` | ワードマークのスケール（元の400x53に対して） |
| `text.y` gap | `+16` | ロゴの下 → ワードマークの上 |
| `progress_track.y` gap | `+28` | ワードマークの下 → トラックの上 |
| `password.prompt.y` gap | `+24` | トラックの下 → プロンプトテキストの上 |
| `password.entry.y` gap | `+14` | プロンプトの下 → 入力フィールドの上 |
| bullet x offset | `+16` | 入力の左 → 最初の箇条書きの位置 |
| `logo.opacity` (dialog) | `0.15` | パスフレーズ要求中のスプラッシュの暗転 |
|プロンプトの色 | `0.72, 0.77, 0.81` | `Image.Text` RGB、~`#B8C4CE` |
| fade | 20 フレーム @ 20 FPS | 約1秒のフェードイン |

## デザイントークン

| トークン | 16進 | 配置場所 |
| --- | --- | --- |
| 背景 | `#111316` | スクリプト（`0.0667, 0.0745, 0.0863`） |
| アクセント | `#3590BD` | ロゴ / ワードマーク / 進行状況表示ピクセル |
| 進行トラック | `#262933` | `progress-bar-track.png` |
| プロンプトテキスト | `#B8C4CE` | スクリプト（`Image.Text` 呼び出し） |

アクセントとトラックの色はPNGアセットに組み込まれており、スクリプト内では表現されません。そのため、色を変更する場合はアセットを再エクスポートするか（またはパレットを編集する必要があります）。
テーマはダーク専用で、ライトバリアントはありません。

## UKI ビットマップ形式

`argvus-uki-splash.bmp` は400x400、32ビット非圧縮Windows BMP（`PC bitmap, Windows 98/2000 and newer format, 400 x 400 x 32`）です。
これは独立したアセットであり、Plymouthスクリプトはこれを読み込まず、Archパッケージもどこにも登録しません — UKIに埋め込むのはユーザー自身の作業です（[ユーザーガイド ](/docs/argvus-boot-splash/uki-splash/)を参照）。

もしそれを置き換える場合は、同等のサイズの圧縮されていない32ビットBMPのままにしてください。
systemd-bootと`ukify`は任意のフォーマットを拡大縮小せず、大きな画像は起動初期にメモリを大量に消費します。

## テーマの変更

実践的なループ:

1. `src/usr/share/plymouth/themes/argvus/argvus.script`（および/またはPNG）を編集します。
2. ライブPlymouthにインストールするか、ソースツリーからプレビューします:

   ```sh
   sudo cp -r src/usr/share/plymouth/themes/argvus/* \
              /usr/share/plymouth/themes/argvus/
   sudo plymouth-set-default-theme argvus
   sudo plymouth --show-splash    # check, then: sudo plymouthquit
   ```
3. コミットする前に`make validate && make build`。

テーマを機能させ続けるためのルール:

- 非Plymouth APIを導入してはいけません。エンジンは制限付き方言です。使ったことがないAPIを使用する前に、サポートする`plymouth`のターゲットバージョンを確認してください。
- argvus.plymouth内の`ImageDir`/`ScriptFile`は絶対パスのままにし、インストールされた `argvus.plymouth` `/usr/share/plymouth/themes/argvus`のパスと一致させる必要があります。
- `arch_check_splash_payload()`にリストされているすべてのアセットを、`src/`に含まれるファイルと同期させてください — `check()`でCI内で稼働するパッケージング。
- プログレスバーの幅は報告された進行状況に忠実な関数のままにすること。`[1, track width]`へのクランプは削除してはいけません。
- ブートスプラッシュだけでなく、パスフレーズダイアログもテストしてください。これは最も壊れやすく、ユーザーが最も気づく状態です。
- 更新コールバックはブート全体で実行されます。可能な限りフレームごとの作業割り当てを無料に保ってください。
