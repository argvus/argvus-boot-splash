---
title: Sorun giderme
description: Yaygın başlatma splash belirtileri ve bunların nasıl düzeltileceği.
---

# Sorun giderme

**Yükledikten sonra splash değişmedi.**
initramfs yeniden oluşturulmadı. `sudo mkinitcpio -P` çalıştırın (veya
`sudo dracut --regenerate-all`) ve sistemi yeniden başlatın. Sisteminiz birden çok kernel kullanıyorsa,
Başlattığınız sistemin yeni initramfs'i aldığından emin olun.

**Hiç açılış ekranı yok; ekran siyah veya sadece metin gösteriyor.**
`plymouth` initramfs kancalarından eksik. `/etc/mkinitcpio.conf`
`HOOKS=(...)`, `plymouth` içeriyor, sonra yeniden oluşturun ve yeniden başlatın. Ubuntu/Debian'da,
ayrıca `plymouth` ve `plymouth-x11`/`plymouth-themes`'nun yüklü olduğunu da doğrulayın ve
`GRUB_CMDLINE_LINUX`, `splash quiet`'ya sahiptir.

**Sadece logo, ilerleme yok.**
Bazı önyükleme adımları init tarafından bildirilmez veya ilerleme geri çağrısı
hiç aramadım — senin tarafında hiçbir şey kırık değil. Çubuk Plymouth'dan doluyor
rapor edilen ilerleme, bazı kurulumlarda mevcut değil (örneğin systemd'nin
`plymouth-spawn`-olmayan dizileri veya belirli dracut modülleri ile).

**Parola istemi yanlış yerde veya görünmez.**
Diyalog, kelime işareti ve iz geometrisinden konumlandırılmıştır, bu yüzden aşırı
çözünürlükler (çok küçük metin modu) ekran dışına itebilir. Normal bir
çözünürlüğü kullanın ve yaygın çözünürlüklerde olursa bildiriniz.

**Plymouth erken kapanıyor / metin konsolunu görüyorsunuz.**
Bir şey Plymouth'u devre dışı bıraktı: `quiet` önyükleme parametresi `splash` olmadan, bir
`plymouth` kancası kaldırıldı veya Plymouth'un kullanamayacağı bir sürücü var. Plymouth, makineyi dondurmak yerine
metin konsoluna çıkar — bu beklenen bir davranıştır.

**Yükseltme sonrasında tema uygulanmadı `argvus-plymouth`.**
Yeni paket eski paketin yerine geçer; doğrulayın `/etc/plymouth/plymouthd.conf` diyor
`PLYMOUTH_THEME_NAME=argvus` ve initramfs'i yeniden oluşturun.

**Kurulum, imza doğrulamasında başarısız oluyor.**
Depo anahtarı anahtar zincirinizde eksik veya güncel değil. Mevcut
açık anahtarı yeniden içe aktarın, sonra `sudo pacman -Sy`.

**Kilit ekranı / askıya alma değişmemiş görünüyor.**
Tema yalnızca önyüklemeyi kapsar. Uyku/geri dönüş ekranları ayrı ayrı kontrol edilir
(`systemd-homed`, ekran kilitleri, `plymouth` kullanımınız
initramfs).

hedefinde uyku sırasında **Bir deneme sonrası Plymouth hâlâ çalışıyor.**
`sudo plymouthquit` oturumunuzu geri yükler. Ekran siyah kalırsa,
başka bir sanal terminal (`Ctrl+Alt+F2`) — oturumunuz sağlam.

## Sonraki adımlar

- [Kurulum](/docs/argvus-boot-splash/installation/) — farklı bir yöntemle tekrar deneyin.
- [Kullanım](/docs/argvus-boot-splash/usage/) — komutlar hile sayfası.
