---
title: 主题架构
description: 普利茅斯描述符、资产和脚本是如何组合在一起的。
---
# 主题架构

Plymouth 主题的组成方式：描述符、资源集，以及 `argvus.script` 的作用，逐部分说明。

有关打包和发布，请参见 [packaging](/docs/argvus-boot-splash/developer-guide/packaging/) 和 [CI 和发布](/docs/argvus-boot-splash/developer-guide/ci-releases/)。有关使用方法，请参见 [用户指南](/docs/argvus-boot-splash/)。

## 描述符

Plymouth 主题是由 Plymouth 的脚本引擎解释的声明性描述符。它们有两个部分：

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
注意事项：

- `ModuleName=script` 选择 Plymouth 内置的脚本解释器。没有编译模块；`ImageDir` 和 `ScriptFile` 必须是**绝对路径**，因为 initramfs 的工作目录与您的会话不同。
- 文件名就是主题名称：`argvus.plymouth` ⇒ 主题 `argvus`，这就是 `plymouth-set-default-theme argvus` 所选择的。
- `argvus.script` 是唯一的代码文件。它在 Plymouth 的嵌入式虚拟机中运行（链接到 `plymouthd` 和 initramfs）。由此产生的约束条件包括：不能进行文件 I/O、不能使用线程、不能运行外部进程、不能使用浮点数，`MathInt` 是您唯一的算术工具，语言是一个小型的 C 类方言（数组是键控对象，`Sprite()` 对象必须在使用前创建）。

## 渲染模型

- 一个平面实心背景 (`Window.SetBackgroundTopColor` / `SetBackgroundBottomColor`)。
- **精灵（Sprites）** 是唯一的绘图原语。每个 `Sprite()` 都有一个图像、一个 `(x, y)` 位置、一个 **z 顺序** 和在 `[0, 1]` 中的不透明度。之后 `SetPosition` 调用窗口；没有场景图。
- 进度通过每帧重新 `ImageScale` 图像并调用 `SetImage` 来绘制 — 没有剪裁或部分绘制原语。
- Plymouth 通过脚本注册的回调报告状态：`PlymouthSetBootProgressFunction`、`PlymouthSetDisplayPasswordFunction`、`PlymouthSetDisplayNormalFunction`、`PlymouthSetRefreshFunction`。
- `Plymouth.SetRefreshRate(20)` 使刷新回调以 20 FPS 运行；主题的唯一定时动画（淡入）依赖于它。

## 资产清单

所有资产存放在 `src/usr/share/plymouth/themes/argvus/`。

| 文件 | 大小 | 格式 | 角色 | 被 `argvus.script` 使用 |
| --- | --- | --- | --- | --- |
| `argvus.plymouth` | — | INI | 主题描述符 | 由 `plymouthd` 加载 |
| `argvus.script` | — | 普利茅斯脚本 | 主题逻辑 | 是 |
| `argvus-logo.png` | 256x256 | RGBA 8 位 | 主标志 | 是 (`logo.base_scale = 0.72`) |
| `argvus-text.png` | 400x53 | RGBA 8 位 | `ARGVUS` 文字标识 | 是 (`text.scale = 0.80`) |
| `progress-bar.png` | 400x4 | 1 位调色板 | 填充条 | 是 |
| `progress-bar-track.png` | 400x4 | 1 位调色板 | 未填充轨道 | 是 |
| `entry-box.png` | 400x48 | RGB 16 位 | 密码输入字段 | 是 |
| `bullet.png` | 12x12 | 4 位调色板 | 一个屏蔽字符 | 是 |
| `entry-line.png` | 300x2 | 1 位调色板 | 输入规则/下划线 | 否 (见 [已知缺口](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)) |
| `logo-glow.png` | 260x300 | 8 位调色板 | 标志发光艺术 | 否 (见 [已知缺口](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)) |
| `argvus-uki-splash.bmp` | 400x400 | BMP 32位 | UKI / systemd-boot 启动画面 | 否（由引导加载程序使用） |

图像宽度用作布局单位：字标是参考宽度
（在比例1.0下为400像素），进度轨迹、进度条和密码输入
字段都从中导出，因此如果重新导出字标资源，组合仍然保持一致。

在 packaging/arch/common/functions.sh 中使用 `arch_check_splash_payload()`
需要上述**所有**文件存在；添加资源意味着将其添加到该列表中。参见
[packaging](/docs/argvus-boot-splash/developer-guide/packaging/#shared-functions)。

## 脚本讲解

从上到下  `packaging/arch/common/functions.sh` `src/usr/share/plymouth/themes/argvus/argvus.script`。

### 1. 背景

```js
Window.SetBackgroundTopColor(0.0667, 0.0745, 0.0863);
Window.SetBackgroundBottomColor(0.0667, 0.0745, 0.0863);
```
上下值相同 ⇒ 平铺填充，无渐变。组件是 `#111316` 的 8 位通道除以 255。

### 2. 资源和缩放

每个图像都通过 `Image("name")` 加载，该加载相对于 `ImageDir` 解析。缩放是明确的：

```js
logo.base_scale = 0.72;
logo.base_width = MathInt(logo.original_image.GetWidth() * logo.base_scale);
logo.frame[logo.base_width] = ImageScale(logo.original_image, logo.base_width,
                                         logo.base_height);
logo.image = logo.frame[logo.base_width];
```
`logo.frame[...]` 缓存是有意为之的：`ImageScale` 如果在每一帧都执行，将会为每一帧分配一个新的图像；徽标只缩放一次，并按目标宽度缓存，因此调整大小只需要一个新的条目。

文字标识在 `text.scale = 0.80` 也遵循相同的思路，但它在行内只缩放一次。进度轨迹和条随后缩放到 `text.image.GetWidth()`——即进度条总是匹配文字标识的宽度，无论文字标识的实际像素大小是多少。

### 3. 布局

每个元素都在窗口的水平轴上居中：

```js
logo.x = Window.GetX() + Window.GetWidth() / 2 - logo.image.GetWidth() / 2;
logo.y = Window.GetY() + Window.GetHeight() / 2 - logo.image.GetHeight() / 2 - 35;
```
注意 `- 35`：堆栈是以整个组合（徽标 + 字标 + 进度条）为中心，而不仅仅是徽标，因此整个模块稍微位于屏幕垂直中线之上。垂直放置随后是相对于前一个元素（`text.y = logo.y + logo.image.GetHeight() + 16`、`progress_track.y = text.y + text.image.GetHeight() + 28` 等）进行的，这意味着整个组合会作为一个单元随分辨率缩放。

此处使用的 Z 顺序：

| Z | 精灵 |
| --- | --- |
| 100 | 徽标、字标、进度条 |
| 101 | 进度条（位于轨道之上） |
| 200 | 密码输入字段 |
| 201 | 密码提示文本 |
| 202 | 密码圆点 |

### 4. 启动进度

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
已注册于 `PlymouthSetBootProgressFunction(progress_callback)`。夹具问题：在某些 Plymouth 版本中，零宽度图像无效，因此进度条永远不会完全消失，并且进度永远不会超出轨道宽度。精灵位置是固定的；只有图像宽度会改变——不会使用填充或裁剪操作。

### 5. 密码对话框

`display_password_callback(prompt, bullets)`:

1. 调暗启动画面：`logo.opacity = 0.15` 和标志文字在 `0.15`，而轨道和进度条保持在 `1.0`。
2. 使用 `Image.Text(prompt, 0.72, 0.77, 0.81)` 渲染提示——主题中唯一的运行时生成图像。它的位置仅在此处已知，因为它取决于文本高度。
3. 将输入字段定位在提示下方：password.entry.y = password.prompt.y + password.prompt.image.GetHeight() + 14。加载时 `password.entry.y` 为 `0`，并附有注释说明真实位置需等待提示。
4. 使用创建或重用循环绘制子弹：

   ```js
   for (index = 0; password.bullet[index] || index < bullets; index++)
   {
       if (!password.bullet[index]) { /* create sprite + image */ }
       /* ...position at entry.x + 16 + index * bullet.width ... */
       if (index < bullets) sprite.SetOpacity(1); else sprite.SetOpacity(0);
   }
   ```
精灵在各个提示之间是被池化和重用的，而不是每次都重新创建；
过期的子弹通过不透明度 `0` 隐藏。子弹在垂直方向上相对于输入字段高度居中。

`display_normal_callback()` 是相反的：它恢复不透明度 `1.0`，隐藏提示、输入框及每个池化的子弹。注册到 `PlymouthSetDisplayNormalFunction`，当密码被接受或中止并继续启动时，Plymouth 会调用它。

结果：`logo.opacity` 是一个变量，而不是常量，因为淡入效果和密码状态都会影响它。

### 6. 淡入

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
刷新回调在整个启动过程中一直运行（它成本低，并且 Plymouth 会持续调用它）；`fade.complete` 守卫使其在动画结束后成为无操作。徽标使用 `logo.opacity * fade.opacity` 而不是简单赋值，以便在淡出时保持密码调暗状态：淡出完成后，`fade.opacity == 1` 并且徽标再次显示 `logo.opacity`。

这个主题的早期版本也有脉冲/生成动画；它们在 `0.2.0`（“chore: remove pulse effects”）中被移除。不要重新引入进度条的逐帧动画——进度条必须保持对启动进度的真实表示。

## 布局常量

用于调整组合的唯一来源：

| 常量 | 值 | 含义 |
| --- | --- | --- |
| `logo.base_scale` | `0.72` | 徽标缩放比例，相对于其原生 256x256 |
| `logo.y` 偏移 | `-35` | 将居中的块提升到屏幕中部以上 |
| `text.scale` | `0.80` | 字标缩放比例，相对于其原生 400x53 |
| `text.y` 间距 | `+16` | 徽标底部 → 字标顶部 |
| `progress_track.y` 间距 | `+28` | 字标底部 → 音轨顶部 |
| `password.prompt.y` 间距 | `+24` | 音轨底部 → 提示文本顶部 |
| `password.entry.y` 间距 | `+14` | 提示底部 → 输入字段顶部 |
| 项目符号 x 偏移 | `+16` | 输入左侧 → 第一个项目符号 |
| `logo.opacity`（对话框） | `0.15` | 当请求密码时闪屏变暗 |
| 提示颜色 | `0.72, 0.77, 0.81` | `Image.Text` RGB, ~`#B8C4CE` |
| 渐隐 | 20 帧 @ 20 FPS | ~1 秒渐入 |

## 设计标记

| 令牌 | 十六进制 | 所在位置 |
| --- | --- | --- |
| 背景 | `#111316` | 脚本 (`0.0667, 0.0745, 0.0863`) |
| 强调色 | `#3590BD` | 标志 / 字体标识 / 进度填充像素 |
| 进度轨道 | `#262933` | `progress-bar-track.png` |
| 提示文本 | `#B8C4CE` | 脚本 (`Image.Text` 调用) |

强调色和轨道颜色被烘焙在 PNG 资源中，而不是在脚本中表示，因此重新上色意味着需要重新导出资源（或编辑调色板）。
该主题仅为深色，没有浅色版本。

## UKI 位图格式

`argvus-uki-splash.bmp` 是一个 400x400、32 位无压缩的 Windows BMP (`PC bitmap, Windows 98/2000 and newer format, 400 x 400 x 32`)。它是一个独立资源：Plymouth 脚本从未加载它，Arch 软件包也未在任何地方注册它——将它嵌入 UKI 是用户的步骤（参见 [用户指南](/docs/argvus-boot-splash/uki-splash/)）。

如果你更换它，请保持为大小相当的普通未压缩32位BMP；
systemd-boot和`ukify`不能缩放任意格式，并且大图像在早期启动时会占用大量内存。

## 修改主题

实际操作循环：

1. 编辑`src/usr/share/plymouth/themes/argvus/argvus.script`（和/或PNG文件）。
2. 安装到你的live Plymouth，或从源代码树中预览：

   ```sh
   sudo cp -r src/usr/share/plymouth/themes/argvus/* \
              /usr/share/plymouth/themes/argvus/
   sudo plymouth-set-default-theme argvus
   sudo plymouth --show-splash    # check, then: sudo plymouthquit
   ```
3. 在提交之前，请执行 `make validate && make build`。

保持主题正常运行的规则：

- 永远不要引入非普利茅斯（Plymouth）的 API。引擎是一个受限制的方言；在使用你以前未使用过的 API 之前，请检查你支持的 `plymouth` 的目标版本。
- `ImageDir`/`ScriptFile` 在 `argvus.plymouth` 中必须保持绝对路径，并且必须与已安装的路径 `/usr/share/plymouth/themes/argvus` 匹配。
- 保持 `arch_check_splash_payload()` 中列出的每个资源与 `src/` 中随附的文件同步 —— `check()` 运行在 CI 中的打包环节中。
- 进度条宽度必须忠实反映报告的进度；不要移除对 `[1, track width]` 的限制。
- 测试密码短语对话框，而不仅仅是启动画面：它是最有可能出现问题且用户最容易注意到的状态。
- 刷新回调在整个启动过程中都会运行；尽量保持每帧工作分配为空闲状态。
