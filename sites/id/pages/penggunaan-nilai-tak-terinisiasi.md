---
title: "Penggunaan Nilai Tak Terinisiasi"
timestamp: 2013-07-04T12:15:15
tags:
  - undef
  - uninitialized value
  - $|
  - warnings
  - buffering
published: true
original: use-of-uninitialized-value
books:
  - beginner
author: szabgab
translator: khadis
---


Ini adalah peringatan paling umum yang akan Anda temui saat menjalankan kode Perl.

Yaitu peringatan, yang tidak akan menghentikan jalannya skrip Anda dan ia hanya tergeneralisasi jika
fitur peringatan diaktifkan. Yang mana hal ini sangat direkomendasikan.

Cara paling umum untuk menghidupkan fitur peringatan adalah dengan menyertakan pernyataan `use warnings;`
di awal skrip atau modul Anda.


Cara lama adalah dengan menambahkan flag `w` pada baris sh-bang. Biasanya sebagai baris pertama skrip Anda
tampak seperti ini:

`#!/usr/bin/perl -w`

Ada perbedaan tentunya, tapi sejak`use warnings` ada selama 12 tahun terakhir,
maka tidak ada alasan untuk menghindarinya. Dengan kata lain:

Selalu gunakan `use warning;`!


Mari kembali pada peringatan sesungguhnya yang ingin saya jelaskan.

## Penjelasan singkat

```
Use of uninitialized value $x in say at perl_warning_1.pl line 6.
```

Artinya variabel `$x` tidak memiliki nilai (nilainya adalah nilai khusus yaitu `undef`).
Baik ia tidak pernah diberi nilai, atau pada beberapa hal `undef` telah disertakan padanya.

Anda harus mencari tempat di mana variabel mendapat perintah terakhir,
atau Anda harus coba memahami mengapa kode tersebut tidak pernah dieksekusi.

## Satu contoh sederhana

Contoh berikut akan menggeneralisasi sebuah peringatan.

```perl
use warning;
use strict;
use 5.010;

my $x;
say $x;
```

Perl itu sangat mengasyikkan, ia memberitahu kita file mana yang menggeneralisasi peringatan dan pada baris yang mana.

## Hanya sebuah peringatan

Seperti yang telah saya sebutkan ini hanya merupakan peringatan. Jika skrip Anda memiliki lebih banyak statemen setelah
statemen `say`, mereka akan dieksekusi:

```perl
use warning;
use strict;
use 5.010;

my $x;
say $x;
$x = 42;
say $x;
```

Hal ini akan menampilkan

```
Use of uninitialized value $x in say at perl_warning_1.pl line 6.

42
```

## Perintah output yang membingungkan

Berhati-hatilah sekalipun jika kode Anda memiliki statemen print sebelum suatu baris
menggeneralisasi sebuah peringatan, seperti pada contoh berikut:

```perl
use warning;
use strict;
use 5.010;

print 'OK';
my $x;
say $x;
$x = 42;
say $x;
```

hasilnya bisa saja membingungkan.

```
Use of uninitialized value $x in say at perl_warning_1.pl line 7.
OK
42
```

Di sini, 'OK', hasil dari `print` terlihat <b>setelah</b>
peringatan, walaupun ia disebut <b>sebelum</b>
kode yang menggeneralisasi peringatan.

Keanehan ini adalah hasil dari `IO buffering`.
Secara default Perl mem-buffer STDOUT, yang merupakan saluran output standar,
meskipun ia tidak mem-buffer STDERR, saluran standar untuk kesalahan (error).

Jadi sementara kata 'OK' menunggu buffer selesai,
pesan peringatan telah muncul terlebih dahulu di layar.

## Mematikan buffering

Untuk menghindari hal ini Anda dapat mematikan fungsi buffering STDOUT.

Hal ini dikerjakan oleh kode berikut: `$| = 1;`
di awal skrip.


```perl
use warning;
use strict;
use 5.010;

$| = 1;

print 'OK';
my $x;
say $x;
$x = 42;
say $x;
```

```
OKUse of uninitialized value $x in say at perl_warning_1.pl line 7.
42
```

(Peringatannya berada pada baris yang sama dengan <b>OK</b> karena kita belum mencetak baris baru
`\n` setelah OK.)

## Scope yang tak diinginkan

```perl
use warning;
use strict;
use 5.010;

my $x;
my $y = 1;

if ($y) {
  my $x = 42;
}
say $x;
```

Kode ini juga menghasilkan `Use of uninitialized value $x in say at perl_warning_1.pl line 11.`

Saya telah beberapa kali mengatur kesalahan ini. Jangan perhatikan penggunaan `my $x`
di dalam blok `if`, yang artinya saya telah membuat variabel $x lain,
memberikan nilai 42 hanya untuk mengeluarkannya dari scope di akhir blok.
($y = 1 hanya sebuah wadah untuk beberapa kode riil dan beberapa syarat riil.
Ia ada hanya agar contoh ini sedikit lebih realistis.)

Ada masalah tentunya saat saya perlu mendeklarasikan sebuah variabel d dalam blok if, tapi tak selalu.
Ketika saya melakukannya karena kesalahan, begitu susah mencari bug-nya.




