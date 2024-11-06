---
title: "Panduan Memasang dan Memulai Perl"
timestamp: 2013-04-30T09:15:00
tags:
  - strict
  - warnings
  - say
  - print
  - chomp
  - scalar
  - $
published: true
original: installing-perl-and-getting-started
books:
  - beginner
author: szabgab
translator: khadis
---


Ini adalah bagian pertama dari [tutorial Perl](/perl-tutorial).

Di sini Anda akan belajar bagaimana memasang Perl pada Microsoft Windows
dan bagaimana mulai menggunakannya di Windows, Linux, atau di Mac.

Anda akan dipandu untuk membangun lingkungan pengembangan, terutama:
editor atau IDE apa yang dipakai untuk menulis bahasa Perl?

Kita juga akan melihat contoh sederhana penulisan "Hello World".


## Windows

Untuk Windows, kita akan menggunakan [DWIM Perl](http://dwimperl.szabgab.com/). Ia merupakan sebuah paket
yang mengandung Perl compiler / interpreter, [Padre, IDE untuk Perl](http://padre.perlide.org/)
dan sejumlah ekstensi tambahan dari CPAN.

Untuk memulai silahkan kunjungi [DWIM Perl](http://dwimperl.szabgab.com/)
dan ikuti tautan untuk mengunduh <b>DWIM Perl untuk Windows</b>.

Lalu, unduh berkas exe-nya dan instal di komputer Anda. Sebelumnya,
pastikan Anda tidak memiliki versi lain dari Perl yang sudah terinstal sebelumnya.

Mereka dapat digunakan secara bersamaan namun akan memerlukan banyak penjelasan mengapa sebaiknya kita menggunakan satu versi Perl saja.
Maka dari itu, untuk saat ini gunakan saja satu versi Perl pada komputer Anda.

## Linux

Kebanyakan distro Linux saat ini datang membawa Perl versi terkini.
Untuk saat ini kita akan menggunakan versi tersebut. Untuk editornya,
Anda dapat menginstal Padre-kebanyakan distro Linux menyertakannya pada
paket sistem manajemen resminya. Selain itu, Anda juga dapat menggunakan text editor lainnya.
Jika Anda merasa familiar dengan vim atau Emacs, gunakanlah salah satunya. Selain itu
Gedit juga bisa jadi pilihan.

## Apple

Saya percaya bahwa Macs juga datang dengan Perl atau Anda dapat dengan mudah menginstalnya melalui 
alat bantu instalasi standar.

## Editor dan IDE

Meskipun hal tersebut disarankan demikian, Anda tidak harus menggunakan Padre IDE untuk menuliskan kode Perl.
Pada bagian selanjutnya saya akan membuat daftar sejumlah [editor dan IDE](/editor-perl) yang 
dapat Anda gunakan dalam pemrograman Perl. Meskipun Anda memilih editor lain
saya merekomendasikan - untuk pengguna Windows - untuk menginstal paket DWIM Perl tersebut di atas.

Ia memiliki banyak paket ekstensi Perl sehingga akan menghemat waktu Anda dalam bekerja.

## Video

Jika Anda mau, Anda juga dapat melihat video
[Hello world dengan Perl](http://www.youtube.com/watch?v=c3qzmJsR2H0) yang saya unggah ke YouTube. Anda juga mungkin ingin melihat
[video pelatihan Perl Maven untuk pemula](https://perlmaven.com/beginner-perl-maven-video-course).

## Program pertama

Program pertama Anda akan tampak seperti ini:

```perl
use 5.010;
use strict;
use warning;

say "Hello World";
```

Berikut penjelasan langkah demi langkahnya.

## Hello world

Setelah Anda menginstal DWIM Perl Anda dapat mengklik pada
"Start -> All programs -> DWIM Perl -> Padre" untuk membuka text editor
dengan file baru/kosong.

Ketikkan

```perl
print."Hello World\n";
```

Seperti yang Anda lihat bahwa statement pada Perl diakhiri tanda titik koma `;`.
Tanda `\n` digunakan sebagai tanda baris baru.
String diapit oleh tanda petik `"`.
Fungsi `print` digunakan untuk mencetak hasil ke layar.
Ketika ini dieksekusi Perl akan mencetak teks dan memunculkan baris baru.

Simpan berkas ini dengan nama hello.pl lalu Anda dapat menjalankan kode ini dengan memilih "Run -> Run Script"
Anda akan melihat jendela baru yang memunculkan output dari kode tadi.

Demikianlah, skrip Perl Anda yang pertama.

Mari tingkatkan lagi.

## Perl pada command line untuk non-pengguna Padre

Jika Anda tidak menggunakan Padre atau salah satu dari [IDE](/editor-perl) yang ada,
Anda tidak akan bisa menjalankan skrip Anda dari editor itu sendiri.
Setidaknya secara default demikian adanya. Anda harus membuka shell
(atau cmd di Windows), arahkan ke direktori di mana Anda menyimpan file hello.pl
dan ketikkan:

`perl hello.pl`

Begitulah cara menjalankan skrip dari command line.

## gunakan say() sebagai ganti print()

Mari tambah sedikit baris pada skrip Perl kita:

Pertama mari kita seragamkan versi minimum Perl yang akan kita gunakan:

```perl
use 5.010;
print."Hello World\n";
```

Setelah Anda mengetikkan ini, Anda dapat menjalankan kembali skripnya dengan memilih
"Run -> Run Script" atau dengan menekan <b>F5</b>.
Aplikasi akan secara otomatis menyimpan file sebelum menjalankannya.

Secara umum ini hal yang tepat untuk mengetahui versi minimum Perl yang dibutuhkan untuk menjalankan kode.

Dalam hal ini, cara ini juga menambahkan sedikit fitur baru pada perl termasuk `say`.
`say` sangat mirip dengan `print` namun lebih pendek dan ia
secara otomatis menambahkan baris baru di bagian akhir.

Anda dapat mengubah kode Anda sebagai berikut:

```perl
use 5.010;
say "Hello World";
```

Kita ganti `print` `dengan` `say` serta menghapus `\n` dari akhir string.

Versi aplikasi Anda saat ini bisa jadi merupakan versi 5.12.3 atau 5.14.
Kebanyakan distro Linux saat ini datang membawa Perl versi 5.10 atau yang lebih baru.

Meski demikian, kita masih bisa menggunakan perl versi lama.
Hanya saja tidak akan bisa menggunakan `say()` dan memerlukan beberapa penyesuaian
pada contoh-contoh berikutnya. Saya akan memberi tahu Anda ketika saya menggunakan fitur-fitur
yang memerlukan versi 5.10.

## Safety.net

Di samping itu saya benar-benar merekomendasikan untuk melakukan modifikasi
pada Perl. Untuk itu kita tambahkan 2, yang disebut pragmatas, yang mirip dengan compiler flags
pada bahasa pemrograman lainnya:

```perl
use 5.010;
use strict;
use warning;

say "Hello World";
```

Dalam hal ini kata kunci `use` memerintahkan perl untuk memuat dan memfungsikan setiap pragma.

`strict` dan `warnings` akan membantu Anda menemukan bugs
pada kode atau bahkan kadang membantu mencegah Anda membuat kesalahan penulisan kode sejak awal.
Keduanya begitu mudah digunakan.

## User input

Nah, sekarang kita tingkatkan lagi kode kita dengan meminta user memasukkan namanya dan menyertakannya 
ke dalam respon aplikasi.

```perl
use 5.010;
use strict;
use warning;

say "What is your name?";
my $name = <STDIN>;
say "Hello $name, how are you?";
```

`$name` disebut variabel skalar.

Variabel dideklarasikan menggunakan kata kunci <b>my</b>.
(sebenarnya ini merupakan salah satu syarat `strict`.)

Variabel skalar selalu diawali dengan tanda `$`.
Sedangkan &lt;STDIN&gt; adalah alat untuk membaca baris dari keyboard.

Tulis skrip di atas dan jalankan dengan menekan tombol F5

Skrip akan menanyakan nama Anda. Tuliskan nama Anda dan tekan ENTER agar perl tahu
Anda sudah selesai menuliskan nama Anda.

Anda mungkin akan melihat bahwa outputnya sedikit aneh: tanda koma setelah
nama muncul pada baris baru. Hal ini terjadi karena Anda menekan ENTER saat menuliskan nama Anda,
masuk ke dalam variabel `$name`.

## Menghapus baris tambahan

```perl
use 5.010;
use strict;
use warning;

say "What is your name?" ";
my $name = <STDIN>;
chomp $name;
say "Hello $name, how are you?";
```

Ini merupakan hal wajar di perl, bahwa terdapat fungsi spesial bernama `chomp`
yang digunakan untuk menghapus tambahan baris baru dari string.

## Kesimpulan

Pada setiap skrip yang Anda tulis Anda harus <b>selalu</b> menambahkan `use strict;` dan `use warnings;`
sebagai statement awal. Juga sangat direkomendasikan untuk menambahkan `use 5.010;`.

## Latihan-latihan

Saya telah menyiapkan beberapa latihan.

Cobalah skrip berikut:

```perl
use strict;
use warning;
use 5.010;

say "Hello";
say "World";
```

Hasilnya tampak tidak dalam satu baris. Mengapa? Bagaimana mengatasinya?

## Latihan 2

Tulislah skrip yang meminta user memasukkan dua buah angka.
Lalu cetak hasil penjumlahan kedua angka tersebut.

## Apa Lagi?

Tutorial berikutnya adalah tentang
[editor, IDE dan lingkungan pengembangan pada Perl](/editor-perl)

