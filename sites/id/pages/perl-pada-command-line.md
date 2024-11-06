---
title: "Perl Pada Command Line"
timestamp: 2013-05-04T05:55:00
tags:
  - -v
  - -e
  - -p
  - i
published: true
original: perl-on-the-command-line
books:
  - beginner
author: szabgab
translator: khadis
---


Sementara kebanyakan [panduan Perl](/perl-tutorial) berhubungan dengan skrip yang disimpan pada sebuah
file, kita juga akan melihat beberapa contoh penggunaan command line.

Sekalipun Anda menggunakan [Padre](http://padre.perlide.org/)
atau IDE lainnya yang memungkinkan Anda untuk menjalankan skrip langsung dari editor itu sendiri,
tetaplah penting untuk mengakrabkan diri dengan command line (atau shell) dan
mampu menggunakan Perl dari sana.


Jika Anda menggunakan Linux, bukalah jendela terminal. Pastikan Anda melihat sebuah
prompt, yang biasanya diakhiri dengan tanda $.

Jika Anda menggunakan Windows, bukalah CMD: klik pada Start -> Run -> ketik "cmd" -> ENTER

Anda akan melihat jendela hitam CMD dengan tanda prompt yang tampak seperti ini:

```
c:\>
```

## Versi Perl

Ketikkan `perl -v`. Kode ini akan memunculkan:

```
C:\> perl -v

This is perl 5, version 12, subversion 3 (v5.12.3)
  built for MSWin32-x86-multi-thread

Copyright 1987-2012, Larry Wall

Perl may be copied only under the terms of either the Artistic License or the
GNU General Public License, which may be found in the Perl 5 source kit.

Complete documentation for Perl, including FAQ lists, should be found on
this system using "man perl" or "perldoc perl". If you have access to the
Internet, point your browser at http://www.perl.org/, the Perl Home Page.
```

Berdasarkan hal ini, kita dapat melihat bahwa saya menggunakan perl versi 5.12.3 yang terinstal pada komputer Windows.


## Mencetak angka

Sekarang ketikkan `perl -e "print 42"`
Skrip tersebut akan memunculkan angka `42` pada layar. Pada Windows, simbol prompt akan muncul pada baris berikutnya

```
c:\perl -e "print 42"
42
c:\>
```

Pada Linux Anda akan melihatnya seperti ini:

```
gabor@pm:~S perl -e "print 42"
42gabor@pm:~S
```

Hasilnya muncul di awal baris, langsung diikuti oleh tanda prompt.
Perbedaan ini dikarenakan ketidaksamaan perilaku interpreter pada kedua command-line.

Pada contoh kita menggunakan penanda `-e` yang memberitahukan Perl,
"Jangan mengira ini sebuah berkas. Kalimat berikutnya pada command-line adalah kode Perl yang sesungguhnya."

Contoh-contoh di atas tentu tidak begitu menarik. Mari saya berikan contoh
yang lebih kompleks:

## Mengganti Java dengan Perl

Perintah ini: `perl -i.bak -p -e "s/\bJava\b/Perl/" resume.txt`
akan mengganti keseluruhan tampilan kata <b>Java</b> dengan kata <b>Perl</b> pada
resume.txt sambil mencadangkan filenya.

Di Linux Anda bahkan dapat menuliskan `perl -i.bak -p -e "s/\bJava\b/Perl/" *.txt`
untuk mengganti Java dengan Perl pada <b>semua</b> berkas .txt Anda

Pada bagian selanjutnya kita akan berbincang-bincang tentang one-liners dan Anda juga akan mempelajari bagaimana menggunakannya.
Perlu dipahami, pengetahuan akan one-liners adalah sangat penting dalam pengembangan Perl.

Ngomong-ngomong jika Anda tertarik pada beberapa one-liners, saya merekomendasikan Anda untuk membaca
[Penjelasan Perl One-Liners](http://www.catonmat.net/blog/perl-book/)
oleh Peteris Krumins

## Selanjutnya

Tutorial berikutnya adalah tentang
[dokumentasi core perl dan dokumentasi modul cpan](/dokumentasi-core-perl-dan-dokumentasi-modul-cpan).


