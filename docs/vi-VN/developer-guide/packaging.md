---
title: Packaging
description: Siêu dữ liệu gói Arch, quy trình xây dựng và các mục tiêu Make.
---

# Packaging

Cách gói Arch được định nghĩa và tạo ra: hai PKGBUILD, các hàm
chia sẻ, các hook cài đặt, quy trình xây dựng cục bộ và các mục tiêu Make.

Đối với giao diện theme, xem [kiến trúc theme](/docs/argvus-boot-splash/developer-guide/theme/); đối với việc xác thực, CI và
các bản phát hành, xem [CI và các bản phát hành](/docs/argvus-boot-splash/developer-guide/ci-releases/).

## Hai PKGBUILD, một payload

`packaging/arch/remote/PKGBUILD` và `packaging/arch/local/PKGBUILD` giống hệt nhau
except for `source=`:

| | `local` | `ci` |
| --- | --- | --- |
| source | `${pkgname}-${pkgver}.tar.gz` (built by `make build`) | `${url}/archive/refs/tags/v${pkgver}.tar.gz` |
| used by | developers, `make build` | GitHub Actions release |

Cả hai đều gọi các hàm giống nhau từ `packaging/arch/common/functions.sh`, và
`tools/sh/validate.sh` xác nhận siêu dữ liệu của chúng (`pkgname`, `pkgver`, `pkgrel`,
`pkgdesc`, `arch`, `license`, `depends`, `makedepends`, `options`) là giống hệt nhau,
vì vậy hai cái không thể lặng lẽ trôi dạt.

Shared metadata:

```bash
pkgname=argvus-boot-splash
pkgver=0.2.0
pkgrel=1
arch=('any')                 # pure data package
depends=('plymouth')
optdepends=('mkinitcpio: rebuild initramfs (Arch Linux)'
            'dracut: rebuild initramfs (alternative)')
options=('!debug')
conflicts=('argvus-plymouth') # renamed predecessor
replaces=('argvus-plymouth')
```

## Chức năng dùng chung

`packaging/arch/common/functions.sh` cung cấp ba chức năng được cả
PKGBUILDs:

- `arch_normalize_source_tree` (`prepare()`) sử dụng — lưu trữ nhãn GitHub giải nén sang
`<repo>-v<version>`, trong khi gói tarball cục bộ giải nén sang
`<pkgname>-<pkgver>`. Điều này đổi tên thư mục cấp cao nhất thành
`${srcdir}/${pkgname}-${pkgver}`, gây lỗi nếu thư mục nguồn
bị thiếu, không rõ ràng, hoặc thư mục đích đã tồn tại.
- `arch_check_splash_payload` (`check()`) — xác nhận rằng mọi tài sản chủ đề tồn tại trong
nguồn đã trích xuất. Đây là "bộ kiểm thử" duy nhất của gói; danh sách các tệp cần thiết
có trong [danh mục tài sản](/docs/argvus-boot-splash/developer-guide/theme/#asset-inventory).
- `arch_package_splash_payload` (`package()`) — đi qua `src/usr` với
`find -print0` và cài đặt mỗi tệp với `install -Dm644` vào `$pkgdir`
(An toàn với NUL, hoạt động với khoảng trắng trong tên), sau đó cài đặt `LICENSE` vào
`/usr/share/licenses/argvus-boot-splash/LICENSE`.

Lưu ý không có cuộc gọi `make install` bên trong `package()`: mọi thứ đều
`install -Dm*`, vì vậy gói này tự chứa và thân thiện với xây dựng không cần quyền root.
That is deliberate — an old 

 that called 

 produced

/

 failures.

## Cài đặt móc

 (identical):

- 

 / 

 → 

,
sau đó  plymouth-set-default-theme argvus  post_upgrade()  post_install()  packaging/arch/{ci,local}/argvus-boot-splash.install  libfakeroot.so  sudo  make install  `package()`  `make install`  `sudo`  `libfakeroot.so`  `packaging/arch/{ci,local}/argvus-boot-splash.install`  `post_install()`  `post_upgrade()`  `plymouth-set-default-theme argvus` `mkinitcpio -P` nếu có, nếu không thì `dracut --regenerate-all`, nếu không thì
cảnh báo cho người dùng tự xây dựng lại.
- `post_remove()` → chỉ là thông điệp thông tin; chủ đề không được chuyển lại
tự động (an toàn hơn so với đoán mò).

## Chuỗi xây dựng cục bộ

`tools/sh/pkgbuild_local.sh` (được gọi bởi `make build`):

1. Xác minh `makepkg`, `sha256sum`, `tar`, `awk`, `find` và rằng PKGBUILD
tồn tại; lấy nguồn PKGBUILD để đọc `pkgname`/`pkgver` và xác thực cả hai
chống lại các biểu thức chính quy trong danh sách cho phép (`^[a-z0-9@._+-]+$` cho tên, một phiên bản có dấu chấm
mẫu cho phiên bản).
2. Xây dựng `build/artifacts/${pkgname}-${pkgver}.tar.gz` với
`tar --sort=name --mtime='UTC 1970-01-01' --owner=0 --group=0 --numeric-owner`
và `--transform "s#^\./#${pkgname}-${pkgver}/#"` — một
lưu trữ có thể tái tạo. Nó loại trừ `.git`, `build/`, `dist/`, `target/`,
`tools/`, `release`/`packages-repo` thư mục tạm, và bất kỳ `src/`, `pkg/` hoặc
dư thừa gói bên trong các thư mục đóng gói.
3. Tính toán `sha256` của kho lưu trữ và chèn nó với `sed` vào một **bản sao tạm thời
** của PKGBUILD cục bộ (`.PKGBUILD.local.XXXXXX`, bị loại bỏ bởi một `EXIT`
trap). Kho lưu trữ luôn giữ `sha256sums=()` trống; `SKIP` không bao giờ
   used.
4. Xóa bất kỳ `${pkgname}-${pkgver}-*.pkg.tar.zst` tồn tại trước đó từ
`build/dist/` để một gói cũ không bị nhầm lẫn với bản build này.
5. Chạy `makepkg -p <generated PKGBUILD> --nodeps --noconfirm --needed
--cleanbuild --force --check` with `BUILDDIR`/`SRCDEST` in `build/artifacts/`
   and 

 in 

. Extra arguments are forwarded to 

;

 overrides the default flag set (word-split on purpose).
6. Fails unless exactly one 

 matches, then runs 

 on it if
   installed.

Outputs:

```text
build/dist/argvus-boot-splash-0.2.0-1-any.pkg.tar.zst   installable package
build/artifacts/argvus-boot-splash-0.2.0.tar.gz          source snapshot
build/artifacts/argvus-boot-splash/{src,pkg}/            makepkg work dirs
```

## Tạo mục tiêu

| Target | Effect |
| --- | --- |
|  namcap  .pkg.tar.zst  MAKEPKG_FLAGS  makepkg  build/dist/  `PKGDEST`  `build/dist/`  `makepkg`  `MAKEPKG_FLAGS`  `.pkg.tar.zst`  `namcap` `make build` (alias `make package`) | run `tools/sh/pkgbuild_local.sh` → `build/` |
| `make install` (alias `make install-package`) | `sudo pacman -U`gói đơn trong`build/dist/`; lỗi nếu số lượng không đúng 1 |
| `make validate` | `tools/sh/validate.sh`: shellcheck + `bash -n` + PKGBUILD metadata sync + `makepkg --printsrcinfo` per PKGBUILD + `git diff --check` |
| `make lint` (alias `make lint-shell`) | shellcheck over `tools`, `packaging/arch/common`, `src` (`SC1090`, `SC2034`, `SC2154` disabled), `bash -n`, `git diff --check` |
| `make spellcheck` | `cspell --config cspell.json .` if `cspell` is installed, otherwise skipped |
| `make clean` | `rm -rf build/` |
| `make help` | target list (default goal) |

CI chạy `make validate` và `make build`; không có gì trong CI chạy `make install`
(xem [các khoảng trống đã biết](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)).

## Prerequisites

Một hệ thống dựa trên Arch với `make`, `git`, `gnupg` và nhóm `base-devel`:

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
```

- `pacman-contrib` cung cấp `updpkgsums` (tái tạo các checksum PKGBUILD).
- `shellcheck` xác thực các tập lệnh shell trong kho lưu trữ và các công cụ chia sẻ Arch
  packaging functions.
- Optional: `namcap` (package
linting) và cspell (kiểm tra chính tả cục bộ). CI cài đặt tất cả chúng.
