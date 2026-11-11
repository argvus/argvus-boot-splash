---
title: CI and Releases
description: Xác thực, tích hợp liên tục, ký và quy trình phát hành.
---

# CI và các bản phát hành

Cổng xác thực, các công việc tích hợp liên tục, pipeline phát hành và
the versioning rules.

Đối với gói chính, xem [đóng gói](/docs/argvus-boot-splash/developer-guide/packaging/); đối với chủ đề, xem
[kiến trúc chủ đề](/docs/argvus-boot-splash/developer-guide/theme/).

## Validation

`tools/sh/validate.sh` là cổng bắt buộc:

- yêu cầu `bash`, `makepkg`, `shellcheck`;
- `shellcheck` + `bash -n` trên `tools/sh/*.sh` và `packaging/arch/common/*.sh`;
- lấy nguồn cả PKGBUILD và so sánh siêu dữ liệu đã trích xuất — từ xa và cục bộ phải
  match;
- `makepkg -p PKGBUILD --printsrcinfo` bên trong `ci/` và `local/` (phân tích tệp
theo cách makepkg làm);
- `git diff --check` (dấu cách/dấu xung đột).

## Tích hợp liên tục

`.github/workflows/ci.yml` (push/PR đến `main`, `archlinux:latest` container):

1. cài đặt `base-devel git namcap pacman-contrib shellcheck sudo`;
2. `make validate`;
3. xây dựng như một người dùng **không có quyền đặc biệt** `builder`
(`sudo -u builder env HOME=/home/builder make build`) — makepkg từ chối chạy
dưới quyền root, và không gian làm việc đã được `chown` chuẩn bị trước;
4. một công việc `spellcheck` riêng chạy `cspell-action@v6` với `cspell.json`.

`namcap` chạy bên trong `pkgbuild_local.sh` khi cài đặt, vì vậy các bản dựng cục bộ hiển thị
cùng lint như CI. Cấu hình kiểm tra chính tả là `cspell.json` với từ điển
trong workspace ở `.cspell/custom-dictionary-workspace.txt` — các thuật ngữ kỹ thuật mới
(cờ shell, tên công cụ) thuộc về từ điển đó, nếu không CI sẽ thất bại.

## pipeline phát hành

`.github/workflows/release.yml` — kích hoạt: đẩy một thẻ `v*`, hoặc
`workflow_dispatch` với một thẻ hiện có (xây dựng lại có kiểm soát). Nhóm đồng thời
`release-<ref>`, không hủy bỏ.

Steps:

1. **Kiểm tra** thẻ (dispatch sử dụng `inputs.tag`).
2. **Bước phiên bản**: xác thực thẻ với
`^v[0-9]+(\.[0-9]+)*([._+-][A-Za-z0-9]+)*$`, thất bại nếu `url` trống trong
`packaging/arch/remote/PKGBUILD`, sau đó ghi lại `pkgver` từ thẻ.
3. **Validate**: `make validate`.
4. **Xây dựng** như không đặc quyền `builder`: `updpkgsums` (giải quyết và xác thực
thực `sha256sums`) sau đó
`makepkg --nodeps --noconfirm --needed --cleanbuild --clean --check`.
Xác định `.pkg.tar.zst` và thất bại nếu không tồn tại.
5. **namcap** trên gói.
6. **Chữ ký**: nhập `GPG_PRIVATE_KEY` vào một `GNUPGHOME` dùng tạm (`mktemp -d`,
chế độ 700), xác minh rằng khóa bí mật nhập khẩu khớp với `GPG_KEY_ID` (ID ngắn hoặc dấu vân tay
), và tạo một `.sig` tách rời với
`--pinentry-mode loopback --passphrase-fd 0`.
7. **Xác minh chữ ký** trong một `GNUPGHOME` mới — việc phát hành sẽ thất bại nếu chữ ký
không xác minh được.
8. **Tải lên hiện vật** (`upload-artifact@v4`, `retention-days: 1`, gói +
chữ ký, `if-no-files-found: error`).
9. **Xuất bản**: kiểm tra `argvus/packages` với `PACKAGES_REPO_TOKEN`, sao chép gói
và `.sig` vào `public/arch/x86_64`, chạy
`repo-add -R argvus.db.tar.gz <pkg>`, ký `argvus.db.tar.gz`,
`argvus.files.tar.gz`, `argvus.db` và `argvus.files`, sau đó commit dưới tên
`github-actions[bot]` và push. Một diff không có thay đổi trả về 0 mà không commit.
10. **GitHub release**: `softprops/action-gh-release@v2` với các ghi chú được tạo
và package + chữ ký như các tài sản.

## Checksums, ký và secrets

- Không có `SKIP`: `sha256sums` luôn là một bản tóm tắt thực, được tính toán khi xây dựng
thời gian (địa phương) hoặc thông qua `updpkgsums` (phát hành CI).
- Giữ `sha256sums=()` **trống** trong kho lưu trữ.
- Các bản phát hành được ký GPG (gói `.sig`, `argvus.db.tar.gz`,

, 

, `argvus.files.tar.gz` GPG_PASSPHRASE  argvus.files  `argvus.db` ).
- 

 must be non-empty; the workflow rejects an empty passphrase.

Prepare the key:

```sh
gpg --full-generate-key            # RSA 4096, no expiry recommended
gpg --list-secret-keys --with-colons | grep ^sec:   # note the KEY_ID
gpg --armor --export-secret-keys KEY_ID            # what the workflow imports
```

Trong **Cài đặt → Bí mật và biến → Actions** của kho lưu trữ:

| Secret | Value |
| --- | --- |
|  `argvus.files`  `GPG_PASSPHRASE` `GPG_PRIVATE_KEY` | `gpg --armor --export-secret-keys KEY_ID` output |
| `GPG_KEY_ID` | expected key ID or fingerprint |
| `GPG_PASSPHRASE` | non-empty passphrase of the signing key |
| `PACKAGES_REPO_TOKEN` | PAT with `contents:write` on `argvus/packages` |

## Xuất bản một bản phát hành

Before tagging:

1. Fill in 

 in 

 with the real repository:
   - GitHub: 

 (the source
     uses 

);
   - GitLab: adjust 

 to

;
   - without 

, the release **fails on purpose** with a clear message.
2. Sync versions/metadata in 

 and
 packaging/arch/local/PKGBUILD  `url`  https://gitlab.com/argvus/argvus-boot-splash/-/archive/v${pkgver}/argvus-boot-splash-v${pkgver}.tar.gz  source=  ${url}/archive/refs/tags/v${pkgver}.tar.gz  url="https://github.com/argvus/argvus-boot-splash"  `packaging/arch/remote/PKGBUILD`   `url="https://github.com/argvus/argvus-boot-splash"`  `${url}/archive/refs/tags/v${pkgver}.tar.gz`  `source=`  `https://gitlab.com/argvus/argvus-boot-splash/-/archive/v${pkgver}/argvus-boot-splash-v${pkgver}.tar.gz` `url`  `packaging/arch/local/PKGBUILD` `packaging/arch/remote/PKGBUILD`.
3. Tag and push:

   ```sh
   git tag v0.1.0
   git push origin v0.1.0
   ```

Quy trình làm việc cũng có thể được bắt đầu thủ công với một thẻ `v*` hiện có như là của nó
   Đầu vào `tag`, điều này hữu ích cho việc xây dựng lại có kiểm soát.

## Versioning

- SemVer trong `pkgver`, số lần phát hành trong `pkgrel`.

## Gỡ rối cho nhà phát triển

**Phát hành thất bại tại “Lấy nguồn”.** `url` trống, thiếu thẻ `v*`, hoặc định dạng URL kho lưu trữ
không khớp với máy chủ (GitHub vs cấu trúc tarball
của GitLab). Quy trình làm việc xác thực mẫu thẻ và thất bại sớm một
`url`.

**`updpkgsums` không thể tìm thấy nguồn.** Thẻ phải tồn tại và được đẩy lên trước
công việc phát hành chạy; việc phân phối với một thẻ chỉ tồn tại cục bộ sẽ thất bại ở đây.

**`make validate` báo "metadata PKGBUILD từ xa và cục bộ không đồng bộ".**
Sao chép các trường metadata (không phải `source=`) từ một PKGBUILD sang PKGBUILD khác.

**Kiểm tra chính tả thất bại với một thuật ngữ mới.** Thêm nó vào
`.cspell/custom-dictionary-workspace.txt` (từ điển `argvus`, `addWords:
true`), not to `ignorePaths`.

**`sudo` được yêu cầu bên trong `make install`, hoặc `libfakeroot.so … LD_PRELOAD`
lỗi.** Một `package()` mà gọi ra `make install` thay vì sử dụng
`install -Dm*`. Cả hai PKGBUILDs đều gọi `arch_package_splash_payload`, mà
không gọi; đảm bảo không ai tái đưa vào một cuộc gọi `make`.

**`makepkg` từ chối chạy.** Nó không được chạy dưới quyền root. Chạy bản build như một người dùng
bình thường, hoặc `sudo -u <user> make build`.

**Gói cài đặt nhưng màn hình khởi động vẫn không thay đổi.** Initramfs chưa được xây dựng lại.
Để kiểm tra tại chỗ, hãy gọi `sudo plymouth --show-splash` thay vì khởi động lại, hoặc
xây dựng lại với  `sudo mkinitcpio -P` `sudo dracut --regenerate-all` / sudo dracut --regenerate-all.
