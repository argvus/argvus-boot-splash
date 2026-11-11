---
title: Theme Architecture
description: Cách mô tả Plymouth, tài sản và tập lệnh được kết hợp với nhau.
---

# Kiến trúc theme

Cách theme Plymouth được kết hợp: mô tả, tập hợp tài sản và những gì
`argvus.script` thực hiện, từng phần một.

Để biết về đóng gói và phát hành, xem [đóng gói](/docs/argvus-boot-splash/developer-guide/packaging/) và
[CI và phát hành](/docs/argvus-boot-splash/developer-guide/ci-releases/). Để sử dụng, xem
[hướng dẫn sử dụng](/docs/argvus-boot-splash/).

## Descriptor

Các chủ đề Plymouth là các mô tả khai báo được kịch bản của Plymouth giải thích
động cơ. Có hai phần:

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

Notes:

- `ModuleName=script` chọn trình thông dịch script tích hợp sẵn của Plymouth. Không có
module đã biên dịch; `ImageDir` và `ScriptFile` phải là **đường dẫn tuyệt đối**,
bởi vì initramfs có thư mục làm việc khác với phiên của bạn.
- Tên tệp là tên chủ đề: `argvus.plymouth` ⇒ chủ đề `argvus`, là
mà `plymouth-set-default-theme argvus` chọn.
- `argvus.script` là tệp mã duy nhất. Nó chạy bên trong VM nhúng của Plymouth
(liên kết vào `plymouthd` và initramfs). Các hạn chế phát sinh từ
  that: không có nhập/xuất tệp, không có luồng, không có tiến trình bên ngoài, không có số thực,
`MathInt` là phép toán duy nhất của bạn, và ngôn ngữ là một biến thể nhỏ giống C
(mảng là các đối tượng được khóa, `Sprite()` các đối tượng phải được tạo trước khi sử dụng).

## Mô hình kết xuất

- Một nền rắn phẳng (`Window.SetBackgroundTopColor` /
  `SetBackgroundBottomColor`).
- **Sprites** là những nguyên thủy vẽ duy nhất. Mỗi `Sprite()` có một hình ảnh, một
vị trí `(x, y)`, một **z-order** và độ mờ trong `[0, 1]`. Sau đó `SetPosition`
gọi thắng; không có đồ thị cảnh.
- Tiến trình được vẽ bằng cách re-`ImageScale` một hình ảnh mỗi khung hình và gọi
`SetImage` trên sprite — không có primitive cắt hay vẽ một phần.
- Plymouth báo cáo trạng thái thông qua các callback mà script đăng ký:
  `PlymouthSetBootProgressFunction`, `PlymouthSetDisplayPasswordFunction`,
  `PlymouthSetDisplayNormalFunction`, `PlymouthSetRefreshFunction`.
- `Plymouth.SetRefreshRate(20)` làm cho callback làm mới chạy ở 20 FPS;
chỉ animation theo thời gian của theme (hiệu ứng mờ dần) phụ thuộc vào nó.

## Kho tài sản

Tất cả tài sản nằm trong `src/usr/share/plymouth/themes/argvus/`. Chiều rộng hình ảnh

| File | Size | Format | Role | Used by `argvus.script` |
| --- | --- | --- | --- | --- |
| `argvus.plymouth` | — | INI | theme descriptor | loaded by `plymouthd` |
| `argvus.script` | — | Plymouth script | theme logic | yes |
| `argvus-logo.png` | 256x256 | RGBA 8-bit | main logo | yes (`logo.base_scale = 0.72`) |
| `argvus-text.png` | 400x53 | RGBA 8-bit | `ARGVUS` wordmark | yes (`text.scale = 0.80`) |
| `progress-bar.png` | 400x4 | 1-bit palette | filled bar | yes |
| `progress-bar-track.png` | 400x4 | 1-bit palette | unfilled track | yes |
| `entry-box.png` | 400x48 | RGB 16-bit | password entry field | yes |
| `bullet.png` | 12x12 | 4-bit palette | one masked character | yes |
| `entry-line.png`| 300x2 | bảng màu 1-bit | quy tắc mục/nằm dưới | không (xem[khoảng trống đã biết](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)) |
| `logo-glow.png`| 260x300 | bảng màu 8-bit | tác phẩm nghệ thuật phát sáng logo | không (xem[khoảng trống đã biết](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)) |
| `argvus-uki-splash.bmp` | 400x400 | BMP 32-bit | UKI / màn hình khởi động systemd-boot | không (đã được bộ nạp khởi động sử dụng) |

được sử dụng làm đơn vị bố cục: chữ ký thương hiệu là chiều rộng tham chiếu
(400 px ở tỷ lệ 1.0) và đường tiến trình, thanh tiến trình và trường nhập mật khẩu
đều được dẫn xuất từ nó, vì vậy bố cục sẽ một mạch nếu tài sản chữ ký thương hiệu
được xuất lại.

`arch_check_splash_payload()` trong `packaging/arch/common/functions.sh` yêu cầu
**tất cả** các tệp ở trên phải tồn tại; thêm một tài sản có nghĩa là thêm nó vào danh sách đó. Xem
[đóng gói](/docs/argvus-boot-splash/developer-guide/packaging/#shared-functions).

## Hướng dẫn script

`src/usr/share/plymouth/themes/argvus/argvus.script`, từ trên xuống dưới.

### 1. Background

```js
Window.SetBackgroundTopColor(0.0667, 0.0745, 0.0863);
Window.SetBackgroundBottomColor(0.0667, 0.0745, 0.0863);
```

Giá trị giống nhau ở trên và dưới ⇒ một lớp phủ phẳng, không có gradient. Các thành phần là
Các kênh 8-bit của `#111316` chia cho 255.

### 2. Tài sản và mở rộng quy mô

Mỗi hình ảnh được tải qua `Image("name")`, mà được giải quyết tương đối với
`ImageDir`. Việc phóng to là rõ ràng:

```js
logo.base_scale = 0.72;
logo.base_width = MathInt(logo.original_image.GetWidth() * logo.base_scale);
logo.frame[logo.base_width] = ImageScale(logo.original_image, logo.base_width,
                                         logo.base_height);
logo.image = logo.frame[logo.base_width];
```

Bộ nhớ cache `logo.frame[...]` là có chủ đích: `ImageScale` trên mỗi khung sẽ
phân bổ một hình ảnh mới cho mỗi khung; logo được phóng to một lần và được lưu trong bộ nhớ đệm theo chiều rộng mục tiêu
nên việc thay đổi kích thước chỉ cần một mục mới.

Chữ ký hiệu tuân theo cùng một ý tưởng tại `text.scale = 0.80`, nhưng nó được phóng to một lần
trực tiếp. Thanh tiến trình và thanh trạng thái sau đó được phóng to đến `text.image.GetWidth()` —
tức là thanh luôn khớp với chiều rộng của chữ ký thương hiệu, bất kể chiều rộng thực tế của chữ ký thương hiệu
pixel size is.

### 3. Layout

Mỗi yếu tố được căn giữa theo trục ngang của cửa sổ:

```js
logo.x = Window.GetX() + Window.GetWidth() / 2 - logo.image.GetWidth() / 2;
logo.y = Window.GetY() + Window.GetHeight() / 2 - logo.image.GetHeight() / 2 - 35;
```

Lưu ý `- 35`: ngăn xếp được căn giữa trên toàn bộ bố cục (logo +
chữ ký thương hiệu + thanh theo dõi), không chỉ riêng logo, vì vậy khối đặt hơi cao hơn
giữa dọc của màn hình. Vị trí dọc sau đó liên quan đến
phần tử trước (`text.y = logo.y + logo.image.GetHeight() + 16`,
`progress_track.y = text.y + text.image.GetHeight() + 28`, …), có nghĩa là
tỷ lệ thành phần như một đơn vị với độ phân giải.

Z-order used here:

| Z | Sprite |
| --- | --- |
| 100 | logo, wordmark, progress track |
| 101 | progress bar (above the track) |
| 200 | password entry field |
| 201 | password prompt text |
| 202 | password bullets |

### 4. Tiến trình khởi động

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

Đã đăng ký với `PlymouthSetBootProgressFunction(progress_callback)`. Cái kẹp
matters: một hình ảnh có chiều rộng bằng không là không hợp lệ trong một số phiên bản Plymouth, vì vậy thanh
sẽ không bao giờ biến mất hoàn toàn, và tiến trình không bao giờ vượt quá chiều rộng của thanh.
Vị trí sprite được cố định; chỉ có chiều rộng hình ảnh thay đổi — không lấp đầy hoặc cắt
operation is used.

### 5. Hộp thoại mật khẩu

`display_password_callback(prompt, bullets)`:

1. Làm mờ phần splash: `logo.opacity = 0.15` và chữ ký tại `0.15`, trong khi track và thanh
vẫn ở `1.0`.
2. hiển thị prompt với `Image.Text(prompt, 0.72, 0.77, 0.81)` — hình ảnh duy nhất được tạo trong thời gian chạy
trong chủ đề. Vị trí của nó chỉ được biết ở đây,
vì nó phụ thuộc vào chiều cao của văn bản.
3. Đặt vị trí trường nhập dưới lời nhắc: `password.entry.y =
password.prompt.y + password.prompt.image.GetHeight() + 14`. Khi tải,
`password.entry.y` là `0` với một chú thích rằng vị trí thực sự chờ
   prompt.
4. Vẽ các biểu tượng đầu đạn với một vòng lặp tạo hoặc tái sử dụng:

   ```js
   for (index = 0; password.bullet[index] || index < bullets; index++)
   {
       if (!password.bullet[index]) { /* create sprite + image */ }
       /* ...position at entry.x + 16 + index * bullet.width ... */
       if (index < bullets) sprite.SetOpacity(1); else sprite.SetOpacity(0);
   }
   ```

Các sprite được gom lại và tái sử dụng trên nhiều lời nhắc thay vì được tạo lại;
   Đạn cũ được ẩn với độ mờ `0`. Đạn được căn giữa theo chiều dọc
   chống lại chiều cao của trường nhập.

`display_normal_callback()` là nghịch đảo: nó khôi phục độ mờ `1.0`, ẩn đi
nhắc nhở, mục nhập và mỗi viên đạn được gom. Được đăng ký với
`PlymouthSetDisplayNormalFunction`, Plymouth gọi nó khi cụm mật khẩu là
được chấp nhận hoặc hủy và quá trình khởi động tiếp tục.

Consequence: `logo.opacity` là một biến, không phải hằng số, vì cả hiệu ứng mờ dần
và trạng thái mật khẩu đều nhân vào nó.

### 6. Hiệu ứng mờ dần vào

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

Hàm gọi lại làm mới liên tục chạy trong suốt quá trình khởi động (nó rẻ và Plymouth
liên tục gọi nó); bảo vệ `fade.complete` làm cho nó không thực hiện sau hoạt ảnh
. Biểu tượng sử dụng `logo.opacity * fade.opacity` thay vì một gán
đơn giản để trạng thái mờ theo mật khẩu vẫn tồn tại sau khi mờ: sau
khi fade hoàn tất, `fade.opacity == 1` và logo hiển thị `logo.opacity` lại.

Các phiên bản trước của chủ đề này cũng có các hiệu ứng nhấp nháy/tái tạo; chúng đã
bị loại bỏ trong `0.2.0` ("chore: remove pulse effects"). Không tái hiện lại hoạt hình
theo từng khung của thanh tiến trình — thanh phải duy trì việc
boot progress.

## Hằng số bố cục

Nguồn duy nhất để tinh chỉnh bố cục:

| Constant | Value | Meaning |
| --- | --- | --- |
| `logo.base_scale` | `0.72` | logo scale vs. its native 256x256 |
| `logo.y` offset | `-35` | nâng khối ở giữa lên trên giữa màn hình |
| `text.scale` | `0.80` | wordmark scale vs. its native 400x53 |
| `text.y` gap | `+16` | logo bottom → wordmark top |
| `progress_track.y` gap | `+28` | wordmark bottom → track top |
| `password.prompt.y` gap | `+24` | track bottom → prompt text top |
| `password.entry.y` gap | `+14` | prompt bottom → entry field top |
| bullet x offset | `+16` | entry left → first bullet |
| `logo.opacity` (dialog) | `0.15` | splash dimming while a passphrase is requested |
| prompt color | `0.72, 0.77, 0.81` | `Image.Text` RGB, ~`#B8C4CE` |
| fade | 20 frames @ 20 FPS | ~1 s fade-in |

## Token thiết kế

| Token | Hex | Where it lives |
| --- | --- | --- |
| Background | `#111316` | script (`0.0667, 0.0745, 0.0863`) |
| Accent | `#3590BD` | logo / wordmark / progress fill pixels |
| Progress track | `#262933` | `progress-bar-track.png` |
| Prompt text | `#B8C4CE` | script (`Image.Text` call) |

Màu nhấn và màu theo dõi được nhúng trong các tài sản PNG, không được biểu thị trong
tập lệnh, vì vậy việc đổi màu có nghĩa là phải xuất lại các tài sản (hoặc chỉnh sửa bảng màu).
Giao diện chỉ có chế độ tối và không có phiên bản sáng.

## Định dạng bitmap UKI

`argvus-uki-splash.bmp` là một file BMP Windows 400x400, 32-bit chưa nén
(`PC bitmap, Windows 98/2000 and newer format, 400 x 400 x 32`). Đây là một
tài sản độc lập: script Plymouth không bao giờ tải nó, và gói Arch cũng
không đăng ký nó ở đâu — việc nhúng nó vào UKI là bước của người dùng (xem
[hướng dẫn sử dụng](/docs/argvus-boot-splash/uki-splash/)).

Nếu bạn thay thế nó, hãy giữ nó ở dạng BMP 32-bit không nén thông thường có kích thước tương đương;
systemd-boot và `ukify` không mở rộng các định dạng tùy ý và các hình ảnh lớn
tiêu tốn nhiều bộ nhớ khi khởi động sớm.

## Chỉnh sửa giao diện

Practical loop:

1. Chỉnh sửa `src/usr/share/plymouth/themes/argvus/argvus.script` (và/hoặc các tệp PNG).
2. Cài đặt vào Plymouth đang chạy của bạn, hoặc xem trước từ cây nguồn:

   ```sh
   sudo cp -r src/usr/share/plymouth/themes/argvus/* \
              /usr/share/plymouth/themes/argvus/
   sudo plymouth-set-default-theme argvus
   sudo plymouth --show-splash    # check, then: sudo plymouthquit
   ```

3. `make validate && make build` trước khi cam kết.

Các quy tắc giữ cho chủ đề hoạt động:

- Không bao giờ giới thiệu các API ngoài Plymouth. Bộ công cụ là một ngôn ngữ hạn chế; kiểm tra
phiên bản mục tiêu của `plymouth` mà bạn hỗ trợ trước khi sử dụng một API mà bạn chưa
  used before.
- 

/

 in 

 must stay absolute and must match
  the installed path 

.
- Keep every asset listed in 

 in sync with the
  files that ship in 

 — the packaging 

 runs in CI.
- Chiều rộng thanh tiến trình phải luôn phản ánh trung thực chức năng của tiến trình được báo cáo;
kẹp vào  check()  src/  arch_check_splash_payload()  /usr/share/plymouth/themes/argvus  argvus.plymouth  ScriptFile  `ImageDir`  `ScriptFile`  `argvus.plymouth`  `/usr/share/plymouth/themes/argvus`  `arch_check_splash_payload()`  `src/`  `check()` `[1, track width]` không được gỡ bỏ.
- Kiểm tra hộp thoại mật khẩu, không chỉ màn hình khởi động: đây là trạng thái
có khả năng bị hỏng nhất và là trạng thái mà người dùng chú ý nhất.
- Hàm gọi lại làm mới chạy cho toàn bộ quá trình khởi động; giữ phân bổ công việc theo từng khung
  free where possible.
