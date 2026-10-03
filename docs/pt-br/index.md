---
title: ARGVUS Boot Splash
description: Tema Plymouth e guia de instalação para o ambiente de desktop ARGVUS
---

# ARGVUS Boot Splash

O tema de boot Argvus é um tema [Plymouth](https://www.freedesktop.org/wiki/Software/Plymouth/) para o ecossistema de desktop Argvus. É o que você vê entre ligar a máquina e o momento em que sua sessão gráfica inicia.

## Documentação

Esta documentação está organizada em duas seções principais:

### Guia do Usuário
Guias de instalação e uso para usuários finais e administradores de sistema.

| Guia | Conteúdo |
| --- | --- |
| [Instalação](/pt/docs/argvus-boot-splash/installation/) | Requisitos, as três formas de instalar, o que os hooks do pacote fazem |
| [Uso](/pt/docs/argvus-boot-splash/usage/) | Verificar a instalação, pré-visualizar sem reiniciar, trocar ou voltar ao tema anterior |
| [Splash em UKI e systemd-boot](/pt/docs/argvus-boot-splash/uki-splash/) | Usar o `argvus-uki-splash.bmp` em um boot com UKI |
| [Desinstalação](/pt/docs/argvus-boot-splash/uninstallation/) | Remover o pacote e restaurar o tema anterior |
| [Solução de problemas](/pt/docs/argvus-boot-splash/troubleshooting/) | Sintomas comuns e suas causas |
| [Referência](/pt/docs/argvus-boot-splash/reference/) | Arquivos instalados, metadados do pacote, valores de cor |

### [Guia do Desenvolvedor](/pt/docs/argvus-boot-splash/developer-guide/)
Documentação técnica para colaboradores e mantenedores.

- [Arquitetura do Tema](/pt/docs/argvus-boot-splash/developer-guide/theme/) — Descritor Plymouth, modelo de renderização e personalização
- [Pacotes](/pt/docs/argvus-boot-splash/developer-guide/packaging/) — Pipeline de build e receitas de pacotes
- [CI e Lançamentos](/pt/docs/argvus-boot-splash/developer-guide/ci-releases/) — Validação, testes e fluxo de lançamento

## Início Rápido

Para sistemas baseados em Arch:

```sh
sudo pacman -S argvus-boot-splash   # ou: sudo pacman -U ./argvus-boot-splash-<versão>-1-any.pkg.tar.zst
```

O instalador define o tema como padrão e regenera seu initramfs automaticamente.

---

- **Repositório:** [github.com/argvus/argvus-boot-splash](https://github.com/argvus/argvus-boot-splash)
- **Licença:** GPL-3.0-only
- **Relatórios de Bugs:** [Problemas do GitHub](https://github.com/argvus/argvus-boot-splash/issues)
