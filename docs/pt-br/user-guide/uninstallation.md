---
title: Desinstalação
description: Remova o pacote e restaure o tema de boot anterior.
---

# Desinstalação

```sh
sudo pacman -Rns argvus-boot-splash
```

Depois escolha outro tema e regenere, senão a tela antiga continua dentro do
initramfs:

```sh
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme
sudo mkinitcpio -P        # ou: sudo dracut --regenerate-all
```

O `pacman -Rns` também remove o `/etc/plymouth/plymouthd.conf`, caso nada mais
o tenha criado.

O hook de remoção do pacote apenas imprime um lembrete — ele não adivinha qual
tema você quer no lugar e não mexe no seu initramfs.

## Próximos passos

- [Solução de problemas](troubleshooting.md) — recuperar a tela anterior.
- [Instalação](installation.md) — reinstalar mais tarde.
