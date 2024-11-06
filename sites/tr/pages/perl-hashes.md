---
title: "Perl de Hashler"
timestamp: 2015-03-30T23:12:06
tags:
  - hash
  - keys
  - value
  - associative
  - "%"
  - =>
  - fat arrow
  - fat comma
published: true
original: perl-hashes
books:
  - beginner
author: szabgab
translator: kbeyazli
---


[Perl Eğitimleri](/perl-tutorial) nin bu bölümünde 
<b>hashleri</b>, Perl dilinin en güçlü özelliklerinden birini öğreneceğiz.

İlişkili dizi, sözlük veya harita olarak adlandırılan hash ler Perl dilinde mevcut veri yapılarından biridir.


Hash sırasız anahtar-değer (key-value) 2'li gruplarından oluşur. Anahtarlar tekil sözcüktür (string). Değerler ise skalardır.
Her değer bir rakam, sözcük veya referans olabilir.

Hashler, diğer Perl değişkenleri gibi `my` anahtar sözcüğü ile tanımlanır. Değişken adının önünde yüzde
(`%`) işareti bulunur. 

Bu tanımlama anahtar-değer yapısını hatırlatmada yardımcı olur.

Bazı insanlar hashlerin dizi gibi olduğunu düşünür (eski adı ile 'ilişkisel dizi' bunu ifade eder, ve diğer bazı dillerde,
mesela PHP dilinde, dizi ve hash arasında bir fark yoktur.), fakat dizi ve hash arasında iki büyük fark vardır. 
Diziler sıralıdır ve dizi elemanına rakamsal indeks kullanılarak erişilir.
Hashler sırasızdır ve değere string bir anahtar ile erişilir.

Her hash anahtarı (key) bir <b>değer (value)</b> ile ilişkilendirilir ve anahtarlar (key) hash yapısında tekildir.
Bunun anlamı tekrar eden anahtar (key) a izin verilmediğidir. (Eğer gerçekten bir anahtar için birden fazla değer olması
isteniyorsa, referanslar konusuna geçene kadar bir müddet beklemeniz gerekecek).

Kod üzerinde görelim:

## Boş bir hash oluşturma

```perl
my %color_of;
```

## Anahtar-değer ikilisini hash e ekleme

Bu örnekte 'apple' anahtar, 'kırmızı' ise ilişkilendirilen değerdir.

```perl
$color_of{'apple'} = 'red';
```

Ayrıca anahtar değeri olarak değişken kullanılabilir, bu durumda tırnak kullanımına
gerek yoktur:

```perl
my $fruit = 'apple';
$color_of{$fruit} = 'red';
```

Aslında anahtar basit bir sözcük ise, direkt sözcük kullanılsa bile turnak kaldırılabilir:

```perl
$color_of{apple} = 'red';
```

Yukarıda görüleceği üzere, anahtar-değer ikilisine erişirken, `$` işareti kullanılır (% işareti değil)
çünkü <b>skalar</b> bir değere erişiyoruz. Anahtar süslü parantez içerisinde yer alır.

## Bir hash elemanına erişim

Eleman eklemeye benzer şekilde, bir elemanın değerine erişebiliriz.

```perl
print $color_of{apple};
```

Eğer anahtar hashde bulunmuyorsa, hash [tanımsız (undef)](/undef-and-defined-in-perl) sonuç
döndürür ve eğer kodda `uyarılar (warnings)` aktif edilmişse, 
[ön tanımlama yapılmamış değer uyarısı](/use-of-uninitialized-value) alırız.

```perl
print $color_of{orange};
```

Şimdi daha fazla anahtar-değer içeren hash görelim:

```perl
$color_of{orange} = "orange";
$color_of{grape} = "purple";
```

## Değerleri ile birlikte hash tanımlama

Hash tanımı yaparken eş zamanlı olarak anahtar-değer çiftlerini atayabiliriz:

```perl
my %color_of = (
    "apple"  => "red",
    "orange" => "orange",
    "grape"  => "purple",
);
```

`=>` işareti <b>şişman ok (fat arrow)</b> veya <b>şişman virgül (fat comma)</b> olarak adlandırılır ve eleman çiftlerini gösterir.
İlki, yani şişman ok, ince ok (->) tanımını görünce daha anlaşılır olacaktır.
Şişman virgül adı bu okların temelde virgül ile aynı olmasından kaynaklanır. Bu nedenle aşağıdaki gibi de yazabilirdik:

```perl
my %color_of = (
    "apple",  "red",
    "orange", "orange",
    "grape",  "purple",
);
```

Aslında şişman ok, kodu daha temiz ve okunabilir yapmak için soldaki elemanın tırnaklarını kaldırmamıza 
izin verir.

```perl
my %color_of = (
    apple  => "red",
    orange => "orange",
    grape  => "purple",
);
```

## Hash elemanına atama yapma

Şimdi var olan bir anahtara başka bir değer atadığımızda ne olduguğunu görelim:

```perl
$color_of{apple} = "green";
print $color_of{apple};     # green
```

Atama işlemi <b>apple</b> ile ilişkilendirilen değeri değiştirdi. Anahtarların tekil ve her bir anahtarın bir değere
sahip oldugunu hatırlayalım.

## Hash üzerinde işlemler

Bir hashdeki değere erişmek için anahtarı bilmeye ihtiyacımız vardır.
Hashin anahtarları ön tanımlı değerler değil ise, `keys` fonksiyonunu kullanarak
anahtar listesini alabiliriz. Daha sonra bu anahtarlar üzerinde işlem yapabiliriz:

```perl
my @fruits = keys %color_of;
for my $fruit (@fruits) {
    print "The color of '$fruit' is $color_of{$fruit}\n";
}
```

`@fruits` geçici değişkenini bile kullanmaya ihtiyacımız yok, direkt 
`keys` fonksiyonundan dönen değerler üzerinde işlem yapabiliriz:

```perl
for my $fruit (keys %color_of) {
    print "The color of '$fruit' is $color_of{$fruit}\n";
}
```


## Dizinin boyutu

Dizinin boyutundan bahsettiğimiz zaman, genellikle anahtar-değer çifti sayısını kastederiz.
Bu değeri `keys` fonksiyonunu skalar bağlamda kullanarak elde edebiliriz.

```perl
print scalar keys %hash;
```

## Teşekkür

Bu makalenin ilk sürümü [Felipe da Veiga Leprevost](http://www.leprevost.com.br/) tarafından yazılmıştır. Kendisi aynı zamanda
Perl Maven makalelerinin [Portekizce tercüme](https://br.perlmaven.com/) sini yapmaktadır.




