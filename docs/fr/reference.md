---
title: Référence
description: Fichiers installés, métadonnées du paquet et valeurs de couleur.
---

# Référence

Référence technique sur ce que le package installe et quelles valeurs il utilise.

## Ce que vous obtenez

| Composant | Description |
| --- | --- |
| Logo Argvus | Marque centrée, dessinée au-dessus du mot-symbole |
| Mot-symbole | Texte `ARGVUS` sous le logo |
| Barre de progression | Barre fine dont la largeur reflète la progression du démarrage de Plymouth |
| Boîte de dialogue de mot de passe | Invite LUKS avec un champ de saisie masqué (`•` puces) |
| Fondu entrant | L'écran de démarrage apparaît en fondu sur ~1 seconde lorsque Plymouth démarre |
| Bitmap UKI | `argvus-uki-splash.bmp` pour les démarrages basés sur UKI / systemd-boot |

Le nom du package est `argvus-boot-splash` et il remplace l'ancien
package `argvus-plymouth` si vous l'aviez installé.

## Fichiers installés

Sous `/usr/share/plymouth/themes/argvus/` :

| Fichier | Taille | Objet |
| --- | --- | --- |
| `argvus.plymouth` | — | descripteur de thème (nom, description, module) |
| `argvus.script` | — | script de thème (langage de script propre à Plymouth) |
| `argvus-logo.png` | 256x256 | logo, RVBA |
| `argvus-text.png` | 400x53 | mot-symbole, RGBA |
| `progress-bar.png` | 400x4 | partie remplie de la barre de progression |
| `progress-bar-track.png` | 400x4 | piste non remplie |
| `entry-box.png` | 400x48 | champ de saisie de mot de passe |
| `entry-line.png` | 300x2 | règle/soulignement du champ de mot de passe |
| `bullet.png` | 12x12 | caractère masqué |
| `logo-glow.png` | 260x300 | illustration de l'éclat du logo |
| `argvus-uki-splash.bmp` | 400x400, 32 bits | image de démarrage UKI/systemd-boot |

Plus la licence à `/usr/share/licenses/argvus-boot-splash/LICENSE`.

## Métadonnées du paquet

| Champ | Valeur |
| --- | --- |
| Nom | `argvus-boot-splash` |
| Architecture | `any` |
| Dépend de | `plymouth` |
| Dépendances facultatives | `mkinitcpio`, `dracut` |
| Conflits / remplace | `argvus-plymouth` |
| Licence | GPL-3.0-only |

## Couleurs

| Élément | Couleur |
| --- | --- |
| Arrière-plan | `#111316` |
| Accent (logo, nom de marque, remplissage de progression) | `#3590BD` |
| Piste de progression | `#262933` |
| Texte de l'invite de mot de passe | gris-bleu clair (`#B8C4CE`) |

Le thème utilise un arrière-plan sombre uni à toute résolution, donc il ne
passe jamais automatiquement entre les variantes claires et sombres.

## Obtenir de l'aide

- Signaler les bugs et demander des fonctionnalités dans le système de suivi des problèmes du projet.
- Problèmes de sécurité : suivez [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md) — ne pas ouvrir un problème public pour les vulnérabilités.
- Source, build et versions : la racine du dépôt ([README](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)).
- Contribuer : [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md).
- Licence : [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE).

## Prochaines étapes

- [Installation](/docs/argvus-boot-splash/installation/)
- [Utilisation](/docs/argvus-boot-splash/usage/)
- [Dépannage](/docs/argvus-boot-splash/troubleshooting/)
