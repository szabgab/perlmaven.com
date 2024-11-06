---
title: "Simbol Global"
timestamp: 2013-06-17T08:15:00
tags:
  - strict
  - my
  - package
  - global symbol
published: true
original: global-symbol-requires-explicit-package-name
books:
  - beginner
author: szabgab
translator: khadis
---


<b>Simbol global memerlukan nama paket yang jelas</b> adalah wajar,
dan menurut saya itu merupakan pesan kesalahan Perl yang menyesatkan. Setidaknya bagi para pemula.

Dengan kata lain "Anda perlu mendeklarasikan variabel dengan <b>my</b>."


## Contoh paling sederhana

```perl
use strict;
use warnings;

$x = 42;
```

Dan kesalahannya adalah

```
Simbol global "$x" memerlukan nama paket yang jelas pada ...
```

Sementara pesan kesalahan yang sesungguhnya itu benar,
ini sedikit berguna bagi programer Perl pemula.
Mereka mungkin tidak belajar apa itu "paket" (package).
Atau sama sekali tidak tahu apa yang bisa lebih eksplisit dari $x?

Kesalahan ini digeneralisasikan oleh <b>use strict</b>.

Penjelasan dalam dokumentasinya adalah:

<i>
Hal ini menggeneralisasi kesalahan waktu kompilasi jika Anda mengakses variabel yang
dideklarasikan melalui "our" atau "use vars", dilokalisasikan melalui "my()", atau sama sekali tidak memenuhi syarat.
</i>

Seorang pemula diharapkan untuk memulai setiap skrip dengan <b>use strict</b>,
dan mungkin akan belajar tentang <b>my</b> jauh sebelum yang lain-lainnya.

Saya tidak tahu apakah teks yang sebenarnya dapat dan harus diubah di perl. Itu bukan tujuan utama
dari postingan ini. Tujuannya adalah untuk membantu pemula untuk memahami pesan kesalahan ini
dalam bahasa mereka.

Untuk menghapus pesan kesalahan di atas Anda perlu menuliskan:

```perl
use strict;
use warnings;

my $x = 42;
```

Begitulah, kita harus <b>mendeklarasikan variabel menggunakan my sebelum penggunaan pertamanya.</b>

## Solusi yang buruk

Solusi "lainnya" adalah dengan menghilangkan <b>strict</b>:

```perl
#use strict;
use warnings;

$x = 23;
```

ia akan tetap bekerja namun kode ini akan menggeneralisasi sebuah peringatan
[Name "main::x" used only once: possible typo at ...](/name-used-only-once-possible-typo)


Ibarat kata, dalam keadaan apapun, sewajarnya Anda tidak mungkin akan mengemudikan mobil tanpa sabuk pengalaman, bukan?

## Contoh 2: scope

Masalah lain yang sering saya jumpai pada para pemula adalah:

```perl
use strict;
use warnings;

my $x = 1;

if ($x) {
my $y = 2;
}

print $y;
```

Pesan kesalahan yang muncul akan sama seperti di atas:

```
Simbol global "$y" memerlukan nama paket yang jelas pada ...
```

yang akan mengejutkan bagi banyak orang. Terutama saat mereka mulai penulisan kode mereka.
Setelah itu mereka mendeklarasikan semua `$y` menggunakan `my`.

Yang pertama, terdapat sedikit masalah visual. Tidak ada indentasi `my $y = 2;`.
Jika itu diindentasi dengan spasi atau sekali tab ke kanan, seperti pada contoh berikut,
sumber permasalahnnya bisa jadi menjadi semakin jelas.

```perl
use strict;
use warnings;

my $x = 1;

if ($x) {
    my $y = 2;
}

print $y;
```

Masalahnya adalah, bahwa variabel `$y` dideklarasikan di dalam blok
(sepasang kurung kurawal) yang artinya ia tidak ada di luar blok tersebut.
Ini disebut <a href="https://perlmaven.com/scope-of-variables-in-perl"><b>scope variable</b></a>

Konsep tentang <b>scope</b> sangat berbeda di antara bahasa-bahasa pemrograman.
Pada Perl, sebuah blok pada kurung kurawal akan menciptakan sebuah scope.
Semua yang dideklarasikan menggunakan `my` tidak akan dapat diakses dari luar blok.

(Ngomong-ngomong `$x = 1` ada hanya supaya kondisi yang menciptakan scope tampak  memenuhi syarat.
Dengan kata lain, `if ($x) {` ada untuk membuat contoh terlihat nyata.)

Solusinya adalah memanggil `print` di dalam blok.

```perl
use strict;
use warnings;

my $x = 1;

if ($x) {
    my $y = 2;
    print $y;
}
```

atau untuk mendeklarasikan variable di luar blok (dan bukan di dalamnya!)

```perl
use strict;
use warnings;

my $x = 1;
my $y;

if ($x) {
    $y = 2;
}

print $y;
```

Metode apa yang Anda ambil akan bergantung pada tugas sebenarnya. Ini hanya solusi yang memungkinkan secara sintaktis.

Tentu jika kita lupa menghapus `my` dari dalam blok, atau jika `$x`-nya salah,
maka kita mendapati peringatan [penggunaan nilai tak terinisiasi](https://perlmaven.com/use-of-uninitialized-value).

## Cara lain

Penjelasan tentang apa yang `our` dan `use vars` bisa lakukan, atau bagaimana kita
bisa memenuhi syarat nama variabel akan dibahas pada postingan lain.

