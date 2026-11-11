---
title: Usage
description: Kurulumu doğrulayın, yeniden başlatmadan önizleyin ve temaları değiştirin.
---

# Usage

Temayı nasıl doğrulayacağınızı, yeniden başlatmadan nasıl önizleyeceğinizi ve temadan nasıl çıkacağınızı öğrenin.
Kurulum için, bkz. [kurulum](/docs/argvus-boot-splash/installation/).

## Kurulumu doğrulama

```sh
# theme is present?
ls /usr/share/plymouth/themes/argvus

# which theme is the default?
plymouth-set-default-theme          # prints, e.g.: argvus

# does Plymouth parse the theme without errors?
sudo plymouth --show-splash
```

## 

```sh
sudo plymouth --show-splash   # shows the splash, simulating boot
sudo plymouthquit             # returns to your session
```

Yeniden başlatmadan önizleme Yaparken önizleme, normal kullanıcı olarak çalıştırıldığında polkit kimlik doğrulaması isteyebilir.
İlerleme çubuğu simüle edilmiş ilerleme ile ilerler; ayrıca durumları zorlayabilirsiniz:

```sh
sudo plymouth --show-details   # verbose boot messages instead of the splash
sudo plymouth --show-splash    # back to the splash
```

Splash görüntülenirken, <kbd>Esc</kbd> tuşuna basarak bir sonraki ekrana geçebilirsiniz
(splash → details → splash).

## Splash gösteriyor

| Stage | Appearance |
| --- | --- |
| Başlangıç | Her şey yaklaşık 1 saniyede görünür hale gelir: logo, kelime işareti, ilerleme çubuğu |
| Başlatılıyor | Plymouth ilerlemeyi bildirirken çubuk soldan sağa doluyor |
| Şifrelenmiş hacim | Başlangıç ekranı %15'e kararır, yazı istemi metni ve maskelenmiş madde işaretleri çubuğun altında görünür |
| Parola kabul edildi | Diyalog kaybolur, açılış ekranı tam opaklığa geri döner |

## Tema değiştirme veya geri alma

```sh
# switch theme (any theme name under /usr/share/plymouth/themes)
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme

# then regenerate the initramfs
sudo mkinitcpio -P              # or: sudo dracut --regenerate-all
```

Useful configuration files:

| File | Purpose |
| --- | --- |
| `/etc/plymouth/plymouthd.conf` | `PLYMOUTH_THEME_NAME=argvus` written by the package |
| `/etc/mkinitcpio.conf` | `HOOKS=(... plymouth ...)` must include `plymouth` |
| `/etc/plymouth/plymouthd.conf` (again) | `PLYMOUTH_TOGGLE_KEY` etc. are global, not per-theme |

## Komutlar hile sayfası

| Command | Effect |
| --- | --- |
| `sudo plymouth-set-default-theme argvus` | make `argvus` the default theme |
| `sudo plymouth-update-theme` | apply the change to the running Plymouth |
| `sudo plymouth --show-splash` | show the splash in the current session |
| `sudo plymouth --show-details` | show verbose boot messages instead |
| `sudo plymouthquit` | leave Plymouth and restore your session |
| `sudo mkinitcpio -P` | rebuild the Arch initramfs |
| `sudo dracut --regenerate-all` | rebuild the initramfs with dracut |

## Sonraki adımlar

- [UKI ve systemd-boot açılış ekranı](/docs/argvus-boot-splash/uki-splash/)
- [Kaldırma](/docs/argvus-boot-splash/uninstallation/)
- [Sorun Giderme](/docs/argvus-boot-splash/troubleshooting/)
