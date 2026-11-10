---
title: Solución de problemas
description: Síntomas comunes de la pantalla de arranque y cómo solucionarlos.
---
# Solución de problemas

**La pantalla de inicio no cambió después de la instalación.**
No se regeneró el initramfs. Ejecute `sudo mkinitcpio -P` (o `sudo dracut --regenerate-all`) y reinicie. Si su sistema utiliza múltiples núcleos, asegúrese de que el que arranca recibió el nuevo initramfs.

**No hay pantalla de inicio en absoluto; la pantalla está en negro o solo muestra texto.**
`plymouth` falta en los hooks del initramfs. Verifique que `/etc/mkinitcpio.conf` `HOOKS=(...)` contenga `plymouth`, luego reconstruya y reinicie. En Ubuntu/Debian, también confirme que `plymouth` y `plymouth-x11`/`plymouth-themes` estén instalados y que `GRUB_CMDLINE_LINUX` tenga `splash quiet`.

**Solo el logo, sin progreso.**
Algunos pasos de arranque no son reportados por su init, o la función de progreso nunca es llamada — no hay nada roto de su parte. La barra se llena según el progreso reportado por Plymouth, que está ausente en algunas configuraciones (por ejemplo, con secuencias sin `plymouth-spawn` de systemd o ciertos módulos de dracut).

**El aviso de contraseña está mal colocado o es invisible.**
El diálogo está posicionado a partir de la marca de palabra y la geometría de la pista, por lo que resoluciones extremas (modo de texto muy pequeño) pueden hacer que se salga de la pantalla. Usa una resolución normal e informa si esto ocurre en resoluciones comunes.

**Plymouth se cierra temprano / ves la consola de texto en su lugar.**
Algo deshabilitó Plymouth: el parámetro de arranque `quiet` sin `splash`, un hook `plymouth` eliminado, o un controlador que Plymouth no puede usar. Plymouth sale a la consola de texto en lugar de congelar la máquina; este es un comportamiento esperado.

**El tema no se aplica después de actualizar desde `argvus-plymouth`.**
El nuevo paquete reemplaza al antiguo; verifica que `/etc/plymouth/plymouthd.conf` diga `PLYMOUTH_THEME_NAME=argvus` y reconstruye el initramfs.

**La instalación falla en la verificación de la firma.**
La clave del repositorio falta o está desactualizada en tu llavero. Vuelve a importar la clave pública actual, luego `sudo pacman -Sy`.

**La pantalla de bloqueo / suspensión parece sin cambios.**
El tema solo cubre el arranque. Las pantallas de hibernación/reanudación se controlan por separado (`systemd-homed`, bloqueadores de pantalla, uso de `plymouth` en el objetivo de suspensión de tu initramfs).

**Un Plymouth errante sigue ejecutándose después de una vista previa.**
`sudo plymouthquit` restaura tu sesión. Si la pantalla permanece en negro, cambia a otro terminal virtual (`Ctrl+Alt+F2`): tu sesión está intacta.

## Próximos pasos

- [Instalación](/docs/argvus-boot-splash/installation/) — vuelve a intentarlo con un método diferente.
- [Uso](/docs/argvus-boot-splash/usage/) — hoja de referencia de comandos.
