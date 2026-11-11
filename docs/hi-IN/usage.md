---
title: Usage
description: इंस्टॉलेशन की पुष्टि करें, बिना रिबूट किए पूर्वावलोकन करें, और थीम बदलें।
---

# Usage

थीम की पुष्टि कैसे करें, बिना रिबूट किए इसे पूर्वावलोकन कैसे करें, और इसे बदलें।
इंस्टॉलेशन के लिए देखें [इंस्टॉलेशन](/docs/argvus-boot-splash/installation/)।

## इंस्टॉलेशन की पुष्टि करना

```sh
# theme is present?
ls /usr/share/plymouth/themes/argvus

# which theme is the default?
plymouth-set-default-theme          # prints, e.g.: argvus

# does Plymouth parse the theme without errors?
sudo plymouth --show-splash
```

## रीबूट किए बिना पूर्वावलोकन करें

```sh
sudo plymouth --show-splash   # shows the splash, simulating boot
sudo plymouthquit             # returns to your session
```

जब सामान्य उपयोगकर्ता के रूप में चलाया जाए तो पूर्वावलोकन पोलकिट प्रमाणीकरण मांग सकता है।
प्रगति पट्टी अनुकरण किए गए प्रगति के साथ बढ़ती है; आप अवस्थाओं को भी मजबूर कर सकते हैं:

```sh
sudo plymouth --show-details   # verbose boot messages instead of the splash
sudo plymouth --show-splash    # back to the splash
```

जब स्प्लैश दिखाई दे रहा हो, तो अगली स्क्रीन पर जाने के लिए <kbd>Esc</kbd> दबाएं
(splash → details → splash).

## स्प्लैश जो दिखाता है

| Stage | Appearance |
| --- | --- |
| स्टार्टअप | लगभग 1 सेकंड में सभी कुछ दिखाई देता है: लोगो, शब्दांक, प्रगति ट्रैक |
| बूटिंग | बार बाईं ओर से भरती है जैसे कि प्लायमाउथ प्रगति की रिपोर्ट करता है |
| एनक्रिप्टेड वॉल्यूम | स्प्लैश 15% तक फीका हो जाता है, प्रॉम्प्ट टेक्स्ट और मास्क किए गए बुलेट बार के नीचे दिखाई देते हैं |
| पासफ्रेज़ स्वीकार किया गया | डायलॉग गायब हो जाता है, स्प्लैश पूरी अपारदर्शिता पर वापस आ जाता है |

## थीम बदलना या पूर्ववत करना

```sh
# switch theme (any theme name under /usr/share/plymouth/themes)
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme

# then regenerate the initramfs
sudo mkinitcpio -P              # or: sudo dracut --regenerate-all
```

Useful configuration files:

| File | Purpose |
| --- | --- |
| `/etc/plymouth/plymouthd.conf` | `PLYMOUTH_THEME_NAME=argvus` written by the package |
| `/etc/mkinitcpio.conf` | `HOOKS=(... plymouth ...)` must include `plymouth` |
| `/etc/plymouth/plymouthd.conf` (again) | `PLYMOUTH_TOGGLE_KEY` etc. are global, not per-theme |

## कमांड्स चीट शीट

| Command | Effect |
| --- | --- |
| `sudo plymouth-set-default-theme argvus` | make `argvus` the default theme |
| `sudo plymouth-update-theme` | apply the change to the running Plymouth |
| `sudo plymouth --show-splash` | show the splash in the current session |
| `sudo plymouth --show-details` | show verbose boot messages instead |
| `sudo plymouthquit` | leave Plymouth and restore your session |
| `sudo mkinitcpio -P` | rebuild the Arch initramfs |
| `sudo dracut --regenerate-all` | rebuild the initramfs with dracut |

## अगले कदम

- [UKI और systemd-boot स्प्लैश](/docs/argvus-boot-splash/uki-splash/)
- [अनइंस्टॉलेशन](/docs/argvus-boot-splash/uninstallation/)
- [समस्या निवारण](/docs/argvus-boot-splash/troubleshooting/)
