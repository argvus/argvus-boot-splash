---
title: Reference
description: Các tập tin đã cài đặt, siêu dữ liệu gói và giá trị màu.
---

# Reference

Tham khảo kỹ thuật về những gì gói cài đặt và các giá trị mà nó sử dụng.

## Những gì bạn nhận được

| Component | Description |
| --- | --- |
| Logo Argvus | Biểu tượng căn giữa, vẽ phía trên chữ ký thương hiệu |
| Wordmark | `ARGVUS` text below the logo |
| Thanh tiến trình | Thanh mỏng có chiều rộng phản ánh tiến trình khởi động của Plymouth |
| Hộp thoại mật khẩu | Lời nhắc LUKS với trường nhập được ẩn (`•` bullets) |
| Mờ dần | Cảnh splash mờ dần trong khoảng ~1 giây khi Plymouth khởi động |
| UKI bitmap |`argvus-uki-splash.bmp`cho các khởi động dựa trên UKI / systemd-boot |

Tên gói là `argvus-boot-splash` và nó thay thế gói
`argvus-plymouth` cũ nếu bạn đã cài đặt.

## Các tập tin đã cài đặt

Dưới `/usr/share/plymouth/themes/argvus/`:

| File | Size | Purpose |
| --- | --- | --- |
| `argvus.plymouth` | — | theme descriptor (name, description, module) |
| `argvus.script` | — | the theme script (Plymouth's own scripting language) |
| `argvus-logo.png` | 256x256 | logo, RGBA |
| `argvus-text.png` | 400x53 | wordmark, RGBA |
| `progress-bar.png` | 400x4 | filled part of the progress bar |
| `progress-bar-track.png` | 400x4 | unfilled track |
| `entry-box.png` | 400x48 | password entry field |
| `entry-line.png` | 300x2 | password field rule/underline |
| `bullet.png` | 12x12 | masked character |
| `logo-glow.png` | 260x300 | logo glow artwork |
| `argvus-uki-splash.bmp` | 400x400, 32-bit | UKI/systemd-boot splash bitmap |

Cộng với giấy phép tại `/usr/share/licenses/argvus-boot-splash/LICENSE`.

## Siêu dữ liệu gói

| Field | Value |
| --- | --- |
| Name | `argvus-boot-splash` |
| Architecture | `any` |
| Depends | `plymouth` |
| Optional depends | `mkinitcpio`, `dracut` |
| Conflicts / replaces | `argvus-plymouth` |
| License | GPL-3.0-only |

## Colors

| Element | Color |
| --- | --- |
| Background | `#111316` |
| Accent (logo, wordmark, progress fill) | `#3590BD` |
| Progress track | `#262933` |
| Password prompt text | light gray-blue (`#B8C4CE`) |

Chủ đề sử dụng nền tối liền mạch ở mọi độ phân giải, vì vậy nó không bao giờ
tự động chuyển đổi giữa các biến thể sáng và tối.

## Nhận trợ giúp

- Báo cáo lỗi và yêu cầu tính năng trong bộ theo dõi vấn đề của dự án.
- Vấn đề bảo mật: làm theo [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md) — không mở nguồn
  issue for vulnerabilities.
- công khai, xây dựng và phát hành: gốc kho lưu trữ ([README](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)).
- Đóng góp: [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md).
- Giấy phép: [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE).

## Các bước tiếp theo

- [Cài đặt](/docs/argvus-boot-splash/installation/)
- [Sử dụng](/docs/argvus-boot-splash/usage/)
- [Khắc phục sự cố](/docs/argvus-boot-splash/troubleshooting/)
