---
title: Convenções e Lacunas Conhecidas
description: Regras da casa, mapa da documentação e achados da auditoria do repositório.
---

# Convenções e lacunas conhecidas

As regras deste repositório, mais as inconsistências encontradas durante a
auditoria — vale corrigir em vez de copiar.

Para a referência técnica, veja [arquitetura do tema](theme.md),
[empacotamento](packaging.md) e [CI e lançamentos](ci-releases.md).

## Convenções

- Shell: `set -euo pipefail`, indentação com tabs, mensagens via
  `printf`/`error` para stderr, checagens de capacidade com `command -v`, limpo
  no shellcheck (veja `.editorconfig`).
- Nunca escreva `sha256sums=('SKIP')`; mantenha `sha256sums=()` vazio no git.
- Não commite saídas de build (`build/`), arquivos de pacote ou cópias geradas
  `.PKGBUILD.local.*`.
- Conventional Commits com os escopos usados no histórico: `splash`, `layout`,
  `pkgbuild`, `release`, `chore`, `ci`, `build`, `docs`.
- Nomes de branch: `feat/…`, `fix/…`, `docs/…`, `chore/…`, `refactor/…`.
- Uma aprovação de revisor antes do merge, squash-merge.
- Licença: GPL-3.0-or-later. Instalada em
  `/usr/share/licenses/argvus-boot-splash/LICENSE`.
- Siga o processo descrito em
  [CONTRIBUTING.md](../../../CONTRIBUTING.md) e
  [DEVELOPMENT.md](../../../DEVELOPMENT.md).

## Lacunas conhecidas

Inconsistências documentadas encontradas na auditoria do repositório:

- O `README.md` anuncia `make test` para uma pré-visualização direta do
  Plymouth, mas não existe esse alvo no [Makefile](../../../Makefile). Os
  comandos reais são `sudo plymouth --show-splash` / `sudo plymouthquit`.
- `entry-line.png` e `logo-glow.png` vão no payload e são exigidos por
  `arch_check_splash_payload()`, mas o `argvus.script` nunca os carrega. Ou
  conecte-os ao script, ou remova-os do payload e da lista de verificação.
- `src/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp` é instalado, mas
  nunca registrado em lugar nenhum; o
  [guia do usuário](../user-guide/uki-splash.md) documenta o passo manual com
  `bootctl`/`ukify`.
- A documentação canônica fica na raiz do repositório (`README.md`,
  `DEVELOPMENT.md`, `CONTRIBUTING.md`) e se sobrepõe aos guias em `docs/`. Mantenha
  os dois lados coerentes ao alterar qualquer um deles.

## Mapa da documentação

| Documento | Público | Escopo |
| --- | --- | --- |
| `README.md` | todos | visão geral em um parágrafo e estrutura |
| `DEVELOPMENT.md` | mantenedores | processo de build, assinatura e lançamento |
| `CONTRIBUTING.md` | contribuidores | fluxo git, regras de PR, política de segredos |
| [`docs/user-guide.md`](../user-guide.md) | usuário final | instalação, uso, solução de problemas |
| [`docs/developer-guide.md`](../developer-guide.md) | desenvolvedores | internals do tema, empacotamento, CI |
| [`docs/en/`](../../en/) | falantes de inglês | estas mesmas páginas em inglês |
| [`docs/pt-br/`](.) | falantes de português | estas mesmas páginas em português |

## Próximos passos

- [Arquitetura do tema](theme.md)
- [Empacotamento](packaging.md)
- [CI e lançamentos](ci-releases.md)
