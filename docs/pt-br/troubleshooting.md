---
title: Solução de problemas
description: Sintomas comuns da tela de boot e como resolvê-los.
---

# Solução de problemas

**A tela de boot não mudou depois de instalar.**
O initramfs não foi regenerado. Rode `sudo mkinitcpio -P` (ou
`sudo dracut --regenerate-all`) e reinicie. Se o sistema tem vários kernels,
verifique se aquele em que você boota recebeu o initramfs novo.

**Nenhuma tela de boot; a tela está preta ou só com texto.**
Falta o `plymouth` nos hooks do initramfs. Confira se `HOOKS=(...)` em
`/etc/mkinitcpio.conf` contém `plymouth`, regenere e reinicie. No Ubuntu/Debian,
confirme também que `plymouth` e `plymouth-x11`/`plymouth-themes` estão
instalados e que `GRUB_CMDLINE_LINUX` tem `splash quiet`.

**Só o logotipo, sem progresso.**
Alguns passos do boot não são reportados pelo seu init, ou o callback de
progresso nunca é chamado — não há nada quebrado do seu lado. A barra preenche a
partir do progresso reportado pelo Plymouth, que falta em algumas
configurações (por exemplo, sequências do systemd sem `plymouth-spawn` ou
determinados módulos do dracut).

**O prompt de senha está fora de lugar ou invisível.**
O diálogo é posicionado a partir da geometria da palavra-marca e do trilho, então
resoluções extremas (modo texto muito pequeno) podem empurrá-lo para fora da
tela. Use uma resolução normal e relate o problema se acontecer em resoluções
comuns.

**O Plymouth sai antes / você vê o console de texto.**
Algo desabilitou o Plymouth: o parâmetro `quiet` sem `splash`, um hook
`plymouth` removido, ou um driver que o Plymouth não consegue usar. O Plymouth
sai para o console de texto em vez de travar a máquina — esse é o comportamento
esperado.

**O tema não é aplicado depois de atualizar a partir do `argvus-plymouth`.**
O novo pacote substitui o antigo; verifique se
`/etc/plymouth/plymouthd.conf` diz `PLYMOUTH_THEME_NAME=argvus` e regenere o
initramfs.

**A instalação falha na verificação da assinatura.**
A chave do repositório está faltando ou desatualizada no seu chaveiro.
Reimporte a chave pública atual e rode `sudo pacman -Sy`.

**A tela de bloqueio / suspensão não mudou.**
O tema só cobre o boot. As telas de hibernação e retomada são controladas à
parte (`systemd-homed`, bloqueadores de tela, uso de `plymouth` no alvo de
suspensão do initramfs).

**Um Plymouth órfão continua rodando depois de uma pré-visualização.**
Use `sudo plymouthquit` para voltar à sessão. Se a tela continuar preta, troque
para outro terminal virtual (`Ctrl+Alt+F2`) — a sua sessão está intacta.

## Próximos passos

- [Instalação](/pt/docs/argvus-boot-splash/installation/) — tentar outro método.
- [Uso](/pt/docs/argvus-boot-splash/usage/) — tabela rápida de comandos.
