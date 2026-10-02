---
title: Uso
description: Verificar a instalação, pré-visualizar sem reiniciar e trocar temas.
---

# Uso

Como verificar o tema, pré-visualizá-lo sem reiniciar a máquina e trocar por
outro quando quiser. Para a instalação, veja
[instalação](/pt/docs/argvus-boot-splash/installation/).

## Verificando a instalação

```sh
# o tema está instalado?
ls /usr/share/plymouth/themes/argvus

# qual é o tema padrão?
plymouth-set-default-theme          # imprime, por exemplo: argvus

# o Plymouth interpretou o tema sem erros?
sudo plymouth --show-splash
```

## Pré-visualizando sem reiniciar

```sh
sudo plymouth --show-splash   # mostra a tela de boot simulando o boot
sudo plymouthquit             # volta para a sua sessão
```

A pré-visualização pode pedir autenticação polkit quando executada por um
usuário sem privilégios. A barra de progresso avança com o progresso simulado;
você também pode forçar os estados:

```sh
sudo plymouth --show-details   # mensagens de boot detalhadas no lugar da tela
sudo plymouth --show-splash    # volta para a tela de boot
```

Com a tela de boot ativa, pressione <kbd>Esc</kbd> para alternar para a próxima
tela (splash → detalhes → splash).

## O que aparece na tela

| Etapa | Aparência |
| --- | --- |
| Inicialização | Tudo aparece com fade de ~1 segundo: logotipo, palavra-marca, trilho de progresso |
| Boot | A barra preenche da esquerda para a direita conforme o Plymouth reporta o progresso |
| Volume criptografado | A tela escurece para 15%, o texto do prompt e as balas mascaradas aparecem abaixo da barra |
| Senha aceita | O diálogo some e a tela volta à opacidade total |

## Trocando ou voltando ao tema anterior

```sh
# trocar de tema (qualquer nome em /usr/share/plymouth/themes)
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme

# depois regenere o initramfs
sudo mkinitcpio -P              # ou: sudo dracut --regenerate-all
```

Arquivos de configuração úteis:

| Arquivo | Finalidade |
| --- | --- |
| `/etc/plymouth/plymouthd.conf` | `PLYMOUTH_THEME_NAME=argvus`, gravado pelo pacote |
| `/etc/mkinitcpio.conf` | `HOOKS=(... plymouth ...)` precisa conter `plymouth` |
| `/etc/plymouth/plymouthd.conf` (de novo) | `PLYMOUTH_TOGGLE_KEY` etc. são globais, não por tema |

## Tabela rápida de comandos

| Comando | Efeito |
| --- | --- |
| `sudo plymouth-set-default-theme argvus` | define `argvus` como tema padrão |
| `sudo plymouth-update-theme` | aplica a mudança no Plymouth em execução |
| `sudo plymouth --show-splash` | mostra a tela de boot na sessão atual |
| `sudo plymouth --show-details` | mostra mensagens de boot detalhadas |
| `sudo plymouthquit` | sai do Plymouth e restaura a sessão |
| `sudo mkinitcpio -P` | reconstrói o initramfs do Arch |
| `sudo dracut --regenerate-all` | reconstrói o initramfs com o dracut |

## Próximos passos

- [Splash em UKI e systemd-boot](/pt/docs/argvus-boot-splash/uki-splash/)
- [Desinstalação](/pt/docs/argvus-boot-splash/uninstallation/)
- [Solução de problemas](/pt/docs/argvus-boot-splash/troubleshooting/)
