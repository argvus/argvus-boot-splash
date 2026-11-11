---
title: UKI ve systemd-boot Splash
description: Bir UKI başlatma akışında ARGVUS splash bitmap kullanın.
---

# UKI ve systemd-boot splash

Paket ayrıca `argvus-uki-splash.bmp` (400x400, 32 bit sıkıştırılmamış
BMP) içerir. Bu, UKI / systemd-boot önyükleme akışları için tasarlanmıştır; burada açılış resmi
,
initramfs.

'den okunmak yerine birleşik çekirdek imajına yerleştirilir. Bitmap, Plymouth teması tarafından *kullanılmaz* ve
siz otomatik olarak: onu yerleştirmek, UKI'nizi nasıl oluşturduğunuza bağlıdır. Görüntü değiştiğinde tipik
consumers are:

```sh
# systemd: set the splash for the next boot (systemd >= 254)
bootctl --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp

# ukify, while building the UKI
ukify build --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp \
           --linux=... --initrd=... --microcode=...
```

UKI derlemesini (veya `bootctl set-splash`) yeniden çalıştırın ve
başka bir yerde oluşturursanız dosyayı ESP'ye kopyalamayı unutmayın. systemd-boot
bitmap'i konsola ölçeklendirir, bu yüzden kare bir görüntü merkezde görünür.

Sadece mkinitcpio veya dracut kullanıyorsanız, bu dosyayı tamamen göz ardı edebilirsiniz —
normal [kurulum](/docs/argvus-boot-splash/installation/) bu yolu kapsar.

## Sonraki adımlar

- [Kullanım](/docs/argvus-boot-splash/usage/)
- [Sorun Giderme](/docs/argvus-boot-splash/troubleshooting/)
