---
title: Splash em UKI e systemd-boot
description: Use o bitmap de splash do ARGVUS em um boot com UKI.
---

# Splash em UKI e systemd-boot

O pacote também traz o `argvus-uki-splash.bmp` (400x400, BMP de 32 bits sem
compressão). Ele serve para boot com UKI / systemd-boot, em que a imagem de splash
é embutida na imagem de kernel unificada (UKI) em vez de ser lida do initramfs.

O bitmap *não* é usado pelo tema do Plymouth e nada é registrado
automaticamente: embutir a imagem depende de como você monta a sua UKI. Os
consumidores mais comuns são:

```sh
# systemd: define o splash para o próximo boot (systemd >= 254)
bootctl --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp

# ukify, durante a montagem da UKI
ukify build --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp \
           --linux=... --initrd=... --microcode=...
```

Refaça a montagem da UKI (ou `bootctl set-splash`) sempre que a imagem mudar, e
lembre-se de copiar o arquivo para a ESP se você compila em outro lugar. O
systemd-boot escala o bitmap para o console, então uma imagem quadrada aparece
centralizada.

Se você usa apenas mkinitcpio ou dracut, pode ignorar este arquivo: a
[instalação](installation.md) comum já cobre esse caminho.

## Próximos passos

- [Uso](usage.md)
- [Solução de problemas](troubleshooting.md)
