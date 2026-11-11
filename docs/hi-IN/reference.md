---
title: Reference
description: स्थापित की गई फ़ाइलें, पैकेज मेटाडेटा, और रंग मान।
---

# Reference

पैकेज क्या स्थापित करता है और यह कौन से मान उपयोग करता है, इसके लिए तकनीकी संदर्भ।

## आपको क्या मिलता है

| Component | Description |
| --- | --- |
| आर्गुस लोगो | केन्द्रित चिह्न, शब्दचिह्न के ऊपर खींचा गया |
| Wordmark | `ARGVUS` text below the logo |
| प्रगति बार | लंबाई में पतला बार जो Plymouth के बूट प्रगति को दर्शाता है |
| पासवर्ड संवाद | मास्क किए गए एंट्री फ़ील्ड के साथ LUKS प्रॉम्प्ट (`•` bullets) |
| फीका-आना | जब प्लायमाउथ शुरू होता है, तो स्प्लैश लगभग 1 सेकंड में फीका हो जाता है |
| यूकेआई बिटमैप | `argvus-uki-splash.bmp`यूकेआई / सिस्टमडी-बूट आधारित बूट्स के लिए |

पैकेज का नाम `argvus-boot-splash` है और यह पुराने
`argvus-plymouth` पैकेज को बदलता है यदि आपने इसे इंस्टॉल किया था।

## इंस्टॉल की गई फाइलें

के अंतर्गत `/usr/share/plymouth/themes/argvus/`:

| File | Size | Purpose |
| --- | --- | --- |
| `argvus.plymouth` | — | theme descriptor (name, description, module) |
| `argvus.script` | — | the theme script (Plymouth's own scripting language) |
| `argvus-logo.png` | 256x256 | logo, RGBA |
| `argvus-text.png` | 400x53 | wordmark, RGBA |
| `progress-bar.png` | 400x4 | filled part of the progress bar |
| `progress-bar-track.png` | 400x4 | unfilled track |
| `entry-box.png` | 400x48 | password entry field |
| `entry-line.png` | 300x2 | password field rule/underline |
| `bullet.png` | 12x12 | masked character |
| `logo-glow.png` | 260x300 | logo glow artwork |
| `argvus-uki-splash.bmp` | 400x400, 32-bit | UKI/systemd-boot splash bitmap |

इसके अलावा लाइसेंस `/usr/share/licenses/argvus-boot-splash/LICENSE` पर।

## पैकेज मेटाडेटा

| Field | Value |
| --- | --- |
| Name | `argvus-boot-splash` |
| Architecture | `any` |
| Depends | `plymouth` |
| Optional depends | `mkinitcpio`, `dracut` |
| Conflicts / replaces | `argvus-plymouth` |
| License | GPL-3.0-only |

## Colors

| Element | Color |
| --- | --- |
| Background | `#111316` |
| Accent (logo, wordmark, progress fill) | `#3590BD` |
| Progress track | `#262933` |
| Password prompt text | light gray-blue (`#B8C4CE`) |

थीम किसी भी रिज़ॉल्यूशन पर ठोस डार्क बैकग्राउंड का उपयोग करता है, इसलिए यह कभी भी
ऑटो-स्विच नहीं करता, लाइट और डार्क वेरिएंट्स के बीच।

## मदद प्राप्त करना

- परियोजना के इश्यू ट्रैकर में बग रिपोर्ट करें और फीचर्स का अनुरोध करें।
- सुरक्षा मुद्दे: पालन करें [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md) — सार्वजनिक
  issue for vulnerabilities.
- स्रोत न खोलें, बिल्ड और रिलीज़: रिपॉजिटरी रूट ([README](https://github.com/argvus/argvus-boot-splash/blob/main/README.md))।
- योगदान करें: [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md)।
- लाइसेंस: [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE)।

## अगले कदम

- [स्थापना](/docs/argvus-boot-splash/installation/)
- [उपयोग](/docs/argvus-boot-splash/usage/)
- [समस्या निवारण](/docs/argvus-boot-splash/troubleshooting/)
