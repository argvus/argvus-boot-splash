---
title: CI и релизы
description: Валидация, непрерывная интеграция, подпись и процесс выпуска.
---
# CI и релизы

Валидационный шлюз, задачи непрерывной интеграции, конвейер выпуска и правила версионирования.

Для самого пакета см. [packaging](/docs/argvus-boot-splash/developer-guide/packaging/)]; для темы см. [theme architecture](/docs/argvus-boot-splash/developer-guide/theme/)].

## Валидация

`tools/sh/validate.sh` — это обязательный шлюз:

- требует `bash`, `makepkg`, `shellcheck`;
- `shellcheck` + `bash -n` на `tools/sh/*.sh` и `packaging/arch/common/*.sh`;
- берет источники как PKGBUILD и сравнивает извлеченные метаданные — удаленные и локальные должны совпадать;
- `makepkg -p PKGBUILD --printsrcinfo` внутри `ci/` и `local/` (разбирает файл так, как это делает makepkg);
- `git diff --check` (пробелы/маркеры конфликтов).

## Непрерывная интеграция

`.github/workflows/ci.yml` (push/PR в `main`, контейнер `archlinux:latest`):

1. Установите `base-devel git namcap pacman-contrib shellcheck sudo`;
2. `make validate`;
3. Собирайте как **непривилегированный** пользователь `builder`
   (`sudo -u builder env HOME=/home/builder make build`) — makepkg отказывается запускаться
   от root, а рабочее пространство сначала `chown`;
4. Отдельная задача `spellcheck` запускает `cspell-action@v6` с `cspell.json`.

`namcap` запускается внутри `pkgbuild_local.sh` при установке, поэтому локальные сборки выявляют
те же ошибки lint, что и CI. Конфигурация проверки орфографии `cspell.json` с рабочим словарем
`.cspell/custom-dictionary-workspace.txt` — новые технические термины
(флаги оболочки, названия инструментов) должны быть в этом словаре, иначе CI не выполнится.

## Конвейер выпуска

`.github/workflows/release.yml` — триггеры: push с тегом `v*` или
`workflow_dispatch` с существующим тегом (контролируемая пересборка). Группа одновременно выполняемых задач
`release-<ref>`, отмена отсутствует.

Шаги:

1. **Checkout** тега (dispatch использует `inputs.tag`).
2. **Этап версии**: проверяет тег относительно `^v[0-9]+(\.[0-9]+)*([._+-][A-Za-z0-9]+)*$`, завершается с ошибкой, если `url` пуст в `packaging/arch/remote/PKGBUILD`, затем переписывает `pkgver` из тега.
3. **Проверка**: `make validate`.
4. **Сборка** как непривилегированный `builder`: `updpkgsums` (разрешает и проверяет реальный `sha256sums`), затем `makepkg --nodeps --noconfirm --needed --cleanbuild --clean --check`.
   Находит `.pkg.tar.zst` и завершает с ошибкой, если ни одного не существует.
5. **namcap** на пакете.
6. **Подпись**: импортирует `GPG_PRIVATE_KEY` в одноразовый `GNUPGHOME` (`mktemp -d`, режим 700), проверяет, что импортированный секретный ключ соответствует `GPG_KEY_ID` (короткий идентификатор или отпечаток), и создает отдельный `.sig` с `--pinentry-mode loopback --passphrase-fd 0`.
7. **Проверка подписи** в свежем `GNUPGHOME` — релиз завершается с ошибкой, если подпись не подтверждается.
8. **Загрузка артефакта** (`upload-artifact@v4`, `retention-days: 1`, пакет +)
   подпись, `if-no-files-found: error`).
9. **Публикация**: проверьте `argvus/packages` с `PACKAGES_REPO_TOKEN`, скопируйте пакет и `.sig` в `public/arch/x86_64`, запустите `repo-add -R argvus.db.tar.gz <pkg>`, подпишите `argvus.db.tar.gz`, `argvus.files.tar.gz`, `argvus.db` и `argvus.files`, затем выполните коммит как `github-actions[bot]` и отправьте. Дифф без изменений завершает работу с кодом 0 без коммита.
10. **Релиз на GitHub**: `softprops/action-gh-release@v2` с сгенерированными заметками и пакетом + подписью как ассеты.

## Контрольные суммы, подпись и секреты

- Нет `SKIP`: `sha256sums` всегда является реальным дайджестом, вычисленным во время сборки (локально) или через `updpkgsums` (release CI).
- Держите `sha256sums=()` **пустым** в репозитории.
- Релизы подписываются GPG (пакет `.sig`, `argvus.db.tar.gz`, `argvus.files.tar.gz`, `argvus.db`, `argvus.files`).
- `GPG_PASSPHRASE` должен быть непустым; рабочий процесс отклоняет пустую парольную фразу.

Подготовьте ключ:

```sh
gpg --full-generate-key            # RSA 4096, no expiry recommended
gpg --list-secret-keys --with-colons | grep ^sec:   # note the KEY_ID
gpg --armor --export-secret-keys KEY_ID            # what the workflow imports
```
В **Настройки → Секреты и переменные → Actions** репозитория:

| Секрет | Значение |
| --- | --- |
| `GPG_PRIVATE_KEY` | `gpg --armor --export-secret-keys KEY_ID` output |
| `GPG_KEY_ID` | ожидаемый ID ключа или отпечаток |
| `GPG_PASSPHRASE` | непустая парольная фраза ключа подписи |
| `PACKAGES_REPO_TOKEN` | PAT с `contents:write` на `argvus/packages` |

## Публикация релиза

Перед тегированием:

1. Заполните `url` в `packaging/arch/remote/PKGBUILD` настоящим репозиторием:
   - GitHub: `url="https://github.com/argvus/argvus-boot-splash"` (источник использует `${url}/archive/refs/tags/v${pkgver}.tar.gz`);
   - GitLab: замените `source=` на `https://gitlab.com/argvus/argvus-boot-splash/-/archive/v${pkgver}/argvus-boot-splash-v${pkgver}.tar.gz`;
   - без `url`, релиз **намеренно не удается** с ясным сообщением.
2. Синхронизируйте версии/метаданные в `packaging/arch/local/PKGBUILD` и `packaging/arch/remote/PKGBUILD`.
3. Создайте тэг и выполните push:

   ```sh
   git tag v0.1.0
   git push origin v0.1.0
   ```
Рабочий процесс также можно запустить вручную, используя в качестве его тега `v*`.
   Вход `tag`, который полезен для управляемой перестройки.

## Управление версиями

- SemVer в `pkgver`, количество выпусков в `pkgrel`.

## Устранение неполадок разработчика

**Не удалось выполнить выпуск на этапе «Получение источников».** Пустой `url`, отсутствует тег `v*` или
Формат URL-адреса архива, который не соответствует хосту (GitHub или GitLab tarball).
макет). Рабочий процесс проверяет шаблон тегов и завершается сбоем на раннем этапе пустого
`url`.

**`updpkgsums` не может найти источник.** Тег должен существовать и быть отправлен до
задание выпуска выполняется; отправка с помощью тега, который существует только локально, здесь невозможна.

**`make validate` сообщает: «Удаленные и локальные метаданные PKGBUILD не синхронизированы».**
Скопируйте поля метаданных (не `source=`) из одного PKGBUILD в другой.

**Проверка правописания не удалась для нового термина.** Добавьте его в
`.cspell/custom-dictionary-workspace.txt` (словарь `argvus`, `addWords:
true`), not to `ignorePaths`.

**`sudo` запрошен внутри `make install` или `libfakeroot.so … LD_PRELOAD` с ошибками.** `package()` вызывает `make install` вместо использования `install -Dm*`. Оба PKGBUILD вызывают `arch_package_splash_payload`, который этого не делает; убедитесь, что никто не повторно ввёл вызов `make`.

**`makepkg` отказывается запускаться.** Он не должен запускаться от имени root. Запустите сборку как обычный пользователь или `sudo -u <user> make build`.

**Пакет установлен, но заставка не изменилась.** Initramfs не был пересобран. Для локального тестирования используйте `sudo plymouth --show-splash` вместо перезагрузки или пересоберите с помощью `sudo mkinitcpio -P` / `sudo dracut --regenerate-all`.
