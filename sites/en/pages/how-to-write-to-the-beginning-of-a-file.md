---
title: "How to write to the beginning of a file?"
timestamp: 2018-08-20T07:30:01
tags:
  - open
  - Path::Tiny
published: true
author: szabgab
archive: true
---


There are plenty of articles explaining how to <a href="/beginner-perl-maven-write-to-file
">write to a file</a> and [how to write to a file](/appending-to-files).

We also have articles on how to [read and write](/open-to-read-and-write)
and if you already know [how to install Perl modules](/how-to-install-a-perl-module-from-cpan) then there is also the
[use of Path::Tiny to read and write files](/use-path-tiny-to-read-and-write-file).

However rarely do we see articles explaining **how to append to the beginning of a file**
or **how to append to the top of a file**.


## Prepend to a text file

First of all, I think I'd write **how to prepend to the beginning of a file**
or **how to prepend to the top of a file**, but that's just nit-picking.

The real thing is that you cannot do that easily as the underlying filesystems don't
make it easy. The only way you can do is to rewrite the whole file with the new content
attached to the beginning of the file.

If the file is relatively small then you can read the whole file into memory into a single scalar
variable, prepend whatever string you wanted to add to the beginning of the file,
and then write the whole thing out to the disk.

If the file is larger than the available free memory then you'd probably need to do this in chunks
using another file as a temporary file.

Let's see the first one, the easier case.

{% include file="examples/prepend.pl" %}

In this one we use the so-called [slurp mode](/slurp) to read the content of the file into a string.

## Prepend to a file with Path::Tiny

If you already know [how to install CPAN modules](/how-to-install-a-perl-module-from-cpan) then
you can use [Path::Tiny](https://metacpan.org/pod/Path::Tiny) to make this shorter.

{% include file="examples/prepend_with_path_tiny.pl" %}

## Comments

Thanks a lot for this useful codes. One question of a beginner: using second version of the code (tiny) at the end of each line I got ^M. I think this has to do with Windows and defines end of line. Interestingly, using the first code (without tiny) after the second version the ^M disappears. So, I'm wondering if there is a way using second version of the code and omitting ^M.


