---
title: Использование
description: Проверьте установку, просмотрите предварительно без перезагрузки и переключите темы.
---
# Использование

Как проверить тему, просмотреть её без перезагрузки и переключиться на другую.
Для установки см. [installation](/docs/argvus-boot-splash/installation/).

## Проверка установки

```sh
# theme is present?
ls /usr/share/plymouth/themes/argvus

# which theme is the default?
plymouth-set-default-theme          # prints, e.g.: argvus

# does Plymouth parse the theme without errors?
sudo plymouth --show-splash
```
## Предварительный просмотр без перезагрузки

```sh
sudo plymouth --show-splash   # shows the splash, simulating boot
sudo plymouthquit             # returns to your session
```
Предварительный просмотр может запросить аутентификацию polkit при запуске от имени обычного пользователя. Полоса выполнения продвигается вместе с имитацией прогресса; вы также можете принудительно задать состояния:

```sh
sudo plymouth --show-details   # verbose boot messages instead of the splash
sudo plymouth --show-splash    # back to the splash
```
Пока экран загрузки отображается, нажмите <kbd>Esc</kbd>, чтобы перейти к следующему экрану (заставка → детали → заставка).

## Что показывает заставка

| Этап | Внешний вид |
| --- | --- |
| Запуск | Всё появляется постепенно за ~1 секунду: логотип, фирменный знак, индикатор прогресса |
| Загрузка | Полоска заполняется слева, пока Plymouth сообщает о прогрессе |
| Зашифрованный том | Заставка затемняется до 15%, под полоской появляются текст запроса и скрытые символы |
| Пароль принят | Диалоговое окно исчезает, заставка возвращается к полной непрозрачности |

## Изменение или возврат темы

```sh
# switch theme (any theme name under /usr/share/plymouth/themes)
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme

# then regenerate the initramfs
sudo mkinitcpio -P              # or: sudo dracut --regenerate-all
```
Полезные конфигурационные файлы:

| Файл | Назначение |
| --- | --- |
| `/etc/plymouth/plymouthd.conf` | `PLYMOUTH_THEME_NAME=argvus` написан пакетом |
| `/etc/mkinitcpio.conf` | `HOOKS=(... plymouth ...)` должен включать `plymouth` |
| `/etc/plymouth/plymouthd.conf` (снова) | `PLYMOUTH_TOGGLE_KEY` и т. д. являются глобальными, а не для каждой темы |

## Справочник команд

| Команда | Эффект |
| --- | --- |
| `sudo plymouth-set-default-theme argvus` | сделать `argvus` темой по умолчанию |
| `sudo plymouth-update-theme` | применить изменение к запущенному Plymouth |
| `sudo plymouth --show-splash` | показать заставку в текущей сессии |
| `sudo plymouth --show-details` | вместо этого показать подробные сообщения загрузки |
| `sudo plymouthquit` | выйти из Plymouth и восстановить вашу сессию |
| `sudo mkinitcpio -P` | перестроить initramfs Arch |
| `sudo dracut --regenerate-all` | перестроить initramfs с dracut |

## Следующие шаги

- [UKI и загрузчик systemd-boot splash](/docs/argvus-boot-splash/uki-splash/)
- [Удаление](/docs/argvus-boot-splash/uninstallation/)
- [Устранение неполадок](/docs/argvus-boot-splash/troubleshooting/)
