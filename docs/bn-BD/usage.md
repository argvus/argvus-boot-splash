---
title: Usage
description: ইনস্টলেশন যাচাই করুন, রিবুট ছাড়াই প্রিভিউ করুন, এবং থিম পরিবর্তন করুন।
---

# Usage

থিম যাচাই করা, রিবুট ছাড়াই প্রিভিউ করা, এবং থিম থেকে সরে যাওয়ার পদ্ধতি।
ইনস্টলেশনের জন্য, দেখুন [ইনস্টলেশন](/docs/argvus-boot-splash/installation/)।

## ইনস্টলেশন যাচাই করা

```sh
# theme is present?
ls /usr/share/plymouth/themes/argvus

# which theme is the default?
plymouth-set-default-theme          # prints, e.g.: argvus

# does Plymouth parse the theme without errors?
sudo plymouth --show-splash
```

## রিবুট ছাড়াই প্রিভিউ করা

```sh
sudo plymouth --show-splash   # shows the splash, simulating boot
sudo plymouthquit             # returns to your session
```

নিয়মিত ব্যবহারকারী হিসেবে চালানোর সময় প্রিভিউটি পলকিট প্রমাণীকরণ চাইতে পারে। সিমুলেটেড প্রগতি অনুযায়ী
প্রগ্রেস বার এগোয়; আপনি চাইলে স্টেটও জোর করে দিতে পারেন:

```sh
sudo plymouth --show-details   # verbose boot messages instead of the splash
sudo plymouth --show-splash    # back to the splash
```

স্প্ল্যাশ চালু থাকা অবস্থায়, পরবর্তী স্ক্রিনে যাওয়ার জন্য <kbd>Esc</kbd> চাপুন
(splash → details → splash).

## স্প্ল্যাশ যা দেখায়

| Stage | Appearance |
| --- | --- |
| স্টার্টআপ | প্রায় ১ সেকেন্ডের মধ্যে সবকিছু ধীরে ধীরে প্রকাশ পায়: লোগো, ওয়ার্ডমার্ক, প্রোগ্রেস ট্র্যাক |
| বুটিং | প্লাইমথ অগ্রগতি রিপোর্ট করার সময় বারটি বাম থেকে পূর্ণ হয় |
| গোপনীকৃত ভলিউম | স্প্ল্যাশ ১৫% পর্যন্ত ফিকে হয়ে যায়, বারটির নিচে প্রম্পট টেক্সট এবং মাস্ক করা বুলেট দেখা যায় |
| পাসফ্রেজ গ্রহণ হয়েছে | ডায়ালগটি অদৃশ্য হয়ে যায়, স্প্ল্যাশ পুরো অস্পষ্টতা ফিরে পায় |

## থিম পরিবর্তন বা পূর্বাবস্থায় ফেরানো

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

## কমান্ড চিট শিট

| Command | Effect |
| --- | --- |
| `sudo plymouth-set-default-theme argvus` | make `argvus` the default theme |
| `sudo plymouth-update-theme` | apply the change to the running Plymouth |
| `sudo plymouth --show-splash` | show the splash in the current session |
| `sudo plymouth --show-details` | show verbose boot messages instead |
| `sudo plymouthquit` | leave Plymouth and restore your session |
| `sudo mkinitcpio -P` | rebuild the Arch initramfs |
| `sudo dracut --regenerate-all` | rebuild the initramfs with dracut |

## পরবর্তী ধাপ

- [UKI এবং systemd-boot স্প্ল্যাশ](/docs/argvus-boot-splash/uki-splash/)
- [অ্যানইনস্টলেশন](/docs/argvus-boot-splash/uninstallation/)
- [সমস্যা সমাধান](/docs/argvus-boot-splash/troubleshooting/)
