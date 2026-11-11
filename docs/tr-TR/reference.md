---
title: Reference
description: Yüklenen dosyalar, paket meta verileri ve renk değerleri.
---

# Reference

Paketin neleri kurduğuna ve hangi değerleri kullandığına dair teknik referans.

## Aldığınız şey

| Component | Description |
| --- | --- |
| Argvus logosu | Ortalanmış işaret, kelime işaretinin üzerine çizilmiş |
| Wordmark | `ARGVUS` text below the logo |
| İlerleme çubuğu | Genişliği Plymouth'un önyükleme ilerlemesini yansıtan ince çubuk |
| Parola iletişim kutusu | Maskeleme alanı bulunan LUKS istemi (`•` bullets) |
| Solma Başlangıcı | Plymouth başladığında efekt yaklaşık 1 saniye içinde görünür |
| UKI bitmap |`argvus-uki-splash.bmp`UKI / systemd-boot tabanlı önyüklemeler için |

Paket adı `argvus-boot-splash` olup, daha önce kuruluysa eski
`argvus-plymouth` paketinin yerini alır.

## Kurulan dosyalar

`/usr/share/plymouth/themes/argvus/` altında:

| File | Size | Purpose |
| --- | --- | --- |
| `argvus.plymouth` | — | theme descriptor (name, description, module) |
| `argvus.script` | — | the theme script (Plymouth's own scripting language) |
| `argvus-logo.png` | 256x256 | logo, RGBA |
| `argvus-text.png` | 400x53 | wordmark, RGBA |
| `progress-bar.png` | 400x4 | filled part of the progress bar |
| `progress-bar-track.png` | 400x4 | unfilled track |
| `entry-box.png` | 400x48 | password entry field |
| `entry-line.png` | 300x2 | password field rule/underline |
| `bullet.png` | 12x12 | masked character |
| `logo-glow.png` | 260x300 | logo glow artwork |
| `argvus-uki-splash.bmp` | 400x400, 32-bit | UKI/systemd-boot splash bitmap |

Artı `/usr/share/licenses/argvus-boot-splash/LICENSE` lisansı.

## Paket meta verileri

| Field | Value |
| --- | --- |
| Name | `argvus-boot-splash` |
| Architecture | `any` |
| Depends | `plymouth` |
| Optional depends | `mkinitcpio`, `dracut` |
| Conflicts / replaces | `argvus-plymouth` |
| License | GPL-3.0-only |

## Colors

| Element | Color |
| --- | --- |
| Background | `#111316` |
| Accent (logo, wordmark, progress fill) | `#3590BD` |
| Progress track | `#262933` |
| Password prompt text | light gray-blue (`#B8C4CE`) |

Tema herhangi bir çözünürlükte koyu bir arka plan kullanır, bu yüzden asla
ışık ve koyu varyantlar arasında otomatik olarak geçiş yapmaz.

## Yardım almak

- Hataları bildirin ve özellik taleplerini proje sorun izleyicisinde iletin.
- Güvenlik sorunları: [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md) dosyasını takip edin — kamuya açık bir
  issue for vulnerabilities.
- Kaynağı, yapıları ve sürümleri açmayın: depo kökü ([README](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)).
- Katkıda Bulunma: [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md).
- Lisans: [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE).

## Sonraki adımlar

- [Kurulum](/docs/argvus-boot-splash/installation/)
- [Kullanım](/docs/argvus-boot-splash/usage/)
- [Sorun Giderme](/docs/argvus-boot-splash/troubleshooting/)
