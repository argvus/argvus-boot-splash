---
title: 테마 건축
description: Plymouth 디스크립터, 자산 및 스크립트가 어떻게 구성되는지.
---

# 테마 아키텍처

Plymouth 테마가 구성되는 방식: 디스크립터, 자산 세트, 그리고 `argvus.script`가 섹션별로 수행하는 작업.

패키징과 릴리스에 대해서는 [packaging](/docs/argvus-boot-splash/developer-guide/packaging/)와 [CI and releases](/docs/argvus-boot-splash/developer-guide/ci-releases/)를 참조하세요. 사용법은 [user guide](/docs/argvus-boot-splash/)를 참조하세요.

## 디스크립터

Plymouth 테마는 Plymouth의 스크립트 엔진이 해석하는 선언적 디스크립터입니다. 두 가지 부분이 있습니다:

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
메모:

- `ModuleName=script`는 Plymouth의 내장 스크립트 인터프리터를 선택합니다. 컴파일된 모듈은 없으며, `ImageDir`와 `ScriptFile`는 **절대 경로**여야 합니다. initramfs의 작업 디렉터리가 세션과 다르기 때문입니다.
- 파일 이름은 테마 이름입니다: `argvus.plymouth` ⇒ 테마 `argvus`, 이는 `plymouth-set-default-theme argvus`가 선택하는 것입니다.
- `argvus.script`는 유일한 코드 파일입니다. 이것은 Plymouth의 내장 VM 내에서 실행됩니다(`plymouthd` 및 initramfs에 링크됨). 그로부터 따르는 제약조건: 파일 I/O 없음, 스레드 없음, 외부 프로세스 없음, 부동 소수점 없음, `MathInt`만 산술 연산 가능, 언어는 작은 C 유사 방언임(배열은 키 객체이며, `Sprite()` 객체는 사용 전에 생성해야 함).

## 렌더링 모델

- 하나의 평면 단색 배경 (`Window.SetBackgroundTopColor` / `SetBackgroundBottomColor`).  
- **스프라이트**만이 유일한 그래픽 기본 요소입니다. 각 `Sprite()`는 이미지, `(x, y)` 위치, **z-순서** 및 `[0, 1]`의 불투명도를 가집니다. 나중에 `SetPosition`는 win을 호출합니다; 장면 그래프는 없습니다.  
- 진행 상황은 매 프레임마다 이미지를 재-`ImageScale`하고 `SetImage`를 스프라이트에 호출하여 그립니다 — 클리핑이나 부분 그리기 기본 요소는 없습니다.  
- 플리머스는 스크립트가 등록한 콜백을 통해 상태를 보고합니다: `PlymouthSetBootProgressFunction`, `PlymouthSetDisplayPasswordFunction`, `PlymouthSetDisplayNormalFunction`, `PlymouthSetRefreshFunction`.  
- `Plymouth.SetRefreshRate(20)`는 갱신 콜백을 초당 20 프레임으로 실행하게 합니다; 테마의 유일한 시간 기반 애니메이션(페이드 인)은 이에 의존합니다.  

## 자산 목록

모든 자산은 `src/usr/share/plymouth/themes/argvus/`에 위치합니다.

| 파일 | 크기 | 형식 | 역할 | `argvus.script` 사용 |
| --- | --- | --- | --- | --- |
| `argvus.plymouth` | — | INI | 테마 디스크립터 | `plymouthd`에 의해 로드됨 |
| `argvus.script` | — | 플리머스 스크립트 | 테마 로지컬 | 네 |
| `argvus-logo.png` | 256x256 | RGBA 8비트 | 메인 로고 | 예 (`logo.base_scale = 0.72`) |
| `argvus-text.png` | 400x53 | RGBA 8비트 | `ARGVUS` 워드마크 | 예 (`text.scale = 0.80`) |
| `progress-bar.png` | 400x4 | 1비트 팔레트 | 채워진 바 | 네 |
| `progress-bar-track.png` | 400x4 | 1비트 팔레트 | 미완성 트랙 | 네 |
| `entry-box.png` | 400x48 | RGB 16비트 | 비밀번호 입력 필드 | 네 |
| `bullet.png` | 12x12 | 4비트 팔레트 | 마스크 캐릭터 하나 | 네 |
| `entry-line.png` | 300x2 | 1비트 팔레트 | 입력 규칙/밑줄 | 없음 ([알려진 공백](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps) 참조) |
| `logo-glow.png` | 260x300 | 8비트 팔레트 | 로고 글로우 아트워크 | 아니오 ([ 알려진 공백](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps) 참조) |
| `argvus-uki-splash.bmp` | 400x400 | BMP 32비트 | UKI / systemd-boot 스플래시 | 없음 (부트 로더에서 사용됨) |

이미지 너비는 레이아웃 단위로 사용됩니다: 워드마크가 참조 너비입니다
(스케일 1.0에서 400 px)이며, 진행 트랙, 진행 바 및 비밀번호 입력
필드는 모두 여기에서 파생되므로 워드마크 자산을 다시 내보내더라도
구성이 일관성을 유지합니다.

`arch_check_splash_payload()`에서 `packaging/arch/common/functions.sh`은
**모든** 위 파일이 존재해야 합니다; 자산을 추가하면 해당 목록에 추가해야 합니다. 자세한 내용은
[패키징](/docs/argvus-boot-splash/developer-guide/packaging/#shared-functions)을 참조하세요.

## 스크립트 순서

`src/usr/share/plymouth/themes/argvus/argvus.script`, 위에서 아래로.

### 1. 배경

```js
Window.SetBackgroundTopColor(0.0667, 0.0745, 0.0863);
Window.SetBackgroundBottomColor(0.0667, 0.0745, 0.0863);
```
상단과 하단의 값이 동일 ⇒ 평평한 채우기, 그라데이션 없음. 구성 요소는 255로 나눈 `#111316`의 8비트 채널입니다.

### 2. 자산 및 스케일링

모든 이미지는 `Image("name")`를 통해 로드되며, 이는 `ImageDir`에 상대적으로 해석됩니다. 스케일링은 명시적입니다:

```js
logo.base_scale = 0.72;
logo.base_width = MathInt(logo.original_image.GetWidth() * logo.base_scale);
logo.frame[logo.base_width] = ImageScale(logo.original_image, logo.base_width,
                                         logo.base_height);
logo.image = logo.frame[logo.base_width];
```
`logo.frame[...]` 캐시는 의도된 것입니다: `ImageScale`를 매 프레임마다 사용하면 매 프레임마다 새로운 이미지를 할당하게 됩니다; 로고는 한 번 크기를 조정하고 대상 너비별로 캐시되므로 크기를 조정할 때는 새로운 항목만 필요합니다.

워드마크는 `text.scale = 0.80`에서 동일한 아이디어를 따르지만, 한 번만 인라인으로 크기가 조정됩니다. 이후 진행률 트랙과 바는 `text.image.GetWidth()`에 맞춰 크기가 조정됩니다 — 즉, 바는 워드마크의 실제 픽셀 크기와 상관없이 항상 워드마크 너비와 일치합니다.

### 3. 레이아웃

모든 요소는 창의 수평 축 중심에 배치됩니다:

```js
logo.x = Window.GetX() + Window.GetWidth() / 2 - logo.image.GetWidth() / 2;
logo.y = Window.GetY() + Window.GetHeight() / 2 - logo.image.GetHeight() / 2 - 35;
```
`- 35`을 참고하세요: 스택은 전체 구성물(로고 + 워드마크 + 트랙)을 기준으로 중앙에 배치되며, 단순히 로고만이 아닌 전체 구성물 기준이므로 블록은 화면의 세로 중앙보다 약간 위에 위치합니다. 세로 위치는 이전 요소(`text.y = logo.y + logo.image.GetHeight() + 16`, `progress_track.y = text.y + text.image.GetHeight() + 28`, …)에 상대적으로 결정되며, 이는 구성물이 해상도에 따라 하나의 단위로 스케일된다는 것을 의미합니다.

여기서 사용된 Z-순서:

| Z | 스프라이트 |
| --- | --- |
| 100 | 로고, 워드마크, 진행 트랙 |
| 101 | 진행 바(트랙 위) |
| 200 | 비밀번호 입력 필드 |
| 201 | 비밀번호 프롬프트 텍스트 |
| 202 | 비밀번호 점표 |

### 4. 부트 진행

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
`PlymouthSetBootProgressFunction(progress_callback)`에 등록되었습니다. 클램프는 중요합니다: 일부 Plymouth 버전에서는 폭이 0인 이미지는 유효하지 않기 때문에, 바가 완전히 사라지지 않으며, 진행 상황이 트랙 너비를 초과할 수 없습니다. 스프라이트 위치는 고정되어 있으며, 이미지 폭만 변경됩니다 — 채우기 또는 클립 작업은 사용되지 않습니다.

### 5. 비밀번호 대화상자

`display_password_callback(prompt, bullets)`:

1. 스플래시를 흐리게 처리합니다: `logo.opacity = 0.15`와 워드마크는 `0.15`에 있으며, 트랙과 바는 `1.0`에 유지됩니다.
2. `Image.Text(prompt, 0.72, 0.77, 0.81)`로 프롬프트를 렌더링합니다 — 테마에서 유일하게 런타임에 생성되는 이미지입니다. 위치는 텍스트 높이에 따라 달라지므로 여기에서만 알 수 있습니다.
3. 입력 필드를 프롬프트 아래에 위치시킵니다: password.entry.y = password.prompt.y + password.prompt.image.GetHeight() + 14. 로드 시 `password.entry.y`는 `0`이며, 실제 위치는 프롬프트를 기다린다는 코멘트가 있습니다.
4. 생성 또는 재사용 루프로 총알을 그립니다:

   ```js
   for (index = 0; password.bullet[index] || index < bullets; index++)
   {
       if (!password.bullet[index]) { /* create sprite + image */ }
       /* ...position at entry.x + 16 + index * bullet.width ... */
       if (index < bullets) sprite.SetOpacity(1); else sprite.SetOpacity(0);
   }
   ```
스프라이트는 새로 생성되는 대신 프롬프트 전반에 걸쳐 풀링되고 재사용됩니다;
오래된 총알은 `0` 불투명도로 숨겨집니다. 총알은 입력 필드 높이에 맞춰 수직으로 중앙에 배치됩니다.

`display_normal_callback()`은 그 반대로: `1.0` 불투명도를 복원하고, 프롬프트, 입력란, 모든 풀링된 총알을 숨깁니다. `PlymouthSetDisplayNormalFunction`에 등록되어 있으며, 패스프레이즈가 받아들여지거나 취소될 때 Plymouth가 호출하고 부팅이 계속됩니다.

결과: `logo.opacity`는 상수가 아닌 변수입니다, 왜냐하면 페이드와 비밀번호 상태가 모두 여기에 곱해지기 때문입니다.

### 6. 페이드 인

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
재갱신 콜백은 전체 부팅 동안 계속 실행됩니다(비용이 적고 Plymouth가 이를 지속적으로 호출합니다); `fade.complete` 가드는 애니메이션 후에 이를 무작동(no-op)으로 만듭니다. 로고는 단순한 할당 대신 `logo.opacity * fade.opacity`를 사용하여 비밀번호로 인해 어둡게 된 상태가 페이드 동안에도 유지되도록 합니다: 페이드가 완료되면 `fade.opacity == 1`가 실행되고 로고는 다시 `logo.opacity`를 표시합니다.

이 테마의 이전 버전에는 펄스/스폰 애니메이션도 있었지만; `0.2.0`("chore: remove pulse effects")에서 제거되었습니다. 진행 표시줄의 프레임별 애니메이션을 다시 도입하지 마십시오 — 바는 부팅 진행 상황을 충실히 나타내야 합니다.

## 레이아웃 상수

구성 튜닝을 위한 단일 진리 소스:

| 상수 | 값 | 의미 |
| --- | --- | --- |
| `logo.base_scale` | `0.72` | 로고 스케일과 원본 256x256 비교 |
| `logo.y` offset | `-35` | 중앙 블록을 화면 중간 위로 올림 |
| `text.scale` | `0.80` | 워드마크 스케일과 원본 400x53 비교 |
| `text.y` gap | `+16` | 로고 하단 → 워드마크 상단 |
| `progress_track.y` gap | `+28` | 워드마크 하단 → 트랙 상단 |
| `password.prompt.y` gap | `+24` | 트랙 하단 → 프롬프트 텍스트 상단 |
| `password.entry.y` gap | `+14` | 프롬프트 하단 → 입력 필드 상단 |
| bullet x offset | `+16` | 입력 왼쪽 → 첫 번째 불릿 |
| `logo.opacity` (dialog) | `0.15` | 패스프레이즈 요청 시 스플래시 화면 어둡게 |
| 프롬프트 색상 | `0.72, 0.77, 0.81` | `Image.Text` RGB, ~`#B8C4CE` |
| 페이드 | 20 프레임 @ 20 FPS | 약 1초 페이드 인 |

## 디자인 토큰

| 토큰 | 16진수 | 위치 |
| --- | --- | --- |
| 배경 | `#111316` | 스크립트 (`0.0667, 0.0745, 0.0863`) |
| 악센트 | `#3590BD` | 로고 / 워드마크 / 진행률 채움 픽셀 |
| 진행 트랙 | `#262933` | `progress-bar-track.png` |
| 프롬프트 텍스트 | `#B8C4CE` | 스크립트 (`Image.Text` 호출) |

악센트와 트랙 색상은 PNG 자산에 내장되어 있으며 스크립트에서는 표현되지 않으므로, 색상을 변경하려면 자산을 다시 내보내거나 팔레트를 편집해야 합니다. 
테마는 다크 전용이며 라이트 버전이 없습니다.

## UKI 비트맵 형식

`argvus-uki-splash.bmp`은 400x400, 32비트 압축되지 않은 Windows BMP(`PC bitmap, Windows 98/2000 and newer format, 400 x 400 x 32`)입니다. 이것은 독립형 자산으로, Plymouth 스크립트는 이를 로드하지 않으며 Arch 패키지도 어디에도 등록하지 않습니다 — UKI에 포함시키는 것은 사용자의 단계입니다([사용자 가이드 ](/docs/argvus-boot-splash/uki-splash/) 참조).

만약 그것을 교체한다면, 비슷한 크기의 평문 압축되지 않은 32비트 BMP로 유지하세요;
systemd-boot와 `ukify`는 임의 형식과 큰 이미지를 스케일하지 않으며, 초기 부팅 시 메모리를 많이 사용합니다.

## 테마 수정

실용적인 루프:

1. `src/usr/share/plymouth/themes/argvus/argvus.script` (또는 PNG)을 편집합니다.
2. 라이브 Plymouth에 설치하거나 소스 트리에서 미리보기합니다:

   ```sh
   sudo cp -r src/usr/share/plymouth/themes/argvus/* \
              /usr/share/plymouth/themes/argvus/
   sudo plymouth-set-default-theme argvus
   sudo plymouth --show-splash    # check, then: sudo plymouthquit
   ```
3. 커밋하기 전에 `make validate && make build` 확인하세요.

테마가 제대로 작동하도록 하는 규칙:

- 비-Plymouth API를 절대 사용하지 마세요. 엔진은 제한된 방언이며, 이전에 사용한 적 없는 API를 사용하기 전에 지원하는 `plymouth` 대상 버전을 확인하세요.
- `ImageDir`/`ScriptFile` in `argvus.plymouth`는 절대 경로를 유지해야 하며 설치된 경로 `/usr/share/plymouth/themes/argvus`와 일치해야 합니다.
- `arch_check_splash_payload()`에 나열된 모든 자산을 `src/`에 포함된 파일과 동기화 상태로 유지하세요 — 패키징 `check()`가 CI에서 실행됩니다.
- 진행률 표시줄 너비는 보고된 진행률의 정확한 함수로 유지해야 합니다; `[1, track width]`에 고정(clamp)은 제거하지 마세요.
- 부팅 스플래시 화면뿐만 아니라 암호 구문(passphrase) 대화상자를 테스트하세요: 사용자들이 가장 많이 주목하고 깨지기 쉬운 상태입니다.
- 새로고침 콜백은 전체 부팅 동안 실행됩니다; 프레임별 작업 할당은 가능한 한 무료로 유지하세요.
