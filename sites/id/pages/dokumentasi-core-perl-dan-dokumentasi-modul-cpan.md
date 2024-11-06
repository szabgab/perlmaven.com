---
title: "Dokumentasi Core Perl dan Dokumentasi Modul CPAN"
timestamp: 2013-05-12T08:50:00
tags:
  - perldoc
  - documentation
  - POD
  - CPAN
published: true
original: core-perl-documentation-cpan-module-documentation
books:
  - beginner
author: szabgab
translator: khadis
---


Perl hadir dengan banyak sekali dokumentasi, namun
Anda akan perlu banyak waktu untuk terbiasa menggunakannya. Nah, pada
[ tutorial Perl](/perl-tutorial) kali ini saya akan menjelaskan bagaimana
cara mengakalinya.


##  perldoc di web

Cara paling mudah untuk mengakses dokumentasi core perl
adalah dengan mengunjungi situs [perldoc](http://perldoc.perl.org/).

Di sana terdapat versi HTML dari dokumentasi Perl, bahasa,
serta modul-modul yang datang dengan core Perl seperti yang dirilis Perl 5 Porters.

Ia tidak menyertakan dokumentasi modul CPAN.
Meskipun terdapat kesimpangsiuran, sebagaimana beberapa modul yang tersedia
di CPAN namun juga disertakan dalam distribusi standar Perl.
(Ini sering disebut <b>dual-lifed</b>.)

Anda dapat menggunakan kotak pencarian pada sudut kanan atas. Misalnya Anda dapat
mengetikkan `split` maka Anda akan mendapatkan dokumentasi tentang `split`.

Sayangnya tidak ada penjelasan tentang `while`,
 `$_`, maupun `@_`. Untuk mendapatkan penjelasan tentang hal tersebut
Anda harus menjelajah ke seluruh bagian dokumentasi.

Salah satu halaman yang mungkin penting adalah [perlvar](http://perldoc.perl.org/perlvar.html),
di mana Anda dapat menemukan informasi mengenai variabel-variabel seperti `$_` dan `@_`.

[Perlsyn](http://perldoc.perl.org/perlsyn.html) memberikan penjelasan mengenai sintaks Perl
termasuk [while loop](https://perlmaven.com/while-loop)

## perldoc pada command line

Dokumentasi yang sama juga datang bersamaan dengan kode sumber Perl, namun tidak
setiap distro Linux menyertakannya secara default. Pada beberapa kasus terdapat
paket yang terpisah. Contohnya pada Debian dan Ubuntu paket <b>perl-doc</b>
harus diinstal menggunakan ` sudo aptitude install perl-doc`
sebelum Anda dapat menggunakan `perldoc` tersebut.

Setelah Anda menginstalnya, Anda dapat mengetikkan `perldoc perl` pada command line
barulah Anda akan mendapatkan penjelasan dan daftar isi dari dokumentasi Perl.
Anda dapat menyudahi sesi ini dengan mengetikkan `q`, dan kemudian mengetikkan nama salah satu bab yang ada.
Contohnya: `perldoc perlsyn`.

Cara ini bekerja baik di Linux maupun Windows meskipun penyeranta pada Windows sangat lemah,
sehingga saya tidak merekomendasikannya. Di Linux ini merupakan bacaan reguler sehingga Anda seharusnya telah familiar
dengannya.

## Dokumentasi Modul CPAN

Setiap modul pada CPAN hadir beserta dokumentasi dan contoh-contohnya.
Jumlah dan kualitas dokumentasinya bervariasi
tergantung penulisnya, dan bahkan kadang seorang penulis mampu
membuat dokumentasi yang baik pada modul yang terdokumentasi dengan baik pula.

Setelah Anda menginstal modul dengan nama Module::Name,
Anda dapat mengakses dokumentasinya dengan mengetikkan `perldoc Module::Name`.

Sebenarnya ada cara yang lebih mudah, bahkan
tidak memerlukan instalasi modul sekalipun. Ada beberapa
situs tentang CPAN. Salah satu yang utama adalah [Meta CPAN](http://metacpan.org/)
dan [search CPAN](http://search.cpan.org/).

Keduanya didasarkan pada dokumentasi yang sama, namun keduanya
menghadirkan pengalaman yang berbeda.


## Kata kunci pencarian pada Perl 5 Maven

Tambahan terbaru pada situs ini adalah fitur pencarian berdasarkan kata kunci pada bagian atas bilah menu.
Secara perlahan Anda akan menemukan banyak penjelasan mengenai Perl.
Pada salah satu bagian dokumentasi core Perl dan dokumentasi
modul CPAN yang paling penting juga akan disertakan.

Jika ada yang terlewat di sana, tinggalkan saja komentar di bawah ini,
sertakan kata kunci yang ingin Anda cari dan Anda
akan mendapat penjelasan tentangnya kemudian.


Tutorial berikutnya adalah tentang
[POD-Plain Old Documentation](/pod-plain-old-documentation).
