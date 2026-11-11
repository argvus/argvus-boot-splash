---
title: Konvansiyonlar ve Bilinen Boşluklar
description: Kurallar, dokümantasyon haritası ve depo denetim bulguları.
---

# Konvansiyonlar ve bilinen boşluklar

Bu depodaki değişiklikler için ev kuralları, ayrıca bulunmuş tutarsızlıklar
denetlemek — kopyalamaktan ziyade düzeltmeye değer.

Teknik referans için bkz. [tema mimarisi](/docs/argvus-boot-splash/developer-guide/theme/),
[ambalaj](/docs/argvus-boot-splash/developer-guide/packaging/)ve[CI ve sürümler](/docs/argvus-boot-splash/developer-guide/ci-releases/).

## Conventions

- Shell: `set -euo pipefail`, girinti için sekmeler, `printf`/`error` mesajları
stderr, `command -v` yetenek kontrolleri, shellcheck temizliği (bakınız
  `.editorconfig`).
- `sha256sums=('SKIP')`'yi yazmayın; git'te `sha256sums=()` boş bırakın.
- Derleme çıktıları (`build/`), paket dosyaları veya üretilmiş olanları commit etmeyin
  `.PKGBUILD.local.*` copies.
- Geçmişte kullanılan kapsamlarla Geleneksel Commitler: `splash`, `layout`,
`pkgbuild`, `release`, `chore`, `ci`, `build`, `docs`.
- Dal adlandırma: `feat/…`, `fix/…`, `docs/…`, `chore/…`, `refactor/…`.
- Birleştirmeden önce bir inceleyici onayı, squash-merge.
- Lisans: Sadece GPL-3.0. `/usr/share/licenses/argvus-boot-splash/LICENSE` olarak gönderildi.
- [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md) ve
[DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md) içindeki süreci takip edin.

## Bilinen boşluklar

Depoyu denetlerken bulunan belgelenmiş tutarsızlıklar:

- `README.md`, bir doğrudan Plymouth önizlemesi için `make test`'yi bildiriyor, ancak böyle bir
Hedef, [Makefile](https://github.com/argvus/argvus-boot-splash/blob/main/Makefile) içinde mevcut. Gerçek komutlar
`sudo plymouth --show-splash` / `sudo plymouthquit`.
- `entry-line.png` ve `logo-glow.png` paket içinde gönderilir ve
`arch_check_splash_payload()` tarafından gereklidir, ancak `argvus.script` bunları hiç yüklemez. Ya
Onları senaryoya bağlayın veya yükten ve kontrol listesinden çıkarın.
- yüklü ancak
hiçbir şeyle kayıtlı değil;
[kullanıcı kılavuzu](/docs/argvus-boot-splash/uki-splash/) manueli belgeler.
   `src/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp` `bootctl`/`ukify` step.
- Kanonik belgeler depo kökünde bulunur (`README.md`,
`DEVELOPMENT.md`) ve `docs/`'deki rehberlerle örtüşür. Hangisi değiştirilirse değişsin bunları tutarlı tutun
. Katkı politikaları (`CONTRIBUTING.md`, `SECURITY.md`)
organizasyondaki `.github` deposunda bulunur.

## Dokümantasyon haritası

| Document | Audience | Scope |
| --- | --- | --- |
| `README.md` | everyone | one-paragraph overview and layout |
| `DEVELOPMENT.md` | maintainers | build, signing, release process |
| [`CONTRIBUTING.md`](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)(org`.github`) | katkıda bulunanlar | git akışı, PR kuralları, gizli bilgiler politikası |
| [`docs/user-guide.md`](/docs/argvus-boot-splash/)| son kullanıcılar | kurulum, kullanım, sorun giderme |
| [`docs/developer-guide.md`](/docs/argvus-boot-splash/developer-guide/)(/docs/argvus-boot-splash/developer-guide/) | developers | theme internals, packaging, CI |
