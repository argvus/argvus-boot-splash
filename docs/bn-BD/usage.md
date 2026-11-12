---
title: ব্যবহার
description: ইনস্টলেশন যাচাই করুন, রিবুট ছাড়াই প্রিভিউ করুন, এবং থিম পরিবর্তন করুন।
---

# ব্যবহার

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
(স্প্ল্যাশ → বিস্তারিত → স্প্ল্যাশ)।

## স্প্ল্যাশ যা দেখায়

| মঞ্চ | চেহারা |
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

দরকারী কনফিগারেশন ফাইল:

| ফাইল | উদ্দেশ্য |
| --- | --- |
| `/etc/plymouth/plymouthd.conf` | `PLYMOUTH_THEME_NAME=argvus` প্যাকেজ দ্বারা লিখিত |
| `/etc/mkinitcpio.conf` | `HOOKS=(... plymouth ...)` অবশ্যই `plymouth` | অন্তর্ভুক্ত করতে হবে
| `/etc/plymouth/plymouthd.conf` (আবার) | `PLYMOUTH_TOGGLE_KEY` ইত্যাদি বিশ্বব্যাপী, প্রতি-থিম নয় |

## কমান্ড চিট শিট

| আদেশ | প্রভাব |
| --- | --- |
| `sudo plymouth-set-default-theme argvus` | `argvus` কে ডিফল্ট থিম করুন |
| `sudo plymouth-update-theme` | চলমান Plymouth | এ পরিবর্তনটি প্রয়োগ করুন
| `sudo plymouth --show-splash` | বর্তমান অধিবেশনে স্প্ল্যাশ দেখান |
| `sudo plymouth --show-details` | পরিবর্তে ভার্বোস বুট বার্তা দেখান |
| `sudo plymouthquit` | Plymouth ছেড়ে দিন এবং আপনার সেশন পুনরুদ্ধার করুন |
| `sudo mkinitcpio -P` | Arch initramfs পুনর্নির্মাণ করুন |
| `sudo dracut --regenerate-all` | dracut | দিয়ে initramfs পুনর্নির্মাণ করুন

## পরবর্তী ধাপ

- [UKI এবং systemd-boot স্প্ল্যাশ](/docs/argvus-boot-splash/uki-splash/)
- [অ্যানইনস্টলেশন](/docs/argvus-boot-splash/uninstallation/)
- [সমস্যা সমাধান](/docs/argvus-boot-splash/troubleshooting/)
