---
title: "How to rename multiple files with one command on Windows, Linux, or Mac?"
timestamp: 2013-12-08T11:20:01
tags:
  - Path::Tiny
  - Path::Iterator::Rule
published: true
author: szabgab
---


Given many, many files named like this: my_file_1.php, how
can I rename them to be named like this: my-file-1.php


```perl
use strict;
use warnings;
use 5.010;

my $dir = shift or die "Usage: $0 DIR";

use Path::Iterator::Rule;
use Path::Tiny qw(path);
my $rule = Path::Iterator::Rule->new;

for my $file ( $rule->all( $dir ) ) {
    #say $file;
    my $pt = path $file;
    #say $pt->basename;
    if ($pt->basename =~ /\.php$/) {
        my $newname = $pt->basename;
        $newname =~ s/_/-/g;
        #say "rename " . $pt->path . " to " . $pt->parent->child($newname);
        rename $pt->path, $pt->parent->child($newname);
    }
}
```

Save this as rename.pl and then run it on the command line `perl rename.pl path/to/dir`.

Alternatively, save this as rename.pl, replace the `my $dir ...` line by
`my $dir = "/full/path/to/dir";`
and then you can run it without passing the directory name on the command line.

On **Windows** the path name should be either using slashes:
`my $dir = "c:/full/path/to/dir";`,
or using pairs of back-slashes: `my $dir = "c:\\full\\path\\to\\dir";`.

[Path::Iterator::Rule](https://metacpan.org/pod/Path::Iterator::Rule) will
allow us to [traverse the directory tree](/finding-files-in-a-directory-using-perl),
so we can rename files in the whole tree.

[Path::Tiny](https://metacpan.org/pod/Path::Tiny) helps us extracting the directory
name and building the new name.

Some commented out print-statement were left in, to make it easier to follow what's happening.

## Comments

This code appeared a short path to my desired goal, but also seems to confuse the target directory with a package name:

D:\usr\crt\src\perl>perl rename_0.pl D:\usr\home\img\crocus\try
Can't locate object method "basename" via package "D:\usr\home\img\crocus\try" (perhaps you forgot to load "D:\usr\home\img\crocus\try"?) at rename_0.pl line 14.

What have I mangled?

---
Disqus seems to hide your source code. Try to post the source code on https://gist.github.com/ and then include the link to it here.
---
Gabor --

Thanks for quick response. No, Disqus indeed shows the command dialog that I posted. Here, however, is the source code, where I only hardwired the target directory, instead of using an inline argument:

use strict;
use warnings;
use 5.010;

# (change multiple filenames perl)
#   //perlmaven.com/how-to-rename-multiple-files 
# Cmd line:  perl rename.pl path/to/dir.
#  OR: replace "my $dir ..." with "my $dir = "/full/path/to/dir";" 
#  then run without passing the directory-name argument

my $dir = "D:/usr/home/img/crocus/try";
# my $dir = shift or die "Usage: $0 DIR";

use Path::Iterator::Rule;
use Path::Tiny qw(path);
my $rule = Path::Iterator::Rule->new;
my $tgt = "IMG_20170303_";
 
for my $file ($rule->all($dir)) {
    # say $file;
    my $pt = path $file;
    say $file->basename;
    if ($pt->basename =~ /$tgt/) {
        my $newname = $pt->basename;
        $newname =~ s/$tgt//g;
        say "rename " . $pt->path . " to " . $pt->parent->child($newname);
        rename $pt->path, $pt->parent->child($newname);
    }
}
---
You probably wanted to write $pt->basename; instead of $file->basename; in the line that gives you the trouble.
---
Gabor -- Yep, that did it. Thanks. You may want to change that offending 'say in your example at line 14 -- slipped right by me.
---
Oh there was a bug in the example. I see. Fixed now. Thanks for mentioning.
---
Gabor -- Thanks again. Now that it's working, I realize that I really want to process just one directory, no iteration. What's the easy/right way for that? The iterator's depth rules seem promising:

$rule->min_depth(0);


But is Path::Iterator::Rule the wrong tool in the first place? 
---
Use the built-in glob function of Perl.
