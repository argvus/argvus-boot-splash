---
title: UKI y pantalla de arranque de systemd-boot
description: Use el mapa de bits de presentación de ARGVUS en un flujo de arranque UKI.
---
# UKI y el arranque splash de systemd-boot

El paquete también incluye `argvus-uki-splash.bmp` (400x400, BMP sin comprimir de 32 bits). Está pensado para los flujos de arranque UKI / systemd-boot, donde la imagen splash se incrusta en la imagen de núcleo unificada en lugar de leerse desde el initramfs.

El mapa de bits *no* es utilizado por el tema Plymouth y no se registra nada automáticamente: incrustarlo depende de cómo construyas tu UKI. Los consumidores típicos son:

```sh
# systemd: set the splash for the next boot (systemd >= 254)
bootctl --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp

# ukify, while building the UKI
ukify build --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp \
           --linux=... --initrd=... --microcode=...
```
Vuelva a ejecutar la compilación de UKI (o `bootctl set-splash`) cada vez que la imagen cambie, y recuerde copiar el archivo al ESP si compila en otro lugar. systemd-boot escala el mapa de bits a la consola, por lo que una imagen cuadrada aparece centrada.

Si solo usa mkinitcpio o dracut, puede ignorar este archivo por completo; la instalación regular [installation](/docs/argvus-boot-splash/installation/) cubre esa ruta.

## Próximos pasos

- [Uso](/docs/argvus-boot-splash/usage/)
- [Solución de problemas](/docs/argvus-boot-splash/troubleshooting/)
