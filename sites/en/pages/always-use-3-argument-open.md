---
title: "Always use 3-argument open"
timestamp: 2014-04-06T23:30:01
tags:
  - open
  - utf8
published: true
author: szabgab
---


Always use `open my $fh, '<:encoding(utf8)', $filename or die ...`, the 3-argument version of `open`,
and [never the old way](/open-files-in-the-old-way).


Note the [open](/open-and-read-from-files) call has 3 parameters:

1. The holder of the file-handle which has been just created.  `open` will assign the file-handle to it.
1. The mode of open. (to read, to write,  to append, etc.)
1. Supply the encoding (utf8 in our case).
1. Path to the file.


## Comment to the experts

In the rare cases when you must use the old version, you'll know it.

