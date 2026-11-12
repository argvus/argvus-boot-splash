---
title: Kurulum
description: Gereksinimler, kurulum seçenekleri ve paket kancalarının ne yaptığı.
---

# Kurulum

Argvus önyükleme açılış ekranını Arch tabanlı bir sistemde almak için ihtiyacınız olan her şey.

Temanın nasıl göründüğünü ve neler içerdiğini görmek için, bkz.
[referans](/docs/argvus-boot-splash/reference/). Bunun yerine kaynaktan yeniden oluşturmak için,
[geliştirici kılavuzuna](/docs/argvus-boot-splash/developer-guide/) bakın.

## Gereksinimler

- `plymouth` kullanan, Arch tabanlı bir sistem (paket buna bağlıdır).
- Bir initramfs oluşturucusu: **mkinitcpio** (Arch varsayılanı) veya **dracut**.
Yükleyici mevcut olanı tespit eder ve sizin için initramfs’i yeniden oluşturur.
- Plymouth, initramfs yapılandırmanızda etkinleştirilmelidir. mkinitcpio ile,
`plymouth`'nin /etc/mkinitcpio.conf'nin `HOOKS` listesinde olduğundan emin olun:

  ```ini
  HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont plymouth)
  ```

Bunu yeni değiştirdiyseniz yeniden başlatın.

- Normal bir grafik oturumu için hiçbir şeye gerek yok; tema yalnızca
  önyükleme yolu.

## Seçenek 1: resmi paket deposunda çalışır (önerilen)

İmzalı paketler Argvus paket deposunda yayımlanmıştır
( `/etc/mkinitcpio.conf` `argvus/packages`, yol `public/arch/$arch`). Bunu `/etc/pacman.conf`'ye ekleyin:

```ini
[argvus]
SigLevel = Required DatabaseOptional
Server = <PACKAGES_REPO_BASE_URL>/argvus/packages/raw/branch/main/public/arch/$arch
```

`<PACKAGES_REPO_BASE_URL>`'yi projenin yayınladığı ana bilgisayar ile değiştirin
depolama alanı (GitHub, GitLab veya Gitea) üzerinde. Önce depolama anahtarını içe aktarın,
aksi takdirde `pacman` indirmeyi reddeder:

```sh
# 1. import the project's public signing key into your pacman keyring
pacman-key --add /path/to/argvus-signing-key.asc
pacman-key --lsign <key-id>

# 2. refresh and install
sudo pacman -Sy
sudo pacman -S argvus-boot-splash
```

## Seçenek 2: paket dosyasını yayınla

Her etiketli sürüm, bir `.pkg.tar.zst` (ve ayrıca onun `.sig` sürümünü) yayınlar
varlık. Doğrudan kurun:

```sh
sudo pacman -U ./argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```

Tedarik zinciri hijyenine önem veriyorsanız, kurmadan önce ayrılmış imzayı
projesinin açık anahtarı ile doğrulayın:

```sh
gpg --verify argvus-boot-splash-0.2.0-1-any.pkg.tar.zst.sig \
        argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```

## Seçenek 3: manuel kurulum

Arch olmayan sistemlerde veya temayı sadece denemek istiyorsanız faydalıdır:
ambalajlama. Tema dizinini Plymouth'un tema yoluna kopyalayın:

```sh
sudo cp -r src/usr/share/plymouth/themes/argvus \
           /usr/share/plymouth/themes/argvus

sudo plymouth-set-default-theme argvus
sudo update-initramfs -u        # Debian/Ubuntu
# or: sudo mkinitcpio -P        # Arch
# or: sudo dracut --regenerate-all
```

Plymouth ayrıca `/etc/default/grub` içinde `GRUB_CMDLINE_LINUX` ile etkinleştirilebilir
`splash`'yu içerir ve `quiet` klasik minimal açılış hissini verir.

## Kurulumcunun yaptığı şey

Kurulum veya yükseltme sonrası, paket kancaları otomatik olarak çalışır:

1. `plymouth-set-default-theme argvus` — `argvus` öğesini
`/etc/plymouth/plymouthd.conf` içerisine yazar.
2. mkinitcpio mevcutsa, `mkinitcpio -P` aksi takdirde `dracut --regenerate-all`.

Her iki jeneratör de bulunamazsa, yükleyici bir uyarı verir ve initramfs'i kendiniz
yeniden oluşturmalısınız. Bir tema değişikliği, sadece
initramfs yeniden oluşturuluyor — bu adım olmadan yeniden başlatmak en tek
"splash değişmedi"nin yaygın nedeni

Kaldırıldığında paket yalnızca bir hatırlatıcı yazdırır: farklı bir tema seçmek ve
initramfs'in yeniden inşası size bırakılmıştır. Bakınız
[kaldırma](/docs/argvus-boot-splash/uninstallation/).

## Sonraki adımlar

- [Kullanım](/docs/argvus-boot-splash/usage/) — kurulumu doğrulama, yeniden başlatmadan önizleme,
  temalar.
- [UKI ve systemd-boot açılış ekranını değiştirme](/docs/argvus-boot-splash/uki-splash/) — UKI'deki bitmap'i kullanma.
- [Sorun Giderme](/docs/argvus-boot-splash/troubleshooting/) — eğer açılış ekranı değişmediyse.
