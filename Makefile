PREFIX ?= /usr
DESTDIR ?=
INSTALL ?= install
RM ?= rm -f

THEME_DIR := $(DESTDIR)$(PREFIX)/share/plymouth/themes/argvus

.DEFAULT_GOAL := help

.PHONY: help build install uninstall set-theme rebuild validate test clean

help:
	@echo "Available targets:"
	@echo "  make build"
	@echo "  make install"
	@echo "  make uninstall"
	@echo "  make set-theme"
	@echo "  make rebuild"
	@echo "  make validate"
	@echo "  make test"
	@echo "  make clean"

build:
	@tools/build-local-package.sh

install:
	$(INSTALL) -dm755 "$(THEME_DIR)"
	$(INSTALL) -Dm644 src/argvus.plymouth "$(THEME_DIR)/argvus.plymouth"
	$(INSTALL) -Dm644 src/argvus.script "$(THEME_DIR)/argvus.script"
	$(INSTALL) -Dm644 src/argvus-logo.png "$(THEME_DIR)/argvus-logo.png"
	$(INSTALL) -Dm644 src/argvus-text.png "$(THEME_DIR)/argvus-text.png"
	$(INSTALL) -Dm644 src/progress-bar.png "$(THEME_DIR)/progress-bar.png"
	$(INSTALL) -Dm644 src/progress-bar-track.png "$(THEME_DIR)/progress-bar-track.png"
	$(INSTALL) -Dm644 src/bullet.png "$(THEME_DIR)/bullet.png"
	$(INSTALL) -Dm644 src/entry-box.png "$(THEME_DIR)/entry-box.png"
	$(INSTALL) -Dm644 src/entry-line.png "$(THEME_DIR)/entry-line.png"
	$(INSTALL) -Dm644 src/argvus-uki-splash.bmp "$(THEME_DIR)/argvus-uki-splash.bmp"

uninstall:
	rm -rf "$(THEME_DIR)"

set-theme:
	plymouth-set-default-theme argvus

rebuild:
	mkinitcpio -P

validate:
	@test -f packaging/arch/PKGBUILD
	@test -f packaging/arch/PKGBUILD.local
	@test -f packaging/arch/argvus-splash.install
	@test -f src/argvus.plymouth
	@test -f src/argvus.script
	@test -f src/argvus-logo.png
	@test -f src/argvus-text.png
	@test -f src/progress-bar.png
	@test -f src/progress-bar-track.png
	@test -f src/bullet.png
	@test -f src/entry-box.png
	@test -f src/entry-line.png
	@test -f src/argvus-uki-splash.bmp
	@sh -n tools/build-local-package.sh
	@if command -v shellcheck >/dev/null 2>&1; then \
		shellcheck tools/build-local-package.sh; \
	fi
	@if command -v makepkg >/dev/null 2>&1; then \
		cd packaging/arch && makepkg -p PKGBUILD --printsrcinfo >/dev/null && makepkg -p PKGBUILD.local --printsrcinfo >/dev/null; \
	else \
		echo "makepkg not found; skipping PKGBUILD syntax validation"; \
	fi
	@echo "argvus-splash validation ok"

test:
	@echo "Starting Plymouth preview... Press Ctrl+C to stop the splash."
	@if [ "$$(id -u)" -eq 0 ]; then \
		plymouthd --mode=boot; \
	else \
		pkexec plymouthd --mode=boot; \
	fi
	@if [ "$$(id -u)" -eq 0 ]; then \
		plymouth --show-splash; \
	else \
		pkexec plymouth --show-splash; \
	fi

clean:
	rm -rf dist
	rm -f packaging/arch/*.pkg.tar* packaging/arch/*.tar.gz
