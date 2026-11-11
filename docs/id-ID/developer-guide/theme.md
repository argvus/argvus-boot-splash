---
title: Theme Architecture
description: Bagaimana deskriptor Plymouth, aset, dan skrip disusun.
---

# Arsitektur tema

Bagaimana tema Plymouth disusun: deskriptor, kumpulan aset, dan apa
`argvus.script` melakukan, bagian demi bagian.

Untuk kemasan dan rilis, lihat [packaging](/docs/argvus-boot-splash/developer-guide/packaging/) dan
[CI dan rilis](/docs/argvus-boot-splash/developer-guide/ci-releases/). Untuk penggunaan, lihat
[panduan pengguna](/docs/argvus-boot-splash/).

## Descriptor

Tema Plymouth adalah deskriptor deklaratif yang diinterpretasikan oleh skrip Plymouth
mesin. Ada dua bagian:

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

- `ModuleName=script` memilih interpreter skrip bawaan Plymouth. Tidak ada
modul yang dikompilasi; `ImageDir` dan `ScriptFile` harus **jalur absolut**,
karena initramfs memiliki direktori kerja yang berbeda dari sesi Anda.
- Nama file adalah nama tema: `argvus.plymouth` ⇒ tema `argvus`, yang merupakan
apa yang dipilih `plymouth-set-default-theme argvus`.
- `argvus.script` adalah satu-satunya file kode. Ini dijalankan di dalam VM tertanam Plymouth
(terkait ke `plymouthd` dan initramfs). Pembatasan yang mengikuti dari
  that: tidak ada I/O file, tidak ada thread, tidak ada proses eksternal, tidak ada floating point,
`MathInt` adalah satu-satunya aritmetika Anda, dan bahasa ini adalah dialek kecil seperti C
(array adalah objek berkunci, `Sprite()` objek harus dibuat sebelum digunakan).

## Model render

- Satu latar belakang padat datar (`Window.SetBackgroundTopColor` /
  `SetBackgroundBottomColor`).
- **Sprites** adalah satu-satunya primitif gambar. Setiap `Sprite()` memiliki gambar, sebuah
posisi `(x, y)`, sebuah **z-order** dan opasitas di `[0, 1]`. Kemudian `SetPosition`
panggilan menang; tidak ada grafik adegan.
- Kemajuan digambar dengan re-`ImageScale`-ing sebuah gambar setiap frame dan memanggil
`SetImage` pada sprite — tidak ada kliping atau primitif gambar parsial.
- Laporan Plymouth menyatakan melalui callback yang didaftarkan oleh skrip:
  `PlymouthSetBootProgressFunction`, `PlymouthSetDisplayPasswordFunction`,
  `PlymouthSetDisplayNormalFunction`, `PlymouthSetRefreshFunction`.
- `Plymouth.SetRefreshRate(20)` membuat callback penyegaran berjalan pada 20 FPS;
Animasi bertimed satu-satunya dari tema (fade-in) bergantung padanya.

## Inventaris aset

Semua aset berada di `src/usr/share/plymouth/themes/argvus/`. Lebar gambar

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
| `entry-line.png`| 300x2 | palet 1-bit | aturan entri/garis bawah | tidak (lihat[kesenjangan yang diketahui](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)) |
| `logo-glow.png`| 260x300 | palet 8-bit | karya seni logo bersinar | tidak (lihat [kesenjangan yang diketahui](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)) |
| `argvus-uki-splash.bmp` | 400x400 | BMP 32-bit | UKI / systemd-boot splash | tidak (dihabiskan oleh boot loader) |

digunakan sebagai unit tata letak: wordmark adalah lebar referensi
(400 px pada skala 1.0) dan jalur progres, bilah progres, serta bidang entri kata sandi
semuanya berasal darinya, sehingga komposisi tetap konsisten jika aset wordmark
diekspor ulang.

`arch_check_splash_payload()` di `packaging/arch/common/functions.sh` memerlukan
**semua** file di atas untuk ada; menambahkan aset berarti menambahkannya ke daftar itu. Lihat
[pengemasan](/docs/argvus-boot-splash/developer-guide/packaging/#shared-functions).

## Panduan skrip

`src/usr/share/plymouth/themes/argvus/argvus.script`, dari atas ke bawah.

### 1. Background

```js
Window.SetBackgroundTopColor(0.0667, 0.0745, 0.0863);
Window.SetBackgroundBottomColor(0.0667, 0.0745, 0.0863);
```

Nilai yang sama di atas dan bawah ⇒ pengisian rata, tanpa gradien. Komponen-komponennya adalah
Saluran 8-bit dari `#111316` dibagi dengan 255.

### 2. Aset dan penskalaan

Setiap gambar dimuat melalui `Image("name")`, yang diselesaikan relatif terhadap
`ImageDir`. Penskalaan bersifat eksplisit:

```js
logo.base_scale = 0.72;
logo.base_width = MathInt(logo.original_image.GetWidth() * logo.base_scale);
logo.frame[logo.base_width] = ImageScale(logo.original_image, logo.base_width,
                                         logo.base_height);
logo.image = logo.frame[logo.base_width];
```

Cache `logo.frame[...]` bersifat disengaja: `ImageScale` pada setiap frame akan
alokasikan gambar baru per frame; logo diskalakan sekali dan disimpan dalam cache berdasarkan lebar target
sehingga resize hanya membutuhkan entri baru.

Wordmark mengikuti ide yang sama di `text.scale = 0.80`, tetapi diskalakan sekali
secara inline. Lacak kemajuan dan bar kemudian diskalakan ke `text.image.GetWidth()` —
yaitu batang selalu sesuai dengan lebar tanda kata, apa pun
pixel size is.

### 3. Layout

lebar sebenarnya dari tanda kata. Setiap elemen disejajarkan di sumbu horizontal jendela:

```js
logo.x = Window.GetX() + Window.GetWidth() / 2 - logo.image.GetWidth() / 2;
logo.y = Window.GetY() + Window.GetHeight() / 2 - logo.image.GetHeight() / 2 - 35;
```

Perhatikan `- 35`: tumpukan disejajarkan pada seluruh komposisi (logo +
tanda kata + jalur), bukan hanya logo, sehingga blok terletak sedikit di atas
tengah vertikal layar. Penempatan vertikal kemudian relatif terhadap
elemen sebelumnya (`text.y = logo.y + logo.image.GetHeight() + 16`,
`progress_track.y = text.y + text.image.GetHeight() + 28`, …), yang berarti
komposisi berskala sebagai satu unit dengan resolusi.

Z-order used here:

| Z | Sprite |
| --- | --- |
| 100 | logo, wordmark, progress track |
| 101 | progress bar (above the track) |
| 200 | password entry field |
| 201 | password prompt text |
| 202 | password bullets |

### 4. Progres boot

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

Terdaftar dengan `PlymouthSetBootProgressFunction(progress_callback)`. Penjepit
matters: gambar dengan lebar nol tidak valid di beberapa versi Plymouth, jadi bilah
tidak pernah sepenuhnya hilang, dan kemajuan tidak pernah melebihi lebar jalur.
Posisi sprite tetap; hanya lebar gambar yang berubah — tidak ada pengisian atau pemotongan
operation is used.

### 5. Dialog kata sandi

`display_password_callback(prompt, bullets)`:

1. Meredupkan splash: `logo.opacity = 0.15` dan wordmark di `0.15`, sementara trek dan bar
tetap di `1.0`.
2. Menampilkan prompt dengan `Image.Text(prompt, 0.72, 0.77, 0.81)` — satu-satunya
gambar yang dihasilkan saat runtime dalam tema. Posisisnya hanya diketahui di sini,
karena tergantung pada tinggi teks.
3. Menempatkan bidang entri di bawah prompt: `password.entry.y =
password.prompt.y + password.prompt.image.GetHeight() + 14`. Saat dimuat
`password.entry.y` adalah `0` dengan komentar bahwa posisi sebenarnya menunggu
   prompt.
4. Menggambar peluru dengan loop buat-atau-gunakan kembali:

   ```js
   for (index = 0; password.bullet[index] || index < bullets; index++)
   {
       if (!password.bullet[index]) { /* create sprite + image */ }
       /* ...position at entry.x + 16 + index * bullet.width ... */
       if (index < bullets) sprite.SetOpacity(1); else sprite.SetOpacity(0);
   }
   ```

Sprite dikumpulkan dan digunakan kembali di berbagai prompt alih-alih dibuat ulang;
Peluru basi disembunyikan dengan opasitas `0`. Peluru dipusatkan secara vertikal
   terhadap tinggi bidang entri.

`display_normal_callback()` adalah inversnya: itu mengembalikan opasitas `1.0`, menyembunyikan
prompt, entri dan setiap peluru yang dikumpulkan. Terdaftar dengan
`PlymouthSetDisplayNormalFunction`, Plymouth menyebutnya ketika kata sandi adalah
diterima atau dibatalkan dan boot berlanjut.

Consequence: `logo.opacity` adalah sebuah variabel, bukan sebuah konstanta, karena kedua efek memudar
dan status kata sandi berkembang menjadi itu.

### 6. Muncul secara perlahan

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

Callback penyegaran terus berjalan selama seluruh proses boot (ini murah dan Plymouth
memanggilnya terus-menerus); penjaga `fade.complete` membuatnya menjadi no-op setelah animasi
. Logo menggunakan `logo.opacity * fade.opacity` alih-alih penugasan
biasa sehingga keadaan yang diredupkan oleh kata sandi tetap ada setelah fading: setelah
fade selesai, `fade.opacity == 1` dan logo menunjukkan `logo.opacity` lagi.

Revisi sebelumnya dari tema ini juga memiliki animasi pulse/spawn; mereka
dihapus di `0.2.0` ("chore: hapus efek pulse"). Jangan perkenalkan kembali animasi
per-frame dari progress bar — bar harus tetap menjadi representasi yang setia dari
boot progress.

## Konstanta tata letak

Sumber kebenaran tunggal untuk menyetel komposisi:

| Constant | Value | Meaning |
| --- | --- | --- |
| `logo.base_scale` | `0.72` | logo scale vs. its native 256x256 |
| `logo.y` offset | `-35`| mengangkat blok yang berada di tengah di atas setengah layar |
| `text.scale` | `0.80` | wordmark scale vs. its native 400x53 |
| `text.y` gap | `+16` | logo bottom → wordmark top |
| `progress_track.y` gap | `+28` | wordmark bottom → track top |
| `password.prompt.y` gap | `+24` | track bottom → prompt text top |
| `password.entry.y` gap | `+14` | prompt bottom → entry field top |
| bullet x offset | `+16` | entry left → first bullet |
| `logo.opacity` (dialog) | `0.15` | splash dimming while a passphrase is requested |
| prompt color | `0.72, 0.77, 0.81` | `Image.Text` RGB, ~`#B8C4CE` |
| fade | 20 frames @ 20 FPS | ~1 s fade-in |

## Token desain

| Token | Hex | Where it lives |
| --- | --- | --- |
| Background | `#111316` | script (`0.0667, 0.0745, 0.0863`) |
| Accent | `#3590BD` | logo / wordmark / progress fill pixels |
| Progress track | `#262933` | `progress-bar-track.png` |
| Prompt text | `#B8C4CE` | script (`Image.Text` call) |

Warna aksen dan trek sudah termasuk dalam aset PNG, tidak diekspresikan dalam skrip
, jadi mewarnai ulang berarti mengekspor ulang aset (atau mengedit palet).
Tema ini hanya gelap dan tidak memiliki varian terang.

## Format bitmap UKI

`argvus-uki-splash.bmp` adalah BMP Windows 400x400, 32-bit yang tidak dikompresi
(`PC bitmap, Windows 98/2000 and newer format, 400 x 400 x 32`). Ini adalah aset
mandiri: skrip Plymouth tidak pernah memuatnya, dan paket Arch
tidak mendaftarkannya di mana pun — menyematkannya ke dalam UKI adalah langkah pengguna (lihat
[panduan pengguna](/docs/argvus-boot-splash/uki-splash/)).

Jika Anda menggantinya, tetap gunakan BMP 32-bit biasa yang tidak dikompresi dengan ukuran yang sebanding;
systemd-boot dan `ukify` tidak menskalakan format arbitrer dan gambar besar
memakan banyak memori saat boot awal.

## Mengubah tema

Practical loop:

1. Edit `src/usr/share/plymouth/themes/argvus/argvus.script` (dan/atau PNG).
2. Pasang ke Plymouth live Anda, atau pratinjau dari pohon sumber:

   ```sh
   sudo cp -r src/usr/share/plymouth/themes/argvus/* \
              /usr/share/plymouth/themes/argvus/
   sudo plymouth-set-default-theme argvus
   sudo plymouth --show-splash    # check, then: sudo plymouthquit
   ```

3. `make validate && make build` sebelum melakukan commit.

Aturan yang menjaga tema tetap bekerja:

- Jangan pernah memperkenalkan API non-Plymouth. Mesin ini adalah dialek terbatas; periksa
versi target dari `plymouth` yang Anda dukung sebelum menggunakan API yang belum Anda
  used before.
- `ImageDir`/`ScriptFile` dalam `argvus.plymouth` harus tetap absolut dan harus cocok dengan
jalur yang terinstal `/usr/share/plymouth/themes/argvus`.
- Pertahankan setiap aset yang tercantum di `arch_check_splash_payload()` tetap sinkron dengan
file yang dikirimkan di `src/` — pengemasan `check()` berjalan di CI.
- Lebar bilah kemajuan harus tetap menjadi fungsi setia dari kemajuan yang dilaporkan;
pengapit ke `[1, track width]` tidak boleh dihapus.
- Uji dialog kata sandi, bukan hanya layar awal: itu adalah keadaan yang paling
mungkin rusak dan yang paling diperhatikan oleh pengguna.
- Callback penyegaran dijalankan untuk seluruh proses boot; tetap alokasikan pekerjaan per-frame
  free where possible.
