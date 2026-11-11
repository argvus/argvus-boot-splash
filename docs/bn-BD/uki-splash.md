---
title: ইউকেআই এবং সিস্টেমড-বুট স্প্ল্যাশ
description: ইউকেআই বুট ফ্লোতে ARGVUS স্প্ল্যাশ বিটম্যাপ ব্যবহার করুন।
---

# ইউকেআই এবং সিস্টেমড-বুট স্প্ল্যাশ

প্যাকেজটিতে `argvus-uki-splash.bmp` (400x400, 32-বিট আনকম্প্রেসড
BMP)ও পাঠানো হয়। এটি UKI / systemd-boot বুট ফ্লো জন্য তৈরি, যেখানে স্প্ল্যাশ ইমেজটি
, যা ইউনিফায়েড কার্নেল ইমেজে এমবেড করা থাকে, বরং
initramfs.

থেকে পড়া হয় না। বিটম্যাপটি Plymouth থিমে ব্যবহৃত হয় না এবং
আপনি স্বয়ংক্রিয়ভাবে: এটি এম্বেড করা নির্ভর করে আপনি আপনার UKI কীভাবে তৈরি করেন তার উপর। সাধারণ
consumers are:

```sh
# systemd: set the splash for the next boot (systemd >= 254)
bootctl --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp

# ukify, while building the UKI
ukify build --splash=/usr/share/plymouth/themes/argvus/argvus-uki-splash.bmp \
           --linux=... --initrd=... --microcode=...
```

UKI বিল্ডটি পুনরায় চালান (অথবা `bootctl set-splash`) যখনই ইমেজ পরিবর্তিত হয়, এবং
মনে রাখবেন যে অন্য কোথাও বিল্ড করলে ফাইলটি ESP তে কপি করতে হবে। systemd-boot
কনসোলে বিটম্যাপটির পরিমাণ বাড়ায়, ফলে একটি বর্গাকার ইমেজ কেন্দ্রীভূতভাবে প্রদর্শিত হয়।

আপনি শুধুমাত্র mkinitcpio বা dracut ব্যবহার করলে, আপনি সম্পূর্ণরূপে এই ফাইলটি উপেক্ষা করতে পারেন —
নিয়মিত [ইনস্টলেশন](/docs/argvus-boot-splash/installation/) সেই পথটি কভার করে।

## পরবর্তী ধাপ

- [ব্যবহার](/docs/argvus-boot-splash/usage/)
- [সমস্যা সমাধান](/docs/argvus-boot-splash/troubleshooting/)
