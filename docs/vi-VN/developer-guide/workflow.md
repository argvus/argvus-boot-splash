---
title: Quy ước và Lỗ hổng đã biết
description: Quy tắc nội bộ, bản đồ tài liệu và kết quả kiểm tra kho lưu trữ.
---

# Quy ước và lỗ hổng đã biết

Quy tắc nội bộ cho các thay đổi trong kho lưu trữ này, cùng với những không nhất quán được tìm thấy trong khi
kiểm toán nó — đáng sửa hơn là sao chép.

Đối với tham chiếu kỹ thuật xem [kiến trúc chủ đề](/docs/argvus-boot-splash/developer-guide/theme/),
[bao bì](/docs/argvus-boot-splash/developer-guide/packaging/)và [CI và các bản phát hành](/docs/argvus-boot-splash/developer-guide/ci-releases/).

## Conventions

- Shell: `set -euo pipefail`, tab cho việc thụt lề, `printf`/`error` thông điệp tới
stderr, kiểm tra khả năng `command -v`, dọn dẹp shellcheck (xem
  `.editorconfig`).
- Không bao giờ viết `sha256sums=('SKIP')`; giữ `sha256sums=()` trống trong git.
- Không commit các đầu ra build (`build/`), các tệp gói, hoặc
  `.PKGBUILD.local.*` copies.
- Commits theo quy ước với các phạm vi được sử dụng trong lịch sử: `splash`, `layout`,
`pkgbuild`, `release`, `chore`, `ci`, `build`, `docs`.
- Đặt tên nhánh: `feat/…`, `fix/…`, `docs/…`, `chore/…`, `refactor/…`.
- Một người đánh giá phê duyệt trước khi hợp nhất, squash-merge.
- Giấy phép: GPL-3.0-only. Vận chuyển dưới dạng `/usr/share/licenses/argvus-boot-splash/LICENSE`.
- Thực hiện quy trình trong [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md) và
[DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md).

## Những khoảng trống đã biết

Các sự không nhất quán được ghi lại khi kiểm toán kho lưu trữ:

- `README.md` quảng bá `make test` cho bản xem trước Plymouth trực tiếp, nhưng không có
mục tiêu tồn tại trong [Makefile](https://github.com/argvus/argvus-boot-splash/blob/main/Makefile). Các lệnh thực sự là
`sudo plymouth --show-splash` / `sudo plymouthquit`.
- `entry-line.png` và `logo-glow.png` đi kèm trong payload và được yêu cầu bởi
`arch_check_splash_payload()`, nhưng `argvus.script` không bao giờ tải chúng. Hoặc
kết nối chúng vào kịch bản hoặc loại chúng ra khỏi gói và danh sách kiểm tra.
- `src/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp` đã được cài đặt nhưng
chưa từng đăng ký với bất kỳ thứ gì; hướng dẫn [người dùng](/docs/argvus-boot-splash/uki-splash/)
ghi lại cách thủ công
  `bootctl`/`ukify` step.
- Các tài liệu chuẩn nằm tại gốc kho lưu trữ (`README.md`,
`DEVELOPMENT.md`) và trùng khớp với các hướng dẫn trong `docs/`. Giữ chúng nhất quán
khi thay đổi bất kỳ cái nào. Chính sách đóng góp (`CONTRIBUTING.md`, `SECURITY.md`)
tồn tại trong kho tổ chức `.github`.

## Sơ đồ tài liệu

| Document | Audience | Scope |
| --- | --- | --- |
| `README.md` | everyone | one-paragraph overview and layout |
| `DEVELOPMENT.md` | maintainers | build, signing, release process |
| [`CONTRIBUTING.md`](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)(tổ chức `.github`) | những người đóng góp | quy trình git, quy tắc PR, chính sách bảo mật |
| [`docs/user-guide.md`](/docs/argvus-boot-splash/)| người dùng cuối | cài đặt, sử dụng, khắc phục sự cố |
| [`docs/developer-guide.md`](/docs/argvus-boot-splash/developer-guide/)(/docs/argvus-boot-splash/developer-guide/) | developers | theme internals, packaging, CI |
