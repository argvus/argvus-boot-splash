---
title: ARGVUS Boot Splash
description: Tema Plymouth e guia de instalação para o ambiente de desktop ARGVUS
---

# ARGVUS Boot Splash

O tema de boot Argvus é um tema [Plymouth](https://www.freedesktop.org/wiki/Software/Plymouth/) para o ecossistema de desktop Argvus. É o que você vê entre ligar a máquina e o momento em que sua sessão gráfica inicia.

## Documentação

Esta documentação está organizada em duas seções principais:

### [Guia do Usuário](user-guide/)
Guias de instalação e uso para usuários finais e administradores de sistema.

- [Instalação](user-guide/installation.md) — Requisitos do sistema e métodos de instalação
- [Uso](user-guide/usage.md) — Verificação, visualização e gerenciamento de temas
- [Solução de Problemas](user-guide/troubleshooting.md) — Problemas comuns e soluções
- [Desinstalação](user-guide/uninstallation.md) — Removendo o pacote

### [Guia do Desenvolvedor](developer-guide/)
Documentação técnica para colaboradores e mantenedores.

- [Arquitetura do Tema](developer-guide/theme.md) — Descritor Plymouth, modelo de renderização e personalização
- [Pacotes](developer-guide/packaging.md) — Pipeline de build e receitas de pacotes
- [CI e Lançamentos](developer-guide/ci-releases.md) — Validação, testes e fluxo de lançamento

## Início Rápido

Para sistemas baseados em Arch:

```sh
sudo pacman -S argvus-boot-splash
```

O instalador define o tema como padrão e regenera seu initramfs automaticamente.

---

- **Repositório:** [github.com/argvus/argvus-boot-splash](https://github.com/argvus/argvus-boot-splash)
- **Licença:** GPL-3.0-or-later
- **Relatórios de Bugs:** [Problemas do GitHub](https://github.com/argvus/argvus-boot-splash/issues)
