---
title: ARGVUS Boot Splash
description: Chủ đề Plymouth và hướng dẫn cài đặt cho môi trường bàn ARGVUS
---

# Ảnh khởi động ARGVUS

Ảnh khởi động Argvus là một [Plymouth](https://www.freedesktop.org/wiki/Software/Plymouth/) theme cho hệ sinh thái máy tính để bàn Argvus. Đây là những gì bạn nhìn thấy giữa lúc bật máy và khi phiên làm việc đồ họa của bạn bắt đầu.

## Documentation

Tài liệu này được tổ chức thành hai phần chính:

### Hướng dẫn người dùng
Hướng dẫn cài đặt và sử dụng cho người dùng cuối và quản trị viên hệ thống.

| Guide | Contents |
| --- | --- |
| [Cài đặt](/docs/argvus-boot-splash/installation/)| Yêu cầu, ba lựa chọn cài đặt, các gói hook thực hiện gì |
| [Sử dụng](/docs/argvus-boot-splash/usage/)| Xác minh cài đặt, xem trước mà không cần khởi động lại, chuyển đổi hoặc khôi phục chủ đề, bảng hướng dẫn lệnh |
| [UKI và màn hình khởi động systemd-boot](/docs/argvus-boot-splash/uki-splash/)| Sử dụng `argvus-uki-splash.bmp`trong một quy trình khởi động UKI |
| [Gỡ cài đặt](/docs/argvus-boot-splash/uninstallation/)| Gỡ gói và khôi phục giao diện trước đó |
| [Khắc phục sự cố](/docs/argvus-boot-splash/troubleshooting/)| Các triệu chứng phổ biến và nguyên nhân của chúng |
| [Reference](/docs/argvus-boot-splash/reference/) for the installed and user paths.

### [Hướng dẫn cho nhà phát triển](/docs/argvus-boot-splash/developer-guide/)
Tài liệu kỹ thuật cho những người đóng góp và người duy trì.

- [Kiến trúc giao diện](/docs/argvus-boot-splash/developer-guide/theme/) — Mô tả Plymouth, mô hình kết xuất, và tùy chỉnh
- [Đóng gói](/docs/argvus-boot-splash/developer-guide/packaging/) — Xây dựng pipeline và đóng gói các công thức
- [CI và Phát hành](/docs/argvus-boot-splash/developer-guide/ci-releases/) — Quy trình xác thực, kiểm tra và phát hành

## Bắt đầu nhanh

Đối với hệ thống dựa trên Arch:

```sh
sudo pacman -S argvus-boot-splash   # or: sudo pacman -U ./argvus-boot-splash-<version>-1-any.pkg.tar.zst
```

Trình cài đặt sẽ đặt chủ đề làm mặc định và tự động tái tạo initramfs của bạn.

---

- **Kho lưu trữ:** [github.com/argvus/argvus-boot-splash](https://github.com/argvus/argvus-boot-splash)
- **License:** GPL-3.0-only
- **Báo cáo lỗi:** [GitHub Issues](https://github.com/argvus/argvus-boot-splash/issues)
