---
title: Заставка загрузки ARGVUS
description: Тема Plymouth и руководство по установке для рабочего окружения ARGVUS
---

# Заставка загрузки ARGVUS

Заставка загрузки Argvus — это тема [Plymouth](https://www.freedesktop.org/wiki/Software/Plymouth/) для рабочего стола Argvus. Она отображается между включением компьютера и моментом начала вашей графической сессии.

## Документация

Эта документация организована в два основных раздела:

### Руководство пользователя
Руководства по установке и использованию для конечных пользователей и системных администраторов.

| Руководство | Содержание |
| --- | --- |
| [Установка](/docs/argvus-boot-splash/installation/) | Требования, три варианта установки, назначение хуков пакета |
| [Использование](/docs/argvus-boot-splash/usage/) | Проверка установки, предпросмотр без перезагрузки, смена или возврат темы, шпаргалка по командам |
| [UKI и загрузочный экран systemd-boot](/docs/argvus-boot-splash/uki-splash/) | Использование `argvus-uki-splash.bmp` в процессе загрузки UKI |
| [Удаление](/docs/argvus-boot-splash/uninstallation/) | Удаление пакета и восстановление предыдущей темы |
| [Устранение неполадок](/docs/argvus-boot-splash/troubleshooting/) | Распространенные симптомы и их причины |
| [Справка](/docs/argvus-boot-splash/reference/) | Установленные файлы, метаданные пакета, значения цветов |

### [Руководство разработчика](/docs/argvus-boot-splash/developer-guide/)
Техническая документация для участников и сопровождающих.

- [Архитектура](/docs/argvus-boot-splash/developer-guide/theme/) — Дескриптор Plymouth, модель рендеринга и настройка
- [Упаковка](/docs/argvus-boot-splash/developer-guide/packaging/) — Конвейер сборки и рецепты пакетов
- [CI и Выпуски](/docs/argvus-boot-splash/developer-guide/ci-releases/) — Проверка, тестирование и процесс выпуска

## Быстрый старт

Для систем на базе Arch:

```sh
sudo pacman -S argvus-boot-splash   # or: sudo pacman -U ./argvus-boot-splash-<version>-1-any.pkg.tar.zst
```
Установщик устанавливает тему по умолчанию и автоматически восстанавливает ваш initramfs.

---

- **Репозиторий:** [github.com/argvus/argvus-boot-splash](https://github.com/argvus/argvus-boot-splash)
- **Лицензия:** GPL-3.0-only
- **Сообщить об ошибках:** [GitHub Issues](https://github.com/argvus/argvus-boot-splash/issues)
