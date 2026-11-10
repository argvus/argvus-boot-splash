---
title: Dépannage
description: Symptômes courants de l'écran de démarrage et comment les réparer.
---
# Dépannage

**L'écran de démarrage n'a pas changé après l'installation.**
L'initramfs n'a pas été régénéré. Exécutez `sudo mkinitcpio -P` (ou `sudo dracut --regenerate-all`) et redémarrez. Si votre système utilise plusieurs noyaux, assurez-vous que celui que vous démarrez a obtenu le nouvel initramfs.

**Aucun écran de démarrage ; l'écran est noir ou uniquement du texte.**
`plymouth` manque dans les hooks de l'initramfs. Vérifiez `/etc/mkinitcpio.conf`. `HOOKS=(...)` contient `plymouth`, puis reconstruisez et redémarrez. Sur Ubuntu/Debian, confirmez également que `plymouth` et `plymouth-x11`/`plymouth-themes` sont installés et que `GRUB_CMDLINE_LINUX` a `splash quiet`.

**Seulement le logo, pas de progression.**
Certaines étapes de démarrage ne sont pas signalées par votre init, ou le rappel de progression n'est jamais appelé — rien n'est cassé de votre côté. La barre se remplit à partir de la progression signalée par Plymouth, qui est absente dans quelques configurations (par exemple avec les séquences sans `plymouth-spawn` de systemd ou certains modules dracut).

**L'invite de mot de passe est mal placée ou invisible.**
La boîte de dialogue est positionnée par rapport au logo et à la géométrie du suivi, donc des résolutions extrêmes (mode texte très petit) peuvent la faire sortir de l'écran. Utilisez une résolution normale et signalez-le si cela se produit à des résolutions courantes.

**Plymouth se ferme prématurément / vous voyez la console texte à la place.**
Quelque chose a désactivé Plymouth : le paramètre de démarrage `quiet` sans `splash`, un hook `plymouth` supprimé, ou un pilote que Plymouth ne peut pas utiliser. Plymouth revient à la console texte au lieu de bloquer la machine — c'est un comportement attendu.

**Le thème n'est pas appliqué après la mise à niveau depuis `argvus-plymouth`.**
Le nouveau paquet remplace l'ancien ; vérifiez que `/etc/plymouth/plymouthd.conf` indique `PLYMOUTH_THEME_NAME=argvus` et reconstruisez l'initramfs.

**L'installation échoue lors de la vérification de la signature.**
La clé du dépôt est manquante ou obsolète dans votre trousseau de clés. Réimportez la clé publique actuelle, puis `sudo pacman -Sy`.

**L'écran de verrouillage / veille semble inchangé.**
Le thème ne couvre que le démarrage. Les écrans d'hibernation/reprise sont contrôlés séparément
(`systemd-homed`, verrous d'écran, utilisation `plymouth` dans la cible sommeil de votre
initramfs).

**Un Plymouth errant fonctionne encore après un aperçu.**
`sudo plymouthquit` restaure votre session. Si l'écran reste noir, passez à
un autre terminal virtuel (`Ctrl+Alt+F2`) — votre session est intacte.

## Prochaines étapes

- [Installation](/docs/argvus-boot-splash/installation/) — réessayez avec une méthode différente.
- [Usage](/docs/argvus-boot-splash/usage/) — feuille de commandes.
