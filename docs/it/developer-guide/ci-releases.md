---
title: CI e Rilasci
description: Validazione, integrazione continua, firma e flusso di lavoro di rilascio.
---

# CI e release

Il gate di validazione, i job di integrazione continua, la pipeline di rilascio e
le regole di versioning.

Per il pacchetto in sé, vedi [packaging](/docs/argvus-boot-splash/developer-guide/packaging/); per il tema, vedi
[theme architecture](/docs/argvus-boot-splash/developer-guide/theme/).

## Validazione

`tools/sh/validate.sh` è il gate richiesto:

- richiede `bash`, `makepkg`, `shellcheck`;
- `shellcheck` + `bash -n` su `tools/sh/*.sh` e `packaging/arch/common/*.sh`;
- utilizza le sorgenti sia dei PKGBUILD e confronta i metadata estratti — devono
  corrispondere remoto e locale;
- `makepkg -p PKGBUILD --printsrcinfo` all'interno di `ci/` e `local/` (analizza il
  file allo stesso modo in cui lo fa makepkg);
- `git diff --check` (spazi bianchi/marcatori di conflitto).

## Integrazione continua

`.github/workflows/ci.yml` (push/PR a `main`, contenitore `archlinux:latest`):

1. installa `base-devel git namcap pacman-contrib shellcheck sudo`;
2. `make validate`;
3. costruisci come utente `builder` **non privilegiato**
   (`sudo -u builder env HOME=/home/builder make build`) — makepkg rifiuta di eseguire
   come root, e l'ambiente di lavoro è prima `chown`;
4. un lavoro `spellcheck` separato esegue `cspell-action@v6` con `cspell.json`.

`namcap` viene eseguito all'interno di `pkgbuild_local.sh` quando installato, quindi le build locali mostrano
lo stesso lint di CI. La configurazione di spellcheck è `cspell.json` con il dizionario dell'ambiente di lavoro in `.cspell/custom-dictionary-workspace.txt` — nuovi termini tecnici
(flag della shell, nomi degli strumenti) appartengono a quel dizionario, altrimenti CI fallisce.

## Pipeline di rilascio

`.github/workflows/release.yml` — trigger: push di un tag `v*`, o
`workflow_dispatch` con un tag esistente (ricostruzione controllata). Gruppo di concorrenza
`release-<ref>`, nessuna cancellazione.

Passaggi:

1. **Checkout** del tag (dispatch utilizza `inputs.tag`).
2. **Fase di versione**: valida il tag contro `^v[0-9]+(\.[0-9]+)*([._+-][A-Za-z0-9]+)*$`, fallisce se `url` è vuoto in `packaging/arch/remote/PKGBUILD`, poi riscrive `pkgver` dal tag.
3. **Valida**: `make validate`.
4. **Costruisci** come `builder` senza privilegi: `updpkgsums` (risolve e valida il reale `sha256sums`) poi `makepkg --nodeps --noconfirm --needed --cleanbuild --clean --check`.
   Trova `.pkg.tar.zst` e fallisce se non esiste.
5. **namcap** sul pacchetto.
6. **Firma**: importa `GPG_PRIVATE_KEY` in un `GNUPGHOME` usa-e-getta (`mktemp -d`, modalità 700), verifica che la chiave segreta importata corrisponda a `GPG_KEY_ID` (ID corto o fingerprint), e crea un `.sig` separato con `--pinentry-mode loopback --passphrase-fd 0`.
7. **Verifica la firma** in un nuovo `GNUPGHOME` — il rilascio fallisce se la firma non verifica.
8. **Carica artefatto** (`upload-artifact@v4`, `retention-days: 1`, pacchetto +
   firma, `if-no-files-found: error`).
9. **Pubblica**: controlla `argvus/packages` con `PACKAGES_REPO_TOKEN`, copia il
   pacchetto e `.sig` in `public/arch/x86_64`, esegui
   `repo-add -R argvus.db.tar.gz <pkg>`, firma `argvus.db.tar.gz`,
   `argvus.files.tar.gz`, `argvus.db` e `argvus.files`, poi esegui il commit come
   `github-actions[bot]` e fai il push. Un diff senza modifiche esce 0 senza eseguire il commit.
10. **Rilascio su GitHub**: `softprops/action-gh-release@v2` con note generate
e il pacchetto + firma come asset.

## Checksum, firma e segreti

- Non esiste un `SKIP`: `sha256sums` è sempre un digest reale, calcolato al momento della compilazione
  (locale) o tramite `updpkgsums` (release CI).
- Mantieni `sha256sums=()` **vuoto** nel repository.
- I rilasci sono firmati con GPG (pacchetto `.sig`, `argvus.db.tar.gz`,
  `argvus.files.tar.gz`, `argvus.db`, `argvus.files`).
- `GPG_PASSPHRASE` deve essere non vuoto; il workflow rifiuta una passphrase vuota.

Prepara la chiave:

```sh
gpg --full-generate-key            # RSA 4096, no expiry recommended
gpg --list-secret-keys --with-colons | grep ^sec:   # note the KEY_ID
gpg --armor --export-secret-keys KEY_ID            # what the workflow imports
```
In **Impostazioni → Segreti e variabili → Azioni** del repository:

| Segreto | Valore |
| --- | --- |
| `GPG_PRIVATE_KEY` | output `gpg --armor --export-secret-keys KEY_ID` |
| `GPG_KEY_ID` | ID chiave previsto o fingerprint |
| `GPG_PASSPHRASE` | passphrase non vuota della chiave di firma |
| `PACKAGES_REPO_TOKEN` | PAT con `contents:write` su `argvus/packages` |

## Pubblicazione di una release

Prima di marcare:

1. Compila `url` in `packaging/arch/remote/PKGBUILD` con il repository reale:
   - GitHub: `url="https://github.com/argvus/argvus-boot-splash"` (la sorgente usa `${url}/archive/refs/tags/v${pkgver}.tar.gz`);
   - GitLab: modifica `source=` in `https://gitlab.com/argvus/argvus-boot-splash/-/archive/v${pkgver}/argvus-boot-splash-v${pkgver}.tar.gz`;
   - senza `url`, il rilascio **fallisce apposta** con un messaggio chiaro.
2. Sincronizza versioni/metadata in `packaging/arch/local/PKGBUILD` e `packaging/arch/remote/PKGBUILD`.
3. Tagga e invia:

   ```sh
   git tag v0.1.0
   git push origin v0.1.0
   ```
Il flusso di lavoro può anche essere avviato manualmente con un tag `v*` esistente come proprio
   Ingresso `tag`, utile per una ricostruzione controllata.

## Controllo delle versioni

- SemVer in `pkgver`, conteggio dei rilasci in `pkgrel`.

## Risoluzione dei problemi degli sviluppatori

**Il rilascio non riesce in "Recupero origini".** `url` vuoto, tag `v*` mancante o un
Formato dell'URL di archivio che non corrisponde all'host (GitHub vs GitLab tarball
disposizione). Il flusso di lavoro convalida il modello di tag e fallisce subito in caso di vuoto
`url`.

**`updpkgsums` non riesce a trovare la fonte.** Il tag deve esistere ed essere stato inviato prima
viene eseguito il lavoro di rilascio; l'invio con un tag che esiste solo localmente fallisce qui.

**`make validate` segnala che "i metadati PKGBUILD remoti e locali non sono sincronizzati".**
Copia i campi dei metadati (non `source=`) da un PKGBUILD all'altro.

**Il controllo ortografico fallisce con un nuovo termine.** Aggiungilo a
`.cspell/custom-dictionary-workspace.txt` (il dizionario `argvus`, `addWords:
true`), not to `ignorePaths`.

**`sudo` richiesto all'interno di `make install`, o errori di `libfakeroot.so … LD_PRELOAD`.** Un `package()` che richiama `make install` invece di usare `install -Dm*`. Entrambi i PKGBUILD chiamano `arch_package_splash_payload`, il quale non; assicurati che nessuno abbia reintrodotto una chiamata a `make`.

**`makepkg` si rifiuta di eseguire.** Non deve essere eseguito come root. Esegui la build come utente normale, o `sudo -u <user> make build`.

**Il pacchetto si installa ma la schermata iniziale non cambia.** L'initramfs non è stato ricostruito. Per test locali, chiama `sudo plymouth --show-splash` invece di riavviare, o ricostruisci con `sudo mkinitcpio -P` / `sudo dracut --regenerate-all`.
