---
title: Guia do Usuário
description: Guia de instalação e uso do tema de boot splash do ARGVUS.
---

# Argvus Boot Splash — Guia do Usuário

O boot splash do Argvus é um tema do [Plymouth](https://www.freedesktop.org/wiki/Software/Plymouth/)
para o ecossistema de desktop Argvus. É o que aparece entre ligar a máquina e o
momento em que a sua sessão gráfica inicia: um fundo escuro, o logotipo e a
palavra-marca do Argvus, uma barra de progresso que acompanha o progresso real do
boot e um diálogo de senha para volumes criptografados (LUKS).

O caminho mais rápido em sistemas Arch é:

```sh
sudo pacman -S argvus-boot-splash   # ou: sudo pacman -U ./argvus-boot-splash-<versão>-1-any.pkg.tar.zst
```

O instalador define o tema como padrão e regenera o initramfs automaticamente.
Se nada mudar no boot, a causa mais comum é a falta de reconstrução do initramfs
— veja [solução de problemas](user-guide/troubleshooting.md).

Este guia é para **usuários**. Se você quer compilar, modificar, assinar ou
publicar o pacote, leia o [guia do desenvolvedor](developer-guide.md).

## Guias

| Guia | Conteúdo |
| --- | --- |
| [Instalação](user-guide/installation.md) | Requisitos, as três formas de instalar, o que os hooks do pacote fazem |
| [Uso](user-guide/usage.md) | Verificar a instalação, pré-visualizar sem reiniciar, trocar ou voltar ao tema anterior |
| [Splash em UKI e systemd-boot](user-guide/uki-splash.md) | Usar o `argvus-uki-splash.bmp` em um boot com UKI |
| [Desinstalação](user-guide/uninstallation.md) | Remover o pacote e restaurar o tema anterior |
| [Solução de problemas](user-guide/troubleshooting.md) | Sintomas comuns e suas causas |
| [Referência](user-guide/reference.md) | Arquivos instalados, metadados do pacote, valores de cor |

## Onde encontrar mais

- Raiz do repositório: [README.md](../../README.md) — visão geral e estrutura
- Processo de desenvolvimento: [DEVELOPMENT.md](../../DEVELOPMENT.md) — builds, assinatura, lançamentos
- Contribuição: [CONTRIBUTING.md](../../CONTRIBUTING.md)
- Política de segurança: [SECURITY.md](../../SECURITY.md)
- Licença: [GPL-3.0-or-later](../../LICENSE)
- Versão em inglês: [English user guide](../en/user-guide.md)
