---
title: स्थापना रद्द करना
description: पैकेज हटाएँ और अपनी पिछली बूट थीम को बहाल करें।
---

# स्थापना रद्द करना

```sh
sudo pacman -Rns argvus-boot-splash
```

फिर कोई अन्य थीम चुनें और पुनर्निर्माण करें, अन्यथा पुराना स्पलैश अंदर ही रहता है
initramfs:

```sh
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme
sudo mkinitcpio -P        # or: sudo dracut --regenerate-all
```

`pacman -Rns` कुछ और न होने पर `/etc/plymouth/plymouthd.conf` को भी हटा देता है
इसे बनाया.

पैकेज को हटाने वाला हुक केवल एक अनुस्मारक प्रिंट करता है — यह अनुमान नहीं लगाता कि कौन सा थीम है
आप इसके बजाय चाहते हैं, और यह आपके initramfs को छूता नहीं है।

## अगले कदम

- [समस्या निवारण](/docs/argvus-boot-splash/troubleshooting/) — पिछला स्प्लैश वापस करना।
- [इंस्टॉलेशन](/docs/argvus-boot-splash/installation/) — बाद में पुनः इंस्टॉल किया जा रहा है।
