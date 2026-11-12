---
title: Tài liệu tham khảo
description: Các tập tin đã cài đặt, siêu dữ liệu gói và giá trị màu.
---

# Tài liệu tham khảo

Tham khảo kỹ thuật về những gì gói cài đặt và các giá trị mà nó sử dụng.

## Những gì bạn nhận được

| Thành phần | Mô tả |
| --- | --- |
| Logo Argvus | Biểu tượng căn giữa, vẽ phía trên chữ ký thương hiệu |
| Dấu từ | Dòng chữ `ARGVUS` bên dưới logo |
| Thanh tiến trình | Thanh mỏng có chiều rộng phản ánh tiến trình khởi động của Plymouth |
| Hộp thoại mật khẩu | Lời nhắc LUKS với trường nhập được ẩn (`•` bullets) |
| Mờ dần | Cảnh splash mờ dần trong khoảng ~1 giây khi Plymouth khởi động |
| UKI bitmap |`argvus-uki-splash.bmp`cho các khởi động dựa trên UKI / systemd-boot |

Tên gói là `argvus-boot-splash` và nó thay thế gói
`argvus-plymouth` cũ nếu bạn đã cài đặt.

## Các tập tin đã cài đặt

Dưới `/usr/share/plymouth/themes/argvus/`:

| Tập tin | Kích thước | Mục đích |
| --- | --- | --- |
| `argvus.plymouth` | — | mô tả chủ đề (tên, mô tả, mô-đun) |
| `argvus.script` | — | tập lệnh chủ đề (ngôn ngữ tập lệnh riêng của Plymouth) |
| `argvus-logo.png` | 256x256 | logo, RGBA |
| `argvus-text.png` | 400x53 | nhãn từ, RGBA |
| `progress-bar.png` | 400x4 | phần đầy của thanh tiến trình |
| `progress-bar-track.png` | 400x4 | đường đua chưa được lấp đầy |
| `entry-box.png` | 400x48 | trường nhập mật khẩu |
| `entry-line.png` | 300x2 | quy tắc/gạch chân trường mật khẩu |
| `bullet.png` | 12x12 | nhân vật đeo mặt nạ |
| `logo-glow.png` | 260x300 | tác phẩm nghệ thuật phát sáng logo |
| `argvus-uki-splash.bmp` | 400x400, 32-bit | UKI/systemd-bitmap giật gân khởi động |

Cộng với giấy phép tại `/usr/share/licenses/argvus-boot-splash/LICENSE`.

## Siêu dữ liệu gói

| Lĩnh vực | Giá trị |
| --- | --- |
| Tên | `argvus-boot-splash` |
| Kiến trúc | `any` |
| Phụ thuộc | `plymouth` |
| Tùy chọn phụ thuộc | `mkinitcpio`, `dracut` |
| Xung đột/thay thế | `argvus-plymouth` |
| Giấy phép | Chỉ GPL-3.0 |

## Màu sắc

| Yếu tố | Màu sắc |
| --- | --- |
| Bối cảnh | `#111316` |
| Giọng (logo, wordmark, điền tiến trình) | `#3590BD` |
| Theo dõi tiến độ | `#262933` |
| Văn bản nhắc mật khẩu | xám-xanh nhạt (`#B8C4CE`) |

Chủ đề sử dụng nền tối liền mạch ở mọi độ phân giải, vì vậy nó không bao giờ
tự động chuyển đổi giữa các biến thể sáng và tối.

## Nhận trợ giúp

- Báo cáo lỗi và yêu cầu tính năng trong bộ theo dõi vấn đề của dự án.
- Vấn đề bảo mật: làm theo [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md) — không mở nguồn
  vấn đề về lỗ hổng.
- công khai, xây dựng và phát hành: gốc kho lưu trữ ([README](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)).
- Đóng góp: [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md).
- Giấy phép: [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE).

## Các bước tiếp theo

- [Cài đặt](/docs/argvus-boot-splash/installation/)
- [Sử dụng](/docs/argvus-boot-splash/usage/)
- [Khắc phục sự cố](/docs/argvus-boot-splash/troubleshooting/)
