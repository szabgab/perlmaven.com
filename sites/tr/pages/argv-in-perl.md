---
title: "@ARGV in Perl"
timestamp: 2013-12-10T08:13:10
tags:
  - @ARGV
  - $ARGV[]
  - $0
  - shift
  - argc
published: true
original: argv-in-perl
books:
  - beginner
author: szabgab
translator: kbeyazli
---


Eğer bir Perl scripti yazdi iseniz, mesela adı <b>programming.pl</b> olsun,
kullanıcılar komut satırından <b>perl programming.pl</b> komutunu kullanarak çalıştırabilirler .

Ayrica şu şekilde komut satırı argümanları gecebilirler. <b>perl programming.pl -a --machine remote /etc</b>.

Kullanıcıların bu şekilde parametre girmesini kimse engelleyemez fakat script bu değeleri önemsemeyecektir.
Bu durumda soru şu, programcı kişi, eğer değer geçilmiş ise bu değerleri nasıl bilecek?


## Komut satırı

Perl otomatik olarak adı @ARGV olan, komut satırından girilen değerleri tutan bir dizi sağlar.
Bu değişkeni tanımlamak zorunda değilsiniz, hatta `use strict` ifadesi kullanılmışsa bile.

Bu değişken her zaman vardır ve komut satırından girilen değerleri tutar .

Eğer parametre yok ise, dizi boş olacaktır. Komut satırından girilen bir parametre var ise, o değer 
`@ARGV` dizisinin tek elemanı olacaktır. Yukarıdaki örnekte `@ARGV` dizisi aşağıdaki elemanları içerir:
-a, --machine, remote, /etc

Şimdi bunu pratikte görelim:

Aşağıdaki kodu <b>programmimg.pl</b> olarak kaydedin.
 
```perl
use strict;
use warnings;
use Data::Dumper qw(Dumper);

print Dumper \@ARGV;
```

Şu şekilde çalıştırın: `perl programming.pl -a --machine remote /etc` çıktı şu olacaktır:

```
$VAR1 = [
          '-a',
          '--machine',
          'remote',
          '/etc'
        ];
```

Göreceğiniz üzere `@ARGV` dizisinin içeriğini basmak için `Data::Dumper`
kütüphanesinin `Dumper` fonksiyonunu kullandık.

Eğer başka bir programlama dilinden geliyor iseniz, aşağıdaki soruyu merak ediyor olabilirsiniz:
<b>Perl programının adı nerede?</b>

## Scriptin adı $0 değişkeni içindedir

Çalıştırılan programın adı, yukarıdaki örnekte <b>programming.pl</b>, her zaman `$0`
adlı Perl değişkeni içindedir. (Lutfen, `$1`, `$2`, vs. gibi tanımlamaların ilişkili olmadığını not ediniz)

## C programcısı

Eğer <b>C programlama dili</b> biliyor iseniz, bu size <b>argv</b> ile benzer gelecektir, tek farkı
Perl'deki `@ARGV` dizisi program adını <b>içermez</b>. 
Script adı `$0` değişkeninde tutulur. Ayrıca <b>argc</b> gibi bir değişkene gerek yoktur,
çünkü [ @ARGV dizisindeki eleman sayısını](/scalar-and-list-context-in-perl)
`scalar` fonksiyonunu kullanarak veya dizinin 
[scalar içeriğini](/scalar-and-list-context-in-perl) alarak kolayca alabilirsiniz.

## Unix/Linux Kabul Programlama

Eğer <b>Unix/Linux Shell programlama</b> dünyasindan geliyor iseniz, `$0`
değişkeninin burada da script adi olduğu size tanıdık gelecektir. Kabuk programlada ayrıca `$1`, `$2`, vs.
diğer komut satırı parametrelerini tutar. Bu değişkenler Perl dilinin 
düzenli ifadeler (regular expressions) konusunda kullanılır. Komut satırı argumanları `@ARGV` dizisinde tutulur. Benzer
şekilde `$*` ifadesi Unix/linux kabuk programlamada kullanılır

## @ARGV dizisinden komut satırı argümanlarına nasıl erişilir

`@ARGV` diğer diziler gibi [Perl'de bir dizidir](/perl-arrays).
Programcı tarafından oluşturulan dizilerden tek farkı, tanımlamaya gerek olmayışı ve
program başladığında Perl tarafından dolduruluşudur.

Bu durum dışında, [normal dizi](/perl-arrays) gibi ele alınabilir.
`foreach` kullanarak elemanları uzerinde gezebilir, veya indeks kullanarak elemanlara teker teker erişebilirsiniz: `$ARGV[0]`.

Ayrıca dizi üzerinde[shift, unshift, pop or push](/manipulating-perl-arrays) komutlarını kullanabilirsiniz.

Aslında, `@ARGV` dizisinin sadece içeriğini görüntülemekle kalmayıp, içeriğini de değiştirebilirsiniz.

Komut satırında tek bir değer bekliyor iseniz bu değerin ne olduğunu kontrol edebilir, ya da `$ARGV[0]`
değerine bakarak geçerli olup olmadığını anlayabilirsiniz. 2 değişken bekliyor iseniz `$ARGV[1]` değerine de bakarsınız.

Örnek olarak bir telefon defteri oluşturalım. Bir isim girildiğinde, uygulama isme karşılık gelen numarayı ekrana basacak.
İsim ve numara girilir ise program bu ikiliyi "veritabanı"na kaydedecek.
(Kodun veritabanı ile ilgili kısmını ele almayacağız, işlem yapılmış varsayacağız.)

Parametrelerin `$ARGV[0]` içinde ve belki ayrıca `$ARGV[1]` içinde tutulacağını, ama
diğer elemanların bir anlam ifade etmediğini biliyoruz.
$ARGV[0] and benzeri değişkenler yerine kendi adlandırdığınız değişkenleri kullanmak her zaman daha iyidir.
Bu nedenle yapmak isteyeceğimiz ilk iş dizi değerlerini oluşturduğumuz değişkenlere kopyalamak:

Aşağıdaki çalışan bir kod:

```perl
my $name   = $ARGV[0];
my $number = $ARGV[1];
```

Fakat aşağıdaki çok daha hoş:

```perl
my ($name, $number) = @ARGV;
```

Şimdi tüm örneği görelim (veritabanı kısmı hariç).
Aşağıdaki kodu <b>programming.pl</b> olarak kaydedin.

```perl
use strict;
use warnings;

my ($name, $number) = @ARGV;

if (not defined $name) {
  die "Need name\n";
}

if (defined $number) {
  print "Save '$name' and '$number'\n";
  # save name/number in database
  exit;
}

print "Fetch '$name'\n";
# look up the name in the database and print it out
```

Değerleri `@ARGV` dizisinden kopyaladıktan sonra, isim girilip girilmediğini kontrol ediyoruz.
Eğer girilmemiş ise, ekrana bir hata mesajı basacak ve scriptten çıkacak olan `die` komutunu çağırıyoruz.

Eğer isim var ise, numarayı kontrol ediyoruz. Eğer numara var ise 
veritabanına kaydediyor (yukarıda ele alınmadı) ve scriptten çıkıyoruz.

Numara yok ise veritabanindan isim bilgisini çekmeye çalışıyoruz. (Bu kısım da yukarıda ele alınmadı.)

Şimdi nasıl çalıştığına bakalım: ($ işareti komut satırından gelmektedir, biz bunu yazmayacağız.)

```
$ perl programming.pl Foo 123
Save 'Foo' and '123'

$ perl programming.pl Bar 456
Save 'Bar' and '456'

$ perl programming.pl John Doe 789
Save 'John' and 'Doe'
```

Ilk iki çağrı OK ama sonuncusu iyi gözükmüyor.
"John Doe"'nun telefon numarasını 789 olarak kaydetmek istedik, ama scriptimiz bunun yerine
"John"'un telefon numarasını "Doe" olarak kaydetti.

Sebep basit, ve Perl ile yapılacak bir şey bulunmamakta. Bu çağrı diğer herhangi bir dilde de bu şekilde çalışacaktı.
Scripti çalıştırdığınız kabuk veya komut satırı, çalıştırma komutunu ayırır ve değerleri `@ARGV` dizisine koyması için
Perl'e geçirir. Hem Unix/Linux kabuk ve Windows Komut Satırı program calistirma kodundan sonraki ifadeleri boşluğu baz alarak
ele alır. Bu nedenle `perl programming.pl John Doe 789` şeklinde çağrı yaptığımızdan, 3 parametre scriptimize geçirildi. 
Doğu çalışmasını sağlamak için çift tırmak içinde boşluk kullanılabilir:

```
$ perl a.pl "John Doe" 789
Save 'John Doe' and '789'
```

Siz, programcı olarak bundan daha fazlasını yapamazsınız.

## Argümanları kontrol etmek

Bazen girilen arguman sayısının beklediğiniz sayıyı aşıp aşmadığını kontrol edebilirsiniz.
Bu kullanıcının yukarıdaki hatayı yapmasını engeller, ama ya kullanıcı John Doe'nun 
telefon numarasını almak ister ve çift tırnakları unutursa:

```
perl a.pl John Doe
Save 'John' and 'Doe'
```

Bu durumda parametre sayısı dogru rakam olan 2'dir.

Bu durumda da, küçük bir geliştirme yapıp `$number` değişkeninin içeriğinin telefon numarası
olarak kabul edilebilecek formatta olup olmadığını kontrol edebilirsiniz. Bu hata olasılığını azaltacaktır.
Fakat hala kusursuz ve evrensel bir çözüm olmayacaktır:
Başka uygulamalarda birçok sayıda aynı kısıtlarda parametreler olabilir.

Maalesef `@ARGV` dizisini "manual" ayrıştırırken yapabileceğimiz fazla şey yok.
Bir başka makalede `Getopt::Long` ve hayatımızı daha kolaylaştıran benzer 
kütüphanelere değineceğiz, şimdi bir başka basit durumu görelim.


## tek bir parametreyi shift etmek

Kullanıcının komut satırından bir dosya adı gireceğini varsayalım
Bu durumda aşağıdaki kodu yazarsınız:

```perl
my $filename = shift or die "Usage: $0 FILENAME\n";
```

Daha kolay açıklayabilmek için kodu 2 bölüme ayıralım:

`my $filename = shift`

Normal şartlarda [shift](/manipulating-perl-arrays) parametre olarak bir dizi alır
ama bu ornekte parametresiz kullandık. Bu gibi durumlarda shift komutu
`@ARGV` dizisi üzerinde çalışır. Bu nedenle yukarıdaki kod `@ARGV` dizisinin birinci değerini
`$filename` değişkenine atar. (En azından kod bir subroutine içinde değilse.)

Bu durumda aşağıdaki koda sahip oluruz:
`$filename or die "Usage: $0 FILENAME\n"`

Bu [boolean](/boolean-values-in-perl) bir ifadedir.
Eğer `$filename` değişkeni dosya adını içeriyor ise
[True olarak düşünülecek](/boolean-values-in-perl) ve script
`or die ...` bölümünü çalıştırmadan çalışmaya devam edecektir.
Diğer taraftan, eğer @ARGV dizisi boş ise, `$filename` `undef` olarak tanımlanacak, 
[False yorumlanacak](/boolean-values-in-perl)
ve Perl sağ tarafta yer alan `or` durumunu çalıştıracağından,
ekrana bir mesaj basıp, scriptten çıkacaktır. 

Etkileyici biçimde, bu kod parçası komut satırından bir değer girilip girilmediğini kontrol eder. Değer
`$filename` değişkenine kopyalanır. Değer yok ise, script `die` komutu ile sonlanır.

## Küçük bir bug

Yukarıdaki kodda küçük bir bug bulunmakta. Kullanıcı dosya adı olarak 0 değerini girerse. Yine False olarak
işlem görecek ve script bu dosyaya işlem yapmayı reddedecektir. Soru şu: Bu çok önemli mi?
Kodumuzun dosya adı <b>0</b> olan bir dosyaya işlem yapmaması ihtimalini göze alabilir miyiz... ?

## Kompleks durumlar

Yukarıdaki bir veya iki parametreli durumlardan cok daha kompleks başka durumlar da mevcuttur.
Bu gibi durumlar için büyük ihtimalle `Getopt::Long` gibi ne tür parametreleri kabul edeceğinize 
bağlı olarak `@ARGV` dizisinin içeriğini analiz edebilecek araçlar kullanmak isteyeceksiniz.


