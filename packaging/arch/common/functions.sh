#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck disable=SC2154
# srcdir, pkgdir, pkgname, and pkgver are supplied by makepkg.

# GitHub source archives use <repository>-v<version> as their top-level
# directory, while the local builder creates <pkgname>-<pkgver>. Normalize
# both forms before check() and package() run.
arch_normalize_source_tree() {
	local expected="${srcdir}/${pkgname}-${pkgver}"
	local -a roots=()

	while IFS= read -r -d '' root; do
		roots+=("$root")
	done < <(find "$srcdir" -mindepth 1 -maxdepth 1 -type d -print0)

	if (( ${#roots[@]} != 1 )); then
		printf 'error: expected exactly one extracted source directory in %s\n' "$srcdir" >&2
		return 1
	fi

	if [[ "${roots[0]}" != "$expected" ]]; then
		[[ ! -e "$expected" ]] || {
			printf 'error: source destination already exists: %s\n' "$expected" >&2
			return 1
		}
		mv -- "${roots[0]}" "$expected"
	fi
}

arch_check_splash_payload() {
	local source_root="${srcdir}/${pkgname}-${pkgver}"

	local payload_root="${source_root}/src/usr/share/plymouth/themes/argvus"
	local required_file

	for required_file in \
		argvus.plymouth argvus.script argvus-logo.png argvus-text.png \
		progress-bar.png progress-bar-track.png bullet.png entry-box.png \
		entry-line.png argvus-uki-splash.bmp; do
		test -f "${payload_root}/${required_file}"
	done
}

arch_package_splash_payload() {
	local source_root="${srcdir}/${pkgname}-${pkgver}"
	local payload_root="${source_root}/src/usr"

	find "$payload_root" -type f -printf '%P\0' | while IFS= read -r -d '' file; do
		install -Dm644 "${payload_root}/${file}" "${pkgdir}/usr/${file}"
	done
	install -Dm644 "${source_root}/LICENSE" \
		"${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"
}
