---
title: CI und Releases
description: Validierung, kontinuierliche Integration, Signierung und Release-Workflow.
---
# CI und Releases

Das Validierungstor, die Continuous-Integration-Jobs, die Release-Pipeline und
die Versionierungsregeln.

Für das Paket selbst siehe [packaging](/docs/argvus-boot-splash/developer-guide/packaging/)]; für das Theme siehe
[theme architecture](/docs/argvus-boot-splash/developer-guide/theme/)].

## Validierung

`tools/sh/validate.sh` ist das erforderliche Tor:

- benötigt `bash`, `makepkg`, `shellcheck`;
- `shellcheck` + `bash -n` auf `tools/sh/*.sh` und `packaging/arch/common/*.sh`;
- bezieht sowohl PKGBUILDs und vergleicht extrahierte Metadaten – remote und lokal müssen
  übereinstimmen;
- `makepkg -p PKGBUILD --printsrcinfo` innerhalb von `ci/` und `local/` (analysiert die
  Datei wie makepkg);
- `git diff --check` (Leerzeichen/Konfliktmarker).

## Continuous Integration

`.github/workflows/ci.yml` (Push/PR zu `main`, `archlinux:latest` Container):

1. installiere `base-devel git namcap pacman-contrib shellcheck sudo`;
2. `make validate`;
3. baue als **nicht privilegierter** `builder` Benutzer
   (`sudo -u builder env HOME=/home/builder make build`) — makepkg weigert sich als root zu laufen,
   und der Arbeitsbereich wird zuerst `chown`;
4. ein separater `spellcheck` Job führt `cspell-action@v6` mit `cspell.json` aus.

`namcap` läuft innerhalb von `pkgbuild_local.sh`, wenn installiert, also zeigen lokale Builds dieselben Lint-Fehler wie CI. Die Rechtschreibprüfung ist `cspell.json` mit dem Arbeitsbereichs-Wörterbuch in `.cspell/custom-dictionary-workspace.txt` — neue technische Begriffe (Shell-Flags, Werkzeugnamen) gehören in dieses Wörterbuch, sonst schlägt CI fehl.

## Release-Pipeline

`.github/workflows/release.yml` — Auslöser: Push eines `v*` Tags oder `workflow_dispatch` mit einem bestehenden Tag (kontrollierter Neuaufbau). Gleichzeitige Gruppe `release-<ref>`, keine Stornierung.

Schritte:

1. **Checkout** des Tags (Dispatch verwendet `inputs.tag`).
2. **Versionsschritt**: validiert das Tag gegen `^v[0-9]+(\.[0-9]+)*([._+-][A-Za-z0-9]+)*$`, schlägt fehl, wenn `url` in `packaging/arch/remote/PKGBUILD` leer ist, dann wird `pkgver` aus dem Tag neu geschrieben.
3. **Validieren**: `make validate`.
4. **Erstellen** als unprivilegierter `builder`: `updpkgsums` (löst auf und validiert das echte `sha256sums`) dann `makepkg --nodeps --noconfirm --needed --cleanbuild --clean --check`. 
   Findet das `.pkg.tar.zst` und schlägt fehl, wenn kein solches existiert.
5. **namcap** auf dem Paket.
6. **Signieren**: importiert `GPG_PRIVATE_KEY` in ein temporäres `GNUPGHOME` (`mktemp -d`, Modus 700), prüft, ob der importierte geheime Schlüssel `GPG_KEY_ID` (kurze ID oder Fingerabdruck) entspricht, und erstellt ein losgelöstes `.sig` mit `--pinentry-mode loopback --passphrase-fd 0`.
7. **Signatur prüfen** in einem frischen `GNUPGHOME` — die Veröffentlichung schlägt fehl, wenn die Signatur nicht verifiziert werden kann.
8. **Artefakt hochladen** (`upload-artifact@v4`, `retention-days: 1`, Paket +)
   Unterschrift, `if-no-files-found: error`).
9. **Veröffentlichen**: prüfe `argvus/packages` mit `PACKAGES_REPO_TOKEN`, kopiere das Paket und `.sig` in `public/arch/x86_64`, führe `repo-add -R argvus.db.tar.gz <pkg>` aus, signiere `argvus.db.tar.gz`, `argvus.files.tar.gz`, `argvus.db` und `argvus.files`, dann committe als `github-actions[bot]` und pushe. Ein Diff ohne Änderungen beendet mit 0 ohne zu committen.
10. **GitHub-Veröffentlichung**: `softprops/action-gh-release@v2` mit generierten Notizen und dem Paket + Signatur als Assets.

## Prüfsummen, Signierung und Geheimnisse

- Es gibt keinen `SKIP`: `sha256sums` ist immer ein echter Digest, berechnet zur Build-Zeit (lokal) oder über `updpkgsums` (Release-CI).
- Halte `sha256sums=()` **leer** im Repository.
- Veröffentlichungen sind GPG-signiert (Paket `.sig`, `argvus.db.tar.gz`, `argvus.files.tar.gz`, `argvus.db`, `argvus.files`).
- `GPG_PASSPHRASE` darf nicht leer sein; der Workflow lehnt ein leeres Passwort ab.

Bereite den Schlüssel vor:

```sh
gpg --full-generate-key            # RSA 4096, no expiry recommended
gpg --list-secret-keys --with-colons | grep ^sec:   # note the KEY_ID
gpg --armor --export-secret-keys KEY_ID            # what the workflow imports
```
In **Einstellungen → Geheimnisse und Variablen → Actions** des Repositories:

| Geheimnis | Wert |
| --- | --- |
| `GPG_PRIVATE_KEY` | `gpg --armor --export-secret-keys KEY_ID` Ausgabe |
| `GPG_KEY_ID` | erwartete Schlüssel-ID oder Fingerabdruck |
| `GPG_PASSPHRASE` | nicht-leere Passphrase des Signierschlüssels |
| `PACKAGES_REPO_TOKEN` | PAT mit `contents:write` auf `argvus/packages` |

## Veröffentlichung eines Releases

Vor dem Taggen:

1. Füllen Sie `url` in `packaging/arch/remote/PKGBUILD` mit dem echten Repository aus:
   - GitHub: `url="https://github.com/argvus/argvus-boot-splash"` (die Quelle verwendet `${url}/archive/refs/tags/v${pkgver}.tar.gz`);
   - GitLab: Passen Sie `source=` an `https://gitlab.com/argvus/argvus-boot-splash/-/archive/v${pkgver}/argvus-boot-splash-v${pkgver}.tar.gz` an;
   - Ohne `url` **schlägt die Freigabe absichtlich fehl** mit einer klaren Meldung.
2. Synchronisieren Sie Versionen/Metadaten in `packaging/arch/local/PKGBUILD` und `packaging/arch/remote/PKGBUILD`.
3. Taggen und pushen:

   ```sh
   git tag v0.1.0
   git push origin v0.1.0
   ```
Der Workflow kann auch manuell mit einem vorhandenen `v*`-Tag gestartet werden
   `tag`-Eingabe, die für einen kontrollierten Neuaufbau nützlich ist.

## Versionierung

– SemVer in `pkgver`, Release-Anzahl in `pkgrel`.

## Fehlerbehebung für Entwickler

**Die Veröffentlichung schlägt bei „Quellen werden abgerufen“ fehl.** Leeres `url`, fehlendes `v*`-Tag oder ein
Archiv-URL-Format, das nicht mit dem Host übereinstimmt (GitHub vs. GitLab-Tarball).
Layout). Der Workflow validiert das Tag-Muster und schlägt bei einem leeren Tag frühzeitig fehl
`url`.

**`updpkgsums` kann die Quelle nicht finden.** Das Tag muss vorhanden sein und zuvor gepusht werden
der Release-Job wird ausgeführt; Der Versand mit einem Tag, der nur lokal existiert, schlägt hier fehl.

**`make validate` meldet „Remote- und lokale PKGBUILD-Metadaten sind nicht synchron“.**
Kopieren Sie die Metadatenfelder (nicht `source=`) von einem PKGBUILD zum anderen.

**Die Rechtschreibprüfung schlägt bei einem neuen Begriff fehl.** Fügen Sie es hinzu
`.cspell/custom-dictionary-workspace.txt` (das `argvus`-Wörterbuch, „addWords:
true`), not to `ignorePaths`.

**`sudo` innerhalb von `make install` oder `libfakeroot.so … LD_PRELOAD` angefordert Fehler.** Ein `package()`, das `make install` aufruft anstatt `install -Dm*` zu verwenden. Beide PKGBUILDs rufen `arch_package_splash_payload` auf, was nicht; stellen Sie sicher, dass niemand einen `make`-Aufruf wieder eingeführt hat.

**`makepkg` weigert sich zu laufen.** Es darf nicht als Root ausgeführt werden. Führen Sie den Build als normaler Benutzer aus, oder `sudo -u <user> make build`.

**Paket installiert, aber der Splash bleibt unverändert.** Das initramfs wurde nicht neu erstellt. Für lokale Tests rufen Sie `sudo plymouth --show-splash` anstatt neu zu starten, oder erstellen Sie es neu mit `sudo mkinitcpio -P` / `sudo dracut --regenerate-all`.
