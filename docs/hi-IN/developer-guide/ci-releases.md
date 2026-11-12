---
title: सीआई और रिलीज़
description: मान्यता, सतत एकीकरण, साइनिंग, और रिलीज़ कार्यप्रवाह।
---

# सीआई और रिलीज़।

मान्यता गेट, सतत एकीकरण जॉब्स, रिलीज़ पाइपलाइन और
संस्करणीकरण नियम.

पैकेज के लिए पैकेजिंग देखें; विषय के लिए देखें
theme architecture.

## मान्यता

 is the required gate:

- requires

,

, tools/sh/validate.sh;
-

 +

 on `tools/sh/validate.sh` and `bash`;
- स्रोत दोनों PKGBUILDs को खोजता है और निकाली गई मेटाडेटा की तुलना करता है — रिमोट और लोकल को  होना चाहिए
  मिलान;
-

 inside

 और `makepkg` git अंतर --चेक लोकल/ सीआई/ मेकपीकेजी -पी पीकेजीबीयूआईएलडी --प्रिंट्सआरसीइन्फो पैकेजिंग/arch/common/*.sh टूल्स/sh/*.sh बैश -n `shellcheck` `shellcheck` (पार्स करता है)
फ़ाइल उसी तरह बनाएं जैसे makepkg करता है);
-

 (whitespace/conflict markers).

## सतत एकीकरण

 `bash -n`  `tools/sh/*.sh`  `packaging/arch/common/*.sh`  `makepkg -p PKGBUILD --printsrcinfo`  `ci/`  `local/`  `git diff --check` `.github/workflows/ci.yml` (`main`, `archlinux:latest` कंटेनर पर पुश/पीआर):

1. `base-devel git namcap pacman-contrib shellcheck sudo` इंस्टॉल करें;
2. `make validate`;
3. एक **अप्रतिबंधित** `builder` उपयोगकर्ता के रूप में निर्माण करें
   (`sudo -u builder env HOME=/home/builder make build`) — makepkg चलाने से इंकार करता है
   रूट के रूप में, और वर्कस्पेस को पहले `chown`ed किया गया;
4. एक अलग `spellcheck` नौकरी `cspell-action@v6` को `cspell.json` के साथ चलाती है।

`namcap` `pkgbuild_local.sh` के भीतर इंस्टॉल होने पर चलता है, इसलिए स्थानीय बिल्ड CI की तरह ही
लिंट को दिखाते हैं। स्पेलचेक कॉन्फ़िगरेशन `cspell.json` है जिसमें वर्कस्पेस
डिक्शनरी `.cspell/custom-dictionary-workspace.txt` में है — नए तकनीकी शब्द
(शेल फ्लैग्स, टूल नाम) उस डिक्शनरी में होने चाहिए, अन्यथा CI फेल हो जाएगा।

## रिलीज़ पाइपलाइन

`.github/workflows/release.yml` — ट्रिगर्स: `v*` टैग का पुश, या
`workflow_dispatch` के साथ मौजूदा टैग (नियंत्रित पुनर्निर्माण)। समवर्ती समूह
`release-<ref>`, कोई रद्दीकरण नहीं।

Steps:

1. **Checkout** the tag (dispatch uses

).
2. **संस्करण चरण**: टैग को  के खिलाफ मान्य करता है

, fails if

 is empty in

, then rewrites

 from the tag.
3. **Validate**:  pkgver  packaging/arch/remote/PKGBUILD  url  ^v[0-9]+(\.[0-9]+)*([._+-][A-Za-z0-9]+)*$  `inputs.tag`  `^v[0-9]+(\.[0-9]+)*([._+-][A-Za-z0-9]+)*$`  `url`  `packaging/arch/remote/PKGBUILD`  `pkgver` `make validate`.
4. **Build** as unprivileged

:

 (resolves and validates the
   real

) then

.
   Locates the

 and fails if none exists.
5. **पैकेज पर namcap**।
6. **Sign**: imports

 into a throwaway

 (`builder` mktemp -d  GNUPGHOME  GPG_PRIVATE_KEY  .pkg.tar.zst  makepkg --nodeps --noconfirm --needed --cleanbuild --clean --check  sha256sums  `updpkgsums` ,
मोड 700), निर्यातित गुप्त कुंजी यह मिलती है कि यह  `sha256sums`  `makepkg --nodeps --noconfirm --needed --cleanbuild --clean --check`  `.pkg.tar.zst`  `GPG_PRIVATE_KEY`  `GNUPGHOME`  `mktemp -d` `GPG_KEY_ID` (संक्षिप्त आईडी या
फ़िंगरप्रिंट) से मेल खाती है, और `.sig` को विशिष्ट रूप से
`--pinentry-mode loopback --passphrase-fd 0` के साथ बनाता है।
7. **हस्ताक्षर सत्यापित करें** एक नए `GNUPGHOME` में — अगर
हस्ताक्षर सत्यापित नहीं होता है तो रिलीज़ विफल हो जाती है।
8. **आर्टिफैक्ट अपलोड करें** (`upload-artifact@v4`, `retention-days: 1`, पैकेज +
सिग्नेचर, `if-no-files-found: error`)।
9. **प्रकाशित करें**: `argvus/packages` को `PACKAGES_REPO_TOKEN` के साथ चेक आउट करें,
पैकेज और `.sig` को `public/arch/x86_64` में कॉपी करें,
`repo-add -R argvus.db.tar.gz <pkg>` चलाएँ, `argvus.db.tar.gz` पर साइन करें,
`argvus.files.tar.gz`, `argvus.db` और `argvus.files`, फिर
के रूप में कमिट करें `github-actions[bot]` और पुश करें। कोई-परिवर्तन डिफ़ 0 बिना कमिट किए बाहर निकलता है।
10. **GitHub रिलीज़**: `softprops/action-gh-release@v2` उत्पन्न नोट्स के साथ
और पैकेज + सिग्नेचर को एसेट के रूप में।

## चेकसुम, साइनिंग और सीक्रेट्स

- कोई `SKIP` नहीं है: `sha256sums` हमेशा एक वास्तविक डाइजेस्ट होता है, जो निर्माण के समय गणना किया जाता है
समय (स्थानीय) या `updpkgsums` (रिलीज़ CI) के माध्यम से।
- `sha256sums=()` को रिपॉजिटरी में **खाली** रखें।
- रिलीज़ GPG-साइन की गई हैं (पैकेज `.sig`, `argvus.db.tar.gz`,
`argvus.files.tar.gz`, `argvus.db`, `argvus.files`).
- `GPG_PASSPHRASE` खाली नहीं होना चाहिए; वर्कफ़्लो एक खाली पासफ़्रेज़ को अस्वीकार करता है।

कुंजी तैयार करें:

```sh
gpg --full-generate-key            # RSA 4096, no expiry recommended
gpg --list-secret-keys --with-colons | grep ^sec:   # note the KEY_ID
gpg --armor --export-secret-keys KEY_ID            # what the workflow imports
```

रिपॉजिटरी में **Settings → Secrets and variables → Actions** में:

| गुप्त | मूल्य |
| --- | --- |
| `GPG_PRIVATE_KEY` | `gpg --armor --export-secret-keys KEY_ID` आउटपुट |
| `GPG_KEY_ID` | अपेक्षित कुंजी आईडी या फिंगरप्रिंट |
| `GPG_PASSPHRASE` | हस्ताक्षर कुंजी का गैर-रिक्त पासफ़्रेज़ |
| `PACKAGES_REPO_TOKEN` | `argvus/packages` पर `contents:write` के साथ पैट |

## एक रिलीज़ प्रकाशित करना

टैग करने से पहले:

1. वास्तविक रिपॉजिटरी के साथ `url` को `packaging/arch/remote/PKGBUILD` में भरें:
   - GitHub:

 (the source
     uses

);
   - GitLab: adjust

 to

;
   - without

, रिलीज़ एक स्पष्ट संदेश के साथ **उद्देश्य पर विफल** है।
2. Sync versions/metadata in

 and
 packaging/arch/local/PKGBUILD  url  https://gitlab.com/argvus/argvus-boot-splash/-/archive/v${pkgver}/argvus-boot-splash-v${pkgver}.tar.gz  source=  ${url}/archive/refs/tags/v${pkgver}.tar.gz  `url="https://github.com/argvus/argvus-boot-splash"`  `${url}/archive/refs/tags/v${pkgver}.tar.gz`  `source=`  `https://gitlab.com/argvus/argvus-boot-splash/-/archive/v${pkgver}/argvus-boot-splash-v${pkgver}.tar.gz`  `url`  `packaging/arch/local/PKGBUILD` `packaging/arch/remote/PKGBUILD`.
3. टैग करें और पुश करें:

   ```sh
   git tag v0.1.0
   git push origin v0.1.0
   ```

कार्यप्रवाह को मौजूदा `v*` टैग के साथ मैन्युअली भी शुरू किया जा सकता है क्योंकि इसका
`tag` इनपुट, जो नियंत्रित पुनर्निर्माण के लिए उपयोगी है।

## संस्करणीकरण

- `pkgver` में SemVer, `pkgrel` में रिलीज़ संख्या।

## डेवलपर समस्या निवारण

**'स्रोत पुनःप्राप्त करना' पर रिलीज़ विफल।** खाली `url`, गायब `v*` टैग, या किसी
आर्काइव URL का फ़ॉर्मेट जो होस्ट से मेल नहीं खाता (GitHub बनाम GitLab टारबॉल
लेआउट)। वर्कफ़्लो टैग पैटर्न को मान्य करता है और एक खाली
`url`.

पर जल्दी विफल हो जाता है **`updpkgsums` स्रोत नहीं मिल सकता।** टैग का होना और उसे पुश किया जाना आवश्यक है, इससे पहले कि
रिलीज़ जॉब चलता है; केवल स्थानीय रूप से मौजूद टैग के साथ डिस्पैच करना यहाँ विफल हो जाता है।

**

 reports "remote and local PKGBUILD metadata is out of sync".**
Copy the metadata fields (not

) एक PKGBUILD से दूसरे तक।

**नई शब्दावली पर वर्तनी जांच विफल होती है।** इसे  में जोड़ें
 source=  `make validate`  `source=` `.cspell/custom-dictionary-workspace.txt` (`argvus` शब्दकोश, `addWords:
true`), not to `ignorePaths`।

**`sudo` को `make install` के अंदर अनुरोध किया गया, या `libfakeroot.so … LD_PRELOAD`
त्रुटियाँ।** एक `package()` जो `make install` को शेल करता है बजाय कि
`install -Dm*`। दोनों PKGBUILD `arch_package_splash_payload` को कॉल करते हैं, जिसे
नहीं करता; सुनिश्चित करें कि किसी ने `make` कॉल को फिर से न जोड़ा हो।

**`makepkg` चलाने से इंकार करता है।** इसे रूट के रूप में नहीं चलाना चाहिए। निर्माण को सामान्य
उपयोगकर्ता के रूप में चलाएँ, या `sudo -u <user> make build`।

**पैकेज इंस्टॉल हो गया है लेकिन स्प्लैश अपरिवर्तित है।** initramfs को पुनर्निर्मित नहीं किया गया था।
स्थानीय परीक्षण के लिए, रीबूट करने के बजाय `sudo plymouth --show-splash` को कॉल करें, या
`sudo mkinitcpio -P` / `sudo dracut --regenerate-all` के साथ पुनर्निर्माण करें।

पैकेज के लिए स्वयं देखें[पैकेजिंग](/docs/argvus-boot-splash/developer-guide/packaging/); थीम के लिए देखें

[थीम आर्किटेक्चर](/docs/argvus-boot-splash/developer-guide/theme/).
