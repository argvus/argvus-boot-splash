---
title: UKI và systemd-boot Splash
description: Sử dụng bitmap khởi động ARGVUS trong luồng khởi động UKI.
---

# UKI và systemd-boot splash

Gói này cũng bao gồm `argvus-uki-splash.bmp` (400x400, BMP
32-bit không nén). Nó được thiết kế cho luồng khởi động UKI / systemd-boot, nơi hình ảnh chào mừng là
được nhúng vào hình ảnh kernel hợp nhất thay vì được đọc từ
initramfs.

. Hình ảnh bitmap *không* được sử dụng bởi chủ đề Plymouth và không có gì được đăng ký cho
bạn tự động: nhúng nó tùy thuộc vào cách bạn xây dựng UKI của mình. Thường thì
người tiêu dùng là:

```sh
# systemd: set the splash for the next boot (systemd >= 254)
bootctl --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp

# ukify, while building the UKI
ukify build --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp \
           --linux=... --initrd=... --microcode=...
```

Chạy lại việc xây dựng UKI (hoặc `bootctl set-splash`) mỗi khi hình ảnh thay đổi, và
hãy nhớ sao chép tệp vào ESP nếu bạn xây dựng ở nơi khác. systemd-boot sẽ phóng to
bitmap lên console, vì vậy một hình vuông sẽ xuất hiện ở giữa.

Nếu bạn chỉ sử dụng mkinitcpio hoặc dracut, bạn có thể hoàn toàn bỏ qua tập tin này — [cài đặt](/docs/argvus-boot-splash/installation/) thông thường của
đã bao phủ đường dẫn đó.

## Các bước tiếp theo

- [Sử dụng](/docs/argvus-boot-splash/usage/)
- [Khắc phục sự cố](/docs/argvus-boot-splash/troubleshooting/)
