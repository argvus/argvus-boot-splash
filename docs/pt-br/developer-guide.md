---
title: Guia do Desenvolvedor
description: Arquitetura e orientação de desenvolvimento para contribuidores do ARGVUS.
---

# Argvus Boot Splash — Guia do Desenvolvedor

Documentação técnica do repositório `argvus-boot-splash`: como o tema do Plymouth
é montado, como o pacote Arch é compilado e como os lançamentos são assinados e
publicados.

Aqui não há etapa de compilação — o tema é dado (um descritor `.plymouth`, um
`.script` e imagens) mais uma receita de pacote Arch. "Compilar" significa gerar
um pacote reproduzível:

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
make validate
make build      # -> build/dist/argvus-boot-splash-<versão>-1-any.pkg.tar.zst
make install    # sudo pacman -U nesse arquivo
```

Antes de commitar uma mudança: `make validate && make build`, e adicione novos
termos técnicos ao `.cspell/custom-dictionary-workspace.txt`, senão o job de
spellcheck falha.

Se você só quer *usar* o tema, leia o
[guia do usuário](user-guide.md). Para o complemento ligado ao processo (fluxo
git, segredos, disciplina do changelog), veja
[DEVELOPMENT.md](../../DEVELOPMENT.md) e [CONTRIBUTING.md](../../CONTRIBUTING.md).

## Guias

| Guia | Conteúdo |
| --- | --- |
| [Arquitetura do tema](developer-guide/theme.md) | Descritor, modelo de renderização, inventário de assets, walkthrough do script, constantes de layout, tokens de cor, bitmap de UKI, como modificar o tema |
| [Empacotamento](developer-guide/packaging.md) | Os dois PKGBUILDs, `functions.sh` compartilhado, hooks de instalação, pipeline de build local, alvos do Make, pré-requisitos |
| [CI e lançamentos](developer-guide/ci-releases.md) | `validate.sh`, `ci.yml`, `release.yml` passo a passo, checksums, assinatura, segredos, publicação, versionamento e changelog |
| [Convenções e lacunas conhecidas](developer-guide/workflow.md) | Regras da casa, mapa da documentação e inconsistências encontradas na auditoria do repositório |

## Referência rápida

| Caminho | O que é |
| --- | --- |
| `src/usr/share/plymouth/themes/argvus/` | payload do tema, instalado em `/usr` |
| `packaging/arch/{ci,local}/PKGBUILD` | receitas de pacote de lançamento e local |
| `packaging/arch/common/functions.sh` | `prepare`/`check`/`package` compartilhados |
| `tools/sh/pkgbuild_local.sh` | tarball determinístico + driver do `makepkg` |
| `tools/sh/validate.sh` | gate de validação obrigatório |
| `.github/workflows/` | `ci.yml` (validação, build, spellcheck), `release.yml` (tags `v*`) |

## Onde encontrar mais

- Raiz do repositório: [README.md](../../README.md)
- Documentação para o usuário final: [guia do usuário](user-guide.md)
- Processo de desenvolvimento: [DEVELOPMENT.md](../../DEVELOPMENT.md)
- Contribuição: [CONTRIBUTING.md](../../CONTRIBUTING.md)
- Política de segurança: [SECURITY.md](../../SECURITY.md)
- Licença: [GPL-3.0-or-later](../../LICENSE)
- Versão em inglês: [English developer guide](../en/developer-guide.md)
