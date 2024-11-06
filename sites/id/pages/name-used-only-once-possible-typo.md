---
title: "Name 'main::x' used only once: possible typo at ..."
timestamp: 2013-11-22T05:15:00
tags:
  - warnings
  - strict
  - possible typo
published: true
original: name-used-only-once-possible-typo
books:
  - beginner
author: szabgab
translator: khadis
---


Jika Anda mendapati peringatan ini pada skrip Perl, artinya Anda tengah dalam masalah besar.


## Menetapkan variable

Menetapkan nilai pada suatu variable, namun tak pernah menggunakannya,
atau menggunakan sebuah variabel tanpa pernah menetapkan suatu nilaipun,
adalah tindakan yang jarang dianggap benar pada kode apapun.

Mungkin hal yang logis adalah jika Anda melakukan kesalahan tulis (typo),
dan karenanya Anda menemui variabel yang hanya dipakai sekali.

Berikut ini adalah sebuah contoh di mana kita <b>hanya menetapkan nilai pada sebuah variabel</b>:

```perl
use warning;

$x = 42;
```

Kode ini akan menghasilkan peringatan sebagai berikut:

```
Name "main::x" used only once: possible typo at ...
```

Bagian "main::" dan $ mungkin membingungkan Anda.
"main::" ada secara asali (default)
setiap variabel dalam Perl adalah bagian dari "main". Ada juga
sejumlah hal yang disebut "main::x" dan hanya satu di antaranya
memiliki tanda $ di awalnya. Jika ini terdengar sedikit membingungkan, jangan khawatir.
Hal ini memang membingungkan, tapi saya harap Anda tak akan berurusan dengan hal ini dalam jangka yang lama.

## Mengambil nilainya saja

Jika Anda mengalami <b>use a variable only once</b>

```perl
use warning;

print $x;
```

maka kemungkinan Anda akan mendapati dua peringatan:

```
Name "main::x" used only once: possible typo at ...
Use of uninitialized value $x in print at ...
```

Salah satu di antaranya adalah yang sedang kita bahas sekarang, sementara yang lainnya dibahas di
[penggunaan nilai tak terinisiasi](https://id.perlmaven.com/penggunaan-nilai-tak-terinisiasi).


## Mana typo-nya?

Anda mungkin bertanya.

Bayangkan seandainya seseorang menggunakan variabel `$l1`. Kemudian, 
Anda ingin coba menggunakan variabel yang sama tapi Anda menuliskan `$ll`.
Tergantung jenis font yang Anda gunakan, keduanya mungkin akan terlihat sangat mirip.

Atau mungkin ada variabel yang disebut `$color` namun karena Anda orang Inggris
dan secara otomatis Anda menulisnya `$colour` saat Anda memikirkannya.

Atau ada variabel yang disebut `$number_of_misstakes` dan Anda tidak memerhatikan
kesalahan tulis pada variabel asli dan Anda menulis `$number_of_mistakes`.

Kini Anda mengerti.

Jika Anda beruntung, kemungkinan Anda akan membuat kesalahan hanya sekali, tapi jika tak seberuntung itu,
dan Anda menggunakan variabel yang tidak tepat dua kali, maka peringatan ini tidak akan muncul.
Akhirnya jika Anda menggunakan variabel yang sama sebanyak dua kali Anda mungkin memiliki alasan tertentu.

Jadi, bagaimana Anda bisa menghindari kesalahan ini?

Yang pertama, coba hindari menggunakan variabel dengan huruf-huruf yang ambigu di dalamnya dan 
berhati-hatilah saat menuliskan nama-nama variabel.

Jika Anda ingin memecahkan masalah ini, gunakan saja <b>use strict</b>!

## use strict

Seperti yang dapat Anda lihat pada contoh-contoh di atas, saya tidak menggunakan strict. Jika saya menggunakannya,
maka bukannya mendapatkan peringatan tentang kemungkinan kesalahan tulis, saya malah akan mendapat kesalahan soal
waktu kompilasi:
[Global symbol requires explicit package name](https://id.perlmaven.com/simbol-global).

Hal tersebut akan terjadi bahkan jika Anda menggunakan variabel yang tidak tepat lebih dari sekali.

Tentu ada saja orang yang mau repot dan menaruh "my" di depan variabel
yang salah itu, tapi Anda bukan salah satunya, kan? Anda akan memikirkan masalahnya dan mencarinya hingga
Anda menemukan nama variabel yang sesungguhnya.

Cara yang paling umum untuk melihat pesan peringatan ini adalah saat Anda tidak menggunakan strict.

Maka Anda dalam masalah besar.

## Masalah lain ketika menggunakan strict

Seperti yang GlitchMr dan komentator anonim tunjukkan, ada beberapa masalah lain:

Kode berikut juga dapat menghasilkan masalah

```perl
use strict;
use warning;

$main::x = 23;
```

Peringatannya adalah: <b>Name "main::x" used only once: possible typo ...</b>

Di sini tampak jelas dari mana 'main' berasal, atau pada
contoh berikutnya, dari mana Mister berasal. (petunjuk: 'main' dan 'Mister' keduanya adalah nama paket.
Jika tertarik, Anda bisa melihat [pesan kesalahan lainnya yang melibatkan hilangnya nama-nama paket](https://id.perlmaven.com/simbol-global)).
Pada contoh berikutnya, nama paketnya adalah 'Mister'.

```perl
use strict;
use warning;

$Mister::x = 23;
```

Peringatannya adalah: <b>Name "Mister::x" used only once: possible typo ...</b>

Contoh berikut ini juga menghasilkan peringatan. Dua kali:

```perl
use strict;
use warning;

use List::Util qw/reduce/;
print reduce { $a * $b } 1..6;
```

```
Name "main::a" used only once: possible typo at ...
Name "main::b" used only once: possible typo at ...
```

Hal ini terjadi karena `$a` dan `$b` adalah
variabel spesial yang digunakan dalam fungsi built-in sehingga
Anda tidak perlu mendeklarasikannya, tapi Anda hanya
menggunakannya sekali saja di sini.
(Sebenarnya belum jelas bagi saya mengapa ini menghasilkan peringatan,
saat kode yang sama menggunakan <b>sort</b> tidak menghasilkan peringatan, tapi
[Perl Monks](http://www.perlmonks.org/?node_id=1021888) mungkin bisa menjawabnya).
