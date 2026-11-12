---
title: Gỡ cài đặt
description: Gỡ bỏ gói và khôi phục giao diện khởi động trước đó của bạn.
---

# Gỡ cài đặt

```sh
sudo pacman -Rns argvus-boot-splash
```

Sau đó chọn một giao diện khác và dựng lại, nếu không giao diện cũ sẽ vẫn còn bên trong
initramfs:

```sh
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme
sudo mkinitcpio -P        # or: sudo dracut --regenerate-all
```

 also removes

 if nothing else
đã tạo ra nó.

Hook gỡ bỏ của gói chỉ in ra một lời nhắc — nó không đoán được chủ đề
bạn muốn thay vào đó, và nó không chạm vào initramfs của bạn.

## Các bước tiếp theo

- Troubleshooting — restoring the previous splash.
- [Cài đặt](/docs/argvus-boot-splash/troubleshooting/) — cài đặt lại sau.
 /etc/plymouth/plymouthd.conf  `pacman -Rns` `/etc/plymouth/plymouthd.conf`

- [Troubleshooting](/docs/argvus-boot-splash/installation/) — restoring the previous splash.
