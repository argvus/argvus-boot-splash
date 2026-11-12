---
title: Geliştirici Kılavuzu
description: ARGVUS katkıda bulunanları için mimari ve geliştirme rehberi.
---

# Argvus Açılış Ekranı — Geliştirici Rehberi

`argvus-boot-splash` deposu için teknik dokümantasyon: Plymouth
temasının nasıl oluşturulduğu, Arch paketinin nasıl derlendiği ve sürümlerin
imzalandı ve yayınlandı.

nasıl yapıldığı. Burada bir derleme adımı yok — tema veridir (bir `.plymouth` tanımlayıcı,
bir `.script` ve resimler) artı bir Arch paket tarifi. "Oluşturmak"
tekrarlanabilir bir paket:

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
[KATKILI.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md).

## Kılavuzlar

| Kılavuzu | İçindekiler |
| --- | --- |
| [Tema mimarisi](/docs/argvus-boot-splash/developer-guide/theme/)| Tanımlayıcı, render modeli, varlık envanteri, betik yürütme, düzen sabitleri, tasarım simgeleri, UKI bitmap, temayı nasıl değiştirilir |
| [Ambalaj](/docs/argvus-boot-splash/developer-guide/packaging/)| İki PKGBUILD, paylaşıldı`functions.sh`, kancaları yükleyin, yerel derleme hattı, Make hedefleri, önkoşullar |
| [CI ve sürümler](/docs/argvus-boot-splash/developer-guide/ci-releases/) | `validate.sh`, `ci.yml`, `release.yml`adım adım, özet değerleri, imzalama, gizli bilgiler, yayınlama ve sürümlendirme |
| [Konvansiyonlar ve bilinen boşluklar](/docs/argvus-boot-splash/developer-guide/workflow/)| Ev kuralları, dokümantasyon haritası ve depo denetlerken bulunan uyumsuzluklar |

## Hızlı referans

| Yol | Nedir |
| --- | --- |
| `src/usr/share/plymouth/themes/argvus/` | `/usr` altında yüklü tema verisi |
| `packaging/arch/{ci,local}/PKGBUILD` | sürüm ve yerel paket tarifleri |
| `packaging/arch/common/functions.sh` | paylaşılan `prepare`/`check`/`package` |
| `tools/sh/pkgbuild_local.sh` | deterministik tarball + `makepkg` sürücüsü |
| `tools/sh/validate.sh` | gerekli doğrulama kapısı |
| `.github/workflows/` | `ci.yml` (doğrulama, oluşturma, yazım denetimi), `release.yml` (etiketler `v*`) |

## Başka yerde

- Depo kökü: [README.md](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)
- Kullanıcıya yönelik belgeler: [kullanıcı kılavuzu](/docs/argvus-boot-splash/)
- Geliştirme süreci: [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md)
- Katkıda Bulunma: [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)
- Güvenlik politikası: [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md)
- Lisans: [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE)
- Portekizce versiyon: [Guia do desenvolvedor](/pt/docs/argvus-boot-splash/developer-guide/)
