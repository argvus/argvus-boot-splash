---
title: Troubleshooting
description: Gejala umum boot splash dan cara memperbaikinya.
---

# Troubleshooting

**Splash tidak berubah setelah instalasi.**
Initramfs tidak dihasilkan ulang. Jalankan `sudo mkinitcpio -P` (atau
`sudo dracut --regenerate-all`) dan lakukan reboot. Jika sistem Anda menggunakan beberapa kernel,
pastikan yang Anda boot mendapat initramfs baru.

**Tidak ada splash sama sekali; layarnya hitam atau hanya teks.**
`plymouth` hilang dari hook initramfs. Periksa `/etc/mkinitcpio.conf`
`HOOKS=(...)` berisi `plymouth`, kemudian bangun ulang dan reboot. Di Ubuntu/Debian,
juga konfirmasikan `plymouth` dan `plymouth-x11`/`plymouth-themes` telah terpasang dan
bahwa `GRUB_CMDLINE_LINUX` memiliki `splash quiet`.

**Hanya logo, tidak ada kemajuan.**
Beberapa langkah boot tidak dilaporkan oleh init Anda, atau callback kemajuan
tidak pernah dipanggil — tidak ada yang rusak di sisi Anda. Bar diisi dari
kemajuan yang dilaporkan, yang tidak ada di beberapa pengaturan (misalnya dengan urutan
`plymouth-spawn`-less systemd atau modul dracut tertentu).

**Prompt kata sandi salah tempat atau tidak terlihat.**
Dialog diposisikan dari wordmark dan geometri trek, jadi ekstrem
resolusi (mode teks sangat kecil) bisa membuatnya terdorong keluar layar. Gunakan resolusi
normal, dan laporkan jika itu terjadi pada resolusi umum.

**Plymouth keluar lebih awal / Anda melihat konsol teks sebagai gantinya.**
Sesuatu menonaktifkan Plymouth: parameter boot `quiet` tanpa `splash`, sebuah
`plymouth` hook dihapus, atau driver yang tidak dapat digunakan oleh Plymouth. Plymouth keluar ke
konsol teks daripada membekukan mesin — ini adalah perilaku yang diharapkan.

**Tema tidak diterapkan setelah peningkatan dari `argvus-plymouth`.**
Paket baru menggantikan yang lama; verifikasi `/etc/plymouth/plymouthd.conf` mengatakan
`PLYMOUTH_THEME_NAME=argvus` dan bangun kembali initramfs.

**Instalasi gagal pada verifikasi tanda tangan.**
Kunci repositori hilang atau kedaluwarsa di keyring Anda. Impor kembali kunci publik
yang terbaru, lalu `sudo pacman -Sy`.

**Layar terkunci / suspend terlihat tidak berubah.**
Tema ini hanya mencakup boot. Layar Hibernate/resume dikendalikan secara terpisah
(`systemd-homed`, pengunci layar, penggunaan `plymouth` dalam target tidur
initramfs).

Anda **Sebuah Plymouth yang tersesat masih berjalan setelah pratinjau.**
`sudo plymouthquit` memulihkan sesi Anda. Jika layar tetap hitam, beralih ke
terminal virtual lain (`Ctrl+Alt+F2`) — sesi Anda tetap utuh.

## Langkah selanjutnya

- [Instalasi](/docs/argvus-boot-splash/installation/) — coba lagi dengan metode berbeda.
- [Penggunaan](/docs/argvus-boot-splash/usage/) — lembar contekan perintah.
