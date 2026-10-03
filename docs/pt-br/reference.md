---
title: Referência
description: Arquivos instalados, metadados do pacote e valores de cor.
---

# Referência

Referência técnica do que o pacote instala e quais valores ele usa.

## O que você recebe

| Componente | Descrição |
| --- | --- |
| Logotipo do Argvus | Marca centralizada, desenhada acima da palavra-marca |
| Palavra-marca | O texto `ARGVUS` abaixo do logotipo |
| Barra de progresso | Barra fina cuja largura acompanha o progresso real do boot |
| Diálogo de senha | Prompt de LUKS com campo de entrada mascarado (balas `•`) |
| Fade-in | A tela aparece com fade de ~1 segundo quando o Plymouth inicia |
| Bitmap de UKI | `argvus-uki-splash.bmp` para boot com UKI / systemd-boot |

O nome do pacote é `argvus-boot-splash` e ele substitui o pacote mais antigo
`argvus-plymouth`, caso você o tivesse instalado.

## Arquivos instalados

Em `/usr/share/plymouth/themes/argvus/`:

| Arquivo | Tamanho | Finalidade |
| --- | --- | --- |
| `argvus.plymouth` | — | descritor do tema (nome, descrição, módulo) |
| `argvus.script` | — | o script do tema (a própria linguagem de script do Plymouth) |
| `argvus-logo.png` | 256x256 | logotipo, RGBA |
| `argvus-text.png` | 400x53 | palavra-marca, RGBA |
| `progress-bar.png` | 400x4 | parte preenchida da barra de progresso |
| `progress-bar-track.png` | 400x4 | trilho não preenchido |
| `entry-box.png` | 400x48 | campo de entrada da senha |
| `entry-line.png` | 300x2 | linha de base do campo de senha |
| `bullet.png` | 12x12 | caractere mascarado |
| `logo-glow.png` | 260x300 | arte do brilho do logotipo |
| `argvus-uki-splash.bmp` | 400x400, 32 bits | bitmap de splash para UKI/systemd-boot |

Mais a licença em `/usr/share/licenses/argvus-boot-splash/LICENSE`.

## Metadados do pacote

| Campo | Valor |
| --- | --- |
| Nome | `argvus-boot-splash` |
| Arquitetura | `any` |
| Dependências | `plymouth` |
| Dependências opcionais | `mkinitcpio`, `dracut` |
| Conflitos / substitui | `argvus-plymouth` |
| Licença | GPL-3.0-only |

## Cores

| Elemento | Cor |
| --- | --- |
| Fundo | `#111316` |
| Destaque (logotipo, palavra-marca, preenchimento da barra) | `#3590BD` |
| Trilho de progresso | `#262933` |
| Texto do prompt de senha | azul-claro acinzentado (`#B8C4CE`) |

O tema usa um fundo sólido escuro em qualquer resolução, então nunca alterna
automaticamente entre variantes clara e escura.

## Onde encontrar ajuda

- Relate bugs e peça recursos no rastreador de issues do projeto.
- Problemas de segurança: siga o [SECURITY.md](https://github.com/argvus/argvus-boot-splash/blob/main/SECURITY.md) — não abra
  issue pública para vulnerabilidades.
- Código-fonte, builds e lançamentos: a raiz do repositório
  ([README](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)).
- Contribuição: [CONTRIBUTING.md](https://github.com/argvus/argvus-boot-splash/blob/main/CONTRIBUTING.md).
- Licença: [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE).
- Versão em inglês: [English reference](/docs/argvus-boot-splash/reference/).

## Próximos passos

- [Instalação](/pt/docs/argvus-boot-splash/installation/)
- [Uso](/pt/docs/argvus-boot-splash/usage/)
- [Solução de problemas](/pt/docs/argvus-boot-splash/troubleshooting/)
