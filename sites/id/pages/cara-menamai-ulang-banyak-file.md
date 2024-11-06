---
title: "Bagaimana cara menamai-ulang banyak file dengan satu perintah pada Windows, Linux, atau Mac?"
timestamp: 2013-12-28T11:40:00
tags:
  - Path::Tiny
  - Path::Iterator::Rule
published: true
original: how-to-rename-multiple-files
author: szabgab
translator: khadis
---


Ada banyak sekali file dengan nama my_file_1.php, bagaimana
caranya agar saya dapat menamai-ulang menjadi my-file-1.php


```perl
use strict;
use warning;
use 5.010;

my $dir = shift or die "Usage: $0 DIR";

use Path::Iterator::Rule;
use Path::Tiny qw(path);
my $rule = Path::Iterator::Rule->new;

for my $file ( $rule->all( $dir ) ) {
    #say $file;
    my $pt = path $file;
    #say $file->basename;
    if ($pt->basename =~ /\.php$/) {
        my $newname = $pt->basename;
        $newname =~ s/_/-/g;
        #say "rename " . $pt->path . " to " . $pt->parent->child($newname);
        rename $pt->path, $pt->parent->child($newname);
    }
}
```

Simpan kode tersebut sebagai rename.pl dan jalankan pada command line `perl rename.pl path/to/dir`.

Sebagai alternatif, simpan sebagai rename.pl, ganti baris `my $dir ...` dengan
`my $dir = "/full/path/to/dir";`
kemudian Anda dapat menjalankannya tanpa menggunakan nama direktori pada command line.

Pada <b>Windows</b> nama path bisa menggunakan tanda garis miring:
`my $dir = "c:/full/path/to/dir";`,
ataupun menggunakan back-slash: `my $dir = "c:\\full\\path\\to\\dir";`.

[Path::Iterator::Rule](https://metacpan.org/pod/Path::Iterator::Rule) akan
memungkinkan kita untuk [melompati alur direktori](https://perlmaven.com/finding-files-in-a-directory-using-perl),
sehingga kita dapat menamai ulang semua file di semua alur.

[Path::Tiny](https://metacpan.org/pod/Path::Tiny) bisa membantu kita mengekstraksi nama
direktori dan membuat nama baru.
