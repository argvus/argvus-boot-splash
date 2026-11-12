---
title: Cài đặt
description: Yêu cầu, tùy chọn cài đặt và các chức năng mà gói cắm vào thực hiện.
---

# Cài đặt

Mọi thứ bạn cần để có giao diện khởi động Argvus trên hệ thống dựa trên Arch.

Để biết giao diện chủ đề trông như thế nào và nó chứa những gì, xem
[tham khảo](/docs/argvus-boot-splash/reference/). Để xây dựng lại từ mã nguồn, xem hướng dẫn dành cho nhà phát triển
[hướng dẫn cho nhà phát triển](/docs/argvus-boot-splash/developer-guide/).

## Yêu cầu

- Một hệ thống dựa trên Arch sử dụng `plymouth` (gói phụ thuộc vào nó).
- Một trình tạo initramfs: **mkinitcpio** (mặc định của Arch) hoặc **dracut**.
Trình cài đặt sẽ phát hiện bất kỳ cái nào có sẵn và xây dựng lại initramfs cho bạn.
- Plymouth phải được bật trong cấu hình initramfs của bạn. Với mkinitcpio,
đảm bảo `plymouth` có trong danh sách `HOOKS` của `/etc/mkinitcpio.conf`:

  ```ini
  HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont plymouth)
  ```

Khởi động lại nếu bạn vừa thay đổi điều này.

- Không cần gì cho một phiên đồ họa bình thường; chủ đề chỉ chạy trong
  đường dẫn khởi động.

## Tùy chọn 1: kho gói chính thức (khuyến nghị)

Các gói đã ký được xuất bản trong kho gói Argvus
(`argvus/packages`, đường dẫn `public/arch/$arch`). Thêm nó vào `/etc/pacman.conf`:

```ini
[argvus]
SigLevel = Required DatabaseOptional
Server = <PACKAGES_REPO_BASE_URL>/argvus/packages/raw/branch/main/public/arch/$arch
```

Thay thế `<PACKAGES_REPO_BASE_URL>` bằng máy chủ mà dự án xuất bản kho
trên đó (GitHub, GitLab hoặc Gitea). Trước tiên, hãy nhập khóa ký kho,
nếu không `pacman` sẽ từ chối tải về:

```sh
# 1. import the project's public signing key into your pacman keyring
pacman-key --add /path/to/argvus-signing-key.asc
pacman-key --lsign <key-id>

# 2. refresh and install
sudo pacman -Sy
sudo pacman -S argvus-boot-splash
```

## Lựa chọn 2: tệp gói phát hành

Mỗi bản phát hành có thẻ sẽ xuất bản một `.pkg.tar.zst` (cùng với `.sig` của nó) như một bản phát hành
tài sản. Cài đặt trực tiếp:

```sh
sudo pacman -U ./argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```

Nếu bạn quan tâm đến việc đảm bảo vệ sinh chuỗi cung ứng, hãy xác minh chữ ký rời so với khóa công khai của dự án
trước khi cài đặt:

```sh
gpg --verify argvus-boot-splash-0.2.0-1-any.pkg.tar.zst.sig \
        argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```

## Lựa chọn 3: cài đặt thủ công

Hữu ích trên các hệ thống không phải Arch, hoặc nếu bạn chỉ muốn thử giao diện mà không cần
đóng gói. Sao chép thư mục chủ đề vào đường dẫn chủ đề của Plymouth:

```sh
sudo cp -r src/usr/share/plymouth/themes/argvus \
           /usr/share/plymouth/themes/argvus

sudo plymouth-set-default-theme argvus
sudo update-initramfs -u        # Debian/Ubuntu
# or: sudo mkinitcpio -P        # Arch
# or: sudo dracut --regenerate-all
```

Plymouth cũng có thể được kích hoạt trong `/etc/default/grub` với `GRUB_CMDLINE_LINUX`
chứa `splash`, và `quiet` mang lại cảm giác khởi động tối giản cổ điển.

## Những gì trình cài đặt thực hiện

Sau khi cài đặt hoặc nâng cấp, các hook của gói sẽ chạy tự động:

1. `plymouth-set-default-theme argvus` — ghi `argvus` vào
`/etc/plymouth/plymouthd.conf`.
2. `mkinitcpio -P` nếu mkinitcpio tồn tại, nếu không thì `dracut --regenerate-all`.

Nếu không tìm thấy bộ tạo nào, chương trình cài đặt sẽ in ra cảnh báo và bạn phải
tự xây dựng lại initramfs. Một thay đổi chủ đề chỉ trở nên hiển thị khi khởi động sau
initramfs được tạo lại — khởi động lại mà không có bước đó là  duy nhất
lý do phổ biến cho việc 'vết bắn nước không thay đổi'.

Khi gỡ bỏ, gói chỉ in ra một lời nhắc: chọn một chủ đề khác và
việc xây dựng lại initramfs để bạn tự thực hiện. Xem
[gỡ cài đặt](/docs/argvus-boot-splash/uninstallation/).

## Các bước tiếp theo

- [Sử dụng](/docs/argvus-boot-splash/usage/) — kiểm tra cài đặt, xem trước mà không cần khởi động lại, chuyển
  chủ đề.
- [UKI và màn hình khởi động systemd](/docs/argvus-boot-splash/uki-splash/) — sử dụng bitmap trong một UKI.
- [Khắc phục sự cố](/docs/argvus-boot-splash/troubleshooting/) — nếu màn hình khởi động không thay đổi.
