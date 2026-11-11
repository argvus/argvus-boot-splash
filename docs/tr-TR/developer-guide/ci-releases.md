---
title: CI and Releases
description: Doğrulama, sürekli entegrasyon, imzalama ve sürüm iş akışı.
---

# CI ve sürümler

Doğrulama kapısı, sürekli entegrasyon işleri, sürüm hattı ve
the versioning rules.

Paket için bkz. [paketleme](/docs/argvus-boot-splash/developer-guide/packaging/); tema için bkz.
[tema mimarisi](/docs/argvus-boot-splash/developer-guide/theme/).

## Validation

`tools/sh/validate.sh` gerekli kapıdır:

- `bash`, `makepkg`, `shellcheck` gerektirir;
- `shellcheck` + `bash -n` `tools/sh/*.sh` ve `packaging/arch/common/*.sh` üzerinde;
- kaynakları hem PKGBUILD'leri alır hem de çıkarılan meta verileri karşılaştırır — uzak ve yerel
  match;
- `makepkg -p PKGBUILD --printsrcinfo` `ci/` ve `local/` içinde olmalıdır (
dosyasını makepkg'in yaptığı şekilde ayrıştırır);
- `git diff --check` (boşluk / çakışma işaretleri).

## Sürekli entegrasyon

`.github/workflows/ci.yml` (`main`, `archlinux:latest` konteynırına push/PR):

1. `base-devel git namcap pacman-contrib shellcheck sudo`'yi yükle;
2. `make validate`;
3. yetkisiz bir `builder` kullanıcısı olarak derleyin
   (`sudo -u builder env HOME=/home/builder make build`) — makepkg çalışmayı reddediyor
kök olarak ve çalışma alanı önce `chown`ed olarak ayarlandı;
4. ayrı bir `spellcheck` işi, cspell.json ile `cspell-action@v6` çalıştırır.

 `cspell.json` `namcap`, kurulduğunda `pkgbuild_local.sh` içinde çalışır, bu nedenle yerel derlemeler CI ile aynı linti
verir. Yazım denetimi yapılandırması `cspell.json` olup, çalışma alanı
sözlüğü `.cspell/custom-dictionary-workspace.txt` içindedir — yeni teknik terimler
(kabuk bayrakları, araç isimleri) o sözlükte yer almalıdır, aksi takdirde CI başarısız olur.

## Yayın hattı

`.github/workflows/release.yml` — tetikleyiciler: bir `v*` etiketi itildiğinde, veya
`workflow_dispatch` mevcut bir etiketle (kontrollü yeniden derleme). Eşzamanlılık grubu
`release-<ref>`, iptal yok.

Steps:

1. **Checkout** the tag (dispatch uses 

).
2. **Sürüm adımı**: etiketi  ile doğrular

, fails if 

 is empty in

, then rewrites 

 from the tag.
3. **Validate**:  pkgver  packaging/arch/remote/PKGBUILD  url  ^v[0-9]+(\.[0-9]+)*([._+-][A-Za-z0-9]+)*$  `inputs.tag`  `^v[0-9]+(\.[0-9]+)*([._+-][A-Za-z0-9]+)*$`  `url`  `packaging/arch/remote/PKGBUILD`  `pkgver` `make validate`.
4. **Build** as unprivileged 

: 

 (resolves and validates the
gerçek  updpkgsums  `builder`  `updpkgsums` `sha256sums`) sonra
`makepkg --nodeps --noconfirm --needed --cleanbuild --clean --check`.
`.pkg.tar.zst`'yi bulur ve hiçbiri yoksa başarısız olur.
5. pakette **namcap**.
6. **İmza**: `GPG_PRIVATE_KEY`'yi geçici bir `GNUPGHOME`'ye aktarır (`mktemp -d`,
mod 700), içe aktarılan gizli anahtarın `GPG_KEY_ID` (kısa ID veya
parmak izi) ile eşleştiğini doğrular ve
`.sig` ile `--pinentry-mode loopback --passphrase-fd 0` oluşturur.
7. **İmza doğrula** yeni bir `GNUPGHOME`'da — imza
ile doğrulanmazsa sürüm başarısız olur.
8. **Artefakt yükle** (`upload-artifact@v4`, `retention-days: 1`, paket +
imza, `if-no-files-found: error`).
9. **Yayınla**: `argvus/packages`'yi `PACKAGES_REPO_TOKEN` ile kontrol et,
paketi ve `.sig`'yi `public/arch/x86_64` içine kopyala,
`repo-add -R argvus.db.tar.gz <pkg>`'yi çalıştır, `argvus.db.tar.gz`'yi imzala,
`argvus.files.tar.gz`, `argvus.db` ve `argvus.files` ardından
olarak commit edin `github-actions[bot]` ve push yapın. Değişiklik yoksa diff 0 olarak commit etmeden çıkar.
10. **GitHub sürümü**: `softprops/action-gh-release@v2` oluşturulan notlarla
ve paket + imzayı varlıklar olarak.

## Checksum'lar, imzalama ve gizli bilgiler

- `SKIP` yok: `sha256sums` her zaman gerçek bir özet olup, yapı
zamanı (yerel) veya `updpkgsums` aracılığıyla (sürüm CI) hesaplanır.
- Depoda `sha256sums=()` **boş** bırakın.
- Sürümler GPG ile imzalanmıştır (paket `.sig`, `argvus.db.tar.gz`,
`argvus.files.tar.gz`, `argvus.db`, `argvus.files`).
- `GPG_PASSPHRASE` boş olmamalıdır; iş akışı boş bir parola reddeder.

Prepare the key:

```sh
gpg --full-generate-key            # RSA 4096, no expiry recommended
gpg --list-secret-keys --with-colons | grep ^sec:   # note the KEY_ID
gpg --armor --export-secret-keys KEY_ID            # what the workflow imports
```

Depodaki **Ayarlar → Sırlar ve değişkenler → Eylemler** kısmında:

| Secret | Value |
| --- | --- |
| `GPG_PRIVATE_KEY` | `gpg --armor --export-secret-keys KEY_ID` output |
| `GPG_KEY_ID` | expected key ID or fingerprint |
| `GPG_PASSPHRASE` | non-empty passphrase of the signing key |
| `PACKAGES_REPO_TOKEN` | PAT with `contents:write` on `argvus/packages` |

## Bir sürüm yayımlama

Before tagging:

1. Gerçek depoyu kullanarak `url` değerini `packaging/arch/remote/PKGBUILD` alanına doldurun:
   - GitHub: `url="https://github.com/argvus/argvus-boot-splash"` (kaynak
`${url}/archive/refs/tags/v${pkgver}.tar.gz` kullanır);
   - GitLab: `source=`'i
'ye ayarla `https://gitlab.com/argvus/argvus-boot-splash/-/archive/v${pkgver}/argvus-boot-splash-v${pkgver}.tar.gz`;
   - `url` olmadan, sürüm **kasıtlı olarak başarısız olur** ve açık bir mesaj verir.
2. `packaging/arch/local/PKGBUILD` ve
`packaging/arch/remote/PKGBUILD`.
3. Tag and push:

   ```sh
   git tag v0.1.0
   git push origin v0.1.0
   ```

İş akışı, mevcut bir `v*` etiketi ile
giriş olarak manuel olarak da başlatılabilir, bu kontrollü bir yeniden oluşturma için faydalıdır.

## Versioning

- SemVer  `tag` `pkgver` içinde, sürüm sayısı `pkgrel` içinde.

## Geliştirici sorun giderme

**Kaynaklar alınırken sürüm yayınlama başarısız oluyor.** Boş `url`, eksik `v*` etiketi veya barındırıcıyla eşleşmeyen bir
arşiv URL formatı (GitHub ve GitLab tarball
düzeni). İş akışı etiket desenini doğrular ve boş bir
`url`.

üzerinde erken başarısız olur **`updpkgsums` kaynağı bulamıyor.** Etiket mevcut olmalı ve
sürüm işi çalışır; sadece yerel olarak var olan bir etiketle gönderim burada başarısız olur.

**`make validate` "uzak ve yerel PKGBUILD meta verisi senkronize değil" rapor ediyor.**
Meta veri alanlarını (`source=` değil) bir PKGBUILD'den diğerine kopyalayın.

**Yeni bir terimde yazım denetimi başarısız oluyor.** Bunu
`.cspell/custom-dictionary-workspace.txt` (`argvus` sözlük, `addWords:
true`), not to `ignorePaths`.

**`sudo` `make install` içinde istendi, veya `libfakeroot.so … LD_PRELOAD`
hatalar.**
 make install  `package()`  `make install` `install -Dm*`. Her iki PKGBUILD de `arch_package_splash_payload`'yi çağırıyor,
çağırmıyor; kimsenin `make` çağrısını tekrar eklemediğinden emin olun.

**`makepkg` çalışmayı reddediyor.** Root olarak çalıştırılmamalıdır. Yapıyı normal bir
kullanıcısı veya `sudo -u <user> make build` olarak çalıştırın.

**Paket yükleniyor ama açılış ekranı değişmedi.** Initramfs yeniden oluşturulmadı.
Yerel test için, yeniden başlatmak yerine `sudo plymouth --show-splash` çağırın veya
 `sudo mkinitcpio -P` `sudo dracut --regenerate-all` / sudo dracut --regenerate-all ile yeniden oluşturun.
