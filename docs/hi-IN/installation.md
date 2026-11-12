---
title: स्थापना
description: आवश्यकताएँ, इंस्टॉल विकल्प, और पैकेज हुक क्या करते हैं।
---

# स्थापना

जो कुछ भी आपको आर्गवस बूट स्प्लैश को आर्च-आधारित सिस्टम पर पाने के लिए चाहिए।

थीम कैसी दिखती है और इसमें क्या है, देखने के लिए देखें
[संदर्भ](/docs/argvus-boot-splash/reference/)। इसे स्रोत से पुनर्निर्मित करने के लिए,
[डेवलपर गाइड](/docs/argvus-boot-splash/developer-guide/) देखें।

## आवश्यकताएँ

- एक आर्च-आधारित सिस्टम जो `plymouth` का उपयोग करता है (पैकेज इस पर निर्भर करता है)।
- एक initramfs जनरेटर: **mkinitcpio** (आर्च डिफ़ॉल्ट) या **dracut**।
इंस्टॉलर जो भी मौजूद है उसे पहचानता है और आपके लिए initramfs को पुनर्निर्मित करता है।
- Plymouth को आपके initramfs कॉन्फ़िगरेशन में सक्षम किया जाना चाहिए। mkinitcpio के साथ,
सुनिश्चित करें कि `plymouth`, `HOOKS` की `/etc/mkinitcpio.conf` सूची में है:

  ```ini
  HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont plymouth)
  ```

अगर आपने अभी इसे बदल दिया है तो पुनःप्रारंभ करें।

- सामान्य ग्राफ़िकल सत्र के लिए कुछ भी आवश्यक नहीं है; थीम केवल
  बूट पथ.

## विकल्प 1: आधिकारिक पैकेज रिपॉजिटरी (सिफारिश की गई) में चलती है

हस्ताक्षरित पैकेज Argvus पैकेज रिपॉजिटरी में प्रकाशित किए गए हैं
(`argvus/packages`, पथ `public/arch/$arch`)। इसे `/etc/pacman.conf` में जोड़ें:

```ini
[argvus]
SigLevel = Required DatabaseOptional
Server = <PACKAGES_REPO_BASE_URL>/argvus/packages/raw/branch/main/public/arch/$arch
```

`<PACKAGES_REPO_BASE_URL>` को उस होस्ट से बदलें जिसे प्रोजेक्ट प्रकाशित करता है
(GitHub, GitLab या Gitea) पर रिपॉज़िटरी। सबसे पहले रिपॉज़िटरी साइनिंग कुंजी आयात करें,
अन्यथा `pacman` डाऊनलोड करने से इंकार करता है:

```sh
# 1. import the project's public signing key into your pacman keyring
pacman-key --add /path/to/argvus-signing-key.asc
pacman-key --lsign <key-id>

# 2. refresh and install
sudo pacman -Sy
sudo pacman -S argvus-boot-splash
```

## विकल्प 2: पैकेज फ़ाइल रिलीज़ करें

प्रत्येक टैग किया गया रिलीज़ एक `.pkg.tar.zst` (साथ ही इसका `.sig`) को एक रिलीज़ के रूप में प्रकाशित करता है
संपत्ति। इसे सीधे इंस्टॉल करें:

```sh
sudo pacman -U ./argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```

यदि आप सप्लाई-चेन स्वच्छता की परवाह करते हैं, तो इंस्टॉल करने से पहले अलग किए गए हस्ताक्षर को
प्रोजेक्ट की सार्वजनिक कुंजी के खिलाफ सत्यापित करें:

```sh
gpg --verify argvus-boot-splash-0.2.0-1-any.pkg.tar.zst.sig \
        argvus-boot-splash-0.2.0-1-any.pkg.tar.zst
```

## विकल्प 3: मैनुअल इंस्टॉलेशन

गैर-आर्क सिस्टम पर उपयोगी, या यदि आप केवल थीम आज़माना चाहते हैं बिना
पैकिंग। थीम डायरेक्टरी को प्लिमाउथ के थीम पथ में कॉपी करें:

```sh
sudo cp -r src/usr/share/plymouth/themes/argvus \
           /usr/share/plymouth/themes/argvus

sudo plymouth-set-default-theme argvus
sudo update-initramfs -u        # Debian/Ubuntu
# or: sudo mkinitcpio -P        # Arch
# or: sudo dracut --regenerate-all
```

प्लिमाउथ को `/etc/default/grub` में `GRUB_CMDLINE_LINUX` के साथ भी सक्षम किया जा सकता है
जिसमें `splash` शामिल है, और `quiet` क्लासिक मिनिमल-बूट अनुभव देता है।

## इंस्टॉलर क्या करता है

इंस्टॉल या अपग्रेड के बाद, पैकेज हुक्स स्वचालित रूप से चलते हैं:

1. `plymouth-set-default-theme argvus` — `argvus` को
`/etc/plymouth/plymouthd.conf` में लिखता है।
2. अगर mkinitcpio मौजूद है, तो `mkinitcpio -P`, अन्यथा `dracut --regenerate-all`।

अगर कोई भी जेनरेटर नहीं मिलता, तो इंस्टॉलर एक चेतावनी प्रदर्शित करता है और आपको
स्वयं initramfs को फिर से बनाना होगा। एक थीम परिवर्तन केवल बूट के समय दिखाई देता है, उसके बाद
initramfs को फिर से बनाया गया है — उस चरण के बिना पुनरारंभ करना सबसे अधिक एकल है
"स्प्लैश बदल नहीं गया" का सामान्य कारण

हटाने पर पैकेज केवल एक याद दिलाने वाला संदेश प्रिंट करता है: एक अलग थीम चुनना और
initramfs को पुनर्निर्मित करना आपके ऊपर छोड़ा गया है। देखिए
[अनइंस्टॉलेशन](/docs/argvus-boot-splash/uninstallation/)।

## अगले कदम

- [उपयोग](/docs/argvus-boot-splash/usage/) — इंस्टॉलेशन की जांच करें, बिना रीबूट किए पूर्वावलोकन करें,
  थीम.
- [UKI और systemd-boot स्प्लैश](/docs/argvus-boot-splash/uki-splash/) — UKI में बिटमैप का उपयोग करें।
- [समस्या निवारण](/docs/argvus-boot-splash/troubleshooting/) — यदि स्प्लैश बदल नहीं गया।
