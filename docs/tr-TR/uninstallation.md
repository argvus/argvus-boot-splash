---
title: Uninstallation
description: Paketi kaldırın ve önceki önyükleme temanızı geri yükleyin.
---

# Uninstallation

```sh
sudo pacman -Rns argvus-boot-splash
```

Sonra başka bir tema seçin ve tekrar oluşturun, aksi takdirde eski açılış ekranı
initramfs:

```sh
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme
sudo mkinitcpio -P        # or: sudo dracut --regenerate-all
```

`pacman -Rns` ayrıca başka bir şey yoksa `/etc/plymouth/plymouthd.conf` öğesini de kaldırır
created it.

Paketin kaldırma kancası yalnızca bir hatırlatıcı yazdırır — hangi temayı
istediğinizi tahmin etmez ve initramfs’inize dokunmaz.

## Sonraki adımlar

- [Sorun Giderme](/docs/argvus-boot-splash/troubleshooting/) — önceki açılış ekranını geri yükleme.
- [Kurulum](/docs/argvus-boot-splash/installation/) — daha sonra yeniden yükleme.
