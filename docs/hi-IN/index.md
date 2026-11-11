---
title: ARGVUS Boot Splash
description: ARGVUS डेस्कटॉप वातावरण के लिए प्लायमाउथ थीम और इंस्टॉलेशन गाइड
---

# ARGVUS बूट स्प्लैश

Argvus बूट स्प्लैश Argvus डेस्कटॉप इकोसिस्टम के लिए एक [Plymouth](https://www.freedesktop.org/wiki/Software/Plymouth/) थीम है। यह वही है जो आप मशीन चालू करने और आपके ग्राफिकल सत्र शुरू होने के बीच देखते हैं।

## Documentation

इस दस्तावेज़ को दो मुख्य खंडों में व्यवस्थित किया गया है:

### उपयोगकर्ता मार्गदर्शिका
अंत उपयोगकर्ताओं और सिस्टम प्रशासकों के लिए इंस्टॉलेशन और उपयोग गाइड।

| Guide | Contents |
| --- | --- |
| [स्थापना](/docs/argvus-boot-splash/installation/)| आवश्यकताएँ, तीन इंस्टॉल विकल्प, पैकेज हुक क्या करते हैं |
| [उपयोग](/docs/argvus-boot-splash/usage/)| इंस्टॉल की पुष्टि करें, रिबूट किए बिना पूर्वावलोकन करें, थीम बदलें या लौटाएँ, कमांड चीट शीट |
| [यूकेआई और systemd-boot स्प्लैश](/docs/argvus-boot-splash/uki-splash/)| का उपयोग करना `argvus-uki-splash.bmp`यूकेआई बूट फ्लो में |
| [अनइंस्टॉलेशन](/docs/argvus-boot-splash/uninstallation/)| पैकेज को हटाना और पिछले थीम को पुनर्स्थापित करना |
| [समस्या निवारण](/docs/argvus-boot-splash/troubleshooting/)| सामान्य लक्षण और उनके कारण |
| [Reference](/docs/argvus-boot-splash/reference/) for the installed and user paths.

### [डेवलपर गाइड](/docs/argvus-boot-splash/developer-guide/)
योगदानकर्ताओं और रखरखावकर्ताओं के लिए तकनीकी दस्तावेज़।

- [थीम आर्किटेक्चर](/docs/argvus-boot-splash/developer-guide/theme/) — प्लायमाउथ डेस्क्रिप्टर, रेंडरिंग मॉडल, और कस्टमाइजेशन
- [पैकेजिंग](/docs/argvus-boot-splash/developer-guide/packaging/) — पाइपलाइन बनाएं और पैकेज रेसिपी तैयार करें
- [सीआई और रिलीज़](/docs/argvus-boot-splash/developer-guide/ci-releases/) — मान्यता, परीक्षण, और रिलीज़ वर्कफ़्लो

## त्वरित प्रारंभ

आर्क-आधारित सिस्टम के लिए:

```sh
sudo pacman -S argvus-boot-splash   # or: sudo pacman -U ./argvus-boot-splash-<version>-1-any.pkg.tar.zst
```

इंस्टॉलर थीम को डिफ़ॉल्ट रूप में सेट करता है और आपका initramfs स्वचालित रूप से पुनः उत्पन्न करता है।

---

- **भंडार:** [github.com/argvus/argvus-boot-splash](https://github.com/argvus/argvus-boot-splash)
- **License:** GPL-3.0-only
- **बग रिपोर्ट:** [GitHub Issues](https://github.com/argvus/argvus-boot-splash/issues)
