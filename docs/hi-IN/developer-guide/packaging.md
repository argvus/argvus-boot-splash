---
title: पैकेजिंग
description: आर्क पैकेज मेटाडेटा, बिल्ड पाइपलाइन, और मेक टारगेट।
---

# पैकेजिंग

आर्च पैकेज को कैसे परिभाषित और उत्पादित किया जाता है: दो PKGBUILD, साझा
फ़ंक्शन, इंस्टॉल हुक, स्थानीय बिल्ड पाइपलाइन और मेक टारगेट्स।

थीम के लिए स्वयं [थीम आर्किटेक्चर](/docs/argvus-boot-splash/developer-guide/theme/) देखें; वैधता, CI और के लिए
रिलीज़ देखें [CI और रिलीज़](/docs/argvus-boot-splash/developer-guide/ci-releases/)।

## दो PKGBUILDs, एक पेलोड

`packaging/arch/remote/PKGBUILD` और `packaging/arch/local/PKGBUILD` समान हैं
`source=` को छोड़कर:

| | `local` | `ci` |
| --- | --- | --- |
| स्रोत | `${pkgname}-${pkgver}.tar.gz` (`make build` द्वारा निर्मित) | `${url}/archive/refs/tags/v${pkgver}.tar.gz` |
| द्वारा उपयोग किया गया | डेवलपर्स, `make build` | GitHub क्रियाएँ रिलीज़ |

दोनों `packaging/arch/common/functions.sh` से वही फ़ंक्शन कॉल करते हैं, और
`tools/sh/validate.sh` उनके मेटाडेटा (`pkgname`, `pkgver`, `pkgrel`,
`pkgdesc`, `arch`, `license`, `depends`, `makedepends`, `options`) समान हैं,
तो दोनों चुपचाप नहीं बह सकते।

साझा मेटाडेटा:

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

## साझा फ़ंक्शन प्रदान करता है

`packaging/arch/common/functions.sh` द्वारा उपयोग किए जाने वाले तीन फ़ंक्शन
पीकेजीबीबिल्ड्स:

- `arch_normalize_source_tree` (`prepare()`) — GitHub टैग संग्रह निष्कर्षण करता है
`<repo>-v<version>`, जबकि स्थानीय टारबॉल निष्कर्षण करता है
`<pkgname>-<pkgver>`। यह एकल शीर्ष-स्तरीय निर्देशिका का नाम बदलकर
कर देता है `${srcdir}/${pkgname}-${pkgver}`, यदि स्रोत निर्देशिका
गायब हो, अस्पष्ट हो, या गंतव्य पहले से मौजूद हो तो त्रुटि देता है।
- `arch_check_splash_payload` (`check()`) — यह सुनिश्चित करता है कि प्रत्येक थीम संपत्ति
निकाले गए स्रोत। यह पैकेज का एकमात्र "टेस्ट सूट" है; सूची
आवश्यक फाइलें [एसेट इन्वेंटरी](/docs/argvus-boot-splash/developer-guide/theme/#asset-inventory) में हैं।
- `arch_package_splash_payload` (`package()`) — `src/usr` के साथ चलता है
`find -print0` और प्रत्येक फाइल को `install -Dm644` से `$pkgdir` में इंस्टॉल करता है
(NUL-सुरक्षित, नामों में स्पेस के साथ काम करता है), फिर `LICENSE` को
`/usr/share/licenses/argvus-boot-splash/LICENSE`.

में इंस्टॉल करता है। ध्यान दें कि `make install` कॉल `package()` के अंदर नहीं है: सब कुछ
`install -Dm*` है, इसलिए पैकेज स्वयं-निहित और रूटलेस-बिल्ड के अनुकूल है।
यह जानबूझकर है — एक पुराना `package()` जिसने `make install` उत्पादन किया
`sudo`/`libfakeroot.so` विफलताएँ।

## इंस्टॉल हुक्स

`packaging/arch/{ci,local}/argvus-boot-splash.install` (समान):

- `post_install()` / `post_upgrade()` → `plymouth-set-default-theme argvus`,
फिर यदि उपलब्ध हो तो `mkinitcpio -P`, अन्यथा `dracut --regenerate-all`, अन्यथा एक
चेतावनी जो उपयोगकर्ता को मैन्युअल रूप से फिर से बनाने के लिए कहती है।
- `post_remove()` → केवल सूचनात्मक संदेश; थीम को स्वचालित रूप से वापस नहीं बदला जाता (अनुमान लगाने से सुरक्षित)।
स्थानीय बिल्ड पाइपलाइन

##

`tools/sh/pkgbuild_local.sh` (`make build` द्वारा प्रवर्तित):

1. सत्यापित करता है `makepkg`, `sha256sum`, `tar`, `awk`, `find` और कि PKGBUILD
मौजूद है; PKGBUILD को स्रोत बनाता है ताकि `pkgname`/`pkgver` पढ़ सके और दोनों
अनुमति सूची रेगुलर एक्सप्रेशन के खिलाफ (नाम के लिए `^[a-z0-9@._+-]+$`, संस्करण के लिए डॉटेड संस्करण
पैटर्न)।
2. बिल्ड्स `build/artifacts/${pkgname}-${pkgver}.tar.gz` के साथ
`tar --sort=name --mtime='UTC 1970-01-01' --owner=0 --group=0 --numeric-owner`
और `--transform "s#^\./#${pkgname}-${pkgver}/#"` — एक निर्धारक,
पुनरुत्पादनीय अभिलेखागार। इसमें `.git`, `build/`, `dist/`, `target/`,
, `tools/`, `release`/`packages-repo` स्क्रैच डायरेक्टरी, और किसी भी `src/`, `pkg/` या
पैकेजिंग डायरेक्ट्री के अंदर पैकेज बची हुई फाइलें शामिल नहीं हैं।
3. आर्काइव का `sha256` गणना करता है और इसे `sed` के साथ स्थानीय PKGBUILD की **अस्थायी
प्रति** में इंजेक्ट करता है (`.PKGBUILD.local.XXXXXX`, जिसे एक `EXIT`
ट्रैप द्वारा हटा दिया जाता है)। रिपॉजिटरी हमेशा `sha256sums=()` को खाली रखता है; `SKIP` कभी
   प्रयोग किया गया।
4. नहीं होता है। किसी भी पूर्व-मौजूद `${pkgname}-${pkgver}-*.pkg.tar.zst` को
`build/dist/` ताकि एक पुराना पैकेज इस बिल्ड के लिए गलत न समझा जाए।
5. `makepkg -p <generated PKGBUILD> --nodeps --noconfirm --needed
--cleanbuild --force --check` with `BUILDDIR`/`SRCDEST` in `build/artifacts/` चलाता है
और `PKGDEST` में `build/dist/`। अतिरिक्त तर्क `makepkg` को आगे बढ़ाए जाते हैं;
`MAKEPKG_FLAGS` डिफ़ॉल्ट फ़्लैग सेट को अधिलेखित करता है (जानबूझकर शब्द विभाजन)।
6. जब तक केवल एक `.pkg.tar.zst` मेल नहीं खाता, विफल रहता है, फिर उस पर `namcap` चलाता है यदि
   स्थापित.

आउटपुट:

```text
build/dist/argvus-boot-splash-0.2.0-1-any.pkg.tar.zst   installable package
build/artifacts/argvus-boot-splash-0.2.0.tar.gz          source snapshot
build/artifacts/argvus-boot-splash/{src,pkg}/            makepkg work dirs
```

## लक्ष्य बनाता है

| लक्ष्य | प्रभाव |
| --- | --- |
| `make build` (उर्फ `make package`) | `tools/sh/pkgbuild_local.sh` चलाएँ → `build/` |
| `make install` (alias `make install-package`) | `sudo pacman -U`एकल पैकेज में`build/dist/`; त्रुटियाँ यदि गिनती ठीक 1 नहीं है |
| `make validate` | `tools/sh/validate.sh`: शेलचेक + `bash -n` + PKGBUILD मेटाडेटा सिंक + `makepkg --printsrcinfo` प्रति PKGBUILD + `git diff --check` |
| `make lint` (उर्फ `make lint-shell`) | `tools`, `packaging/arch/common`, `src` (`SC1090`, `SC2034`, `SC2154` अक्षम), `bash -n`, `git diff --check` पर शेलचेक |
| `make spellcheck` | `cspell --config cspell.json .` यदि `cspell` स्थापित है, अन्यथा छोड़ दिया गया है |
| `make clean` | `rm -rf build/` |
| `make help` | लक्ष्य सूची (डिफ़ॉल्ट लक्ष्य) |

CI `make validate` और `make build` चलाता है; CI में `make install`
कुछ भी नहीं चलता (देखें [ज्ञात अंतर](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)).

## पूर्वावश्यकताएँ

`make`, `git`, `gnupg` और `base-devel` समूह के साथ एक Arch-आधारित प्रणाली:

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
```

- `pacman-contrib` `updpkgsums` प्रदान करता है (PKGBUILD चेकसम को पुनर्जन्म करता है)।
- `shellcheck` रिपॉजिटरी शेल स्क्रिप्ट और साझा Arch
पैकेजिंग कार्य।
- वैकल्पिक: `namcap` (पैकेज
को मान्य करता है (linting) और cspell (स्थानीय स्पेलचेक)। CI इन सभी को इंस्टॉल करता है।
