---
title: Руководство разработчика
description: Руководство по архитектуре и разработке для участников ARGVUS.
---
# Argvus Boot Splash — Руководство для разработчиков

Техническая документация для репозитория `argvus-boot-splash`: как собрана тема Plymouth, как создается пакет Arch и как подписываются и публикуются релизы.

Здесь нет этапа компиляции — тема представляет собой данные (дескриптор `.plymouth`, `.script` и изображения) плюс рецепт пакета Arch. "Сборка" означает создание воспроизводимого пакета:

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
make validate
make build      # -> build/dist/argvus-boot-splash-<version>-1-any.pkg.tar.zst
make install    # sudo pacman -U that file
```
Прежде чем зафиксировать изменение: `make validate && make build`, добавьте новые технические термины в `.cspell/custom-dictionary-workspace.txt`, иначе проверка орфографии не пройдет.

Если вы хотите только *использовать* тему, прочтите [руководство пользователя](/docs/argvus-boot-splash/). Для процессно-ориентированного аналога этого файла (git flow, секреты, процесс релиза) см. [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md) и [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md).

## Руководства

| Руководство | Содержание |
| --- | --- |
| [Архитектура темы](/docs/argvus-boot-splash/developer-guide/theme/) | Дескриптор, модель рендеринга, инвентаризация ресурсов, пошаговое прохождение скриптов, константы макета, дизайнерские токены, UKI bitmap, как изменить тему |
| [Упаковка](/docs/argvus-boot-splash/developer-guide/packaging/) | Два PKGBUILD-файла, общий `functions.sh`, hook'и установки, локальный конвейер сборки, цели Make, предварительные требования |
| [CI и релизы](/docs/argvus-boot-splash/developer-guide/ci-releases/) | `validate.sh`, `ci.yml`, `release.yml` шаг за шагом, контрольные суммы, подпись, секреты, публикация и версионирование |
| [Соглашения и известные пробелы](/docs/argvus-boot-splash/developer-guide/workflow/) | Правила внутреннего пользования, карта документации и несоответствия, обнаруженные при аудите репозитория |

## Быстрая справка

| Путь | Что это |
| --- | --- |
| `src/usr/share/plymouth/themes/argvus/` | тема, установочная под `/usr` |
| `packaging/arch/{ci,local}/PKGBUILD` | рецепты релиза и локального пакета |
| `packaging/arch/common/functions.sh` | общий `prepare`/`check`/`package` |
| `tools/sh/pkgbuild_local.sh` | детерминированный tarball + драйвер `makepkg` |
| `tools/sh/validate.sh` | необходимый контрольный этап проверки |
| `.github/workflows/` | `ci.yml` (валидация, сборка, проверка орфографии), `release.yml` (теги `v*`) |

## В других местах

- Корень репозитория: [README.md](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)
- Документация для пользователей: [user guide](/docs/argvus-boot-splash/)
- Процесс разработки: [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md)
- Участие в проекте: [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)
- Политика безопасности: [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md)
- Лицензия: [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE)
- Версия на португальском: [Guia do desenvolvedor](/pt/docs/argvus-boot-splash/developer-guide/)
