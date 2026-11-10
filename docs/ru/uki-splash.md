---
title: UKI и загрузочный экран systemd-boot
description: Используйте битмап-заставку ARGVUS в процессе загрузки UKI.
---
# UKI и заставка systemd-boot

Пакет также включает `argvus-uki-splash.bmp` (400x400, 32-бит, несжатый BMP). Он предназначен для загрузочных процессов UKI / systemd-boot, где изображение заставки встраивается в унифицированное ядро, а не считывается из initramfs.

Этот битмап *не* используется темой Plymouth и ничего не регистрируется автоматически: его встраивание зависит от того, как вы собираете свой UKI. Типичные пользователи:

```sh
# systemd: set the splash for the next boot (systemd >= 254)
bootctl --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp

# ukify, while building the UKI
ukify build --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp \
           --linux=... --initrd=... --microcode=...
```
Повторно запустите сборку UKI (или `bootctl set-splash`) каждый раз, когда изображение меняется, и не забудьте скопировать файл на ESP, если вы собираете его в другом месте. systemd-boot масштабирует bitmap до размера консоли, поэтому квадратное изображение отображается по центру.

Если вы используете только mkinitcpio или dracut, этот файл можно полностью игнорировать — обычная [установка](/docs/argvus-boot-splash/installation/) покрывает этот путь.

## Следующие шаги

- [Использование](/docs/argvus-boot-splash/usage/)
- [Устранение неполадок](/docs/argvus-boot-splash/troubleshooting/)
