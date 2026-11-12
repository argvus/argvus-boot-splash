---
title: Khắc phục sự cố
description: Các triệu chứng phổ biến của màn hình khởi động và cách khắc phục.
---

# Khắc phục sự cố

**Màn hình khởi động không thay đổi sau khi cài đặt.**
Initramfs chưa được tái tạo. Chạy `sudo mkinitcpio -P` (hoặc
`sudo dracut --regenerate-all`) và khởi động lại. Nếu hệ thống của bạn sử dụng nhiều kernel,
đảm bảo rằng thiết bị bạn khởi động có initramfs mới.

**Không có màn hình splash; màn hình chỉ đen hoặc chỉ hiển thị văn bản.**
`plymouth` bị thiếu trong các hook của initramfs. Kiểm tra `/etc/mkinitcpio.conf`
`HOOKS=(...)` chứa `plymouth`, sau đó xây dựng lại và khởi động lại. Trên Ubuntu/Debian,
cũng xác nhận `plymouth` và `plymouth-x11`/`plymouth-themes` được cài đặt và
rằng `GRUB_CMDLINE_LINUX` có `splash quiet`.

**Chỉ logo, không có tiến trình.**
Một số bước khởi động không được báo cáo bởi init của bạn, hoặc callback tiến trình
không bao giờ được gọi — không có gì bị hỏng ở phía bạn. Thanh tiến trình được lấp đầy từ
đã báo cáo tiến độ, điều này thiếu trong một vài cài đặt (ví dụ như với các chuỗi không có
`plymouth-spawn` của systemd hoặc một số module dracut nhất định).

**Hộp thoại nhập mật khẩu bị đặt sai vị trí hoặc không nhìn thấy.**
Hộp thoại được định vị từ nhãn chữ và hình học theo dõi, vì vậy cực đoan
độ phân giải (chế độ văn bản rất nhỏ) có thể đẩy nó ra ngoài màn hình. Sử dụng một độ phân giải
bình thường và báo cáo nếu điều đó xảy ra ở các độ phân giải phổ biến.

**Plymouth thoát sớm / bạn nhìn thấy bảng điều khiển văn bản thay vào đó.**
Điều gì đó đã tắt Plymouth: tham số khởi động `quiet` mà không có `splash`, một
`plymouth` móc bị loại bỏ, hoặc một trình điều khiển mà Plymouth không thể sử dụng. Plymouth thoát ra
bảng điều khiển văn bản thay vì làm máy bị treo — đây là hành vi mong đợi.

**Chủ đề không được áp dụng sau khi nâng cấp từ `argvus-plymouth`.**
Gói mới thay thế gói cũ; xác minh `/etc/plymouth/plymouthd.conf` nói
`PLYMOUTH_THEME_NAME=argvus` và xây dựng lại initramfs.

**Cài đặt thất bại do kiểm tra chữ ký.**
Khóa kho lưu trữ bị thiếu hoặc đã lỗi thời trong keyring của bạn. Nhập lại khóa công khai
hiện tại, sau đó `sudo pacman -Sy`.

**Màn hình khóa / chế độ ngủ có vẻ không thay đổi.**
Chủ đề chỉ bao phủ khởi động. Màn hình ngủ đông/tiếp tục được điều khiển riêng
(`systemd-homed`, trình khóa màn hình, việc sử dụng `plymouth` trong mục tiêu ngủ của
initramfs).

**Một Plymouth lạc vẫn đang chạy sau khi xem trước.**
`sudo plymouthquit` khôi phục phiên làm việc của bạn. Nếu màn hình vẫn đen, chuyển sang
một thiết bị đầu cuối ảo khác (`Ctrl+Alt+F2`) - phiên của bạn vẫn nguyên vẹn.

## Các bước tiếp theo

- [Cài đặt](/docs/argvus-boot-splash/installation/)— thử lại với một phương pháp khác.
- [Usage](/docs/argvus-boot-splash/usage/) for the installed and user paths.
