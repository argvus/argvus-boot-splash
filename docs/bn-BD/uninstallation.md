---
title: আনইনস্টলেশন
description: প্যাকেজটি অপসারণ করুন এবং আপনার পূর্ববর্তী বুট থিমটি পুনরুদ্ধার করুন।
---

# আনইনস্টলেশন

```sh
sudo pacman -Rns argvus-boot-splash
```

তারপর অন্য একটি থিম নির্বাচন করুন এবং পুনর্নির্মাণ করুন, অন্যথায় পুরানো স্প্ল্যাশটি ভিতরে থেকে যায়
initramfs:

```sh
sudo plymouth-set-default-theme argonaut
sudo plymouth-update-theme
sudo mkinitcpio -P        # or: sudo dracut --regenerate-all
```

`pacman -Rns` এছাড়াও `/etc/plymouth/plymouthd.conf` সরিয়ে দেয় যদি আর কিছু না থাকে
এটা তৈরি

প্যাকেজের অপসারণ হুক কেবল একটি অনুস্মারক প্রিন্ট করে — এটি অনুমান করে না কোন থিম
আপনি পরিবর্তে চান, এবং এটি আপনার initramfs স্পর্শ করে না।

## পরবর্তী ধাপ

- [সমস্যা সমাধান](/docs/argvus-boot-splash/troubleshooting/) — পূর্ববর্তী স্প্ল্যাশ পুনরুদ্ধার করা।
- [ইনস্টলেশন](/docs/argvus-boot-splash/installation/) — পরে পুনরায় ইনস্টল করা।
