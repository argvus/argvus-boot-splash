---
title: ARGVUS Önyükleme Sıçraması
description: ARGVUS masaüstü ortamı için Plymouth teması ve kurulum rehberi
---

# ARGVUS Başlangıç Ekranı

Argvus boot splash, Argvus masaüstü ekosistemi için bir [Plymouth](https://www.freedesktop.org/wiki/Software/Plymouth/) temasıdır. Bu, cihazı açtığınız ile grafik oturumunuzun başladığı an arasındaki görüntülediğiniz şeydir.

## Dokümantasyon

Bu dokümantasyon iki ana bölümde düzenlenmiştir:

### Kullanıcı Kılavuzu
Son kullanıcılar ve sistem yöneticileri için kurulum ve kullanım rehberleri.

| Kılavuzu | İçindekiler |
| --- | --- |
| [Kurulum](/docs/argvus-boot-splash/installation/)| Gereksinimler, üç kurulum seçeneği, paket kancalarının ne yaptığı |
| [Kullanım](/docs/argvus-boot-splash/usage/)| Kurulumu doğrulayın, yeniden başlatmadan önizleme yapın, temaları değiştirin veya geri alın, komut hilesi sayfası |
| [UKI ve systemd-boot açılış ekranı](/docs/argvus-boot-splash/uki-splash/)| Kullanarak `argvus-uki-splash.bmp`Bir UKI önyükleme akışında |
| [Kaldırma](/docs/argvus-boot-splash/uninstallation/)| Paketi kaldırma ve önceki temayı geri yükleme |
| [Sorun Giderme](/docs/argvus-boot-splash/troubleshooting/)| Yaygın belirtiler ve nedenleri |
| [Reference](/docs/argvus-boot-splash/reference/)yüklenen ve kullanıcı yolları için.

### [Geliştirici Rehberi](/docs/argvus-boot-splash/developer-guide/)
Katkıda bulunanlar ve bakımcılar için teknik dokümantasyon.

- [Tema Mimarisi](/docs/argvus-boot-splash/developer-guide/theme/) — Plymouth tanımlayıcısı, render modeli ve özelleştirme
- [Paketleme](/docs/argvus-boot-splash/developer-guide/packaging/) — Derleme hattı ve paket tarifleri
- [CI ve Sürümler](/docs/argvus-boot-splash/developer-guide/ci-releases/) — Doğrulama, test ve sürüm iş akışı

## Hızlı Başlangıç

Arch tabanlı sistemler için:

```sh
sudo pacman -S argvus-boot-splash   # or: sudo pacman -U ./argvus-boot-splash-<version>-1-any.pkg.tar.zst
```

Kurucu, temayı varsayılan olarak ayarlar ve initramfs'inizi otomatik olarak yeniden oluşturur.

---

- **Depo:** [github.com/argvus/argvus-boot-splash](https://github.com/argvus/argvus-boot-splash)
- **Lisans:** Yalnızca GPL-3.0
- **Hata Bildirimleri:** [GitHub Issues](https://github.com/argvus/argvus-boot-splash/issues)
