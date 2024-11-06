---
title: "PSGI Kavramına Giriş"
timestamp: 2015-03-31T19:30:11
tags:
  - PSGI
  - Plack
  - plackup
published: true
original: getting-started-with-psgi
author: szabgab
translator: kbeyazli
---


Gerçekten iyi bir web uygulaması yapmak birçok üst düzey bilgi gerektirir
fakat temel bazı yapıları bilmek yardımcı olabilir. Son birkaç yılda
Perl Dünyasında bunu gerçekleştirmek için yeni bir standart ortaya çıktı, PSGI.

Şimdi basit bir web uygulaması yapmak için bu temel yapı bloklarını nasıl
kullanabileceğimizi görelim.


## Daha üst düzey soyutlama

Gerçek bir PSGI koduna bakmadan önce, önemine değinelim.
Perl ile [modern bir web uygulaması](/modern-web-with-perl) yapmak isterseniz,
büyük ihtimalle PSGI yapısından daha üst düzey bir soyutlama sağlayan web frameworku ile başlardınız.
Mesela [Dancer](/dancer), [Mojolicious](/mojolicious), ya da [Catalyst](/catalyst).
Aslında bu frameworkler de web sunucu ile haberleşmek için PSGI kullanırlar.

Benzer şekilde, bir "CGI uygulaması" yapmak isterseniz, büyük ihtimalle PSGI bileşenli bir sayfası yazar ve
PSGI-tabanlı uygulamanın önünde CGI kullanırsınız

## Ön Gereksinimler

Örneği çalıştırabilmek için, öncelikle [Plack](http://plackperl.org/) modulünün yüklenmiş olması gerekir. 

Yükleme işleminin nasıl yapılacağı konusunda [detaya](/how-to-install-a-perl-module-from-cpan) girmeyeceğim, genel
olarak konsola `cpan Plack` ya da `cpanm Plack` yazarak yapabilirsiniz.

Eğer Windows kullanıyorsanız [DWIM Perl for Windows](http://dwimperl.szabgab.com/) sürümü
Plack modülünü içermektedir.

## İlk script

first.psgi adlı bir Perl scripti oluşturacağız - Bu düz bir Perl scriptidir,
son bölümünde bir alt fonksiyon döndürmektedir:

```perl
#!/usr/bin/perl
use strict;
use warnings;

my $app = sub {
  return [
    '200',
    [ 'Content-Type' => 'text/html' ],
    [ 42 ],
  ];
};
```

Tüm script bu kadardır.

Konsolda `plackup first.psgi` komutunu çalıştırın. Aşağıdaki gibi bir çıktı oluşacaktır:

```
HTTP::Server::PSGI: Accepting connections at http://0:5000/
```

Tarayıcınızı açın ve adres çubuğuna http://localhost:5000/ adresini yazın.

Tarayıcınızda <b>42</b> görüyor olmalısınız.

## Dinamik veri ekleme

Dosyada 42 yazan yeri time() ile değiştirin:

```perl
#!/usr/bin/perl
use strict;
use warnings;

my $app = sub {
  return [
    '200',
    [ 'Content-Type' => 'text/html' ],
    [ time() ],
  ];
};
```

Ctrl-C tuş kombinasyonu ile sunucuyu durdurun ve yeniden başlatın.

Sayfayı yeniden yüklediğinizde tarih göreceksiniz. 10 basamaklı uzun bir sayı.

Sayfayı birkaç kez refresh edip yüklerseniz, tarih
değerinin değiştiğini göreceksiniz. Böylelikle PSGI
kullanarak ilk dinamik web uygulamamızı yazmış olduk.

Eğer ki daha okunabilir bir tarih değeri görmek isterseniz, the `time()`
ifadesini `scalar localtime` ifadesi ile değiştirin, sunucuyu restart edip
sayfayı tekrar yükleyin.

## PSGI Kavramını Açıklayalım

.psgi uzantısı önemli değildir. Bu bir standard halini almıştır.
Dosyanızı herhangi bir adla isimlendirebilirsiniz.

Örneğimizdeki alt fonksiyon 3 değerli bir dizi referansı döndürmektedir.
Birincisi [HTTP durum kodudur](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes).
Örneğimizde başarılı anlamına gelen 200 değeridir.

2. değer header bilgisini gösteren, anahtar-değer çiftinden oluşan bir dizi referansıdır. 
Ne tip anahtarlar kulanabileceğimizi belirleyen kesin kurallar vardır, bu örneğimizde
durum kodunu 200 olarak belirlediğimizden, en azından `Content-Type` bilgisini sağlamalıyız.

3. değer ise sayfa içeriğini gösteren bir dizi referansıdır.
Dizi referansı içerik olarak basit bir elemanı gösterebileceği gibi, parçalara
bölünebilen yapıyı da gösterebilir.

PSGI kullanarak bir "web uygulaması" yazmanın temellerini görmüş olduk
Keyfini çıkarın.

