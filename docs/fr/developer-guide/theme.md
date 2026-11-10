---
title: Thème Architecture
description: Comment le descripteur Plymouth, les actifs et le script sont assemblés.
---

# Architecture du thème

Comment le thème Plymouth est assemblé : le descripteur, l'ensemble des ressources, et ce que fait `argvus.script`, section par section.

Pour l'emballage et les versions, voir [packaging](/docs/argvus-boot-splash/developer-guide/packaging/) et [CI et releases](/docs/argvus-boot-splash/developer-guide/ci-releases/). Pour l'utilisation, voir le [guide de l'utilisateur](/docs/argvus-boot-splash/).

## Descripteur

Les thèmes Plymouth sont des descripteurs déclaratifs interprétés par le moteur de script de Plymouth. Il y a deux parties :

`src/usr/share/plymouth/themes/argvus/argvus.plymouth`:

```ini
[Plymouth Theme]
Name=Argvus
Description=Argvus boot splash theme
ModuleName=script

[script]
ImageDir=/usr/share/plymouth/themes/argvus
ScriptFile=/usr/share/plymouth/themes/argvus/argvus.script
```
Notes :

- `ModuleName=script` sélectionne l'interpréteur de scripts intégré de Plymouth. Il n'y a pas de module compilé ; `ImageDir` et `ScriptFile` doivent être des **chemins absolus**, car l'initramfs a un répertoire de travail différent de votre session.
- Le nom du fichier est le nom du thème : `argvus.plymouth` ⇒ thème `argvus`, que `plymouth-set-default-theme argvus` sélectionne.
- `argvus.script` est le seul fichier de code. Il s'exécute à l'intérieur de la VM intégrée de Plymouth (liée à `plymouthd` et à l'initramfs). Les contraintes qui en découlent : pas d'entrée/sortie de fichiers, pas de threads, pas de processus externes, pas de nombres à virgule flottante, `MathInt` est votre seule arithmétique, et le langage est un petit dialecte similaire au C (les tableaux sont des objets indexés, les objets `Sprite()` doivent être créés avant utilisation).

## Modèle de rendu

- Un seul arrière-plan solide plat (`Window.SetBackgroundTopColor` / `SetBackgroundBottomColor`).  
- **Sprites** sont les seuls primitives de dessin. Chaque `Sprite()` a une image, une position `(x, y)`, un **ordre Z** et une opacité dans `[0, 1]`. Plus tard, `SetPosition` appelle win ; il n'y a pas de graphe de scène.  
- La progression est dessinée en re-`ImageScale`-nt une image à chaque image et en appelant `SetImage` sur le sprite — il n'y a pas de découpages ni de primitives de dessin partiel.  
- Plymouth rapporte l'état via des callbacks que le script enregistre : `PlymouthSetBootProgressFunction`, `PlymouthSetDisplayPasswordFunction`, `PlymouthSetDisplayNormalFunction`, `PlymouthSetRefreshFunction`.  
- `Plymouth.SetRefreshRate(20)` fait exécuter le callback de rafraîchissement à 20 FPS ; la seule animation temporelle du thème (le fondu) en dépend.  

## Inventaire des ressources

Toutes les ressources se trouvent dans `src/usr/share/plymouth/themes/argvus/`.  

| Fichier | Taille | Format | Rôle | Utilisé par `argvus.script` |
| --- | --- | --- | --- | --- |
| `argvus.plymouth` | — | INI | descripteur de thème | chargé par `plymouthd` |
| `argvus.script` | — | script Plymouth | logique de thème | oui |
| `argvus-logo.png` | 256x256 | RGBA 8 bits | logo principal | oui (`logo.base_scale = 0.72`) |
| `argvus-text.png` | 400x53 | RGBA 8 bits | mot-symbole `ARGVUS` | oui (`text.scale = 0.80`) |
| `progress-bar.png` | 400x4 | palette 1 bit | barre remplie | oui |
| `progress-bar-track.png` | 400x4 | palette 1 bit | piste non remplie | oui |
| `entry-box.png` | 400x48 | RGB 16 bits | champ de saisie du mot de passe | oui |
| `bullet.png` | 12x12 | palette 4 bits | un caractère masqué | oui |
| `entry-line.png` | 300x2 | palette 1 bit | règle/soulignement de saisie | non (voir [lacunes connues](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)) |
| `logo-glow.png` | 260x300 | palette 8 bits | illustration du halo du logo | non (voir [lacunes connues](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)) |
| `argvus-uki-splash.bmp` | 400x400 | BMP 32 bits | UKI / écran de démarrage systemd-boot | non (consommé par le chargeur de démarrage) |

La largeur de l'image est utilisée comme unité de mise en page : le logotype est la largeur de référence
(400 px à l'échelle 1.0) et la piste de progression, la barre de progression et le champ de saisie du mot de passe
en sont tous dérivés, donc la composition reste cohérente si l'actif du logotype est réexporté.

`arch_check_splash_payload()` dans `packaging/arch/common/functions.sh` nécessite
**tous** les fichiers ci-dessus pour exister ; ajouter un actif signifie l'ajouter à cette liste. Voir
[packaging](/docs/argvus-boot-splash/developer-guide/packaging/#shared-functions).

## Présentation du script

`src/usr/share/plymouth/themes/argvus/argvus.script`, de haut en bas.

### 1. Arrière-plan

```js
Window.SetBackgroundTopColor(0.0667, 0.0745, 0.0863);
Window.SetBackgroundBottomColor(0.0667, 0.0745, 0.0863);
```
Même valeur en haut et en bas ⇒ un remplissage uniforme, sans dégradé. Les composants sont les canaux 8 bits de `#111316` divisés par 255.

### 2. Ressources et mise à l'échelle

Chaque image est chargée via `Image("name")`, qui se résout par rapport à `ImageDir`. La mise à l'échelle est explicite :

```js
logo.base_scale = 0.72;
logo.base_width = MathInt(logo.original_image.GetWidth() * logo.base_scale);
logo.frame[logo.base_width] = ImageScale(logo.original_image, logo.base_width,
                                         logo.base_height);
logo.image = logo.frame[logo.base_width];
```
Le cache `logo.frame[...]` est intentionnel : `ImageScale` à chaque image allouerait une nouvelle image par image ; le logo est mis à l'échelle une seule fois et mis en cache selon la largeur cible, donc un redimensionnement nécessite seulement une nouvelle entrée.

Le mot-symbole suit la même idée à `text.scale = 0.80`, mais il est mis à l'échelle une seule fois en ligne. La piste et la barre de progression sont ensuite mises à l'échelle à `text.image.GetWidth()` — c'est-à-dire que la barre correspond toujours à la largeur du mot-symbole, quelle que soit la taille réelle en pixels du mot-symbole.

### 3. Disposition

Chaque élément est centré sur l'axe horizontal de la fenêtre :

```js
logo.x = Window.GetX() + Window.GetWidth() / 2 - logo.image.GetWidth() / 2;
logo.y = Window.GetY() + Window.GetHeight() / 2 - logo.image.GetHeight() / 2 - 35;
```
Notez le `- 35` : la pile est centrée sur l'ensemble de la composition (logo + logotype + piste), et pas seulement sur le logo, donc le bloc se situe légèrement au-dessus du milieu vertical de l'écran. Le positionnement vertical est ensuite relatif à l'élément précédent (`text.y = logo.y + logo.image.GetHeight() + 16`, `progress_track.y = text.y + text.image.GetHeight() + 28`, …), ce qui signifie que la composition s'adapte comme une seule unité selon la résolution.

Ordre Z utilisé ici :

| Z | Sprite |
| --- | --- |
| 100 | logo, logotype, piste de progression |
| 101 | barre de progression (au-dessus de la piste) |
| 200 | champ de saisie du mot de passe |
| 201 | texte d'invite du mot de passe |
| 202 | puces du mot de passe |

### 4. Progression du démarrage

```js
fun progress_callback(duration, progress)
{
    width = MathInt(progress_bar.original_image.GetWidth() * progress);
    if (width < 1) width = 1;
    if (width > progress_bar.original_image.GetWidth())
        width = progress_bar.original_image.GetWidth();
    progress_bar.image = ImageScale(progress_bar.original_image, width,
                                     progress_bar.original_image.GetHeight());
    progress_bar.sprite.SetImage(progress_bar.image);
}
```
Enregistré avec `PlymouthSetBootProgressFunction(progress_callback)`. La pince importe : une image de largeur nulle est invalide dans certaines versions de Plymouth, donc la barre ne disparaît jamais complètement, et la progression ne peut jamais dépasser la largeur de la piste. La position du sprite est fixe ; seule la largeur de l'image change — aucune opération de remplissage ou de découpe n'est utilisée.

### 5. Boîte de dialogue du mot de passe

`display_password_callback(prompt, bullets)`:

1. Assombrit le splash : `logo.opacity = 0.15` et le logotype à `0.15`, tandis que la piste et la barre restent à `1.0`.
2. Rend l'invite avec `Image.Text(prompt, 0.72, 0.77, 0.81)` — la seule image générée à l'exécution dans le thème. Sa position est uniquement connue ici, car elle dépend de la hauteur du texte.
3. Positionne le champ d'entrée sous l'invite : password.entry.y = password.prompt.y + password.prompt.image.GetHeight() + 14. Au moment du chargement, `password.entry.y` est `0` avec un commentaire indiquant que la position réelle attend l'invite.
4. Dessine les puces avec une boucle créer-ou-réutiliser :

   ```js
   for (index = 0; password.bullet[index] || index < bullets; index++)
   {
       if (!password.bullet[index]) { /* create sprite + image */ }
       /* ...position at entry.x + 16 + index * bullet.width ... */
       if (index < bullets) sprite.SetOpacity(1); else sprite.SetOpacity(0);
   }
   ```
Les sprites sont mis en pool et réutilisés dans différents prompts au lieu d'être recréés ;
les balles obsolètes sont cachées avec l'opacité `0`. Les balles sont centrées verticalement
par rapport à la hauteur du champ de saisie.

`display_normal_callback()` est l'inverse : il rétablit l'opacité `1.0`, cache le
prompt, le champ de saisie et chaque balle mise en pool. Enregistré avec
`PlymouthSetDisplayNormalFunction`, Plymouth l'appelle lorsque la phrase de passe est
acceptée ou annulée et que le démarrage continue.

Conséquence : `logo.opacity` est une variable, pas une constante, car à la fois le fondu
t et l'état du mot de passe multiplient sa valeur.

### 6. Fondu en entrée

```js
Plymouth.SetRefreshRate(20);
fun refresh_callback()
{
    if (!fade.complete) {
        fade.frame += 1;
        fade.opacity = fade.frame / 20;      /* 20 frames @ 20 FPS = 1s */
        if (fade.opacity > 1) fade.opacity = 1;
        text.sprite.SetOpacity(fade.opacity);
        progress_track.sprite.SetOpacity(fade.opacity);
        progress_bar.sprite.SetOpacity(fade.opacity);
        if (fade.frame >= 20) fade.complete = 1;
    }
    logo.sprite.SetOpacity(logo.opacity * fade.opacity);
}
```
Le rappel de rafraîchissement continue de s'exécuter pendant tout le démarrage (il est peu coûteux et Plymouth l'appelle en continu) ; le garde `fade.complete` en fait une opération nulle après l'animation. Le logo utilise `logo.opacity * fade.opacity` au lieu d'une simple affectation afin que l'état assombri par le mot de passe survive au fondu : après la fin du fondu, `fade.opacity == 1` et le logo montrent de nouveau `logo.opacity`.

Les révisions précédentes de ce thème comportaient également des animations de pulsation/génération ; elles ont été supprimées dans `0.2.0` ("chore: remove pulse effects"). Ne réintroduisez pas l'animation par image de la barre de progression — la barre doit rester une représentation fidèle de la progression du démarrage.

## Constantes de mise en page

Source unique de vérité pour le réglage de la composition:

| Constante | Valeur | Signification |
| --- | --- | --- |
| `logo.base_scale` | `0.72` | échelle du logo par rapport à son format natif 256x256 |
| `logo.y` décalage | `-35` | soulève le bloc centré au-dessus du milieu de l'écran |
| `text.scale` | `0.80` | échelle du mot-symbole par rapport à son format natif 400x53 |
| `text.y` espace | `+16` | bas du logo → haut du mot-symbole |
| `progress_track.y` espace | `+28` | bas du mot-symbole → haut de la piste |
| `password.prompt.y` espace | `+24` | bas de la piste → haut du texte d'invite |
| `password.entry.y` espace | `+14` | bas de l'invite → haut du champ de saisie |
| décalage x des puces | `+16` | gauche du champ de saisie → première puce |
| `logo.opacity` (dialogue) | `0.15` | atténuation de l'écran de démarrage pendant qu'un mot de passe est demandé |
| couleur de l'invite | `0.72, 0.77, 0.81` | `Image.Text` RVB, ~`#B8C4CE` |
| fondu | 20 images @ 20 FPS | ~1 s fondu entrant |

## Jetons de conception

| Jeton | Hex | Où il se trouve |
| --- | --- | --- |
| Arrière-plan | `#111316` | script (`0.0667, 0.0745, 0.0863`) |
| Accent | `#3590BD` | logo / logotype / pixels de remplissage de progression |
| Piste de progression | `#262933` | `progress-bar-track.png` |
| Texte de l'invite | `#B8C4CE` | script (appel `Image.Text`) |

Les couleurs des accents et de la piste sont intégrées dans les fichiers PNG, non exprimées dans le script, donc recolorer signifie réexporter les fichiers (ou éditer la palette).
Le thème est uniquement sombre et n'a pas de variante claire.

## Format bitmap UKI

`argvus-uki-splash.bmp` est un BMP Windows non compressé 32 bits de 400x400
(`PC bitmap, Windows 98/2000 and newer format, 400 x 400 x 32`). C'est un
élément autonome : le script Plymouth ne le charge jamais, et le paquet Arch ne
l'enregistre nulle part — l'intégrer dans un UKI est une étape de l'utilisateur (voir le
[guide utilisateur](/docs/argvus-boot-splash/uki-splash/)).

Si vous le remplacez, gardez-le en BMP 32 bits simple et non compressé de taille comparable ;
systemd-boot et `ukify` ne redimensionnent pas les formats arbitraires et les grandes images consomment beaucoup de mémoire au démarrage.

## Modification du thème

Boucle pratique :

1. Modifiez `src/usr/share/plymouth/themes/argvus/argvus.script` (et/ou les PNG).
2. Installez-le sur votre Plymouth live, ou prévisualisez depuis l'arborescence source :

   ```sh
   sudo cp -r src/usr/share/plymouth/themes/argvus/* \
              /usr/share/plymouth/themes/argvus/
   sudo plymouth-set-default-theme argvus
   sudo plymouth --show-splash    # check, then: sudo plymouthquit
   ```
3. `make validate && make build` avant de valider.

Règles qui maintiennent le thème fonctionnel :

- N'introduisez jamais d'API non-Plymouth. Le moteur est un dialecte restreint ; vérifiez
  la version cible de `plymouth` que vous supportez avant d'utiliser une API que vous n'avez pas
  utilisée auparavant.
- `ImageDir`/`ScriptFile` dans `argvus.plymouth` doit rester absolu et doit correspondre
  au chemin installé `/usr/share/plymouth/themes/argvus`.
- Maintenez chaque ressource listée dans `arch_check_splash_payload()` synchronisée avec les
  fichiers fournis dans `src/` — le packaging `check()` utilisé en CI.
- La largeur de la barre de progression doit rester une fonction fidèle de la progression rapportée ;
  la restriction à `[1, track width]` ne doit pas être supprimée.
- Testez la boîte de dialogue du mot de passe, pas seulement l'écran de démarrage : c'est l'état le plus
  susceptible de se casser et celui que les utilisateurs remarquent le plus.
- Le rappel de rafraîchissement fonctionne pendant tout le boot ; gardez l'allocation de travail par image gratuite quand c'est possible.
