---
title: "Peringatan Kategori Tak Dikenal"
timestamp: 2013-11-24T08:10:08
tags:
  - ;
  - warnings
  - unknown warnings
published: true
original: unknown-warnings-category
books:
  - beginner
author: szabgab
translator: khadis
---


Saya tidak berpikir ini adalah pesan kesalahan yang sangat sering ditemui di Perl.
Setidaknya, saya tidak ingat pernah melihatnya sebelumnya, tapi belakangan hal ini cukup mengganggu saya
selama di kelas pelatihan Perl.


## Peringatan Kategori Tak Dikenal '1'

Pesan kesalahannya tampak sebagai berikut:

```
Unknown warnings category '1' at hello_world.pl line 4
BEGIN failed--compilation aborted at hello_world.pl line 4.
Hello World
```

Hal ini benar-benar mengganggu, padahal kodenya begitu sederhana:

```
use strict;
use warnings

print "Hello World";
```

Saya melihat kode tersebut cukup lama dan tidak menemukan masalah di dalamnya.
Seperti yang dapat Anda lihat juga, kodenya telah mencetak string "Hello World".

Ini mengherankan dan membuat saya perlu waktu untuk memperhatikannya dengan seksama,
malah mungkin telah Anda ketahui:

Masalahnya adalah ketiadaan tanda titik koma setelah statement
`use warnings`.
Perl mengeksekusi statement print,
hal tersebut mencetak string dan fungsi `print` bernilai 1
mengindikasikan bahwa kode berhasil dijalankan.

Perl mengira saya menuliskan `use warnings 1`.

Ada banyak sekali kategori peringatan, tapi tak satupun yang bernama "1".

## Kategori Peringatan Tak Dikenal 'Foo'

Ini merupakan kasus yang sama.

Pesan kesalahannya berbunyi:

```
Unknown warnings category 'Foo' at hello.pl line 4
BEGIN failed--compilation aborted at hello.pl line 4.
```

dan contoh kode berikut menunjukkan bagaimana interpolasi string bekerja.
Ini adalah contoh kedua yang saya ajarkan, tepat setelah "Hello World".

```perl
use strict;
use warnings

my $name = "Foo";
print "Hi $name\n";
```

## Kurang Titik Koma

Tentu saja semua ini hanya kasus umum
gara-gara titik komanya ketinggalan.
Perl dapat menemukannya hanya
pada pernyataan (statement) berikutnya.

Maka sangat disarankan untuk memeriksa baris sebelum
lokasi yang mengindikasikan pesan kesalahan.
Mungkin di sana kurang tanda titik koma.

