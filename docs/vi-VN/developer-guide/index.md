---
title: Developer Guide
description: Hướng dẫn kiến trúc và phát triển cho các đóng góp viên ARGVUS.
---

# Argvus Boot Splash — Hướng dẫn dành cho nhà phát triển

Tài liệu kỹ thuật cho kho `argvus-boot-splash`: cách mà chủ đề Plymouth
được cấu thành, cách gói Arch được xây dựng, và cách các phiên bản được
signed and published.

. Không có bước biên dịch nào ở đây — chủ đề là dữ liệu (một mô tả `.plymouth`,
một `.script`, và hình ảnh) cộng với công thức gói Arch. "Xây dựng" có nghĩa là tạo ra
a reproducible package:

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
make validate
make build      # -> build/dist/argvus-boot-splash-<version>-1-any.pkg.tar.zst
make install    # sudo pacman -U that file
```

Trước khi cam kết một thay đổi: `make validate && make build`, và thêm các thuật ngữ kỹ thuật mới
vào `.cspell/custom-dictionary-workspace.txt` nếu không công việc kiểm tra chính tả sẽ thất bại.

Nếu bạn chỉ muốn *sử dụng* chủ đề, hãy đọc [hướng dẫn người dùng](/docs/argvus-boot-splash/). Đối với
bản tương ứng theo quy trình của tệp này (git flow, secrets, phát hành
quy trình) xem [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md) và
[CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md).

## Guides

| Guide | Contents |
| --- | --- |
| [Kiến trúc chủ đề](/docs/argvus-boot-splash/developer-guide/theme/)| Bộ mô tả, mô hình kết xuất, kho tài sản, hướng dẫn kịch bản, hằng số bố cục, token thiết kế, bitmap UKI, cách sửa đổi chủ đề |
| [Bao bì](/docs/argvus-boot-splash/developer-guide/packaging/)| Hai PKGBUILD, được chia sẻ`functions.sh`, cài đặt hooks, quy trình xây dựng cục bộ, mục tiêu Make, các yêu cầu trước |
| [CI và các bản phát hành](/docs/argvus-boot-splash/developer-guide/ci-releases/) | `validate.sh`, `ci.yml`, `release.yml`từng bước, kiểm tra tổng, ký, bí mật, xuất bản và quản lý phiên bản |
| [Các quy ước và những khoảng trống đã biết](/docs/argvus-boot-splash/developer-guide/workflow/)| Quy tắc nhà, bản đồ tài liệu, và các điểm không nhất quán được phát hiện khi kiểm toán kho lưu trữ |

## Tham khảo nhanh

| Path | What it is |
| --- | --- |
| `src/usr/share/plymouth/themes/argvus/` | theme payload installed under `/usr` |
| `packaging/arch/{ci,local}/PKGBUILD` | release and local package recipes |
| `packaging/arch/common/functions.sh` | shared `prepare`/`check`/`package` |
| `tools/sh/pkgbuild_local.sh` | deterministic tarball + `makepkg` driver |
| `tools/sh/validate.sh` | required validation gate |
| `.github/workflows/` | `ci.yml` (validate, build, spellcheck), `release.yml` (tags `v*`) |

## Elsewhere

- Thư mục gốc kho lưu trữ: [README.md](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)
- Tài liệu hướng dẫn người dùng: [hướng dẫn người dùng](/docs/argvus-boot-splash/)
- Quy trình phát triển: [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md)
- Đóng góp: [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)
- Chính sách bảo mật: [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md)
- Giấy phép: [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE)
- Phiên bản tiếng Bồ Đào Nha: [Guia do desenvolvedor](/pt/docs/argvus-boot-splash/developer-guide/)
