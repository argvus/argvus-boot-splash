---
title: Удаление
description: Удалите пакет и восстановите прежнюю тему загрузки.
---
# Удаление

```sh
sudo pacman -Rns argvus-boot-splash
```
Затем выберите другую тему и перестройте, иначе старый сплэш останется внутри initramfs:

```sh
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme
sudo mkinitcpio -P        # or: sudo dracut --regenerate-all
```
`pacman -Rns` также удаляет `/etc/plymouth/plymouthd.conf`, если никто другой его не создавал.

Хук удаления пакета только выводит напоминание — он не угадывает, какую тему вы хотите вместо этого, и не трогает ваш initramfs.

## Следующие шаги

- [Устранение неполадок](/docs/argvus-boot-splash/troubleshooting/) — восстановление предыдущего заставочного экрана.
- [Установка](/docs/argvus-boot-splash/installation/) — повторная установка позже.
