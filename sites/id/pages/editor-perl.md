---
title: "Editor Perl"
timestamp: 2013-05-04T12:13:00
tags:
  - IDE
  - editor
  - Padre
  - vim
  - emacs
  - Eclipse
  - Komodo
published: true
original: perl-editor
books:
  - beginner
author: szabgab
translator: khadis
---


Skrip Perl atau program-program Perl hanyalah terdiri dari berkas-berkas teks biasa.
Anda dapat menggunakan editor teks apapun untuk membuatnya, namun Anda tidak boleh
menggunakan program pengolah kata. Berikut beberapa editor teks dan IDE yang dapat saya sarankan.

Artikel ini adalah bagian dari [ tutorial Perl](/perl-tutorial).


## Editor atau IDE?

Untuk pengembangan Perl Anda dapat menggunakan editor teks biasa maupun
<b>Integrated Development Environment</b>, atau disebut juga IDE.

Pertama, akan saya jelaskan mengenai editor teks yang terdapat pada sebagian besar platform yang dapat Anda gunakan,
dan kemudian IDE yang tidak tergantung platform.

## Unix / Linux

JIka Anda menggunakan Linux atau Unix, maka editor teks yang umum adalah
[Vim](http://www.vim.org/) dan
[Emacs](http://www.gnu.orgsoftware/emacs/).
Keduanya memiliki filosofi yang berbeda
satu sama lain, dan berbeda dengan kebanyakan editor teks yang ada.

Jika Anda sudah familiar dengan salah satu di antaranya, maka saya merekomendasikan untuk menggunakannya.

Masing-masing dari mereka memiliki koleksi ekstensi atau mode-mode yang memberikan dukungan bagi Perl,
tapi walaupun tanpa hal tersebut keduanya bagus untuk pengembangan Perl.

Jika Anda tidak familiar dengan editor-editor tersebut, maka saya menyarankan
agar Anda memisahkan antara pembelajaran Perl dari pengalaman belajar menggunakan editor tertentu terlebih dahulu.

Kedua editor tadi sebenarnya sangat bagus, namun perlu waktu yang cukup lama untuk menguasainya.

Mungkin sekarang saatnya untuk lebih fokus ke pelajaran Perl terlebih dahulu, dan kemudian mempelajari
salah satu dari editor teks tadi.

Meskipun keduanya bawaan Unix/Linux, baik
<b>Emacs</b> dan <b>Vim</b> juga tersedia untuk sistem operasi lainnya.

## Editor Perl untuk Windows

Di Windows, banyak orang mengggunakan "programmer's editors".

* [Ultra Edit](http://www.ultraedit.com/) yang merupakan sebuah editor komersil
* [TextPad](http://www.textpad.com/) yang merupakan shareware.
* [Notepad++](http://notepad-plus-plus.org/) yang merupakan aplikasi open source dan gratis.

Saya telah banyak menggunakan <b>Notepad++</b> dan saya membiarkannya terinstal pada komputer Windows saya
karena ia sangat bermanfaat.

## Mac OSX

Saya memang tidak memiliki Mac namun berdasarkan banyak voting
[TextMate](http://macromates.com/) adalah yang paling sering digunakan pada Mac
untuk pengembangan Perl.

## Perl IDE

Tak satupun IDE tersebut di atas, yang menyediakan
debugger built-in nyata untuk Perl. Mereka juga tidak memiliki bantuan khusus bahasa.

[Komodo](http://www.activestate.com/) dari ActiveState memiliki harga beberapa ratus dolar Amerika.
Ia juga mempunyai versi gratisnya meski dengan kemampuan terbatas.

Bagi pengguna [Eclipse](http://www.eclipse.org/) mungkin ingin tahu
bahwa terdapat plug-in Perl untuk Eclipse yang disebut EPIC. Ada juga proyek yang disebut
[Perlipse](http://github.com/skorg/perlipse).

## Padre, IDE untuk Perl

Pada bulan Juli 2008 saya mulai menuliskan <b>IDE untuk Perl</b>. Saya menyebutnya Padre -
Perl Application Development and Refactoring Environment atau
[Padre, IDE untuk Perl](http://padre.perlide.org/).

Banyak orang yang bergabung pada proyek ini. Ia terdistribusi melalui banyak distro-distro besar Linux
dan ia juga dapat diinstal dari CPAN. Lihat
[halaman pengunduhan](http://padre.perlide.org/download.html) untuk detailnya.

Pada beberapa aspek, ia memang belum sebaik Eclipse atau Komodo namun pada beberapa hal,
area yang lebih spesifik untuk Perl telah jauh lebih baik daripada keduanya.

Apalagi, ia dikembangkan secara aktif.
Jika Anda mencari <b>editor Perl</b> atau sebuah <b>IDE untuk Perl</b>,
Saya merekomendasikan Anda untuk mencoba.

## Jajak pendapat editor Perl

Pada bulan Oktober 2009 saya mengadakan jajak pendapat dan bertanya
[Editor atau IDE apa yang Anda gunakan untuk pengembangan Perl?](http://perlide.org/poll200910/)

Sekarang Anda dapat memilih untuk menggunakan editor yang ada atau memilih sendiri yang dirasa cocok untuk Anda.

## Lain-lain

Alex Shatlovsky merekomendasikan [Sublime Text](http://www.sublimetext.com/), yang merupakan editor independen untuk semua platform,
namun ia merupakan aplikasi berbayar.

## Selanjutnya

Tutorial berikutnya adalah [Perl pada command line](/perl-pada-command-line)

