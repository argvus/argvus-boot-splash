SRC      = src
THEME_DIR = /usr/share/plymouth/themes/argvus
THEME_NAME = argvus

.PHONY: install uninstall set-theme rebuild build

install:
	@echo "Installing Argvus Plymouth theme..."
	@install -Dm644 $(SRC)/argvus.plymouth        "$(DESTDIR)$(THEME_DIR)/argvus.plymouth"
	@install -Dm644 $(SRC)/argvus.script          "$(DESTDIR)$(THEME_DIR)/argvus.script"
	@install -Dm644 $(SRC)/argvus-logo.png        "$(DESTDIR)$(THEME_DIR)/argvus-logo.png"
	@install -Dm644 $(SRC)/argvus-text.png        "$(DESTDIR)$(THEME_DIR)/argvus-text.png"
	@install -Dm644 $(SRC)/progress-bar.png       "$(DESTDIR)$(THEME_DIR)/progress-bar.png"
	@install -Dm644 $(SRC)/progress-bar-track.png "$(DESTDIR)$(THEME_DIR)/progress-bar-track.png"
	@install -Dm644 $(SRC)/bullet.png             "$(DESTDIR)$(THEME_DIR)/bullet.png"
	@install -Dm644 $(SRC)/entry-line.png         "$(DESTDIR)$(THEME_DIR)/entry-line.png"
	@echo "Done. Run 'make set-theme' to activate."

uninstall:
	@echo "Removing Argvus Plymouth theme..."
	@rm -rf "$(DESTDIR)$(THEME_DIR)"
	@echo "Done."

set-theme:
	plymouth-set-default-theme $(THEME_NAME)

rebuild:
	mkinitcpio -P

build:
	@echo "Building package..."
	cd $(SRC) && makepkg -d --skipchecksums --skippgpcheck -f
	@mkdir -p dist
	@pkg="$$(find "$(SRC)" -maxdepth 1 -type f -name 'argvus-splash-*.pkg.tar.zst' -printf '%T@ %p\n' | sort -n | tail -n 1 | cut -d' ' -f2-)"; \
	if [ -n "$$pkg" ]; then \
		mv -f "$$pkg" dist/; \
		echo "Done. Package in dist/"; \
	else \
		echo "No package artifact was created."; \
		exit 1; \
	fi
