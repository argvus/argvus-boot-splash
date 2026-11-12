---
title: डेवलपर गाइड
description: ARGVUS योगदानकर्ताओं के लिए आर्किटेक्चर और विकास मार्गदर्शन।
---

# आर्ग्वस बूट स्प्लैश — डेवलपर गाइड

`argvus-boot-splash` रिपॉजिटरी के लिए तकनीकी दस्तावेज़: प्लीमाउथ
थीम कैसे बनाई जाती है, Arch पैकेज कैसे बनाया जाता है, और रिलीज़
हस्ताक्षरित एवं प्रकाशित।

कैसे होते हैं। यहाँ कोई संकलन चरण नहीं है — थीम डेटा है (एक `.plymouth` वर्णनकर्ता,
एक `.script`, और चित्र) साथ ही एक Arch पैकेज नुस्खा। "बनाना" का मतलब
एक प्रतिलिपि प्रस्तुत करने योग्य पैकेज:

```sh
sudo pacman -S --needed base-devel git gnupg make pacman-contrib shellcheck
make validate
make build      # -> build/dist/argvus-boot-splash-<version>-1-any.pkg.tar.zst
make install    # sudo pacman -U that file
```

परिवर्तन करने से पहले: `make validate && make build`, और नए तकनीकी
शब्द `.cspell/custom-dictionary-workspace.txt` में जोड़ें या स्पेलचेक कार्य विफल हो जाएगा।

यदि आप केवल थीम *प्रयोग* करना चाहते हैं, तो [उपयोगकर्ता गाइड](/docs/argvus-boot-splash/) पढ़ें। इसके लिए
इस फ़ाइल का प्रक्रिया-उन्मुख समकक्ष (गिट फ्लो, रहस्य, रिलीज़
प्रक्रिया) देखें [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md) और
[CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)।

## मार्गदर्शक

| मार्गदर्शक | सामग्री |
| --- | --- |
| [थीम आर्किटेक्चर](/docs/argvus-boot-splash/developer-guide/theme/)| विवरणकर्ता, रेंडरिंग मॉडल, संपत्ति सूची, स्क्रिप्ट वॉकथ्रू, लेआउट स्थिरांक, डिज़ाइन टोकन, UKI बिटमैप, थीम को कैसे संशोधित करें |
| [पैकेजिंग](/docs/argvus-boot-splash/developer-guide/packaging/)| दोनों PKGBUILDs, साझा किए गए`functions.sh`, हुक्स इंस्टॉल करें, स्थानीय बिल्ड पाइपलाइन, Make टारगेट्स, आवश्यकताएँ |
| [सीआई और रिलीज़](/docs/argvus-boot-splash/developer-guide/ci-releases/) | `validate.sh`, `ci.yml`, `release.yml`कदम दर कदम, चेकसाम, साइनिंग, सीक्रेट्स, प्रकाशन और संस्करणन |
| [परंपराएँ और ज्ञात अंतर](/docs/argvus-boot-splash/developer-guide/workflow/)| हाउस नियम, दस्तावेज़ीकरण मानचित्र, और रिपॉजिटरी का ऑडिट करते समय पाए गए असंगतियाँ |

## त्वरित संदर्भ

| पथ | यह क्या है |
| --- | --- |
| `src/usr/share/plymouth/themes/argvus/` | `/usr` के अंतर्गत थीम पेलोड स्थापित किया गया |
| `packaging/arch/{ci,local}/PKGBUILD` | रिलीज और स्थानीय पैकेज रेसिपी |
| `packaging/arch/common/functions.sh` | साझा `prepare`/`check`/`package` |
| `tools/sh/pkgbuild_local.sh` | नियतात्मक टारबॉल + `makepkg` ड्राइवर |
| `tools/sh/validate.sh` | आवश्यक सत्यापन गेट |
| `.github/workflows/` | `ci.yml` (मान्य करें, निर्माण करें, वर्तनी जांचें), `release.yml` (टैग `v*`) |

## अन्यत्र

- रिपॉजिटरी रूट: [README.md](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)
- उपयोगकर्ता-मुखी दस्तावेज़: [user guide](/docs/argvus-boot-splash/)
- विकास प्रक्रिया: [DEVELOPMENT.md](https://github.com/argvus/argvus-boot-splash/blob/main/DEVELOPMENT.md)
- योगदान देना: [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)
- सुरक्षा नीति: [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md)
- लाइसेंस: [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE)
- पुर्तगाली संस्करण: [Guia do desenvolvedor](/pt/docs/argvus-boot-splash/developer-guide/)
