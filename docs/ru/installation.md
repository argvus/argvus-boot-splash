---
title: Установка
description: Требования, варианты установки и функции, которые выполняют хуки пакета.
---

# Установка

Все, что нужно, чтобы получить загрузочный экран Argvus на системе, основанной на Arch.

Чтобы увидеть, как выглядит тема и что она содержит, см. [reference](/docs/argvus-boot-splash/reference/). Чтобы собрать её из исходников, см. [developer guide](/docs/argvus-boot-splash/developer-guide/).

## Требования

- Система на основе Arch, использующая `plymouth` (пакет зависит от этого).
- Генератор initramfs: **mkinitcpio** (по умолчанию в Arch) или **dracut**. Установщик обнаруживает, что присутствует, и пересобирает initramfs за вас.
- Plymouth должен быть включён в конфигурацию initramfs. С mkinitcpio убедитесь, что `plymouth` находится в списке `HOOKS` `/etc/mkinitcpio.conf`:

  ```ini
  HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont plymouth)
  ```
Перезагрузите систему, если вы только что это изменили.

- Для обычной графической сессии ничего не требуется; тема работает только в загрузочном пути.

## Вариант 1: официальный репозиторий пакетов (рекомендуется)

Подписанные пакеты публикуются в репозитории пакетов Argvus (`argvus/packages`, путь `public/arch/$arch`). Добавьте его в `/etc/pacman.conf`:

```ini
[argvus]
SigLevel = Required DatabaseOptional
Server = <PACKAGES_REPO_BASE_URL>/argvus/packages/raw/branch/main/public/arch/$arch
```
Замените `<PACKAGES_REPO_BASE_URL>` на хост, на котором проект публикует репозиторий (GitHub, GitLab или Gitea). Сначала импортируйте ключ подписи репозитория, иначе `pacman` откажется от загрузки:

```sh
# 1. import the project's public signing key into your pacman keyring
pacman-key --add /path/to/argvus-signing-key.asc
pacman-key --lsign <key-id>

# 2. refresh and install
sudo pacman -Sy
sudo pacman -S argvus-boot-splash
```
## Вариант 2: файл выпуска пакета

Каждый отмеченный выпуск публикует `.pkg.tar.zst` (плюс его `.sig`) как ассет выпуска. Установите его напрямую:

```sh
sudo pacman -U ./argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```
Если вам небезразлична гигиена цепочки поставок, проверьте отдельную подпись с использованием открытого ключа проекта перед установкой:

```sh
gpg --verify argvus-boot-splash-0.2.0-1-any.pkg.tar.zst.sig \
        argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```
## Вариант 3: ручная установка

Полезно для систем, не являющихся Arch, или если вы просто хотите попробовать тему без упаковки. Скопируйте каталог темы в путь темы Plymouth:

```sh
sudo cp -r src/usr/share/plymouth/themes/argvus \
           /usr/share/plymouth/themes/argvus

sudo plymouth-set-default-theme argvus
sudo update-initramfs -u        # Debian/Ubuntu
# or: sudo mkinitcpio -P        # Arch
# or: sudo dracut --regenerate-all
```
Plymouth также может быть включен в `/etc/default/grub` с `GRUB_CMDLINE_LINUX`, содержащим `splash`, и `quiet` дает классическое ощущение минимальной загрузки.

## Что делает установщик

После установки или обновления, пакетные хуки запускаются автоматически:

1. `plymouth-set-default-theme argvus` — записывает `argvus` в `/etc/plymouth/plymouthd.conf`.
2. `mkinitcpio -P`, если существует mkinitcpio, в противном случае `dracut --regenerate-all`.

Если ни один генератор не найден, установщик выводит предупреждение, и вам нужно самостоятельно пересобрать initramfs. Изменение темы становится видимым при загрузке только после регенерации initramfs — перезагрузка без этого шага является самой распространенной причиной, по которой "сплэш не изменился".

При удалении пакет только выводит напоминание: выбор другой темы и пересборка initramfs остаются за вами. См. [uninstallation](/docs/argvus-boot-splash/uninstallation/).

## Следующие шаги

- [Usage](/docs/argvus-boot-splash/usage/) — проверить установку, предварительный просмотр без перезагрузки, переключение тем.
- [UKI и systemd-boot splash](/docs/argvus-boot-splash/uki-splash/) — использовать растровое изображение в UKI.
- [Troubleshooting](/docs/argvus-boot-splash/troubleshooting/) — если заставка не изменилась.
