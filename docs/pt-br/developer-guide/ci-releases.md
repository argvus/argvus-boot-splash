---
title: CI e Lançamentos
description: Validação, integração contínua, assinatura e fluxo de lançamento.
---

# CI e lançamentos

O gate de validação, os jobs de integração contínua, o pipeline de lançamento e
as regras de versionamento.

Para o pacote em si, veja [empacotamento](/pt/docs/argvus-boot-splash/developer-guide/packaging/); para o tema, veja
[arquitetura do tema](/pt/docs/argvus-boot-splash/developer-guide/theme/).

## Validação

`tools/sh/validate.sh` é o gate obrigatório:

- exige `bash`, `makepkg` e `shellcheck`;
- `shellcheck` + `bash -n` em `tools/sh/*.sh` e `packaging/arch/common/*.sh`;
- faz source dos dois PKGBUILDs e compara os metadados extraídos — CI e local
  precisam ser iguais;
- `makepkg -p PKGBUILD --printsrcinfo` dentro de `ci/` e `local/` (interpreta o
  arquivo como o makepkg faria);
- `git diff --check` (espaços em branco e marcadores de conflito).

## Integração contínua

`.github/workflows/ci.yml` (push/PR para `main`, container `archlinux:latest`):

1. instala `base-devel git namcap pacman-contrib shellcheck sudo`;
2. `make validate`;
3. compila como um usuário **sem privilégio** `builder`
   (`sudo -u builder env HOME=/home/builder make build`) — o makepkg se recusa a
   rodar como root, e o workspace recebe `chown` antes;
4. um job separado de `spellcheck` roda `cspell-action@v6` com `cspell.json`.

O `namcap` roda dentro de `pkgbuild_local.sh` quando instalado, então builds
locais mostram o mesmo lint da CI. A configuração do spellcheck é `cspell.json`,
com o dicionário do workspace em `.cspell/custom-dictionary-workspace.txt` —
novos termos técnicos (flags de shell, nomes de ferramentas) pertencem a esse
dicionário, senão a CI falha.

## Pipeline de lançamento

`.github/workflows/release.yml` — gatilhos: push de uma tag `v*`, ou
`workflow_dispatch` com uma tag existente (rebuild controlado). Grupo de
concorrência `release-<ref>`, sem cancelamento.

Etapas:

1. **Checkout** da tag (no dispatch usa `inputs.tag`).
2. **Etapa de versão**: valida a tag contra
   `^v[0-9]+(\.[0-9]+)*([._+-][A-Za-z0-9]+)*$`, falha se `url` estiver vazio em
   `packaging/arch/ci/PKGBUILD` e então reescreve o `pkgver` a partir da tag.
3. **Validação**: `make validate`.
4. **Build** como `builder` sem privilégio: `updpkgsums` (resolve e valida o
   `sha256sums` real) e depois
   `makepkg --nodeps --noconfirm --needed --cleanbuild --clean --check`.
   Localiza o `.pkg.tar.zst` e falha se nenhum existir.
5. **namcap** no pacote.
6. **Assinatura**: importa `GPG_PRIVATE_KEY` em um `GNUPGHOME` descartável
   (`mktemp -d`, modo 700), verifica se a chave secreta importada corresponde a
   `GPG_KEY_ID` (ID curto ou fingerprint) e cria um `.sig` destacado com
   `--pinentry-mode loopback --passphrase-fd 0`.
7. **Verificação da assinatura** em um `GNUPGHOME` novo — o lançamento falha se a
   assinatura não verificar.
8. **Upload do artefato** (`upload-artifact@v4`, `retention-days: 1`, pacote +
   assinatura, `if-no-files-found: error`).
9. **Publicação**: faz checkout de `argvus/packages` com `PACKAGES_REPO_TOKEN`,
   copia o pacote e o `.sig` para `public/arch/x86_64`, roda
   `repo-add -R argvus.db.tar.gz <pkg>`, assina `argvus.db.tar.gz`,
   `argvus.files.tar.gz`, `argvus.db` e `argvus.files` e então commita como
   `github-actions[bot]` e envia. Um diff sem mudanças sai com 0 sem commitar.
10. **Release no GitHub**: `softprops/action-gh-release@v2` com notas geradas e o
    pacote mais a assinatura como anexos.

## Checksums, assinatura e segredos

- Não existe `SKIP`: `sha256sums` é sempre um digest real, calculado no momento
  do build (local) ou via `updpkgsums` (CI de release).
- Mantenha `sha256sums=()` **vazio** no repositório.
- Os lançamentos são assinados com GPG (`.sig` do pacote, `argvus.db.tar.gz`,
  `argvus.files.tar.gz`, `argvus.db`, `argvus.files`).
- `GPG_PASSPHRASE` precisa ser não vazia; o workflow recusa uma senha vazia.

Preparando a chave:

```sh
gpg --full-generate-key            # RSA 4096, sem expiração recomendado
gpg --list-secret-keys --with-colons | grep ^sec:   # anote o KEY_ID
gpg --armor --export-secret-keys KEY_ID            # o que o workflow importa
```

Em **Settings → Secrets and variables → Actions** do repositório:

| Segredo | Valor |
| --- | --- |
| `GPG_PRIVATE_KEY` | saída de `gpg --armor --export-secret-keys KEY_ID` |
| `GPG_KEY_ID` | ID ou fingerprint esperado da chave de assinatura |
| `GPG_PASSPHRASE` | senha não vazia da chave de assinatura |
| `PACKAGES_REPO_TOKEN` | PAT com escopo `contents:write` em `argvus/packages` |

## Publicando um lançamento

Antes de criar a tag:

1. Preencha `url` em `packaging/arch/ci/PKGBUILD` com o repositório real:
   - GitHub: `url="https://github.com/argvus/argvus-boot-splash"` (o source usa
     `${url}/archive/refs/tags/v${pkgver}.tar.gz`);
   - GitLab: ajuste o `source=` para
     `https://gitlab.com/argvus/argvus-boot-splash/-/archive/v${pkgver}/argvus-boot-splash-v${pkgver}.tar.gz`;
   - sem `url`, o lançamento **falha de propósito** com uma mensagem clara.
2. Sincronize versões/metadados em `packaging/arch/local/PKGBUILD` e
   `packaging/arch/ci/PKGBUILD`.
3. Regenere e commite o `CHANGELOG.md` (veja
   [versionamento](#versionamento-e-changelog)).
4. Crie e envie a tag:

   ```sh
   git tag v0.1.0
   git push origin v0.1.0
   ```

   O workflow também pode ser iniciado manualmente com uma tag `v*` existente no
   campo `tag`, o que é útil para um rebuild controlado.

## Versionamento e changelog

- SemVer no `pkgver`, contador de release no `pkgrel`.
- O `CHANGELOG.md` é gerado pelo `git-cliff` a partir de Conventional Commits,
  usando `cliff.toml`: grupos `feat`, `fix`, `docs`, `refactor`, `test`, `ci`,
  `perf`, `build`; commits `chore` são ignorados; commits são ordenados do mais
  antigo para o mais novo.
- Gere **antes** de taguear, commite o resultado e só então crie a tag — do
  contrário os commits já ficam atribuídos à nova versão e a seção datada só se
  resolve na próxima execução.

  ```sh
  make changelog
  git add CHANGELOG.md
  git commit -m "docs(changelog): update for v0.1.0"
  git tag v0.1.0
  git push origin v0.1.0
  ```

- As entradas pendentes aparecem em `## [Unreleased]`; `[Unreleased]` vira
  `## [X.Y.Z] - <data>` assim que existir uma tag.
- `git-cliff --unreleased --strip header` mostra as mudanças pendentes,
  `git-cliff --bump` sugere a próxima versão.
- Um repositório sem nenhum commit faz `make changelog` falhar
  (`reference 'refs/heads/main' not found`).

## Solução de problemas do desenvolvedor

**O lançamento falha em "Retrieving sources".** `url` vazia, tag `v*` ausente, ou
um formato de URL de arquivo que não corresponde ao host (layout de tarball do
GitHub vs GitLab). O workflow valida o padrão da tag e falha cedo com `url` vazia.

**O `updpkgsums` não encontra o código-fonte.** A tag precisa existir e ter sido
enviada antes do job de release; disparar com uma tag que só existe localmente
falha aqui.

**`make validate` reclama que "CI and local PKGBUILD metadata is out of sync".**
Copie os campos de metadados (não o `source=`) de um PKGBUILD para o outro.

**O spellcheck falha em um termo novo.** Adicione-o ao
`.cspell/custom-dictionary-workspace.txt` (o dicionário `argvus`, com
`addWords: true`), e não ao `ignorePaths`.

**O `sudo` é pedido dentro do `make install`, ou aparecem erros de
`libfakeroot.so … LD_PRELOAD`.** Um `package()` que chama `make install` em vez
de usar `install -Dm*`. Os dois PKGBUILDs chamam `arch_package_splash_payload`,
que não faz isso; confira se ninguém reintroduziu uma chamada a `make`.

**O makepkg se recusa a rodar.** Ele não pode rodar como root. Rode o build como
usuário normal, ou `sudo -u <usuário> make build`.

**O pacote instala mas a tela de boot não muda.** O initramfs não foi
reconstruído. Para testes locais, chame `sudo plymouth --show-splash` em vez de
reiniciar, ou reconstrua com `sudo mkinitcpio -P` /
`sudo dracut --regenerate-all`.
