---
title: थीम आर्किटेक्चर
description: यह कि Plymouth वर्णनक, एसेट्स, और स्क्रिप्ट कैसे एक साथ रखे जाते हैं।
---

# थीम वास्तुकला

यह कि Plymouth थीम कैसे बनाई जाती है: वर्णनक, एसेट सेट, और क्या
`argvus.script` सेक्शन दर सेक्शन क्या करता है।

पैकेजिंग और रिलीज़ के लिए देखें [packaging](/docs/argvus-boot-splash/developer-guide/packaging/) और
[CI और रिलीज़](/docs/argvus-boot-splash/developer-guide/ci-releases/)। उपयोग के लिए, देखें
[उपयोगकर्ता गाइड](/docs/argvus-boot-splash/)।

## वर्णनकर्ता

प्लायमाउथ थीम्स घोषणात्मक वर्णक हैं जिन्हें प्लायमाउथ के स्क्रिप्ट द्वारा व्याख्यायित किया जाता है
इंजन। इसके दो भाग हैं:

`src/usr/share/plymouth/themes/argvus/argvus.plymouth`:

```ini
[Plymouth Theme]
Name=Argvus
Description=Argvus boot splash theme
ModuleName=script

[script]
ImageDir=/usr/share/plymouth/themes/argvus
ScriptFile=/usr/share/plymouth/themes/argvus/argvus.script
```

टिप्पणियाँ:

- `ModuleName=script` प्लीमाउथ के बिल्ट-इन स्क्रिप्ट इंटरप्रेटर का चयन करता है। कोई
संकलित मॉड्यूल नहीं है; `ImageDir` और `ScriptFile` **पूर्ण पथ** होना चाहिए,
क्योंकि initramfs का कार्यशील निर्देशिका आपके सत्र से अलग है।
- फ़ाइल का नाम थीम नाम है: `argvus.plymouth` ⇒ थीम `argvus`, जो कि
है जो `plymouth-set-default-theme argvus` चुनता है।
- `argvus.script` ही एकमात्र कोड फ़ाइल है। यह Plymouth के एम्बेडेड VM
के अंदर चलता है (`plymouthd` और initramfs में लिंक किया गया)।
  that: कोई फ़ाइल इनपुट/आउटपुट नहीं, कोई थ्रेड्स नहीं, कोई बाहरी प्रक्रियाएँ नहीं, कोई फ्लोटिंग पॉइंट नहीं,
`MathInt` ही आपकी केवल अंकगणित है, और भाषा एक छोटी सी C जैसी डायलक्ट है
(ऐरेज़ कुंजी वाले ऑब्जेक्ट्स हैं, `Sprite()` ऑब्जेक्ट्स का उपयोग करने से पहले बनाया जाना चाहिए)।

## रेंडरिंग मॉडल

- एक फ्लैट ठोस पृष्ठभूमि (`Window.SetBackgroundTopColor` /
  `SetBackgroundBottomColor`).
- **स्प्राइट्स** ही एकमात्र ड्रा इंट्रिमिटिव हैं। प्रत्येक `Sprite()` का एक इमेज, एक
`(x, y)` स्थिति, एक **z-क्रम** और `[0, 1]` में एक अपारदर्शिता होती है। बाद में `SetPosition`
win को कॉल करता है; कोई दृश्य ग्राफ नहीं है।
- प्रगति को हर फ्रेम में इमेज को पुनः `ImageScale` करके और
`SetImage` स्प्राइट पर — कोई क्लिपिंग या आंशिक-ड्रा प्रिमिटिव नहीं है।
- प्लीमाउथ रिपोर्ट्स स्क्रिप्ट द्वारा रजिस्टर्ड कॉलबैक के माध्यम से स्थिति बताते हैं:
  `PlymouthSetBootProgressFunction`, `PlymouthSetDisplayPasswordFunction`,
  `PlymouthSetDisplayNormalFunction`, `PlymouthSetRefreshFunction`.
- `Plymouth.SetRefreshRate(20)` रिफ्रेश कॉलबैक को 20 FPS पर चलने देता है;
थीम की एकमात्र समयबद्ध एनिमेशन (फेड-इन) इसी पर निर्भर करती है।

## एसेट इन्वेंटरी

सभी संपत्तियाँ `src/usr/share/plymouth/themes/argvus/` में रहती हैं।

| फ़ाइल | आकार | प्रारूप | भूमिका | `argvus.script` द्वारा प्रयुक्त |
| --- | --- | --- | --- | --- |
| `argvus.plymouth` | — | आईएनआई | विषयवस्तु वर्णनकर्ता | `plymouthd` द्वारा लोड किया गया |
| `argvus.script` | — | Plymouth स्क्रिप्ट | थीम तर्क | हाँ |
| `argvus-logo.png` | 256x256 | आरजीबीए 8-बिट | मुख्य लोगो | हाँ (`logo.base_scale = 0.72`) |
| `argvus-text.png` | 400x53 | आरजीबीए 8-बिट | `ARGVUS` वर्डमार्क | हाँ (`text.scale = 0.80`) |
| `progress-bar.png` | 400x4 | 1-बिट पैलेट | भरी हुई बार | हाँ |
| `progress-bar-track.png` | 400x4 | 1-बिट पैलेट | अधूरा ट्रैक | हाँ |
| `entry-box.png` | 400x48 | आरजीबी 16-बिट | पासवर्ड प्रविष्टि फ़ील्ड | हाँ |
| `bullet.png` | 12x12 | 4-बिट पैलेट | एक नकाबपोश पात्र | हाँ |
| `entry-line.png`| 300x2 | 1-बिट पैलेट | प्रवेश नियम/अंडरलाइन | नहीं (देखें[ज्ञात अंतर](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)) |
| `logo-glow.png`| 260x300 | 8-बिट पैलेट | लोगो ग्लो आर्टवर्क | नहीं (देखें[ज्ञात अंतर](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)) |
| `argvus-uki-splash.bmp` | 400x400 | BMP 32-बिट | UKI / systemd-boot स्प्लैश | नहीं (बूट लोडर द्वारा उपयोग किया गया) |

छवि की चौड़ाई लेआउट इकाई के रूप में उपयोग की जाती है: शब्दचिह्न संदर्भ चौड़ाई
(मान 1.0 पर 400 पिक्सल) है और प्रगति ट्रैक, प्रगति बार और पासवर्ड एंट्री
फ़ील्ड इससे व्युत्पन्न होते हैं, जिससे यदि
शब्दचिह्न संपत्ति पुनः निर्यात की जाती है तो संरचना सुसंगत रहती है।

`arch_check_splash_payload()` में `packaging/arch/common/functions.sh` को
**सभी** ऊपर की फाइलें मौजूद होना आवश्यक है; किसी एसेट को जोड़ना मतलब इसे उस सूची में जोड़ना।
[पैकेजिंग](/docs/argvus-boot-splash/developer-guide/packaging/#shared-functions) देखें।

## स्क्रिप्ट वॉकथ्रू

`src/usr/share/plymouth/themes/argvus/argvus.script`, ऊपर से नीचे तक।

### 1. पृष्ठभूमि

```js
Window.SetBackgroundTopColor(0.0667, 0.0745, 0.0863);
Window.SetBackgroundBottomColor(0.0667, 0.0745, 0.0863);
```

ऊपर और नीचे एक ही मान ⇒ एक फ़्लैट फिल, कोई ग्रेडिएंट नहीं। कंपोनेंट्स हैं
`#111316` के 8-बिट चैनल 255 से विभाजित।

### 2. संसाधन और स्केलिंग

हर छवि `Image("name")` के माध्यम से लोड की जाती है, जो
`ImageDir` के सापेक्ष हल होती है। स्केलिंग स्पष्ट है:

```js
logo.base_scale = 0.72;
logo.base_width = MathInt(logo.original_image.GetWidth() * logo.base_scale);
logo.frame[logo.base_width] = ImageScale(logo.original_image, logo.base_width,
                                         logo.base_height);
logo.image = logo.frame[logo.base_width];
```

`logo.frame[...]` कैश इरादतन है: `ImageScale` प्रत्येक फ्रेम पर
प्रत्येक फ्रेम के लिए एक नई छवि आवंटित करें; लोगो को एक बार स्केल किया जाता है और लक्षित
चौड़ाई द्वारा कैश किया जाता है ताकि एक रिसाइज़ के लिए केवल एक नया प्रवेश आवश्यक हो।

वर्डमार्क वही विचार `text.scale = 0.80` पर अनुसरण करता है, लेकिन इसे एक बार
इनलाइन में स्केल किया जाता है। प्रगति ट्रैक और बार फिर `text.image.GetWidth()` पर स्केल की जाती हैं —
यानी बार हमेशा वर्डमार्क की चौड़ाई के मेल खाता है, चाहे वर्डमार्क की वास्तविक
पिक्सेल आकार है.

### 3. लेआउट

जो भी हो। हर तत्व विंडो के क्षैतिज अक्ष पर केंद्रित है:

```js
logo.x = Window.GetX() + Window.GetWidth() / 2 - logo.image.GetWidth() / 2;
logo.y = Window.GetY() + Window.GetHeight() / 2 - logo.image.GetHeight() / 2 - 35;
```

। यह ध्यान दें `- 35`: स्टैक पूरे कंपोज़िशन (लोगो +
वर्डमार्क + ट्रैक) पर केंद्रित है, केवल लोगो पर नहीं, इसलिए ब्लॉक थोड़ी ऊपर बैठता है
स्क्रीन का ऊर्ध्वाधर मध्य। ऊर्ध्वाधर स्थिति तब सापेक्ष होती है
पिछला तत्व (`text.y = logo.y + logo.image.GetHeight() + 16`,
`progress_track.y = text.y + text.image.GetHeight() + 28`, …), जिसका मतलब है
संयोजन संकल्प के साथ एक इकाई के रूप में मापता है।

यहाँ Z-क्रम का उपयोग किया गया है:

| जेड | स्प्राइट |
| --- | --- |
| 100 | लोगो, वर्डमार्क, प्रगति ट्रैक |
| 101 | प्रगति पट्टी (ट्रैक के ऊपर) |
| 200 | पासवर्ड प्रविष्टि फ़ील्ड |
| 201 | पासवर्ड प्रॉम्प्ट टेक्स्ट |
| 202 | पासवर्ड बुलेट्स |

### 4. बूट प्रगति

```js
fun progress_callback(duration, progress)
{
    width = MathInt(progress_bar.original_image.GetWidth() * progress);
    if (width < 1) width = 1;
    if (width > progress_bar.original_image.GetWidth())
        width = progress_bar.original_image.GetWidth();
    progress_bar.image = ImageScale(progress_bar.original_image, width,
                                     progress_bar.original_image.GetHeight());
    progress_bar.sprite.SetImage(progress_bar.image);
}
```

`PlymouthSetBootProgressFunction(progress_callback)` के साथ पंजीकृत। क्लैम्प
matters: कुछ Plymouth संस्करणों में शून्य-चौड़ाई वाली छवि अमान्य होती है, इसलिए बार
कभी पूरी तरह से गायब नहीं होता, और प्रगति कभी ट्रैक की चौड़ाई से अधिक नहीं हो सकती।
स्प्राइट स्थिति स्थिर है; केवल छवि की चौड़ाई बदलती है — कोई भराई या क्लिप नहीं
ऑपरेशन का प्रयोग किया जाता है.

### 5. पासवर्ड डायलॉग

`display_password_callback(prompt, bullets)`:

1. स्प्लैश को धुंधला करता है: `logo.opacity = 0.15` और वर्डमार्क `0.15` पर, जबकि
ट्रैक और बार `1.0` पर रहते हैं।
2. प्रॉम्प्ट को `Image.Text(prompt, 0.72, 0.77, 0.81)` के साथ प्रस्तुत करता है — थीम में केवल
रनटाइम-जनरेटेड इमेज। इसका स्थान केवल यहाँ ज्ञात है,
क्योंकि यह टेक्स्ट की ऊँचाई पर निर्भर करता है।
3. प्रॉम्प्ट के नीचे एंट्री फ़ील्ड की स्थिति निर्धारित करता है: `password.entry.y =
password.prompt.y + password.prompt.image.GetHeight() + 14`। लोड समय पर
`password.entry.y` `0` होता है, एक टिप्पणी के साथ कि वास्तविक स्थिति
   संकेत.
4. के इंतजार में रहती है। क्रिएट-या-रीयूज़ लूप के साथ बुलेट्स बनाता है:

   ```js
   for (index = 0; password.bullet[index] || index < bullets; index++)
   {
       if (!password.bullet[index]) { /* create sprite + image */ }
       /* ...position at entry.x + 16 + index * bullet.width ... */
       if (index < bullets) sprite.SetOpacity(1); else sprite.SetOpacity(0);
   }
   ```

स्प्राइट्स को प्रत्येक प्रॉम्प्ट पर फिर से बनाने के बजाय पूल किया जाता है और पुनः उपयोग किया जाता है;
पुरानी गोलियां अस्पष्टता `0` के साथ छिपी हुई हैं। गोलियां लंबवत रूप से केंद्रित हैं
   प्रविष्टि फ़ील्ड की ऊँचाई के खिलाफ।

`display_normal_callback()` इसका विपरीत है: यह अपारदर्शिता `1.0` को बहाल करता है, छुपाता है
प्रॉम्प्ट, प्रवेश और हर एक पूल किए गए बुलेट।
`PlymouthSetDisplayNormalFunction` के साथ पंजीकृत, प्लाइमाउथ इसे तब कॉल करता है जब पासफ़्रेज़
स्वीकार या रद्द किया जाता है और बूट जारी रहता है।

Consequence: `logo.opacity` एक चर है, स्थिरांक नहीं, क्योंकि दोनों फ़ेड
और पासवर्ड स्थिति इसमें गुणा होती हैं।

### 6. फ़ेड-इन

```js
Plymouth.SetRefreshRate(20);
fun refresh_callback()
{
    if (!fade.complete) {
        fade.frame += 1;
        fade.opacity = fade.frame / 20;      /* 20 frames @ 20 FPS = 1s */
        if (fade.opacity > 1) fade.opacity = 1;
        text.sprite.SetOpacity(fade.opacity);
        progress_track.sprite.SetOpacity(fade.opacity);
        progress_bar.sprite.SetOpacity(fade.opacity);
        if (fade.frame >= 20) fade.complete = 1;
    }
    logo.sprite.SetOpacity(logo.opacity * fade.opacity);
}
```

रिफ्रेश कॉलबैक पूरे बूट के दौरान चलता रहता है (यह सस्ता है और Plymouth
इसे लगातार कॉल करता है); `fade.complete` गार्ड इसे
एनिमेशन के बाद निष्क्रिय बना देता है। लोगो एक साधारण
असाइनमेंट की जगह `logo.opacity * fade.opacity` का उपयोग करता है ताकि पासवर्ड से धुंधला किया गया स्थिति फेड होने के बाद भी बनी रहे:
फेड पूरा होता है, `fade.opacity == 1` और लोगो फिर से `logo.opacity` दिखाता है।

इस थीम के पहले के संस्करणों में भी पल्स/स्पॉन एनिमेशन थे; उन्हें
`0.2.0` में हटा दिया गया था ("chore: remove pulse effects")। प्रगति बार की प्रति-फ्रेम
एनिमेशन को फिर से न जोड़ें — बार
बूट प्रगति.

## लेआउट स्थिरांक

रचना को ट्यून करने के लिए सत्य का एकल स्रोत:

| लगातार | मूल्य | मतलब |
| --- | --- | --- |
| `logo.base_scale` | `0.72` | लोगो स्केल बनाम इसका मूल 256x256 |
| `logo.y` offset | `-35` | मिड-स्क्रीन के ऊपर केंद्रित ब्लॉक को उठाता है |
| `text.scale` | `0.80` | वर्डमार्क स्केल बनाम इसका मूल 400x53 |
| `text.y` गैप | `+16` | लोगो नीचे → वर्डमार्क शीर्ष |
| `progress_track.y` गैप | `+28` | वर्डमार्क बॉटम → ट्रैक टॉप |
| `password.prompt.y` गैप | `+24` | ट्रैक बॉटम → प्रॉम्प्ट टेक्स्ट टॉप |
| `password.entry.y` गैप | `+14` | शीघ्र नीचे → प्रवेश क्षेत्र शीर्ष |
| बुलेट एक्स ऑफसेट | `+16` | प्रविष्टि बाएँ → पहली गोली |
| `logo.opacity` (संवाद) | `0.15` | पासफ़्रेज़ का अनुरोध करते समय स्प्लैश डिमिंग |
| शीघ्र रंग | `0.72, 0.77, 0.81` | `Image.Text` RGB, ~`#B8C4CE` |
| फीका | 20 फ्रेम @ 20 एफपीएस | ~1 एस फ़ेड-इन |

## डिजाइन टोकन

| टोकन | हेक्स | यह कहाँ रहता है |
| --- | --- | --- |
| पृष्ठभूमि | `#111316` | स्क्रिप्ट (`0.0667, 0.0745, 0.0863`) |
| एक्सेंट | `#3590BD` | लोगो/वर्डमार्क/प्रगति पिक्सेल भरें |
| प्रगति पथ | `#262933` | `progress-bar-track.png` |
| शीघ्र पाठ | `#B8C4CE` | स्क्रिप्ट (`Image.Text` कॉल) |

हाइलाइट और ट्रैक रंग PNG संपत्तियों में शामिल हैं,
स्क्रिप्ट में व्यक्त नहीं हैं, इसलिए रंग बदलने का मतलब है संपत्तियों को पुनः निर्यात करना (या पैलेट को संपादित करना)।
थीम केवल डार्क है और इसका कोई लाइट वेरिएंट नहीं है।

## UKI बिटमैप फ़ॉर्मेट

`argvus-uki-splash.bmp` एक 400x400, 32-बिट अनकंप्रेस्ड विंडोज BMP
(`PC bitmap, Windows 98/2000 and newer format, 400 x 400 x 32`) है। यह एक
स्टैंडअलोन एसेट है: प्लाइमाउथ स्क्रिप्ट इसे कभी लोड नहीं करता, और आर्च पैकेज इसे
कहीं भी रजिस्टर नहीं करता — इसे एक UKI में एम्बेड करना उपयोगकर्ता का कदम है (देखें
[उपयोगकर्ता मार्गदर्शिका](/docs/argvus-boot-splash/uki-splash/)).

यदि आप इसे बदलते हैं, तो इसे इसी आकार के साधारण अनकंप्रेस्ड 32-बिट BMP के रूप में रखें;
systemd-boot और `ukify` किसी भी फॉर्मेट को स्केल नहीं करते हैं और बड़ी इमेजेज़
प्रारंभिक बूट पर बहुत मेमोरी लेती हैं।

## थीम को संशोधित करना

प्रैक्टिकल लूप:

1. संपादित करें `src/usr/share/plymouth/themes/argvus/argvus.script` (और/या PNGs)।
2. अपने लाइव Plymouth पर इंस्टॉल करें, या स्रोत वृक्ष से पूर्वावलोकन करें:

   ```sh
   sudo cp -r src/usr/share/plymouth/themes/argvus/* \
              /usr/share/plymouth/themes/argvus/
   sudo plymouth-set-default-theme argvus
   sudo plymouth --show-splash    # check, then: sudo plymouthquit
   ```

3. `make validate && make build` प्रतिज्ञा करने से पहले।

थीम को काम करते रहने वाले नियम:

- कभी भी गैर-Plymouth API पेश न करें। इंजन एक सीमित बोलिपद्धति है; इस्तेमाल करने से पहले
आप जिस API का उपयोग कर रहे हैं उसमें लक्ष्य संस्करण `plymouth` की जाँच करें
  पहले इस्तेमाल किया गया.
- `ImageDir`/`ScriptFile` को `argvus.plymouth` में पूर्ण रूप से स्थिर रहना चाहिए और
स्थापित पथ `/usr/share/plymouth/themes/argvus` से मेल खाना चाहिए।
- `arch_check_splash_payload()` में सूचीबद्ध प्रत्येक संपत्ति को
फाइलों के साथ सिंक में रखें जो `src/` में शिप होती हैं — पैकेजिंग `check()` CI में चलती है।
- प्रोग्रेस बार की चौड़ाई को रिपोर्ट किए गए प्रोग्रेस का सच्चा फ़ंक्शन ही रहना चाहिए;
`[1, track width]` तक क्लैंप को नहीं हटाया जाना चाहिए।
- पासफ्रेज़ डायलॉग का परीक्षण करें, सिर्फ़ बूट स्प्लैश नहीं: यह सबसे
टूटने की संभावना वाली स्थिति है और वह जिसे उपयोगकर्ता सबसे अधिक नोटिस करते हैं।
- फ्रेश रिफ्रेश कॉलबैक पूरे बूट के लिए चलता है; प्रति-फ्रेम कार्य आवंटन को बनाए रखें
  जहां संभव हो मुफ़्त.
