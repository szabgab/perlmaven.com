---
title: "POD - Plain Old Documentation"
timestamp: 2013-05-22T11:45:59
tags:
  - POD
  - perldoc
  - =head1
  - =cut
  - =pod
  - =head2
  - documentation
  - pod2html
  - pod2pdf
published: true
original: pod-plain-old-documentation-of-perl
books:
  - beginner
author: szabgab
translator: khadis
---


Para programer biasanya benci menulis dokumentasi. Sebagian alasannya
adalah bahwa program seringkali hanya merupakan berkas teks biasa, namun pada beberapa kasus para pengembang
diharuskan menulis dokumentasi pada program pengolah kata.

Hal tersebut membuat kita perlu banyak waktu dan tenaga untuk berlatih menggunakan program pengolah kata 
agar dokumentasinya "tampak bagus" ketimbang membuat konten "yang benar-benar bagus".

Tidak demikian halnya dengan Perl. Biasanya Anda akan menuliskan
dokumentasi modul langsung pada kode sumber dan mengandalkan
program eksternal untuk memformatnya agar tampak lebih baik.


Pada [tutorial Perl](/perl-tutorial) kali ini
kita akan melihat-lihat <b>POD - Plain Old Documentation</b> yaitu
bahasa mark-up yang digunakan para programer Perl.

Berikut ini adalah contoh kode Perl yang menggunakan POD:

```perl
#!usr/bin/perl
use strict;
use warnings;

=pod

=head1 DESKRIPSI

Skrip ini dapat menggunakan 2 buah parameter. Nama atau alamat komputer
dan sebuah perintah. Ia akan mengeksekusi perintah pada komputer dan
mencetak hasilnya pada layar.

=cut

print "Di sinilah Anda meletakkan kode Anda... \n";
```

Jika Anda menyimpannya sebagai `script.pl` dan menjalankannya dengan perintah `perl script.pl`,
Perl akan mengabaikan semua hal yang terletak di antara baris `=pod` dan `=cut`.
Ia hanya akan mengeksekusi kode yang sesungguhnya.

Di sisi lain, jika Anda mengetikkan `perldoc script.pl`, perintah <b>perldoc</b>
akan mengabaikan semua kode yang ada. Ia justru akan memanggil baris antara `=pod` dan `=cut`,
memformatnya berdasarkan aturan tertentu, dan memunculkannya di layar.

Aturan-aturan ini nantinya tergantung pada sistem operasi Anda, namun umumnya mereka sama dengan
apa yang bisa Anda lihat ketika kita belajar
[dokumentasi standar Perl](/dokumentasi-core-perl-dan-dokumentasi-modul-cpan).

Kelebihan dari penggunaan POD adalah bahwa kode Anda tidak akan secara sengaja diberitahukan
tanpa dokumentasi, karena sudah ada di dalam modul-modul dan skrip-skripnya.
Anda juga dapat menggunakan kembali alat-alat dan infrastruktur di komunitas Open Source Perl
yang dibangun untuk komunitas itu sendiri. Sekalipun untuk kepentingan pribadi Anda.

## Terlalu simpel ya?

Asumsinya adalah bahwa jika Anda membuka sebagian besar blokir penulisan dokumentasi, maka lebih banyak orang akan menulis dokumentasi. Daripada belajar
bagaimana menggunakan program pengolah kata untuk membuat dokumen yang tampak bagus, Anda hanya perlu
mengetikkan beberapa teks dengan sedikit tambahan simbol-simbol dan seketika Anda bisa mendapatkan
dokumen yang layak. (Lihat dokumen pada [Meta CPAN](http://metacpan.org/)
untuk melihat versi POD yang terformat dengan baik.)

## Bahasa Markup

Deskripsi detail mengenai [POD markup language](http://perldoc.perl.org/perlpod.html)
dapat ditemukan di [perldoc perlpod](http://perldoc.perl.org/perlpod.html) dan
ini sangat mudah.

Ada beberapa tag seperti `head1` dan `head2`
untuk menandai bagian header yang "sangat penting" dan "agak penting".
Ada pula `=over` yang menyediakan fungsi indentasi dan `=item`
yang memungkinkan pembuatan tulisan dalam bentuk poin-poin, serta banyak lagi yang lainnya.

Lalu ada `=cut` untuk menandai akhir dari POD serta
`=pod` untuk mengawalinya. Meski begitu bagian awalnya tidak begitu diperlukan.

Semua string yang diawali tanda sama dengan `=` seperti karakter pertama pada suatu baris akan
diinterpretasikan sebagai POD markup, dan akan memulai bagian POD yang nantinya akan ditutup menggunakan `=cut`

POD bahkan memungkinkan penyertaan hyper-links menggunakan notasi L&lt;tautan>.

Teks antara bagian markup akan ditampilkan sebagai paragraf teks biasa.

Jika teksnya tidak muncul pada karakter pertama dari baris, ia akan diambil kata per kata,
artinya mereka akan tampak persis seperti apa yang Anda tuliskan: baris panjang akan tetap
dituliskan panjang dan baris pendek akan dituliskan pendek. Ini digunakan pada contoh kode.

Satu hal yang penting untuk diingat adalah bahwa POD membutuhkan baris kosong di sekitar tag.
Jadi

```perl
=head1 Judul
=head2 Subjudul
Teks
=cut
```

tidak akan menampilkan seperti yang Anda harapkan.

## Tampilan

Karena POD merupakan bahasa mark-up maka ia tidak dengan sendirinya mendefinisikan bagaimana suatu teks akan ditampilkan.
Penggunaan `=head1` mengindikasikan hal penting, `=head2` artinya sesuatu yang agak penting.

Program untuk menampilkan POD biasanya akan menggunakan karakter yang lebih besar untuk menampilkan
teks pada bagian head1 daripada bagian head2, menggunakan font yang lebih besar dari teks
biasa. Kendalinya berada pada program penampil.

Perintah `perldoc` yang datang bersama Perl akan menampilkan POD sebagai panduan manual. Hal ini cukup berguna di Linux.
Namun tidak terlalu bagus di Windows.

Modul [Pod::Html](https://metacpan.org/pod/Pod::Html) menyediakan command line yang disebut
`pod2html`. ia dapat mengonversi POD ke dokumen HTML yang dapat dilihat melalui peramban.

Ada juga beberapa program tambahan lagi yang bisa menggeneralisasi berkas pdf atau mobi dari POD.

## Siapa audiensnya?

Setelah melihat teknik ini, mari kita lihat siapa audiensnya?

Komentar (yang diawali dengan tanda #) adalah penjelasan bagi
programer pemelihara. Yaitu orang yang perlu menambahkan fitur-fitur
atau memperbaiki kesalahan program.

Dokumentasi yang ditulis dalam POD adalah untuk pengguna program. Yaitu orang yang tidak boleh
melihat kode sumber program. Yang dalam hal aplikasi tersebut akan
disebut sebagai "pengguna akhir". Siapapun orangnya.

Dalam hal modul Perl, pengguna adalah programmer Perl lainnya yang perlu
membangun aplikasi atau modul-modul lainnya. Merekapun tidak seharusnya
melihat kode sumber Anda. Mereka masih dapat menggunakan
modul Anda hanya dengan membaca dokumentasinya melalui
perintah `perldoc`.


## Kesimpulan

Menuliskan dokumentasi dan membuatnya tampak bagus di Perl tidaklah sulit.


Tutorial berikutnya adalah tentang
[Debugging Perl Scripts](/debugging-perl-scripts)
