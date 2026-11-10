---
title: Конвенции и известные пробелы
description: Правила дома, карта документации и результаты аудита репозитория.
---

# Конвенции и известные пробелы

Правила изменения этого репозитория, а также несоответствия, обнаруженные при его аудите — лучше исправить, чем копировать.

Для технической справки смотрите [theme architecture](/docs/argvus-boot-splash/developer-guide/theme/)], [packaging](/docs/argvus-boot-splash/developer-guide/packaging/)] и [CI and releases](/docs/argvus-boot-splash/developer-guide/ci-releases/)].

## Конвенции

- Shell: `set -euo pipefail`, табуляции для отступов, `printf`/`error` сообщения в stderr, `command -v` проверки возможностей, чистый shellcheck (см. `.editorconfig`).  
- Никогда не писать `sha256sums=('SKIP')`; держите `sha256sums=()` пустым в git.  
- Не коммитьте результаты сборки (`build/`), файлы пакетов или сгенерированные копии `.PKGBUILD.local.*`.  
- Conventional Commits с областями, используемыми в истории: `splash`, `layout`, `pkgbuild`, `release`, `chore`, `ci`, `build`, `docs`.  
- Именование веток: `feat/…`, `fix/…`, `docs/…`, `chore/…`, `refactor/…`.  
- Одобрение одного ревьюера перед слиянием, squash-merge.  
- Лицензия: GPL-3.0-only. Распространяется как `/usr/share/licenses/argvus-boot-splash/LICENSE`.  
- Следуйте процессу в [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md) и [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md).

## Известные пробелы

Задокументированные несоответствия, обнаруженные при аудите репозитория:

- `README.md` рекламирует `make test` для прямого просмотра Plymouth, но такой цели нет в [Makefile](https://github.com/argvus/argvus-boot-splash/blob/main/Makefile). Реальные команды:
  `sudo plymouth --show-splash` / `sudo plymouthquit`.
- `entry-line.png` и `logo-glow.png` входят в комплект и требуются `arch_check_splash_payload()`, но `argvus.script` никогда их не загружает. Либо интегрируйте их в скрипт, либо удалите из комплекта и контрольного списка.
- `src/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp` установлен, но никогда ни с чем не регистрируется; [руководство пользователя](/docs/argvus-boot-splash/uki-splash/)] документирует ручной шаг `bootctl`/`ukify`.
- Каноническая документация находится в корне репозитория (`README.md`, `DEVELOPMENT.md`) и пересекается с руководствами в `docs/`. Держите их согласованными
  при изменении любого из них. Политики внесения вкладов (`CONTRIBUTING.md`, `SECURITY.md`) находятся в репозитории организации `.github`.

## Карта документации

| Документ | Аудитория | Область применения |
| --- | --- | --- |
| `README.md` | все | однопараграфный обзор и структура |
| `DEVELOPMENT.md` | поддерживающие | сборка, подпись, процесс выпуска |
| [`CONTRIBUTING.md`](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md) (орг. `.github`) | участники | git flow, правила PR, политика секретов |
| [`docs/user-guide.md`](/docs/argvus-boot-splash/) | конечные пользователи | установка, использование, устранение неполадок |
| [`docs/developer-guide.md`](/docs/argvus-boot-splash/developer-guide/) | разработчики | внутренности темы, упаковка, CI |
