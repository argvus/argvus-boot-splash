---
title: Arquitetura do Tema
description: Como o descritor do Plymouth, os assets e o script são organizados.
---

# Arquitetura do tema

Como o tema do Plymouth é montado: o descritor, o conjunto de assets e o que o
`argvus.script` faz, seção por seção.

Para empacotamento e lançamentos, veja
[empacotamento](packaging.md) e [CI e lançamentos](ci-releases.md). Para o uso,
veja o [guia do usuário](../user-guide.md).

## Descritor

Temas do Plymouth são descritores declarativos interpretados pelo motor de script
do Plymouth. Há duas partes:

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

Observações:

- `ModuleName=script` seleciona o interpretador de script embutido no Plymouth.
  Não há módulo compilado; `ImageDir` e `ScriptFile` precisam ser **caminhos
  absolutos**, porque o initramfs tem um diretório de trabalho diferente do da
  sua sessão.
- O nome do arquivo é o nome do tema: `argvus.plymouth` ⇒ tema `argvus`, que é o
  que `plymouth-set-default-theme argvus` seleciona.
- `argvus.script` é o único arquivo de código. Ele roda dentro da VM embutida do
  Plymouth (ligada ao `plymouthd` e ao initramfs). As restrições que daí
  decorrem: sem I/O de arquivos, sem threads, sem processos externos, sem ponto
  flutuante, `MathInt` é a sua única aritmética, e a linguagem é um pequeno
  dialeto resemble a C (arrays são objetos indexados; objetos `Sprite()` precisam
  ser criados antes do uso).

## Modelo de renderização

- Um único fundo sólido (`Window.SetBackgroundTopColor` /
  `SetBackgroundBottomColor`).
- **Sprites** são as únicas primitivas de desenho. Cada `Sprite()` tem uma imagem,
  uma posição `(x, y)`, uma **ordem de profundidade** e uma opacidade em
  `[0, 1]`. A última chamada a `SetPosition` vence; não há grafo de cena.
- O progresso é desenhado reaplicando `ImageScale` a uma imagem a cada quadro e
  chamando `SetImage` no sprite — não existe primitiva de recorte ou de
  desenho parcial.
- O Plymouth informa estado por callbacks que o script registra:
  `PlymouthSetBootProgressFunction`, `PlymouthSetDisplayPasswordFunction`,
  `PlymouthSetDisplayNormalFunction`, `PlymouthSetRefreshFunction`.
- `Plymouth.SetRefreshRate(20)` faz o callback de refresh rodar a 20 FPS; a única
  animação com tempo do tema (o fade-in) depende disso.

## Inventário de assets

Todos os assets ficam em `src/usr/share/plymouth/themes/argvus/`.

| Arquivo | Tamanho | Formato | Papel | Usado por `argvus.script` |
| --- | --- | --- | --- | --- |
| `argvus.plymouth` | — | INI | descritor do tema | carregado pelo `plymouthd` |
| `argvus.script` | — | script Plymouth | lógica do tema | sim |
| `argvus-logo.png` | 256x256 | RGBA 8 bits | logotipo principal | sim (`logo.base_scale = 0.72`) |
| `argvus-text.png` | 400x53 | RGBA 8 bits | palavra-marca `ARGVUS` | sim (`text.scale = 0.80`) |
| `progress-bar.png` | 400x4 | paleta de 1 bit | barra preenchida | sim |
| `progress-bar-track.png` | 400x4 | paleta de 1 bit | trilho vazio | sim |
| `entry-box.png` | 400x48 | RGB 16 bits | campo de entrada da senha | sim |
| `bullet.png` | 12x12 | paleta de 4 bits | um caractere mascarado | sim |
| `entry-line.png` | 300x2 | paleta de 1 bit | linha do campo de senha | não (ver [lacunas conhecidas](workflow.md#lacunas-conhecidas)) |
| `logo-glow.png` | 260x300 | paleta de 8 bits | arte do brilho do logotipo | não (ver [lacunas conhecidas](workflow.md#lacunas-conhecidas)) |
| `argvus-uki-splash.bmp` | 400x400 | BMP 32 bits | splash de UKI / systemd-boot | não (consumido pelo bootloader) |

A largura das imagens é a unidade de layout: a palavra-marca é a largura de
referência (400 px na escala 1.0) e o trilho de progresso, a barra de progresso e
o campo de senha são todos derivados dela, então a composição continua coerente
mesmo que o asset da palavra-marca seja reexportado.

`arch_check_splash_payload()`, em `packaging/arch/common/functions.sh`, exige que
**todos** os arquivos acima existam; adicionar um asset significa adicionar ele
à lista. Veja [empacotamento](packaging.md#funções-compartilhadas).

## Walkthrough do script

`src/usr/share/plymouth/themes/argvus/argvus.script`, de cima para baixo.

### 1. Fundo

```js
Window.SetBackgroundTopColor(0.0667, 0.0745, 0.0863);
Window.SetBackgroundBottomColor(0.0667, 0.0745, 0.0863);
```

Mesmo valor em cima e embaixo ⇒ preenchimento sólido, sem gradiente. Os
componentes são os canais de 8 bits de `#111316` divididos por 255.

### 2. Assets e escala

Toda imagem é carregada por `Image("nome")`, que resolve a partir do `ImageDir`. A
escala é explícita:

```js
logo.base_scale = 0.72;
logo.base_width = MathInt(logo.original_image.GetWidth() * logo.base_scale);
logo.frame[logo.base_width] = ImageScale(logo.original_image, logo.base_width,
                                         logo.base_height);
logo.image = logo.frame[logo.base_width];
```

O cache `logo.frame[...]` é intencional: `ImageScale` a cada quadro alocaria uma
nova imagem por quadro; o logotipo é escalado uma vez e cacheado pela largura de
destino, então um redimensionamento só precisa de uma nova entrada.

A palavra-marca segue a mesma ideia com `text.scale = 0.80`, mas é escalada uma
única vez em linha. O trilho e a barra de progresso são então escalados para
`text.image.GetWidth()` — ou seja, a barra sempre acompanha a largura da
palavra-marca, qualquer que seja o tamanho real dela em pixels.

### 3. Layout

Todo elemento é centralizado no eixo horizontal da janela:

```js
logo.x = Window.GetX() + Window.GetWidth() / 2 - logo.image.GetWidth() / 2;
logo.y = Window.GetY() + Window.GetHeight() / 2 - logo.image.GetHeight() / 2 - 35;
```

Repare no `- 35`: a pilha é centralizada como um todo (logotipo + palavra-marca +
trilho), e não apenas o logotipo, então o bloco fica levemente acima do centro
vertical da tela. O posicionamento vertical é relativo ao elemento anterior
(`text.y = logo.y + logo.image.GetHeight() + 16`,
`progress_track.y = text.y + text.image.GetHeight() + 28`, …), o que faz a
composição escalar como uma única unidade conforme a resolução.

Profundidade usada:

| Z | Sprite |
| --- | --- |
| 100 | logotipo, palavra-marca, trilho de progresso |
| 101 | barra de progresso (acima do trilho) |
| 200 | campo de entrada da senha |
| 201 | texto do prompt de senha |
| 202 | balas da senha |

### 4. Progresso do boot

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

Registrado com `PlymouthSetBootProgressFunction(progress_callback)`. O
limitador importa: uma imagem de largura zero é inválida em algumas versões do
Plymouth, então a barra nunca desaparece por completo, e o progresso nunca
ultrapassa a largura do trilho. A posição do sprite é fixa; só a largura da
imagem muda — nenhuma operação de preenchimento ou recorte é usada.

### 5. Diálogo de senha

`display_password_callback(prompt, bullets)`:

1. Escurece a tela: `logo.opacity = 0.15` e a palavra-marca em `0.15`, enquanto o
   trilho e a barra permanecem em `1.0`.
2. Renderiza o prompt com `Image.Text(prompt, 0.72, 0.77, 0.81)` — a única imagem
   gerada em tempo de execução no tema. A posição só é conhecida aqui, porque
   depende da altura do texto.
3. Posiciona o campo de entrada abaixo do prompt:
   `password.entry.y = password.prompt.y + password.prompt.image.GetHeight() + 14`.
   No carregamento, `password.entry.y` é `0`, com um comentário de que a posição
   real espera pelo prompt.
4. Desenha as balas com um laço que cria ou reaproveita sprites:

   ```js
   for (index = 0; password.bullet[index] || index < bullets; index++)
   {
       if (!password.bullet[index]) { /* cria sprite + imagem */ }
       /* ...posiciona em entry.x + 16 + index * bullet.width... */
       if (index < bullets) sprite.SetOpacity(1); else sprite.SetOpacity(0);
   }
   ```

   Os sprites são agrupados e reaproveitados entre prompts em vez de recriados;
   balas antigas são escondidas com opacidade `0`. As balas são centralizadas
   verticalmente em relação à altura do campo de entrada.

`display_normal_callback()` é o inverso: restaura a opacidade `1.0`, esconde o
prompt, o campo e todas as balas agrupadas. Registrado com
`PlymouthSetDisplayNormalFunction`, o Plymouth o chama quando a senha é aceita ou
abortada e o boot continua.

Consequência: `logo.opacity` é uma variável, e não uma constante, porque tanto o
fade quanto o estado de senha multiplicam sobre ela.

### 6. Fade-in

```js
Plymouth.SetRefreshRate(20);
fun refresh_callback()
{
    if (!fade.complete) {
        fade.frame += 1;
        fade.opacity = fade.frame / 20;      /* 20 quadros a 20 FPS = 1s */
        if (fade.opacity > 1) fade.opacity = 1;
        text.sprite.SetOpacity(fade.opacity);
        progress_track.sprite.SetOpacity(fade.opacity);
        progress_bar.sprite.SetOpacity(fade.opacity);
        if (fade.frame >= 20) fade.complete = 1;
    }
    logo.sprite.SetOpacity(logo.opacity * fade.opacity);
}
```

O callback de refresh continua rodando durante todo o boot (é barato e o Plymouth
o chama continuamente); a guarda `fade.complete` o torna inerte depois da
animação. O logotipo usa `logo.opacity * fade.opacity` em vez de uma atribuição
simples para que o estado escurecido pela senha sobreviva ao fade: quando o fade
termina, `fade.opacity == 1` e o logotipo volta a exibir `logo.opacity`.

Revisões anteriores deste tema também tinham animações de pulso e de spawn; elas
foram removidas em `0.2.0` ("chore: remove pulse effects"). Não reintroduza
animação por quadro na barra de progresso — a barra deve continuar sendo uma
representação fiel do progresso do boot.

## Constantes de layout

Fonte única de verdade para ajustar a composição:

| Constante | Valor | Significado |
| --- | --- | --- |
| `logo.base_scale` | `0.72` | escala do logotipo em relação aos seus 256x256 nativos |
| offset de `logo.y` | `-35` | ergue o bloco centralizado acima do meio da tela |
| `text.scale` | `0.80` | escala da palavra-marca em relação aos seus 400x53 nativos |
| gap de `text.y` | `+16` | base do logotipo → topo da palavra-marca |
| gap de `progress_track.y` | `+28` | base da palavra-marca → topo do trilho |
| gap de `password.prompt.y` | `+24` | base do trilho → topo do texto do prompt |
| gap de `password.entry.y` | `+14` | base do prompt → topo do campo de entrada |
| offset x das balas | `+16` | esquerda do campo → primeira bala |
| `logo.opacity` (diálogo) | `0.15` | escurecimento da tela enquanto a senha é pedida |
| cor do prompt | `0.72, 0.77, 0.81` | RGB de `Image.Text`, ~`#B8C4CE` |
| fade | 20 quadros a 20 FPS | fade-in de ~1 s |

## Tokens de cor

| Token | Hex | Onde fica |
| --- | --- | --- |
| Fundo | `#111316` | no script (`0.0667, 0.0745, 0.0863`) |
| Destaque | `#3590BD` | pixels do logotipo / palavra-marca / preenchimento da barra |
| Trilho de progresso | `#262933` | `progress-bar-track.png` |
| Texto do prompt | `#B8C4CE` | no script (chamada `Image.Text`) |

As cores de destaque e do trilho estão gravadas nos assets PNG, e não expressas
no script, então trocar a cor significa reexportar os assets (ou editar a paleta).
O tema é apenas escuro e não tem variante clara.

## Formato do bitmap de UKI

`argvus-uki-splash.bmp` é um BMP de 400x400, 32 bits, sem compressão
(`PC bitmap, Windows 98/2000 and newer format, 400 x 400 x 32`). É um asset
autônomo: o script do Plymouth nunca o carrega e o pacote Arch não o registra em
lugar nenhum — embutir a imagem em uma UKI é um passo do usuário (veja o
[guia do usuário](../user-guide/uki-splash.md)).

Se você substituí-lo, mantenha um BMP simples de 32 bits sem compressão e de
tamanho comparável; o systemd-boot e o `ukify` não escalam formatos arbitrários e
imagens grandes são caras em memória no início do boot.

## Modificando o tema

Ciclo prático:

1. Edite `src/usr/share/plymouth/themes/argvus/argvus.script` (e/ou os PNGs).
2. Instale no Plymouth em uso, ou pré-visualize a partir da árvore do código:

   ```sh
   sudo cp -r src/usr/share/plymouth/themes/argvus/* \
              /usr/share/plymouth/themes/argvus/
   sudo plymouth-set-default-theme argvus
   sudo plymouth --show-splash    # confira, depois: sudo plymouthquit
   ```

3. `make validate && make build` antes de commitar.

Regras para o tema continuar funcionando:

- Nunca introduza APIs que não sejam do Plymouth. O motor é um dialeto
  restrito; confira a versão de `plymouth` que você quer suportar antes de usar
  uma API que você ainda não usou.
- `ImageDir` e `ScriptFile` em `argvus.plymouth` precisam continuar absolutos e
  iguais ao caminho instalado `/usr/share/plymouth/themes/argvus`.
- Mantenha em sincronia todos os assets listados em
  `arch_check_splash_payload()` com os arquivos que vão em `src/` — o
  `check()` do empacotamento roda na CI.
- A largura da barra de progresso precisa continuar sendo uma função fiel do
  progresso reportado; o limitador para `[1, largura do trilho]` não pode ser
  removido.
- Teste o diálogo de senha, e não apenas a tela de boot: é o estado mais
  provável de quebrar e o que os usuários mais percebem.
- O callback de refresh roda durante todo o boot; evite alocar memória por quadro
  sempre que possível.
