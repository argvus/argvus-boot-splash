---
title: UKI और systemd-boot स्प्लैश
description: UKI बूट फ्लो में ARGVUS स्प्लैश बिटमैप का उपयोग करें।
---

# UKI और systemd-boot स्प्लैश

पैकेज में `argvus-uki-splash.bmp` (400x400, 32-बिट अनकंप्रेस्ड
BMP) भी शिप होता है। यह UKI / systemd-boot बूट फ्लोज़ के लिए बनाया गया है, जहां स्प्लैश इमेज
को विशिष्ट कर्नेल इमेज में एम्बेड किया जाता है बजाय इसके कि इसे
initramfs.

से पढ़ा जाए। बिटमैप का उपयोग Plymouth थीम द्वारा *नहीं* किया जाता और
आप स्वतः: इसे एम्बेड करते हैं यह इस पर निर्भर करता है कि आप अपना UKI कैसे बनाते हैं। सामान्य
consumers are:

```sh
# systemd: set the splash for the next boot (systemd >= 254)
bootctl --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp

# ukify, while building the UKI
ukify build --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp \
           --linux=... --initrd=... --microcode=...
```

जब भी इमेज बदलती है, UKI बिल्ड (या `bootctl set-splash`) को फिर से चलाएँ, और
याद रखें कि यदि आप कहीं और बिल्ड करते हैं तो फ़ाइल को ESP में कॉपी करें। systemd-boot
बिटमैप को कंसोल के अनुसार स्केल करता है, इसलिए एक वर्गाकार छवि केंद्रित दिखाई देती है।

यदि आप केवल mkinitcpio या dracut का उपयोग करते हैं, तो आप इस फ़ाइल को पूरी तरह से अनदेखा कर सकते हैं —
नियमित [इंस्टॉलेशन](/docs/argvus-boot-splash/installation/) उस रास्ते को कवर करता है।

## अगले कदम

- [उपयोग](/docs/argvus-boot-splash/usage/)
- [समस्या निवारण](/docs/argvus-boot-splash/troubleshooting/)
