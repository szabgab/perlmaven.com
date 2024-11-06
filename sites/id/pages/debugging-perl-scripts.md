---
title: "Debugging Perl Scripts"
timestamp: 2013-05-26T12:00:00
tags:
  - -d
  - Data::Dumper
  - print
  - debug
  - debugging
  - $VAR1
  - $VAR2
published: true
original: debugging-perl-scripts
books:
  - beginner
author: szabgab
translator: khadis
---


Ketika saya belajar ilmu komputer di universitas, saya belajar banyak tentang bagaimana menuliskan program,
tapi seingat saya tak ada yang mengajari soal debugging. Kita sering mendengar bagaimana enaknya membuat 
sebuah program baru, tapi tak seorangpun menerangkan bahwa kita justru akan lebih sering menghabiskan waktu untuk coba memahami
kode-kode buatan orang lain.

Ternyata saat kita bersenang-senang menulis program, sebenarnya kita justru menghabiskan
lebih banyak waktu untuk coba memahami apa yang kita (orang lain) tulis dan mengapa
ia tidak berjalan dengan semestinya, daripada waktu yang kita habiskan di awal-awal saat menuliskan program tersebut.


## Apakah debugging itu?

Sebelum program dijalankan, semuanya dalam kondisi baik.

Setelah program dijalankan, ada sesuatu yang tak beres, dan program berjalan dalam kondisi yang buruk.

Tugas kita adalah menemukan di mana letak kesalahannya lalu membetulkannya.

## Apakah pemrograman itu dan apakah bug itu?

Pada dasarnya, pemrograman adalah mengubah dunia dengan memindahkan data dalam variabel-variabel.

Pada setiap langkah program kita mengubah beberapa data dalam sebuah variabel, atau sesuatu di "dunia nyata".
(Contohnya pada kepingan cakram atau pada layar.)

Ketika Anda menulis sebuah program Anda berpikir melalui setiap langkah: nilai apa yang harus dipindahkan ke variabel yang mana.

Bug adalah ketika Anda pikir Anda memasukkan nilai X pada suatu variabel namun kenyataannya yang masuk adalah nilai Y.

Biasanya, di akhir program Anda dapat melihat bahwa program menampilkan hasil yang tidak tepat.

Selama proses eksekusi program, bug dapat berupa munculnya sebuah peringatan atau berhentinya program secara tidak wajar.

## Bagaimana melakukan debug?

Cara langsung untuk men-debug program adalah dengan menjalankan program tersebut, dan periksa jika semua variabel
mengandung nilai yang diharapkan. Anda dapat <b>menggunakan debugger</b> atau menyertakan <b>print statements</b> di dalam
program dan menguji outputnya kemudian.

Perl datang dengan command-line debugger yang sangat hebat. Meskipun saya merekomendasikan Anda untuk mempelajarinya,
ia akan sedikit sulit di awalnya. Saya telah menyiapkan sebuah video di mana saya menunjukkan 
[perintah dasar built-in debugger pada Perl](https://perlmaven.com/using-the-built-in-debugger-of-perl).

IDE, seperti [Komodo](http://www.activestate.com/),
[Eclipse](http://eclipse.org/) dan
[Padre](http://padre.perlide.org/) dilengkapi
dengan debugger berbasis grafis. Dalam beberapa hal saya akan menyiapkan sebuah video tentang ketiganya.

## Statement Print

Banyak orang masih menggunakan strategi lama dengan menambahkan statement print ke dalam kode.

Dalam bahasa yang proses kompilasi dan pembuatannya memakan waktu lama statement print
dinilai sebagai cara yang buruk untuk melakukan debug.
Tidak demikian di Perl, di mana aplikasi besar sekalipun dapat terkompilasi dan berjalan dalam hitungan detik.

Ketika menambahkan statement print waspadalah dalam menambahkan delimeter di sekitar nilai. Hal ini akan mempermudah
deteksi ketika ada kekurangan atau kelebihan spasi pada suatu nilai yang menyebabkan masalah.
Hal tersebut akan susah dimengerti tanpa sebuah delimiter.

Nilai scalar dapat dicetak sebagai berikut:

```perl
print "<$nama_file>\n";
```

Di sini tanda "kurang dari" dan "lebih dari" hanya untuk mempermudah pembaca
untuk melihat konten sesungguhnya pada variabel:

```
<path/to/file
>
```

Jika kode di atas dicetak Anda dapat dengan cepat menemukan bahwa ada baris baru di akhir variabel
$nama_file. Mungkin Anda lupa menggunakan <b>chomp</b>

## Struktur Data Komplek

Kita belum banyak belajar tentang scalar, tapi mari kita melompat ke sini dan tunjukkan bagaimana Anda bisa
mencetak konten dari struktur data yang lebih komplek. Jika Anda membaca bagian ini
sebagai bagian dari tutorial Perl maka mungkin Anda ingin melewatinya untuk lanjut ke entri berikutnya serta kembali lagi nanti.
Namun bukan berarti ini terlalu dini untuk Anda.

Sebaliknya, tetap lanjutkan saja bacanya.

Untuk struktur data yang komplek (references, arrays dan hashes) Anda dapat menggunakan `Data::Dumper`

```perl
use Data::Dumper qw(Dumper);

print Dumper \@an_array;
print Dumper \%a_hash;
print Dumper $a_reference;
```

Ini akan mencetak hal sebagai berikut, yang akan membantu untuk memahami isi dari sebuah variabel,
namun hanya menunjukkan nama generik suatu variabel seperti `$VAR1` dan `$VAR2`.

```
$VAR1 = [
       'a',
       'b',
       'c',
     ];
$VAR1 = {
       'a' => 1,
       'b' => 2
     };
$VAR1 = {
       'c' => 3,
       'd' => 4
     };
```

Saya merekomendasikan penambahan beberapa kode dan cetak nama variabelnya seperti berikut:

```perl
print '@an_array: ' . Dumper \@an_array;
```

untuk mendapatkan:

```
@an_array: $VAR1 = [
        'a',
        'b',
        'c',
      ];
```

atau dengan Data::Dumper seperti:

```perl
print Data::Dumper->Dump([\@an_array, \%a_hash, $a_reference],
   [qw(an_array a_hash a_reference)]);
```

menghasilkan

```
$an_array = [
            'a',
            'b',
            'c',
          ];
$a_hash = {
          'a' => 1,
          'b' => 2
        };
$a_reference = {
               'c' => 3,
               'd' => 4
             };
```

Ada beberapa cara untuk mencetak struktur data namun untuk saat ini `Data::Dumper`
sudah cukup memenuhi kebutuhan kita dan ini terdapat pada setiap instalasi Perl.
Kita akan membahasnya di kemudian hari saja.

