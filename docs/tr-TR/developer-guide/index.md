---
title: Developer Guide
description: ARGVUS katkıda bulunanları için mimari ve geliştirme rehberi.
---

# Argvus Açılış Ekranı — Geliştirici Rehberi

`argvus-boot-splash` deposu için teknik dokümantasyon: Plymouth
temasının nasıl oluşturulduğu, Arch paketinin nasıl derlendiği ve sürümlerin
signed and published.

nasıl yapıldığı. Burada bir derleme adımı yok — tema veridir (bir `.plymouth` tanımlayıcı,
bir `.script` ve resimler) artı bir Arch paket tarifi. "Oluşturmak"
a reproducible package:

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
make validate
make build      # -> build/dist/argvus-boot-splash-<version>-1-any.pkg.tar.zst
make install    # sudo pacman -U that file
```

Bir değişiklik yapmadan önce: `make validate && make build` ve yeni teknik
terimleri `.cspell/custom-dictionary-workspace.txt`'ya ekleyin yoksa yazım denetimi işi başarısız olur.

Sadece temayı *kullanmak* istiyorsanız, [kullanıcı kılavuzunu](/docs/argvus-boot-splash/) okuyun.
Bu dosyanın süreç odaklı karşılığı (git flow, gizli bilgiler, sürüm
süreç) bkz. [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md) ve
[CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md).

## Guides

| Guide | Contents |
| --- | --- |
| [Tema mimarisi](/docs/argvus-boot-splash/developer-guide/theme/)| Tanımlayıcı, render modeli, varlık envanteri, betik yürütme, düzen sabitleri, tasarım simgeleri, UKI bitmap, temayı nasıl değiştirilir |
| [Ambalaj](/docs/argvus-boot-splash/developer-guide/packaging/)| İki PKGBUILD, paylaşıldı`functions.sh`, kancaları yükleyin, yerel derleme hattı, Make hedefleri, önkoşullar |
| [CI ve sürümler](/docs/argvus-boot-splash/developer-guide/ci-releases/) | `validate.sh`, `ci.yml`, `release.yml`adım adım, özet değerleri, imzalama, gizli bilgiler, yayınlama ve sürümlendirme |
| [Konvansiyonlar ve bilinen boşluklar](/docs/argvus-boot-splash/developer-guide/workflow/)| Ev kuralları, dokümantasyon haritası ve depo denetlerken bulunan uyumsuzluklar |

## Hızlı referans

| Path | What it is |
| --- | --- |
| `src/usr/share/plymouth/themes/argvus/` | theme payload installed under `/usr` |
| `packaging/arch/{ci,local}/PKGBUILD` | release and local package recipes |
| `packaging/arch/common/functions.sh` | shared `prepare`/`check`/`package` |
| `tools/sh/pkgbuild_local.sh` | deterministic tarball + `makepkg` driver |
| `tools/sh/validate.sh` | required validation gate |
| `.github/workflows/` | `ci.yml` (validate, build, spellcheck), `release.yml` (tags `v*`) |

## Elsewhere

- Depo kökü: [README.md](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)
- Kullanıcıya yönelik belgeler: [kullanıcı kılavuzu](/docs/argvus-boot-splash/)
- Geliştirme süreci: [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md)
- Katkıda Bulunma: [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)
- Güvenlik politikası: [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md)
- Lisans: [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE)
- Portekizce versiyon: [Guia do desenvolvedor](/pt/docs/argvus-boot-splash/developer-guide/)
