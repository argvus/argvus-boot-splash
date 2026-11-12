---
title: Referans
description: Yüklenen dosyalar, paket meta verileri ve renk değerleri.
---

# Referans

Paketin neleri kurduğuna ve hangi değerleri kullandığına dair teknik referans.

## Aldığınız şey

| Bileşen | Açıklama |
| --- | --- |
| Argvus logosu | Ortalanmış işaret, kelime işaretinin üzerine çizilmiş |
| Kelime İşareti | logonun altındaki `ARGVUS` metni |
| İlerleme çubuğu | Genişliği Plymouth'un önyükleme ilerlemesini yansıtan ince çubuk |
| Parola iletişim kutusu | Maskeleme alanı bulunan LUKS istemi (`•` bullets) |
| Solma Başlangıcı | Plymouth başladığında efekt yaklaşık 1 saniye içinde görünür |
| UKI bitmap |`argvus-uki-splash.bmp`UKI / systemd-boot tabanlı önyüklemeler için |

Paket adı `argvus-boot-splash` olup, daha önce kuruluysa eski
`argvus-plymouth` paketinin yerini alır.

## Kurulan dosyalar

`/usr/share/plymouth/themes/argvus/` altında:

| Dosya | Boyut | Amaç |
| --- | --- | --- |
| `argvus.plymouth` | — | tema tanımlayıcısı (ad, açıklama, modül) |
| `argvus.script` | — | tema komut dosyası (Plymouth'nun kendi komut dosyası dili) |
| `argvus-logo.png` | 256x256 | logosu, RGBA |
| `argvus-text.png` | 400x53 | marka işareti, RGBA |
| `progress-bar.png` | 400x4 | ilerleme çubuğunun doldurulmuş kısmı |
| `progress-bar-track.png` | 400x4 | doldurulmamış parça |
| `entry-box.png` | 400x48 | şifre giriş alanı |
| `entry-line.png` | 300x2 | şifre alanı kuralı/altı çizili |
| `bullet.png` | 12x12 | maskeli karakter |
| `logo-glow.png` | 260x300 | logo parıltılı sanat eseri |
| `argvus-uki-splash.bmp` | 400x400, 32 bit | UKI/systemd-önyükleme sıçrama bit eşlemi |

Artı `/usr/share/licenses/argvus-boot-splash/LICENSE` lisansı.

## Paket meta verileri

| Alan | Değer |
| --- | --- |
| İsim | `argvus-boot-splash` |
| Mimarlık | `any` |
| bağlıdır | `plymouth` |
| İsteğe bağlıdır | `mkinitcpio`, `dracut` |
| Çatışmalar / değiştirmeler | `argvus-plymouth` |
| Lisans | Yalnızca GPL-3.0 |

## Renkler

| Eleman | Renk |
| --- | --- |
| Arka Plan | `#111316` |
| Aksan (logo, marka işareti, ilerleme dolgusu) | `#3590BD` |
| İlerleme takibi | `#262933` |
| Şifre istemi metni | açık gri-mavi (`#B8C4CE`) |

Tema herhangi bir çözünürlükte koyu bir arka plan kullanır, bu yüzden asla
ışık ve koyu varyantlar arasında otomatik olarak geçiş yapmaz.

## Yardım almak

- Hataları bildirin ve özellik taleplerini proje sorun izleyicisinde iletin.
- Güvenlik sorunları: [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md) dosyasını takip edin — kamuya açık bir
  güvenlik açıkları sorunu.
- Kaynağı, yapıları ve sürümleri açmayın: depo kökü ([README](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)).
- Katkıda Bulunma: [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md).
- Lisans: [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE).

## Sonraki adımlar

- [Kurulum](/docs/argvus-boot-splash/installation/)
- [Kullanım](/docs/argvus-boot-splash/usage/)
- [Sorun Giderme](/docs/argvus-boot-splash/troubleshooting/)
