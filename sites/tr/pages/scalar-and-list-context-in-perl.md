---
title: "Perl programlarında tekli ve çoklu bağlam, bir dizideki eleman sayısı"
timestamp: 2014-08-31T14:14:14
tags:
  - scalar
  - list
  - array
  - size
  - length
  - context
  - Perl
published: true
original: scalar-and-list-context-in-perl
books:
  - beginner
author: szabgab
translator: nanis
---


[Perl dersimizin](/perl-tutorial) bu bölümünde Perl'de <b>bağlam duyarlılığını</b> işleyeceğiz.

Her dilde olduğu gibi Türkçe'de de aynı kelime farklı bağlamlarda farklı anlamlar ifade edebilir. Mesela "çakmak" fiili birçok anlam içerir:

Çivi çakmak

Çakmak çakmak

Kelimenin çevresindeki metin, yani kelimenin bulunduğu bağlam, kelimeyi doğru anlamamızı sağlar.

Perl 5 de buna benzer. Kelimeler, fonksiyon çağrıları ve diğer ifadeler bulundukları bağlamlara göre farklı anlamlar ifade edebilir. Bu durum öğrenmeyi zorlaştırır, ama ifade kabiliyetimizi zenginleştirir.


Perl dilinde <dfn title="scalar context">tekli bağlam</dfn> ve <dfn title="list context">çoklu bağlam</dfn> olmak üzere iki ana bağlam türü vardır.

## Çoklu bağlamda dizi

Bir örnek verelim:

```perl
my @words = ('Foo', 'Bar', 'Baz');
my @names = @words;
```

Yukaridaki atama sonrası `@names` dizisi `@words` dizi değerlerinin kopyalarını içerir.

Bir diziyi başka bir diziye atama işlemi dizinin içeriğini diğer diziye kopyalar.

## Tekli bağlamda dizi

```perl
my @words = ('Foo', 'Bar', 'Baz');
my $people =  @words;
```

Bu kez `@words` dizisini `$people` adlı <abbr title="scalar">tek değerli</abbr> bir değişkene atadık.

Başka dillerde bu farklı sonuçlar doğurur ama Perl dilinde bu atama işlemi <b>dizinin eleman sayısını</b> tek değerli değişkene kopyalar.

Hem keyfî hem de yukarıdaki kullanımın faydalı olduğu da söylenemez olsa da bu işlemin çok faydalı olduğu birçok başka durum vardır.

## Tekli ve Çoklu Bağlam

Yukarıda tekli, yani tek bir değer beklediğimiz, ve çoklu, yani birden çok değer beklediğimiz, bağlam örnekleri gördük. Çoklu bağlamda bir ifade 0, 1, 2 ya da başka herhangi bir sayıda değer içerebilir.

## if ifadesinin bağlamı

Aşağıdaki örneğe bakalım:

```perl
my @words = ('Foo', 'Bar', 'Baz');

if (@words) {
   say "There are some words in the array";
}
```

`if` ifadesinin koşul kısmında tek bir değer bekliyoruz. Bu durumda beklenen tekli bağlam olmalı.

Böylece bir dizinin tekli bağlamdaki değerinin dizideki eleman sayısı olduğunu biliyoruz. Ayrıca boş bir dizideki eleman sayısın sıfır (yani [yanlış](/boolean-values-in-perl)) olduğunu, bir veya daha fazla eleman içeriyor ise pozitif bir sayı (yani [doğru](/boolean-values-in-perl)) olduğunu da biliyoruz.

Yani, yukarıda bahsettiğimiz keyfî işlem sayesinde, `if (@words)` kod ifadesi dizide herhangi bir eleman olup olmadığını sınar. Dizi boş ise koşul sağlanmamış olur.

if-koşulunu `if (! @words)` şekline çevirmemiz durumunda dizi boş ise sınama doğru değeri verir.

## Tekli and Çoklu Bağlam

[Bir önceki bölümde](/the-year-19100) `localtime()` ifadesinin tekli ve çoklu bağlamlarda nasıl davrandığını, şimdi ise bir dizinin tekli and çoklu bağlamlarda nasıl davrandığını gördük.

Bağlam üzerinde genel-geçer bir kural yoktur. Özel durumları öğrenmek zorundasınız ama genellikle bunlar çok açıktır. Ne olursa olsun, [perldoc](/core-perl-documentation-cpan-module-documentation) kullanarak fonksiyonun dokümantasyonuna bakarsanız, tekli ve çoklu bağlamlara göre farklı değerler veren her fonksiyon için kısa bir açıklama göreceksiniz.

Şimdi biraz daha Perl ifadelerine ve nasıl bağlamlar oluşturduklarına bakalım.

## Tekli bağlam oluşturmak

Tek değerli herhangi bir değişkene ne atamasi yaparsanız yapın bu işlemin
tekli bağlamda gerçekleştiğini gördük.  Bunu şöyle açıklayabiliriz:

```
$x = TEKDEĞER;
```

Dizinin her bir elemanı da tek bir değer tuttuğundan, bunlara yapılan atamalar da tekli bağlam oluşturur:

```
$word[3] = TEKDEĞER;
```

Birleştirme operatörü her iki tarafında karakter dizesi beklediği için aşağıdaki iki durumda da tekli bağlam oluşturur:

```
"string" . TEKDEĞER;
```

ve ayrıca

```
TEKDEĞER . "string"
```

Yani

```perl
my @words = ('Foo', 'Bar', 'Baz');
say "Eleman sayisi: " . @words;
say "Simdi " . localtime();
```

programını çalıştırdığımızda

```
Eleman sayisi: 3
Simdi Thu Feb 30 14:15:53 1998
```

çıktısını verir.

Sayısal işlemler genellikle işlem imgesini her iki yanında iki sayı &mdash;iki tek değerli ifade&mdash; bekler. Bu nedenle sayısal işlemler her iki yanlarında tekli bağlam oluştururlar.

```
5 + TEKDEĞER;

TEKDEĞER + 5;
```

## Çoklu bağlam oluşturma

Belli başlı bazı yapılar çoklu bağlam oluşturur:

Diziye atama yapmak bunlardan biridir:

```
@x = LİSTE;
```

Bir listeye atama yapmak diğer bir yoldur:

```
($x, $y) = LİSTE;
```

Bu liste tek bir eleman içerse dahi durum aynıdır:

```
($x) =  LİSTE;
```

Bu da bize başkalarını kolayca tuzağa düşürmek bir yöntem verir:

## Parantezler ne zaman önemlidir?

```perl
use strict;
use warnings;
use 5.010;

my @words = ('Foo', 'Bar', 'Baz');

my ($x) = @words;
my $y   = @words;

say $x;
say $y;
```

programı

```
Foo
3
```

çıktısını verir.

Bu, parantezlerin önemli olduğu nadir durumlardan biridir.

İlk atama olan `my ($x) = @words;` ifadesinde bir tekdeğerli değişken listesine atama yaptık. Bu işlem sağ tarafta çoklu bağlam oluşturdu. Yani dizinin <b>değerleri</b> sol taraftaki listeye kopyalandı. Sadece bir tek değerli değişken olduğundan, dizinin ilk elemanı kopyalandı, diğerleri kopyalanmadı.

İkinci atama olan `my $y = @words;` ifadesinde <b>doğrudan</b> tek değerli bir değişkene atama yaptık. Bu işlem sağ tarafta tekli bağlam oluşturdu.  Tekli bağlamda bir dizi, dizideki eleman sayısını verir.

Bu gözlem, [fonksiyona parametre göndermek](/subroutines-and-functions-in-perl) konusuna geçtiğinizde çok önemli olacak.

## Tekli bağlama zorlamak

Hem `print()` hem de `say()` parametreleri için çoklu bağlam oluştururlar. Ya bir dizideki eleman sayısını yazdırmak isterseniz ne yapacaksınız? Ya da `localtime()` fonksiyonunun verdiği formatlanmış tarihi yazdırmak isterseniz?

Şu programı bir deneyelim:

```perl
use strict;
use warnings;
use 5.010;

my @words = ('Foo', 'Bar', 'Baz');

say @words;
say localtime();
```

Çıktısı:

```
FooBarBaz
3542071011113100
```

İlkinin anlaşılması bir şekilde mümkün, bunlar dizideki değerlerin peşisıra
yazılmış halidir.

İkinci ise çok daha kafa karıştırıcı. Bu sonuc `time()`
fonksiyonundan verdiği değer ile aynı değildir. Bu aslında
`localtime()` fonksiyonunun çoklu bağlamda verdiği dokuz sayının peşi
sıra yazılmış şeklidir. Hatırlamıyorsanız <a href="/the-year-19100">19100
yılı</a> adlı bölüme bir göz atın.

Çözüm, argümanına tekli bağlam yaratan `scalar()` fonksiyonunu
kullanmaktır.  Aslında `scalar()` fonksiyonunun tek görevi budur. Bu
fonksiyonu çoğul bir ifadeyi tekile dönüştüren <b>casting</b> gibi düşünmek
mümkün ama Perl dünyasında bu kelimenin pek kullanılmadığını sanıyorum.

```perl
say scalar @words;
say scalar localtime();
```

programını çalıştırdığımızda

```
3
Mon Nov  7 21:02:41 2011
```

çıktısını verecektir.

## Perl'de bir dizinin uzunluğu veya boyu

Perl'de bir dizinin boyunu, yani elemanlarının sayısını `scalar()` fonksiyonunu kullanarak tekli bağlama zorlamak yoluyla alabilirsiniz.

## Kurnaz yöntem

Bazen aşağıdaki gibi kod görebilirsiniz:

```perl
0 + @words;
```

Bu dizinin boyutunu almanın kurnaz yöntemidir. ` + ` işlem imgesi her iki tarafta da tekli bağlam oluşturur. Yani bu ifadede kullanılan `@words` boyutunu verecektir. Sıfır eklemek bir sayının değerini değiştirmez, bu nedenle yukarıdaki ifade dizinin boyutunu verir.

`scalar` fonksiyonunu kullanarak biraz daha uzun ama daha açık yazmanızı öneririm.

