---
title: "Warn - Uyarı"
timestamp: 2015-04-09T23:01:01
tags:
  - warn
  - STDERR
published: true
original: warn
books:
  - beginner
author: szabgab
translator: kbeyazli
---


Script/program/uygulama nızda hafif yanlış giden birşeyler olduğunda, bu konu hakkında kullanıcıyı 
uyarmak alışagelmiş bir durumdur. Bir komut satırı scriptinde bu iş normalde
[Standard Hata kanalı](/stdout-stderr-and-redirection)na uyarı mesajı yazdırmakla sağlanır. 


[standard çıktı ve hata](/stdout-stderr-and-redirection) konulu makalede açıklandığı gibi
Perl dilinde bu işi `STDERR` alanina yazdirarak yapabilirsiniz.

```perl
print STDERR "Slight problem here...\n";
```

Bu yöntemden daha iyi, hatta data standart bir yol ise `warn`
fonksiyonunu çağırmaktır:

```perl
warn "Slight problem here.\n";
```

Bu yöntem daha kısa, daha açıklayıcı ve aynı etkiye sahiptir.

Her iki durumda da script uyarı mesajını yazdırdıktan sonra çalışmaya devam edecektir!

Hatta daha fazlası mümkün. Eger ifade sonunda yeni satır belirteci kullanılmazsa(the `\n` ): 

```perl
warn "Slight problem here.";
```

dosya adı ve `warn` fonksiyonunun çağrıldığı satır numarasını 
çıktı olarak verecektir:

```
Slight problem here. at programming.pl line 5.
```

Bu özellik birçok başka scripti çalıştıran bir scriptiniz veya
birçok modülden oluşan büyük bir uygulamanız varsa çok yararlı olabilir.
Sizin veya programınızı kullanan kullanıcı için hatanın
kaynağını tespit etmekte oldukça kolaylık sağlar.

## Uyarıları yakalamak

Perl [uyarıları yakalayabilmek](/how-to-capture-and-save-warnings-in-perl) 
için programınıza daha sonra sizin veya başka birinin kod eklemesine olanak verir.
Bu biraz daha üst düzey bir konu olsa da, daha ileri seviyede öğrenmek istiyorsanız,
sayfayı ziyaret edin.

## uyarı

Bir uyarı örneği aşağıda yer almakta. print ifadesinden sonra çağrılan 
uyarı fonksiyonunun (warn) print fonksiyonundan önce ekrana veri bastığı
durumla karşılaşmış olabilirsiniz.

Kod:

```perl
print "before";
warn "Slight problem here.\n";
print STDERR "More problems.\n";
print "after";
```

aşağıdaki çıktıyı ekrana basar:

```
Slight problem here.
More problems.
beforeafter
```

"before" kelimesi her iki uyarı mesajından sonra gözükmektedir.

Bu konu hakkında detaylı bilgi için [tamponlama](/stdout-stderr-and-redirection#buffering)
adlı makaleyi okuyabilirsiniz.

