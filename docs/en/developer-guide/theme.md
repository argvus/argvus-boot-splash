---
title: Theme Architecture
description: How the Plymouth descriptor, assets, and script are put together.
---

# Theme architecture

How the Plymouth theme is put together: the descriptor, the asset set, and what
`argvus.script` does, section by section.

For packaging and releases see [packaging](/docs/argvus-boot-splash/developer-guide/packaging/) and
[CI and releases](/docs/argvus-boot-splash/developer-guide/ci-releases/). For usage, see the
[user guide](/docs/argvus-boot-splash/).

## Descriptor

Plymouth themes are declarative descriptors interpreted by Plymouth's script
engine. There are two parts:

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

Notes:

- `ModuleName=script` selects Plymouth's built-in script interpreter. There is no
  compiled module; `ImageDir` and `ScriptFile` must be **absolute paths**,
  because the initramfs has a different working directory than your session.
- The file name is the theme name: `argvus.plymouth` ⇒ theme `argvus`, which is
  what `plymouth-set-default-theme argvus` selects.
- `argvus.script` is the only code file. It runs inside Plymouth's embedded VM
  (linked into `plymouthd` and the initramfs). Constraints that follow from
  that: no file I/O, no threads, no external processes, no floating point,
  `MathInt` is your only arithmetic, and the language is a small C-like dialect
  (arrays are keyed objects, `Sprite()` objects must be created before use).

## Rendering model

- One flat solid background (`Window.SetBackgroundTopColor` /
  `SetBackgroundBottomColor`).
- **Sprites** are the only drawing primitives. Each `Sprite()` has an image, an
  `(x, y)` position, a **z-order** and an opacity in `[0, 1]`. Later `SetPosition`
  calls win; there is no scene graph.
- Progress is drawn by re-`ImageScale`-ing an image every frame and calling
  `SetImage` on the sprite — there is no clipping or partial-draw primitive.
- Plymouth reports state through callbacks the script registers:
  `PlymouthSetBootProgressFunction`, `PlymouthSetDisplayPasswordFunction`,
  `PlymouthSetDisplayNormalFunction`, `PlymouthSetRefreshFunction`.
- `Plymouth.SetRefreshRate(20)` makes the refresh callback run at 20 FPS; the
  theme's only timed animation (the fade-in) depends on it.

## Asset inventory

All assets live in `src/usr/share/plymouth/themes/argvus/`.

| File | Size | Format | Role | Used by `argvus.script` |
| --- | --- | --- | --- | --- |
| `argvus.plymouth` | — | INI | theme descriptor | loaded by `plymouthd` |
| `argvus.script` | — | Plymouth script | theme logic | yes |
| `argvus-logo.png` | 256x256 | RGBA 8-bit | main logo | yes (`logo.base_scale = 0.72`) |
| `argvus-text.png` | 400x53 | RGBA 8-bit | `ARGVUS` wordmark | yes (`text.scale = 0.80`) |
| `progress-bar.png` | 400x4 | 1-bit palette | filled bar | yes |
| `progress-bar-track.png` | 400x4 | 1-bit palette | unfilled track | yes |
| `entry-box.png` | 400x48 | RGB 16-bit | password entry field | yes |
| `bullet.png` | 12x12 | 4-bit palette | one masked character | yes |
| `entry-line.png` | 300x2 | 1-bit palette | entry rule/underline | no (see [known gaps](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)) |
| `logo-glow.png` | 260x300 | 8-bit palette | logo glow artwork | no (see [known gaps](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)) |
| `argvus-uki-splash.bmp` | 400x400 | BMP 32-bit | UKI / systemd-boot splash | no (consumed by the boot loader) |

Image width is used as the layout unit: the wordmark is the reference width
(400 px at scale 1.0) and the progress track, progress bar and password entry
field are all derived from it, so the composition stays coherent if the
wordmark asset is re-exported.

`arch_check_splash_payload()` in `packaging/arch/common/functions.sh` requires
**all** files above to exist; adding an asset means adding it to that list. See
[packaging](/docs/argvus-boot-splash/developer-guide/packaging/#shared-functions).

## Script walkthrough

`src/usr/share/plymouth/themes/argvus/argvus.script`, top to bottom.

### 1. Background

```js
Window.SetBackgroundTopColor(0.0667, 0.0745, 0.0863);
Window.SetBackgroundBottomColor(0.0667, 0.0745, 0.0863);
```

Same value top and bottom ⇒ a flat fill, no gradient. The components are the
8-bit channels of `#111316` divided by 255.

### 2. Assets and scaling

Every image is loaded through `Image("name")`, which resolves relative to
`ImageDir`. Scaling is explicit:

```js
logo.base_scale = 0.72;
logo.base_width = MathInt(logo.original_image.GetWidth() * logo.base_scale);
logo.frame[logo.base_width] = ImageScale(logo.original_image, logo.base_width,
                                         logo.base_height);
logo.image = logo.frame[logo.base_width];
```

The `logo.frame[...]` cache is intentional: `ImageScale` on every frame would
allocate a new image per frame; the logo is scaled once and cached by target
width so a resize only needs a new entry.

The wordmark follows the same idea at `text.scale = 0.80`, but it is scaled once
inline. Progress track and bar are then scaled to `text.image.GetWidth()` —
i.e. the bar always matches the wordmark width, whatever the wordmark's real
pixel size is.

### 3. Layout

Every element is centered on the window's horizontal axis:

```js
logo.x = Window.GetX() + Window.GetWidth() / 2 - logo.image.GetWidth() / 2;
logo.y = Window.GetY() + Window.GetHeight() / 2 - logo.image.GetHeight() / 2 - 35;
```

Note the `- 35`: the stack is centered on the whole composition (logo +
wordmark + track), not just the logo, so the block sits slightly above the
vertical middle of the screen. Vertical placement is then relative to the
previous element (`text.y = logo.y + logo.image.GetHeight() + 16`,
`progress_track.y = text.y + text.image.GetHeight() + 28`, …), which means the
composition scales as one unit with resolution.

Z-order used here:

| Z | Sprite |
| --- | --- |
| 100 | logo, wordmark, progress track |
| 101 | progress bar (above the track) |
| 200 | password entry field |
| 201 | password prompt text |
| 202 | password bullets |

### 4. Boot progress

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

Registered with `PlymouthSetBootProgressFunction(progress_callback)`. The clamp
matters: a zero-width image is invalid in some Plymouth versions, so the bar
never disappears entirely, and progress can never overshoot the track width.
The sprite position is fixed; only the image width changes — no fill or clip
operation is used.

### 5. Password dialog

`display_password_callback(prompt, bullets)`:

1. Dims the splash: `logo.opacity = 0.15` and wordmark at `0.15`, while the
   track and bar stay at `1.0`.
2. Renders the prompt with `Image.Text(prompt, 0.72, 0.77, 0.81)` — the only
   runtime-generated image in the theme. Its position is only known here,
   because it depends on the text height.
3. Positions the entry field below the prompt: `password.entry.y =
   password.prompt.y + password.prompt.image.GetHeight() + 14`. At load time
   `password.entry.y` is `0` with a comment that the real position waits for the
   prompt.
4. Draws bullets with a create-or-reuse loop:

   ```js
   for (index = 0; password.bullet[index] || index < bullets; index++)
   {
       if (!password.bullet[index]) { /* create sprite + image */ }
       /* ...position at entry.x + 16 + index * bullet.width ... */
       if (index < bullets) sprite.SetOpacity(1); else sprite.SetOpacity(0);
   }
   ```

   Sprites are pooled and reused across prompts instead of being recreated;
   stale bullets are hidden with opacity `0`. Bullets are centered vertically
   against the entry field height.

`display_normal_callback()` is the inverse: it restores opacity `1.0`, hides the
prompt, the entry and every pooled bullet. Registered with
`PlymouthSetDisplayNormalFunction`, Plymouth calls it when the passphrase is
accepted or aborted and boot continues.

Consequence: `logo.opacity` is a variable, not a constant, because both the fade
and the password state multiply into it.

### 6. Fade-in

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

The refresh callback keeps running for the whole boot (it is cheap and Plymouth
calls it continuously); the `fade.complete` guard makes it a no-op after the
animation. The logo uses `logo.opacity * fade.opacity` instead of a plain
assignment so that the dimmed-by-password state survives the fade: after the
fade completes, `fade.opacity == 1` and the logo shows `logo.opacity` again.

Earlier revisions of this theme also had pulse/spawn animations; they were
removed in `0.2.0` ("chore: remove pulse effects"). Do not reintroduce per-frame
animation of the progress bar — the bar must stay a faithful representation of
boot progress.

## Layout constants

Single source of truth for tuning the composition:

| Constant | Value | Meaning |
| --- | --- | --- |
| `logo.base_scale` | `0.72` | logo scale vs. its native 256x256 |
| `logo.y` offset | `-35` | lifts the centered block above mid-screen |
| `text.scale` | `0.80` | wordmark scale vs. its native 400x53 |
| `text.y` gap | `+16` | logo bottom → wordmark top |
| `progress_track.y` gap | `+28` | wordmark bottom → track top |
| `password.prompt.y` gap | `+24` | track bottom → prompt text top |
| `password.entry.y` gap | `+14` | prompt bottom → entry field top |
| bullet x offset | `+16` | entry left → first bullet |
| `logo.opacity` (dialog) | `0.15` | splash dimming while a passphrase is requested |
| prompt color | `0.72, 0.77, 0.81` | `Image.Text` RGB, ~`#B8C4CE` |
| fade | 20 frames @ 20 FPS | ~1 s fade-in |

## Design tokens

| Token | Hex | Where it lives |
| --- | --- | --- |
| Background | `#111316` | script (`0.0667, 0.0745, 0.0863`) |
| Accent | `#3590BD` | logo / wordmark / progress fill pixels |
| Progress track | `#262933` | `progress-bar-track.png` |
| Prompt text | `#B8C4CE` | script (`Image.Text` call) |

Accent and track colors are baked into the PNG assets, not expressed in the
script, so recoloring means re-exporting the assets (or editing the palette).
The theme is dark-only and has no light variant.

## UKI bitmap format

`argvus-uki-splash.bmp` is a 400x400, 32-bit uncompressed Windows BMP
(`PC bitmap, Windows 98/2000 and newer format, 400 x 400 x 32`). It is a
standalone asset: the Plymouth script never loads it, and the Arch package does
not register it anywhere — embedding it into a UKI is the user's step (see the
[user guide](/docs/argvus-boot-splash/uki-splash/)).

If you replace it, keep it a plain uncompressed 32-bit BMP of comparable size;
systemd-boot and `ukify` do not scale arbitrary formats and large images are
memory-hungry on early boot.

## Modifying the theme

Practical loop:

1. Edit `src/usr/share/plymouth/themes/argvus/argvus.script` (and/or the PNGs).
2. Install to your live Plymouth, or preview from the source tree:

   ```sh
   sudo cp -r src/usr/share/plymouth/themes/argvus/* \
              /usr/share/plymouth/themes/argvus/
   sudo plymouth-set-default-theme argvus
   sudo plymouth --show-splash    # check, then: sudo plymouthquit
   ```

3. `make validate && make build` before committing.

Rules that keep the theme working:

- Never introduce non-Plymouth APIs. The engine is a restricted dialect; check
  the target version of `plymouth` you support before using an API you have not
  used before.
- `ImageDir`/`ScriptFile` in `argvus.plymouth` must stay absolute and must match
  the installed path `/usr/share/plymouth/themes/argvus`.
- Keep every asset listed in `arch_check_splash_payload()` in sync with the
  files that ship in `src/` — the packaging `check()` runs in CI.
- Progress bar width must remain a faithful function of the reported progress;
  the clamp to `[1, track width]` must not be removed.
- Test the passphrase dialog, not just the boot splash: it is the state most
  likely to break and the one users notice most.
- The refresh callback runs for the whole boot; keep per-frame work allocation
  free where possible.
