---
title: सम्मेलन और ज्ञात अंतर
description: हाउस रूल्स, दस्तावेज़ मानचित्र, और रिपॉजिटरी ऑडिट निष्कर्ष।
---

# सम्मेलन और ज्ञात अंतर

इस रिपॉजिटरी में बदलाव के लिए हाउस रूल्स, साथ ही पाई गई असंगतियां
इसका ऑडिटिंग करना — कॉपी करने के बजाय सुधारने लायक है।

तकनीकी संदर्भ के लिए देखें [थीम आर्किटेक्चर](/docs/argvus-boot-splash/developer-guide/theme/),
[पैकेजिंग](/docs/argvus-boot-splash/developer-guide/packaging/)और [सीआई और रिलीज़](/docs/argvus-boot-splash/developer-guide/ci-releases/).

## कन्वेंशन

- शेल: `set -euo pipefail`, इंडेंटेशन के लिए टैब्स, `printf`/`error` संदेशों को
stderr, `command -v` क्षमता जांच, shellcheck साफ़ (देखें
  `.editorconfig`).
- कभी भी `sha256sums=('SKIP')` न लिखें; git में `sha256sums=()` खाली रखें।
- build आउटपुट (`build/`), पैकेज फ़ाइलें, या उत्पन्न फ़ाइलें कमिट न करें
  `.PKGBUILD.local.*` प्रतियां।
- इतिहास में प्रयुक्त स्कोप के साथ Conventional Commits: `splash`, `layout`,
`pkgbuild`, `release`, `chore`, `ci`, `build`, `docs`.
- शाखा नामकरण: `feat/…`, `fix/…`, `docs/…`, `chore/…`, `refactor/…`.
- मर्ज करने से पहले एक समीक्षक की स्वीकृति, स्क्वैश-मर्ज।
- लाइसेंस: GPL-3.0-केवल। भेजा गया जैसा कि `/usr/share/licenses/argvus-boot-splash/LICENSE`।
- [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md) और
[DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md) में प्रक्रिया का पालन करें।

## ज्ञात अंतराल

रिपॉजिटरी का ऑडिट करते समय पाए गए प्रलेखित असंगतियाँ:

- `README.md` सीधे Plymouth प्रिव्यू के लिए `make test` का विज्ञापन करता है, लेकिन ऐसी कोई
लक्ष्य [Makefile](https://github.com/argvus/argvus-boot-splash/blob/main/Makefile) में मौजूद है। वास्तविक आदेश
`sudo plymouth --show-splash` / `sudo plymouthquit` हैं।
- `entry-line.png` और `logo-glow.png` पैलोड में शामिल हैं और
`arch_check_splash_payload()` द्वारा आवश्यक हैं, लेकिन `argvus.script` उन्हें कभी लोड नहीं करता। या तो
उन्हें स्क्रिप्ट में वायर करें या पेलोड और चेकलिस्ट से हटा दें।
- `src/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp` स्थापित है लेकिन
कभी किसी चीज़ के साथ पंजीकरण नहीं हुआ;
[यूज़र गाइड](/docs/argvus-boot-splash/uki-splash/) मैनुअल को दस्तावेज़ित करता है।
  `bootctl`/`ukify` चरण।
- कैनोनिकल दस्तावेज़ रिपॉजिटरी रूट पर रहते हैं (`README.md`,
`DEVELOPMENT.md`) और `docs/` में गाइड्स के साथ ओवरलैप करें। किसी एक को बदलते समय उन्हें सुसंगत रखें
। योगदान नीतियाँ (`CONTRIBUTING.md`, `SECURITY.md`)
संगठन `.github` रिपॉजिटरी में रहती हैं।

## दस्तावेज़ीकरण मानचित्र

| दस्तावेज़ | श्रोतागण | दायरा |
| --- | --- | --- |
| `README.md` | हर कोई | एक पैराग्राफ सिंहावलोकन और लेआउट |
| `DEVELOPMENT.md` | रखवाले | निर्माण, हस्ताक्षर, रिलीज़ प्रक्रिया |
| [`CONTRIBUTING.md`](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)(संगठन `.github`) | योगदानकर्ता | गिट फ्लो, पीआर नियम, सीक्रेट्स नीति |
| [`docs/user-guide.md`](/docs/argvus-boot-splash/)| एंड यूज़र्स | इंस्टॉलेशन, उपयोग, समस्या निवारण |
| [`docs/developer-guide.md`](/docs/argvus-boot-splash/developer-guide/)(/docs/argvus-boot-splash/developer-guide/) | developers | theme internals, packaging, CI |
