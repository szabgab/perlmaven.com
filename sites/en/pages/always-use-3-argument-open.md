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

<ol>
  <li>The holder of the file-handle which has been just created.  `open` will assign the file-handle to it.</li>
  <li>The mode of open. (to read, to write,  to append, etc.)</li>
  <li>Supply the encoding (utf8 in our case).</li>
  <li>Path to the file.</li>
</ol>


## Comment to the experts

In the rare cases when you must use the old version, you'll know it.

