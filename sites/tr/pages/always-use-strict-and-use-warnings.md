---
title: "Perl kodunuzda her zaman use strict ve use warnings kullanın!"
timestamp: 2015-07-05T17:00:01
tags:
  - strict
  - warnings
published: true
original: always-use-strict-and-use-warnings
books:
  - beginner
author: szabgab
translator: kbeyazli
archive: true
---


Eğer [Perl Maven Başlangıç dersleri](/beginner-perl-maven.html) 
veya sınıf derslerimden Perl dilini öğrenmiş iseniz bu konuyu çoktan öğrenmişsiniz demektir.
Maalesef hala `use strict` ve `use warnings` kullanımının öneminin 
farkında olmayan Perl geliştiricileri bulunmakta.


Perl'i kendi başına veya meslektaşlarından öğrenenlerin bazıları 
bu 2 kullanımın önemini kavrayamıyor veya internetten rastgele örnekler bulup 
kopyala-yapıştır yaptıklarından kullanmamaya meyilli oluyor.

Kullansalar bile, bunlara neden ihtiyaç duyulduğunu anlayamayabiliyorlar.

Bunun sebebi aslında açık, birçok eski ders notu ve kitaplarda
Bu 2 onemli konudan sonlara doğru bahsediliyor.
Tonlarca koda ek olarak, şirketlerde ve webde yayınlanan programlar bu 2
önemli yapı kullanılmadan yazılmış. Daha kötüsü, bu 2 yapıyı kullanmaya savaş açmış
insanlar bulunmakta çünkü bu durumu "özgürlüğün genişlemesi" olarak görüyorlar.

Küçük ekstra maliyet ya da bu araçları kullanmanın vermiş olduğu rahatsızlık
sağladıkları değerden daha ağır basar.

Kullanımı aşağıdaki gibidir.

Kodunuzun herhangi bir bölümünde <b>her zaman use strict and warnings</b> 
kullanmanız iyi olacaktır

Bu özelliği sadece çok kısıtlı alanlarda veya gerçekten ekstra güce ihtiyacınız
olduğunda kapatınız.

(Kuaföre gittiğinizde kask giymeye büyük olasılıkla ihtiyacınız yoktur, değil mi?)
 
Zamanla nasıl ve ne zaman bu özelliği kapatacağınızı öğreneceksiniz.
Ama bir çoğumuz için bu yapıları default kullanmak iyi bir yaklaşımdır.

## strict ve warnings nedir?

Derleyiciye Perl'i daha katı derlemesi için direktif veren derleyici işaretçileridir.

Varlık sebepleri birçok ortak program hatasından kaçınmaya yardımcı olmaktır.

Ayrı bir makalede karşılaşabileceğiniz [ortak hata mesaj ve uyarılarını](/common-warnings-and-error-messages)
görebilirsiniz.

## use warnings

`-w` işaretçisini şimdiye kadar perl derleyici tanımının yapıldığı satırda 
aşağıdaki gibi görmüş olabilirsiniz:
`#!/usr/bin/perl -w`.

`use warnings`, `-w` işaretçisinin "yeni" ve gelişmiş versiyonudur.
Sayısız avantajı vardır ve her perl scriptinin `-w` kullanımından 
<h>warnings` kullanımına dönüştürülmesini öneriyorum.

"new" 2000 yılında 5.6 versiyonu ile Perl diline eklenmiştir.
Bu nedenle gerçekten yeni değildir, ama maalesef hala birçok Perl 
geliştiricisine yenidir.

`warnings` kullanımı potansiyel bir soruna sebep olabilecek
birçok çalışma zamanı hatasını görmemizi sağlar.

Genelde uyarıları görmek iyidir fakat son kullanıcıların uygulamada
bu uyarıları görmesini istemeyiz.
Bazı durumlarda bu uyarıları düzeltmeye çalışmak son kullanıcılar
açısından istenmeyen durumların oluşmasına sebep olabilir. Boylece
son kullanıcının ürüne olan guveni sarsılabilir.

Hiç kimse uygulamayı kullanırken etrafta uçuşan her türlü "hata mesajları"nı 
gerçekten görmek istemez.

Bu nedenle bazı insanlar warnings yapısının ürün ortamında (production) kullanılmaması 
gerektiği yönünde tavsiyede bulunurlar. Son kullanıcılarının Perl'den 
gelen bu uyarıları görmesini istemezler. Bu anlaşılabilir bir yaklaşımdır
fakat warnings yapısının istenmeyen etkilerinden kurtulmanın başka
metotları vardır.

Bu linkten görebilirsiniz [how to capture and save warnings](/how-to-capture-and-save-warnings-in-perl).

Eğer bir uyarı çalışma boyunca sürekli tetikleniyorsa "bazı" problemlere işaret ediyordur.
Kesinlikle daha dikkatli kodlama ile uyarıları en aza indirecek birisi olabilir.
Bu nedenle kesinlikle her zaman warnings kullanımını şiddetle tavsiye ediyorum.

Kodumuzda oluşan uyarıları gidermenin birçok yolunu göreceğiz.

Görebileceğiniz bazı uyarılar aşağıdadır:

* [Use of uninitialized value](/use-of-uninitialized-value)
* [Name "main::x" used only once: possible typo at ...](/name-used-only-once-possible-typo)
* ["my" variable masks earlier declaration in same scope](/my-variable-masks-earlier-declaration-in-same-scope)
* [Argument ... isn't numeric in numeric ...](/argument-isnt-numeric-in-numeric)

## use strict

Bu yapının 3 farklı özelliği vardır. Yukarıdaki gibi kullanıldığında 
3 özellik birden aktif edilmiş olur. Bu önerilen kullanım şeklidir.

Bu 3 özellikten en çok görüleni her değişkenin `my` veya `our` anahtar
sözcükleri ile tanımlanmasını zorunlu kılan kullanımdır. Sadece bu özelliği aktif etmek gerektiğinde
`use strict 'vars';` şeklinde tanımlama yapılır.

Bu özellik aktif edildiğinde eğer ki yukarıda belirtildiği gibi tanımlama
yapılmaz ise aşağıdaki hata mesajı alınır:
[Global symbol requires explicit package name](/global-symbol-requires-explicit-package-name)

`use strict 'refs';` [sembolik referans](/symbolic-reference-in-perl)
ie karşılaşıldığında çalışma zamanı hatası üretir. Başka bir bölümde sembolik
referans kavramını açıklayacağız. Perl dosyamızın en başında bu özelliği kullanmış
isek ne zaman faydalı olduğunu ne nasıl kullanılması
gerektiğine değineceğiz.

`use strict "subs"` kullanımı uygunsuz [barewords](/barewords-in-perl)
kullanımını (derleme zamanında) engeller. Aşağıdaki hata mesajını oluşturur:
[Bareword not allowed while "strict subs" in use](/barewords-in-perl).

Daha basit bir ifade ile, string değişkenlerini çift veya tek tırnak içine
almanız gerekir.

```
"Foo"       # iyi
'Bar'       # iyi
Baz         # kötü
```

## Uyarılardan kaçınmak

Uyarılardan kaçınmanın yollarından biri kodunuzu daha kurşun geçirmez
hale getirmektir. Uyarının oluşabileceği her yerde özel koşulları kontrol eden,
varsayılan değerleri atayan ya da uyarıdan kaçınmayı sağlayacak uygun kodun
çalışmasını sağlayacak daha fazla kod yazın.

Tabi bu durumda uyarıların nerede oluşacağını bildiğinizi varsayıyoruz.
Bu iyi bir egzersiz olabilir, ama daha fazla kod ve disiplin gerektirir.

Mutlaka perl ile geliştirilen bir uygulama için gerekli değildir.

Kesinlikle var olan bir uygulamanın içinde kolaylıkla yapabileceğiniz bir şey değildir.

## splain ve diagnostics

Kodumuzdan net olmayan bir uyarı aldığımızda, [use diagnostics;](/use-diagnostics-or-splain)
ifadesini kodumuza ekleyerek daha detaylı açıklama isteyebiliriz. Veya 
[splain](/use-diagnostics-or-splain) komut satırı aracını kullanarak bunu yapabiliriz.

## Ölümcül uyarılar (Fatal warnings)

Aşağıdaki kullanım tüm uyarıları hataya dönüştürür.
Bu üretim (production) kodumuzda iyi bir fikir gibi gözükmeyebilir ama 
geliştirme (development) kodumuzda sizi ve takımınızı uyarıları hızlıca temizlemeye zorlar.

```perl
use warnings FATAL => 'all';
```

