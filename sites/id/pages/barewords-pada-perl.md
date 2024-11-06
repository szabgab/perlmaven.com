---
title: "Barewords pada Perl"
timestamp: 2013-07-21T07:00:00
tags:
  - bareword
  - strict
published: true
original: barewords-in-perl
books:
  - beginner
author: szabgab
translator: khadis
---


`use strict` memiliki 3 bagian. Salah satu di antaranya, juga sering disebut `use strict "subs"`,
yang mendisfungsikan penggunaan <b>barewords</b> yang tak perlu.

Apa maksudnya?


Tanpa adanya pembatasan ini, kode berikut akan tetap berjalan dan mencetak "hello".

```perl
my $x = hello;
print "$x\n";    # hello
```

Hal tersebut tampak aneh karena biasanya kita meletakkan string di dalam tanda petik tapi
secara default Perl mengijinkan <b>barewords</b> - kata-kata tanpa tanda petik - untuk bertindak layaknya strings.

Kode di atas akan mencetak "hello".

Setidaknya sampai seseorang menambahkan subrutin yang disebut "hello" di atas
skrip Anda:

```perl
sub hello {
  return "zzz";
}

my $x = hello;
print "$x\n";    # zzz
```

Ya. Pada versi ini Perl melihat subrutin hello(), memanggilnya dan menetapkan
nilai kembalinya menjadi $x.

Kemudian, jika seseorang memindahkan subrutinnya ke bagian akhir berkas Anda
setelah penempatan, perl tidak akan melihat adanya subrutin
pada saat penempatan sehingga kita harus kembali menempatkan "hello" pada $x.

Tidak, Anda pastinya tidak ingin berada dalam kekacauan seperti itu karena kesalahan. Atau mungkin saja malah pernah mengalaminya.
Dengan `use strict` pada kode Anda perl tidak akan mengijinkan bareword <b>hello</b>
ada dalam kode Anda, untuk menghindari kekacauan seperti ini.

```perl
use strict;

my $x = hello;
print "$x\n";
```

Menghasilkan pesan kesalahan sebagai berikut:

```
Bareword "hello" not allowed while "strict subs" in use at script.pl line 3.
Execution of script.pl aborted due to compilation errors.
```

## Bagusnya keberadaan barewords

Ada tempat lain di mana barewords dapat digunakan bahkan ketika `use strict "subs"`
berjalan.

Pertama, nama dari subrutin yang kita buat sebenarnya hanyalah barewords.
Itu kan bagus.

Juga, ketika kita mengacu pada sebuah elemen hash kita dapat menggunakan barewords di dalam kurung kurawal
dan kata-kata di sebelah kiri tanda => juga bisa dibiarkan tanpa tanda petik:

```perl
use strict;
use warning;

my %h = ( name => 'Foo' );

print $h {name}, "\n";
```

Pada kedua kasus di atas kode "name" adalah sebuah bareword,
tapi hal ini diperbolehkan bahkan ketika use strict berjalan.


