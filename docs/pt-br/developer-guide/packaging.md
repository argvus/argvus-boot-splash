---
title: Empacotamento
description: Metadados do pacote Arch, pipeline de build e alvos do Make.
---

# Empacotamento

Como o pacote Arch é definido e produzido: os dois PKGBUILDs, as funções
compartilhadas, os hooks de instalação, o pipeline de build local e os alvos do
Make.

Para o tema em si, veja [arquitetura do tema](/pt/docs/argvus-boot-splash/developer-guide/theme/); para validação, CI e
lançamentos, veja [CI e lançamentos](/pt/docs/argvus-boot-splash/developer-guide/ci-releases/).

## Dois PKGBUILDs, um payload

`packaging/arch/ci/PKGBUILD` e `packaging/arch/local/PKGBUILD` são idênticos
exceto por `source=`:

| | `local` | `ci` |
| --- | --- | --- |
| source | `${pkgname}-${pkgver}.tar.gz` (gerado por `make build`) | `${url}/archive/refs/tags/v${pkgver}.tar.gz` |
| usado por | desenvolvedores, `make build` | release do GitHub Actions |

Ambos chamam as mesmas funções de `packaging/arch/common/functions.sh`, e
`tools/sh/validate.sh` garante que os metadados deles (`pkgname`, `pkgver`,
`pkgrel`, `pkgdesc`, `arch`, `license`, `depends`, `makedepends`, `options`) sejam
idênticos, então os dois não podem divergir em silêncio.

Metadados compartilhados:

```bash
pkgname=argvus-boot-splash
pkgver=0.2.0
pkgrel=1
arch=('any')                 # pacote só de dados
depends=('plymouth')
optdepends=('mkinitcpio: rebuild initramfs (Arch Linux)'
            'dracut: rebuild initramfs (alternative)')
options=('!debug')
conflicts=('argvus-plymouth') # antecessor renomeado
replaces=('argvus-plymouth')
```

## Funções compartilhadas

`packaging/arch/common/functions.sh` fornece três funções usadas pelos dois
PKGBUILDs:

- `arch_normalize_source_tree` (`prepare()`) — os arquivos de tag do GitHub são
  extraídos em `<repo>-v<versão>`, enquanto o tarball local é extraído em
  `<pkgname>-<pkgver>`. A função renomeia o único diretório de nível superior para
  `${srcdir}/${pkgname}-${pkgver}`, falhando se o diretório de código-fonte
  estiver ausente, ambíguo, ou se o destino já existir.
- `arch_check_splash_payload` (`check()`) — garante que todo asset do tema exista
  no código-fonte extraído. Esta é a única "suíte de testes" do pacote; a lista
  de arquivos obrigatórios está no
  [inventário de assets](/pt/docs/argvus-boot-splash/developer-guide/theme/#inventário-de-assets).
- `arch_package_splash_payload` (`package()`) — percorre `src/usr` com
  `find -print0` e instala cada arquivo com `install -Dm644` no `$pkgdir`
  (seguro com NUL, funciona com espaços nos nomes) e depois instala o `LICENSE`
  em `/usr/share/licenses/argvus-boot-splash/LICENSE`.

Repare que não há chamada a `make install` dentro de `package()`: tudo é
`install -Dm*`, então o pacote é autossuficiente e amigável a builds sem
privilégio. Isso é deliberado — um `package()` antigo que chamava `make install`
produzia falhas de `sudo`/`libfakeroot.so`.

## Hooks de instalação

`packaging/arch/{ci,local}/argvus-boot-splash.install` (idênticos):

- `post_install()` / `post_upgrade()` → `plymouth-set-default-theme argvus`,
  depois `mkinitcpio -P` se disponível, senão `dracut --regenerate-all`, senão um
  aviso dizendo para reconstruir manualmente.
- `post_remove()` → apenas mensagem informativa; o tema não é trocado
  automaticamente (mais seguro do que adivinhar).

## Pipeline de build local

`tools/sh/pkgbuild_local.sh` (invocado por `make build`):

1. Verifica `makepkg`, `sha256sum`, `tar`, `awk`, `find` e se o PKGBUILD existe;
   faz source do PKGBUILD para ler `pkgname`/`pkgver` e valida os dois contra
   regexes de lista permitida (`^[a-z0-9@._+-]+$` para o nome, um padrão de
   versão pontilhada para a versão).
2. Gera `build/artifacts/${pkgname}-${pkgver}.tar.gz` com
   `tar --sort=name --mtime='UTC 1970-01-01' --owner=0 --group=0 --numeric-owner`
   e `--transform "s#^\./#${pkgname}-${pkgver}/#"` — um arquivo determinístico e
   reproduzível. Ele exclui `.git`, `build/`, `dist/`, `target/`, `tools/`, os
   diretórios temporários `release`/`packages-repo` e quaisquer sobras de
   `src/`, `pkg/` ou pacotes dentro dos diretórios de empacotamento.
3. Calcula o `sha256` do arquivo e o injeta com `sed` em uma **cópia temporária**
   do PKGBUILD local (`.PKGBUILD.local.XXXXXX`, removida por uma trap de `EXIT`).
   O repositório sempre mantém `sha256sums=()` vazio; `SKIP` nunca é usado.
4. Apaga qualquer `${pkgname}-${pkgver}-*.pkg.tar.zst` pré-existente em
   `build/dist/`, para que um pacote antigo não seja confundido com o resultado
   deste build.
5. Roda `makepkg -p <PKGBUILD gerado> --nodeps --noconfirm --needed --cleanbuild
   --force --check` com `BUILDDIR`/`SRCDEST` em `build/artifacts/` e `PKGDEST` em
   `build/dist/`. Argumentos extras são repassados ao `makepkg`; `MAKEPKG_FLAGS`
   substitui o conjunto padrão de flags (divisão por espaços proposital).
6. Falha a não ser que exatamente um `.pkg.tar.zst` corresponda e então roda o
   `namcap` nele, se instalado.

Saídas:

```text
build/dist/argvus-boot-splash-0.2.0-1-any.pkg.tar.zst   pacote instalável
build/artifacts/argvus-boot-splash-0.2.0.tar.gz          instantâneo do código
build/artifacts/argvus-boot-splash/{src,pkg}/            diretórios de trabalho
```

## Alvos do Make

| Alvo | Efeito |
| --- | --- |
| `make build` (apelido `make package`) | roda `tools/sh/pkgbuild_local.sh` → `build/` |
| `make install` (apelido `make install-package`) | `sudo pacman -U` do único pacote em `build/dist/`; falha se a contagem não for exatamente 1 |
| `make validate` | `tools/sh/validate.sh`: shellcheck + `bash -n` + sincronia de metadados dos PKGBUILD + `makepkg --printsrcinfo` em cada PKGBUILD + `git diff --check` |
| `make lint` (apelido `make lint-shell`) | shellcheck em `tools`, `packaging/arch/common`, `src` (`SC1090`, `SC2034`, `SC2154` desativados), `bash -n`, `git diff --check` |
| `make spellcheck` | `cspell --config cspell.json .` se o `cspell` estiver instalado, senão é pulado |
| `make changelog` | `git-cliff -o CHANGELOG.md` |
| `make clean` | `rm -rf build/` |
| `make help` | lista de alvos (alvo padrão) |

A CI roda `make validate` e `make build`; nada na CI roda `make install` ou
`make changelog` (veja [lacunas conhecidas](/pt/docs/argvus-boot-splash/developer-guide/workflow/#lacunas-conhecidas)).

## Pré-requisitos

Um sistema baseado em Arch com `make`, `git`, `gnupg` e o grupo `base-devel`:

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
```

- `pacman-contrib` fornece o `updpkgsums` (regera os checksums do PKGBUILD).
- `shellcheck` valida os scripts shell do repositório e as funções de
  empacotamento Arch compartilhadas.
- Opcional: `git-cliff` (changelog, `make changelog`), `namcap` (lint de pacote) e
  cspell (spellcheck local). A CI instala todos.
