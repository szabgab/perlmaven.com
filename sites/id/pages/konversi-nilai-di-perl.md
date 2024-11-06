---
title: "Konversi otomatis dari string ke angka di Perl"
timestamp: 2014-03-15T11:00:00
tags:
  - is_number
  - looks_like_number
  - Scalar::Util
  - casting
  - type conversion
published: true
original: automatic-value-conversion-or-casting-in-perl
books:
  - beginner
author: szabgab
translator: khadis
---


Bayangkan Anda sedang menyiapkan daftar belanja, tertulis di dalamnya

```
"2 potong roti"
```

dan memberikannya pada pasangan Anda yang langsung
melemparkan kesalahan penulisan itu ke wajah Anda.
Selanjutnya "2" di sini adalah string, bukan angka.

Hal ini tentu akan sangat membingunkan, bukan?


## Tipe konversi di Perl

Pada sebagian besar bahasa pemrograman jenis-jenis operand menentukan bagaimana sebuah operator bekerja.
Yaitu, menambahkan dua angka menghasilkan penjumlahan, sementara menambahkan dua string akan menggabungkan keduanya.
Fungsi ini disebut 'operator overloading'.

Perl, bekerja sebaliknya.

Di Perl, operator adalah sesuatu yang mendefinisikan bagaimana sebuah operand digunakan.

Artinya, jika Anda menggunakan operasi bilangan (contohnya penjumlahan) maka kedua nilainya
secara otomatis dikonversikan ke dalam angka. Jika Anda melakukan operasi string
(contohnya penggabungan) maka kedua nilainya dikonversikan ke dalam string.

Programmer bahasa C mungkin menyebutnya <b>casting</b> namun istilah ini
tidak digunakan dalam Perl. Mungkin karena segalanya otomatis.

Perl tidak peduli apakah Anda menulis sesuatu sebagai angka atau string.
Perl mengkonversikan keduanya secara otomatis berdasarkan konteksnya.

Konversi `angka => string` itu mudah.
Hanya seperti membayangkan ada "" mengapit sebuah angka.

Konversi `string => angka` mungkin membuat Anda berpikir sejenak.
Jika sebuah string tampak seperti angka bagi Perl, maka mudah.
Nilai yang berupa angka adalah hal yang sama. Tanpa tanda petik.

Jika ada suatu karakter yang menahan Perl dari mengkonversi string ke
angka, maka Perl akan menggunakannya sebanyak yang ia mampu pada sisi kiri string untuk
angka dan mengabaikan sisanya.

Berikut saya tunjukkan beberapa contohnya:

```
Original   As string   As number

  42         "42"        42
  0.3        "0.3"       0.3
 "42"        "42"        42
 "0.3"       "0.3"       0.3

 "4z"        "4z"        4        (*)
 "4z3"       "4z3"       4        (*)
 "0.3y9"     "0.3y9"     0.3      (*)
 "xyz"       "xyz"       0        (*)
 ""          ""          0        (*)
 "23\n"      "23\n"      23
```

Pada kasus-kasus di mana konversi string ke angka berjalan tidak sempurna,
kecuali yang terakhir, Perl akan mengeluarkan peringatan. Tentu, diasumsikan Anda menggunakan
`use warnings` seperti yang direkomendasikan.

## Contoh

Sekarang Anda lihat tabel tersebut, mari lihat kodenya:

```perl
use strict;
use warnings;

my $x = "4T";
my $y = 3;

```

Penggabungan mengkonversikan kedua nilai tersebut ke dalam string:

```perl
print $x . $y;    # 4T3
```

Penjumlahan angka mengkonversikan kedua nilai ke dalam angka:

```perl
print $x + $y;  # 7
                # Argument "4T" isn't numeric in addition (+) at ...
```

## Argument bukan angka

Itu adalah peringatan yang akan Anda dapat ketika Perl mencoba mengkonversikan
sebuah string ke dalam angka dan konversinya tak sempurna.

Ada banyak peringatan dan pesan kesalahan lainnya di Perl.
Contohnya [Simbol global](https://id.perlmaven.com/simbol-global)
dan [Penggunaan nilai tak terinisiasi](https://id.perlmaven.com/penggunaan-nilai-tak-terinisiasi).

## Bagaimana menghindari munculnya pesan peringatan?

Ini sangat menyenangkan karena Perl akan memperingatkan Anda (jika diminta demikian) ketika tipe konversinya tak sempurna, tapi tidak adakah fungsi
seperti <b>is_number</b> yang akan memeriksa jika string yang diberikan benar-benar sebuah angka?

Ya dan tidak.

Perl tidak memiliki fungsi <b>is_number</b> seolah ini semacam komitmen bahwa pengembang Perl
tahu angka itu seperti apa. Sayangnya banyak orang yang tidak sepenuhnya setuju terhadap hal ini. Ada beberapa sistem
yang menerima ".2" sebagai angka, namun sistem-sistem lain tidak menerimanya.
Bahkan tidak jarang jika "2" tidak diterima, namun ada sistem di mana ia diterima sepenuhnya sebagai angka.

Bahkan ada tempat di mana 0xAB dianggap sebagai angka. Angka heksadesimal.

Jadi tidak ada fungsi <b>is_number</b>, tapi ada fungsi yang disebut <b>looks_like_number</b>.

Itulah yang Anda pikirkan. Ia akan memeriksa apakah string yang ditulis tampak seperti angka bagi Perl.

Ini sudah tersedia dalam modul [Scalar::Util](http://perldoc.perl.org/Scalar/Util.html)
dan Anda dapat menggunakannya seperti berikut:

```perl
use strict;
use warnings;

use Scalar::Util qw(looks_like_number);

print "Berapa potong roti yang akan saya beli? ";
my $potong = <STDIN>;
chomp $potong;

if (looks_like_number($potong)) {
    print "Saya mengerti...\n";
} else {
    print "Maaf, saya tidak mengerti\n";
}
```


Jangan lupa susunya!


