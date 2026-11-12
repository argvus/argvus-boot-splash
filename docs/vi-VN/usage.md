---
title: Cách sử dụng
description: Xác minh cài đặt, xem trước mà không khởi động lại, và chuyển đổi chủ đề.
---

# Cách sử dụng

Cách xác minh chủ đề, xem trước nó mà không khởi động lại, và chuyển sang chủ đề khác.
Để cài đặt, xem [cài đặt](/docs/argvus-boot-splash/installation/).

## Xác minh việc cài đặt

```sh
# theme is present?
ls /usr/share/plymouth/themes/argvus

# which theme is the default?
plymouth-set-default-theme          # prints, e.g.: argvus

# does Plymouth parse the theme without errors?
sudo plymouth --show-splash
```

## Xem trước mà không khởi động lại

```sh
sudo plymouth --show-splash   # shows the splash, simulating boot
sudo plymouthquit             # returns to your session
```

Khi chạy với tư cách người dùng thông thường, xem trước có thể yêu cầu xác thực polkit. Thanh tiến trình
sẽ tiến triển theo tiến trình mô phỏng; bạn cũng có thể ép các trạng thái:

```sh
sudo plymouth --show-details   # verbose boot messages instead of the splash
sudo plymouth --show-splash    # back to the splash
```

Khi màn hình khởi động xuất hiện, nhấn <kbd>Esc</kbd> để chuyển sang màn hình tiếp theo
(giật gân → chi tiết → giật gân).

## Những gì màn hình khởi động hiển thị

| Sân khấu | Ngoại hình |
| --- | --- |
| Khởi động | Mọi thứ xuất hiện dần trong khoảng ~1 giây: logo, chữ thương hiệu, thanh tiến trình |
| Khởi động | Thanh nạp đầy từ bên trái khi Plymouth báo cáo tiến trình |
| Ổ đĩa được mã hóa | Màn hình khởi động mờ đi còn 15%, văn bản nhắc và các dấu đầu dòng bị ẩn xuất hiện dưới thanh |
| Mật khẩu được chấp nhận | Hộp thoại biến mất, màn hình khởi động trở lại độ mờ đầy đủ |

## Thay đổi hoặc khôi phục chủ đề

```sh
# switch theme (any theme name under /usr/share/plymouth/themes)
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme

# then regenerate the initramfs
sudo mkinitcpio -P              # or: sudo dracut --regenerate-all
```

Các tập tin cấu hình hữu ích:

| Tập tin | Mục đích |
| --- | --- |
| `/etc/plymouth/plymouthd.conf` | `PLYMOUTH_THEME_NAME=argvus` viết theo gói |
| `/etc/mkinitcpio.conf` | `HOOKS=(... plymouth ...)` phải bao gồm `plymouth` |
| `/etc/plymouth/plymouthd.conf` (lại) | `PLYMOUTH_TOGGLE_KEY`, v.v. mang tính toàn cầu, không phải theo chủ đề |

## Bảng mẹo lệnh

| Lệnh | Hiệu ứng |
| --- | --- |
| `sudo plymouth-set-default-theme argvus` | đặt `argvus` làm chủ đề mặc định |
| `sudo plymouth-update-theme` | áp dụng thay đổi cho Plymouth đang chạy |
| `sudo plymouth --show-splash` | hiển thị phần giật gân trong phiên hiện tại |
| `sudo plymouth --show-details` | thay vào đó hãy hiển thị các thông báo khởi động dài dòng |
| `sudo plymouthquit` | rời khỏi Plymouth và khôi phục phiên của bạn |
| `sudo mkinitcpio -P` | xây dựng lại Arch initramfs |
| `sudo dracut --regenerate-all` | xây dựng lại initramfs bằng dracut |

## Các bước tiếp theo

- [UKI và màn hình khởi động systemd-boot](/docs/argvus-boot-splash/uki-splash/)
- [Gỡ cài đặt](/docs/argvus-boot-splash/uninstallation/)
- [Khắc phục sự cố](/docs/argvus-boot-splash/troubleshooting/)
