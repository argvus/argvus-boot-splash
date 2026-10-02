---
title: Instalação
description: Requisitos, formas de instalar e o que os hooks do pacote fazem.
---

# Instalação

Tudo o que é preciso para colocar o boot splash do Argvus em um sistema baseado
em Arch.

Para ver o que o tema contém, consulte a
[referência](reference.md). Para compilá-lo a partir do código-fonte, veja o
[guia do desenvolvedor](../developer-guide.md).

## Requisitos

- Um sistema baseado em Arch com `plymouth` (o pacote depende dele).
- Um gerador de initramfs: **mkinitcpio** (padrão do Arch) ou **dracut**. O
  instalador detecta o que estiver presente e regenera o initramfs por você.
- O Plymouth precisa estar habilitado na configuração do initramfs. Com o
  mkinitcpio, verifique se `plymouth` está na lista `HOOKS` do
  `/etc/mkinitcpio.conf`:

  ```ini
  HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont plymouth)
  ```

  Reinicie se você acabou de alterar isso.

- Nada é necessário para uma sessão gráfica normal; o tema só roda no caminho do
  boot.

## Opção 1: repositório oficial de pacotes (recomendado)

Os pacotes assinados são publicados no repositório de pacotes do Argvus
(`argvus/packages`, caminho `public/arch/$arch`). Adicione-o ao
`/etc/pacman.conf`:

```ini
[argvus]
SigLevel = Required DatabaseOptional
Server = <PACKAGES_REPO_BASE_URL>/argvus/packages/raw/branch/main/public/arch/$arch
```

Substitua `<PACKAGES_REPO_BASE_URL>` pelo host em que o projeto publica o
repositório (GitHub, GitLab ou Gitea). Importe antes a chave de assinatura do
repositório, caso contrário o `pacman` recusa o download:

```sh
# 1. importe a chave pública de assinatura do projeto para o seu chaveiro do pacman
pacman-key --add /caminho/para/argvus-signing-key.asc
pacman-key --lsign <id-da-chave>

# 2. atualize e instale
sudo pacman -Sy
sudo pacman -S argvus-boot-splash
```

## Opção 2: arquivo de pacote do lançamento

Cada lançamento com tag publica um `.pkg.tar.zst` (e o respectivo `.sig`) como
anexo do release. Instale diretamente:

```sh
sudo pacman -U ./argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```

Se você se preocupa com a cadeia de suprimentos, verifique a assinatura destacada
contra a chave pública do projeto antes de instalar:

```sh
gpg --verify argvus-boot-splash-0.2.0-1-any.pkg.tar.zst.sig \
        argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```

## Opção 3: instalação manual

Útil em sistemas que não são Arch, ou se você só quiser experimentar o tema sem
empacotamento. Copie o diretório do tema para o caminho de temas do Plymouth:

```sh
sudo cp -r src/usr/share/plymouth/themes/argvus \
           /usr/share/plymouth/themes/argvus

sudo plymouth-set-default-theme argvus
sudo update-initramfs -u        # Debian/Ubuntu
# ou: sudo mkinitcpio -P        # Arch
# ou: sudo dracut --regenerate-all
```

No Plymouth também é possível habilitar a opção em `/etc/default/grub`, com
`GRUB_CMDLINE_LINUX` contendo `splash`; `quiet` dá o visual clássico de boot
mínimo.

Se preferir compilar o pacote a partir do repositório, veja o
[guia do desenvolvedor](../developer-guide.md).

## O que o instalador faz

Após a instalação ou atualização, os hooks do pacote são executados
automaticamente:

1. `plymouth-set-default-theme argvus` — grava `argvus` em
   `/etc/plymouth/plymouthd.conf`.
2. `mkinitcpio -P` se o mkinitcpio existir; caso contrário `dracut --regenerate-all`.

Se nenhum dos dois geradores for encontrado, o instalador mostra um aviso e você
precisa reconstruir o initramfs manualmente. Uma mudança de tema só fica visível
no boot depois que o initramfs é regenerado — reiniciar sem essa etapa é o motivo
número um de "a tela de boot não mudou".

Na remoção, o pacote apenas imprime um lembrete: escolher outro tema e
reconstruir o initramfs fica por sua conta. Veja
[desinstalação](uninstallation.md).

## Próximos passos

- [Uso](usage.md) — verificar a instalação, pré-visualizar sem reiniciar, trocar
  de tema.
- [Splash em UKI e systemd-boot](uki-splash.md) — usar o bitmap em uma UKI.
- [Solução de problemas](troubleshooting.md) — se a tela de boot não mudou.
