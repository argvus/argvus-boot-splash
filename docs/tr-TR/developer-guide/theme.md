---
title: Tema Mimarisi
description: Plymouth açıklayıcısının, varlıklarının ve betiğinin nasıl bir araya getirildiği.
---

# Tema mimarisi

Plymouth temasının nasıl bir araya getirildiği: açıklayıcı, varlık seti ve
`argvus.script` bölüm bölüm yapar.

Paketleme ve sürümler için bkz. [packaging](/docs/argvus-boot-splash/developer-guide/packaging/) ve
[CI ve sürümler](/docs/argvus-boot-splash/developer-guide/ci-releases/). Kullanım için bkz.
[kullanıcı kılavuzu](/docs/argvus-boot-splash/).

## Tanımlayıcı

Plymouth temaları, Plymouth'un betiği tarafından yorumlanan bildirgesel tanımlayıcılardır
motor. İki parça vardır:

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

Notlar:

- `ModuleName=script` Plymouth'in yerleşik komut dosyası yorumlayıcısını seçer.
derlenmiş bir modül yoktur; `ImageDir` ve `ScriptFile` **mutlak yollar** olmalıdır,
çünkü initramfs, oturumunuzdan farklı bir çalışma dizinine sahiptir.
- Dosya adı tema adıdır: `argvus.plymouth` ⇒ tema `argvus`, bu
tarafından seçilen `plymouth-set-default-theme argvus`.
- `argvus.script` tek kod dosyasıdır. Plymouth'un gömülü VM'si içinde çalışır
(`plymouthd` ve initramfs'e bağlanmıştır).
  that: dosya girişi/çıkışı yok, iş parçacığı yok, harici süreç yok, kayan nokta yok,
`MathInt` tek aritmetiğinizdir ve dil küçük bir C-benzeri diyalekttir
(diziler anahtarlı nesnelerdir, `Sprite()` nesneler kullanım öncesi oluşturulmalıdır).

## Render modeli

- Tek düz katı arka plan (`Window.SetBackgroundTopColor` /
  `SetBackgroundBottomColor`).
- **Spritelar** tek çizim ilkel öğeleridir. Her `Sprite()`'un bir resmi, bir
`(x, y)` konumu, bir **z-sırası** ve `[0, 1]` içinde bir opaklığı vardır. Daha sonra `SetPosition`
win çağrılır; bir sahne grafiği yoktur.
- İlerleme, her karede bir resmi yeniden `ImageScale` ederek ve
`SetImage` sprite üzerinde — kırpma veya kısmi çizim primitive'i yok.
- Plymouth raporları, scriptin kaydettiği geri çağrılar aracılığıyla durumu bildirir:
  `PlymouthSetBootProgressFunction`, `PlymouthSetDisplayPasswordFunction`,
  `PlymouthSetDisplayNormalFunction`, `PlymouthSetRefreshFunction`.
- `Plymouth.SetRefreshRate(20)`, yenileme geri çağrısının 20 FPS'de çalışmasını sağlar;
temanın tek zamanlı animasyonu (fade-in) buna bağlıdır.

## Varlık envanteri

Tüm varlıklar `src/usr/share/plymouth/themes/argvus/` içinde bulunur.

| Dosya | Boyut | Biçim | Rol | `argvus.script` tarafından kullanılır |
| --- | --- | --- | --- | --- |
| `argvus.plymouth` | — | INI | tema tanımlayıcı | `plymouthd` tarafından yüklendi |
| `argvus.script` | — | Plymouth senaryosu | tema mantığı | evet |
| `argvus-logo.png` | 256x256 | RGBA 8 bit | ana logo | evet (`logo.base_scale = 0.72`) |
| `argvus-text.png` | 400x53 | RGBA 8 bit | `ARGVUS` marka işareti | evet (`text.scale = 0.80`) |
| `progress-bar.png` | 400x4 | 1 bitlik palet | dolu çubuk | evet |
| `progress-bar-track.png` | 400x4 | 1 bitlik palet | doldurulmamış parça | evet |
| `entry-box.png` | 400x48 | RGB 16 bit | şifre giriş alanı | evet |
| `bullet.png` | 12x12 | 4 bitlik palet | bir maskeli karakter | evet |
| `entry-line.png`| 300x2 | 1-bit palet | giriş kuralı/alt çizgi | hayır (bkz [bilinen boşluklar](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)) |
| `logo-glow.png`| 260x300 | 8-bit palet | logo parıltı tasarımı | hayır (bak)[bilinen boşluklar](/docs/argvus-boot-splash/developer-guide/workflow/#known-gaps)) |
| `argvus-uki-splash.bmp` | 400x400 | BMP 32-bit | UKI / systemd-boot açılış ekranı | hayır (önyükleyici tarafından tüketiliyor) |

Görüntü genişliği, düzen birimi olarak kullanılır: logotype referans genişliktir
(1.0 ölçeğinde 400 px) ve ilerleme çubuğu, ilerleme yolu ve şifre giriş
alanı bunun üzerinden türetilir, bu yüzden bileşim,
logotype varlığı yeniden dışa aktarılırsa bile uyumlu kalır.

`arch_check_splash_payload()` içindeki `packaging/arch/common/functions.sh`,
**tüm** yukarıdaki dosyaların var olmasını gerektirir; bir varlık eklemek, onu o listeye eklemek anlamına gelir.
[paketleme](/docs/argvus-boot-splash/developer-guide/packaging/#shared-functions) kısmına bakın.

## Betik yürütme

`src/usr/share/plymouth/themes/argvus/argvus.script`, yukarıdan aşağıya.

### 1. Arka Plan

```js
Window.SetBackgroundTopColor(0.0667, 0.0745, 0.0863);
Window.SetBackgroundBottomColor(0.0667, 0.0745, 0.0863);
```

Üst ve alt aynı değer ⇒ düz dolgu, gradyan yok. Bileşenler
`#111316`'nin 8-bit kanalları 255'e bölünmüştür.

### 2. Varlıklar ve ölçekleme

Her resim, `Image("name")` üzerinden yüklenir, bu da
`ImageDir`'e göre çözülür. Ölçekleme açık bir şekilde yapılır:

```js
logo.base_scale = 0.72;
logo.base_width = MathInt(logo.original_image.GetWidth() * logo.base_scale);
logo.frame[logo.base_width] = ImageScale(logo.original_image, logo.base_width,
                                         logo.base_height);
logo.image = logo.frame[logo.base_width];
```

`logo.frame[...]` önbelleği kasıtlıdır: `ImageScale` her karede
her kare için yeni bir resim tahsis edin; logo bir kez ölçeklenir ve hedef  tarafından önbelleğe alınır
sadece yeni bir giriş gerektirecek şekilde genişlik.

The wordmark follows the same idea at

, but it is scaled once
inline. Progress track and bar are then scaled to

 —
yani çubuk her zaman kelime işaretinin genişliğiyle eşleşir, kelime işaretinin gerçek genişliği ne olursa olsun
piksel boyutudur.

### 3. Düzen

Tüm öğeler pencerenin yatay ekseninde ortalanmıştır:

```js
logo.x = Window.GetX() + Window.GetWidth() / 2 - logo.image.GetWidth() / 2;
logo.y = Window.GetY() + Window.GetHeight() / 2 - logo.image.GetHeight() / 2 - 35;
```

Şuna dikkat edin  text.image.GetWidth()  `text.scale = 0.80`  `text.image.GetWidth()` `- 35`: yığın tüm kompozisyonun (logo +
kelime işareti + parça) ortasında yer alır, yalnızca logo değil, bu yüzden blok biraz yukarı oturur
ekranın dikey ortası. Dikey yerleştirme daha sonra 'ya göre yapılır
previous element (

,

, …), which means the
bileşim çözünürlük ile bir birim olarak ölçeklenir.

Burada kullanılan Z sırası:

| Z | Peri |
| --- | --- |
| 100 | logo, marka işareti, ilerleme takibi |
| 101 | ilerleme çubuğu (parçanın üstünde) |
| 200 | şifre giriş alanı |
| 201 | şifre istemi metni |
| 202 | şifre madde işaretleri |

### 4. Başlangıç ilerlemesi

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

Registered with

. The clamp
matters: sıfır genişlikte bir görüntü bazı Plymouth sürümlerinde geçersizdir, bu yüzden çubuk
hiçbir zaman tamamen kaybolmaz ve ilerleme asla yol genişliğini aşamaz.
Sprite konumu sabittir; yalnızca görüntü genişliği değişir — dolgu veya kesme yok
işlemi kullanılır.

### 5. Şifre diyaloğu

 PlymouthSetBootProgressFunction(progress_callback)  progress_track.y = text.y + text.image.GetHeight() + 28  `text.y = logo.y + logo.image.GetHeight() + 16`  `progress_track.y = text.y + text.image.GetHeight() + 28`  `PlymouthSetBootProgressFunction(progress_callback)` `display_password_callback(prompt, bullets)`:

1. Sıçramayı kısar: `logo.opacity = 0.15` ve `0.15`'deki kelime işareti, `1.0`'de ise
parça ve çubuk kalır.
2. , temadaki tek
çalışma zamanında oluşturulmuş görüntü olan `Image.Text(prompt, 0.72, 0.77, 0.81)` ile istemi render eder. Konumu yalnızca burada bilinir,
çünkü metin yüksekliğine bağlıdır.
3. Giriş alanını istemin altına konumlandırır: `password.entry.y =
password.prompt.y + password.prompt.image.GetHeight() + 14`. Yükleme sırasında
`password.entry.y`, `0` ile birlikte gerçek konumun
   çabuk.
4. için beklediği bir yorumdur. Madde işaretlerini oluştur veya yeniden kullan döngüsü ile çizer:

   ```js
   for (index = 0; password.bullet[index] || index < bullets; index++)
   {
       if (!password.bullet[index]) { /* create sprite + image */ }
       /* ...position at entry.x + 16 + index * bullet.width ... */
       if (index < bullets) sprite.SetOpacity(1); else sprite.SetOpacity(0);
   }
   ```

Sprite'lar yeniden oluşturulmak yerine istemler arasında havuzlanıp yeniden kullanılır;
eski mermiler opaklık ile gizlenir `0`. Mermiler giriş alanı yüksekliğine göre dikey olarak ortalanır
.

`display_normal_callback()` tersidir: opaklığı geri yükler `1.0`,
istem, giriş ve her bir birikmiş mermi.
`PlymouthSetDisplayNormalFunction` ile kaydedildi, Plymouth, parola
kabul edildiğinde veya iptal edildiğinde ve önyükleme devam ettiğinde bunu çağırır.

Consequence: `logo.opacity` bir değişkendir, sabit değildir, çünkü hem solma
hem de parola durumu buna çarpılır.

### 6. Solma-yavaşça-giriş

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

Yenileme geri çağrısı tüm başlatma süresince çalışmaya devam eder (ucuzdur ve Plymouth
onu sürekli çağırır); `fade.complete` koruması,
animasyonundan sonra onu etkisiz hale getirir. Logo, basit bir
ataması yerine `logo.opacity * fade.opacity` kullanır, böylece parola ile karartılmış durum solma işleminden sonra korunur:
solma tamamlanır, `fade.opacity == 1` ve logo tekrar `logo.opacity` gösterir.

Bu temanın daha önceki revizyonları da darbe/oluşum animasyonlarına sahipti; onlar
`0.2.0` içinde kaldırıldı ("iş: nabız efektlerini kaldır"). Kare başına tekrar eklemeyin
ilerleme çubuğunun animasyonu — çubuk, sadık bir temsil olarak kalmalıdır
önyükleme ilerlemesi.

## Yerleşim sabitleri

Kompozisyonu ayarlamak için tek doğruluk kaynağı:

| Sabit | Değer | Anlamı |
| --- | --- | --- |
| `logo.base_scale` | `0.72` | logo ölçeği ve yerel 256x256 |
| `logo.y` offset | `-35` | ortalanmış bloğu ekranın ortasının üstüne kaldırır |
| `text.scale` | `0.80` | kelime işareti ölçeği ile yerel 400x53 karşılaştırması |
| `text.y` boşluğu | `+16` | logo alt → kelime işareti üst |
| `progress_track.y` boşluğu | `+28` | kelime işareti alt → parça üst |
| `password.prompt.y` boşluğu | `+24` | parça alt → bilgi istemi metni üst |
| `password.entry.y` boşluğu | `+14` | bilgi istemi alt → giriş alanı üst |
| madde işareti x uzaklığı | `+16` | giriş sola → ilk madde işareti |
| `logo.opacity` (iletişim kutusu) | `0.15` | parola istendiğinde sıçrama karartma |
| istem rengi | `0.72, 0.77, 0.81` | `Image.Text` RGB, ~`#B8C4CE` |
| solması | 20 kare @ 20 FPS | ~1 sn. yavaş yavaş belirme |

## Tasarım tokenları

| Jeton | Altıgen | Nerede yaşıyor |
| --- | --- | --- |
| Arka Plan | `#111316` | komut dosyası (`0.0667, 0.0745, 0.0863`) |
| Aksan | `#3590BD` | logo / kelime işareti / ilerleme dolgu pikselleri |
| İlerleme takibi | `#262933` | `progress-bar-track.png` |
| Bilgi istemi metni | `#B8C4CE` | komut dosyası (`Image.Text` çağrısı) |

Vurgu ve parça renkleri PNG varlıklarına gömülüdür,
betiğinde ifade edilmemiştir, bu nedenle yeniden renklendirme varlıkların yeniden dışa aktarılmasını (veya paletin düzenlenmesini) gerektirir.
Tema yalnızca koyu renkli ve açık varyantı yoktur.

## UKI bit eşlem biçimi

`argvus-uki-splash.bmp`, 400x400, 32-bit sıkıştırılmamış Windows BMP
(`PC bitmap, Windows 98/2000 and newer format, 400 x 400 x 32`) formatındadır. Bu
bağımsız bir varlıktır: Plymouth betiği asla onu yüklemez ve Arch paketi
onu hiçbir yere kaydetmez — bir UKI içerisine gömmek kullanıcının adımıdır (bkz.
[kullanıcı kılavuzu](/docs/argvus-boot-splash/uki-splash/)).

Eğer değiştirirseniz, benzer boyutta düz, sıkıştırılmamış 32-bit BMP olarak tutun;
systemd-boot ve `ukify` rastgele formatları ölçeklendirmez ve büyük resimler
erken önyüklemede hafıza tüketir.

## Temayı değiştirme

Pratik döngü:

1. Düzenle `src/usr/share/plymouth/themes/argvus/argvus.script` (ve/veya PNG dosyaları).
2. Canlı Plymouth'unuza yükleyin veya kaynak ağacından önizleyin:

   ```sh
   sudo cp -r src/usr/share/plymouth/themes/argvus/* \
              /usr/share/plymouth/themes/argvus/
   sudo plymouth-set-default-theme argvus
   sudo plymouth --show-splash    # check, then: sudo plymouthquit
   ```

3. `make validate && make build` taahhütte bulunmadan önce.

Temayı çalışır durumda tutan kurallar:

- Hiçbir zaman Plymouth dışı API'leri tanıtmayın. Motor sınırlı bir lehçedir;
kullanmadığınız bir API'yi kullanmadan önce desteklediğiniz `plymouth` hedef sürümü kontrol edin.
  daha önce kullanılmış.
- `ImageDir`/`ScriptFile`, `argvus.plymouth` içinde mutlak olarak kalmalı ve
kurulu yol olan `/usr/share/plymouth/themes/argvus` ile eşleşmelidir.
- `arch_check_splash_payload()` içinde listelenen her varlığı,
`src/` içinde dağıtılan dosyalarla senkronize tutun — paketleme `check()` CI içinde çalışır.
- İlerleme çubuğu genişliği, bildirilen ilerlemenin doğru bir fonksiyonu olarak kalmalıdır;
`[1, track width]`'ye olan kelepçe kaldırılmamalıdır.
- Parola iletişim kutusunu test edin, sadece önyükleme ekranını değil: bu, en
olası olarak bozulacak durumdur ve kullanıcıların en çok fark ettiği durumdur.
- Yenileme geri çağrısı tüm açılış için çalışır; kare başına iş tahsisini sürdür
  mümkün olduğunda ücretsiz.
