#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGING_DIR="$ROOT_DIR/packaging/arch"
BUILD_SCRIPT="$PACKAGING_DIR/PKGBUILD.local"

if [[ ! -f "$BUILD_SCRIPT" ]]; then
  echo "PKGBUILD.local not found under packaging/arch." >&2
  exit 1
fi

metadata="$({ cd "$PACKAGING_DIR" && bash -c 'source "$1"; printf "%s\n%s\n" "$pkgname" "$pkgver"' bash "$BUILD_SCRIPT"; })"
pkgname="$(printf '%s\n' "$metadata" | sed -n '1p')"
pkgver="$(printf '%s\n' "$metadata" | sed -n '2p')"
archive="$PACKAGING_DIR/${pkgname}-${pkgver}.tar.gz"

echo "Creating local source archive: $archive"
staging_dir="$(mktemp -d)"
cleanup() {
  rm -rf "$staging_dir"
}
trap cleanup EXIT

mkdir -p "$staging_dir/${pkgname}-${pkgver}"

tar -cf - \
  --exclude='./.git' \
  --exclude='./.github' \
  --exclude='./dist' \
  --exclude='./tmp' \
  --exclude='./packaging/arch/pkg' \
  --exclude='./packaging/arch/src' \
  --exclude='./packaging/arch/*.pkg.tar*' \
  --exclude='./packaging/arch/*.tar.gz' \
  -C "$ROOT_DIR" . | tar -xf - -C "$staging_dir/${pkgname}-${pkgver}"

tar -czf "$archive" -C "$staging_dir" "${pkgname}-${pkgver}"

if [[ -n "${MAKEPKG_FLAGS:-}" ]]; then
  # shellcheck disable=SC2206
  flags=(${MAKEPKG_FLAGS})
else
  flags=(--nodeps --noconfirm --needed --cleanbuild --clean --force)
fi

cd "$PACKAGING_DIR"
makepkg -p PKGBUILD.local "${flags[@]}" "$@"

mapfile -t packages < <(find "$PACKAGING_DIR" -maxdepth 1 -type f -name "${pkgname}-*.pkg.tar.zst" -print | sort)
if ((${#packages[@]} == 0)); then
  echo "No package artifact was created." >&2
  exit 1
fi

dist_dir="$ROOT_DIR/dist"
mkdir -p "$dist_dir"
mv -f "${packages[@]}" "$dist_dir/"
printf 'Packages moved to %s:\n' "$dist_dir"
printf '%s\n' "${packages[@]##*/}"
