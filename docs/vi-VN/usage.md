---
title: Usage
description: Xác minh cài đặt, xem trước mà không khởi động lại, và chuyển đổi chủ đề.
---

# Usage

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
(splash → details → splash).

## Những gì màn hình khởi động hiển thị

| Stage | Appearance |
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

Useful configuration files:

| File | Purpose |
| --- | --- |
| `/etc/plymouth/plymouthd.conf` | `PLYMOUTH_THEME_NAME=argvus` written by the package |
| `/etc/mkinitcpio.conf` | `HOOKS=(... plymouth ...)` must include `plymouth` |
| `/etc/plymouth/plymouthd.conf` (again) | `PLYMOUTH_TOGGLE_KEY` etc. are global, not per-theme |

## Bảng mẹo lệnh

| Command | Effect |
| --- | --- |
| `sudo plymouth-set-default-theme argvus` | make `argvus` the default theme |
| `sudo plymouth-update-theme` | apply the change to the running Plymouth |
| `sudo plymouth --show-splash` | show the splash in the current session |
| `sudo plymouth --show-details` | show verbose boot messages instead |
| `sudo plymouthquit` | leave Plymouth and restore your session |
| `sudo mkinitcpio -P` | rebuild the Arch initramfs |
| `sudo dracut --regenerate-all` | rebuild the initramfs with dracut |

## Các bước tiếp theo

- [UKI và màn hình khởi động systemd-boot](/docs/argvus-boot-splash/uki-splash/)
- [Gỡ cài đặt](/docs/argvus-boot-splash/uninstallation/)
- [Khắc phục sự cố](/docs/argvus-boot-splash/troubleshooting/)
