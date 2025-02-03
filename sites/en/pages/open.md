---
title: "open a file in Perl"
timestamp: 2021-04-07T14:30:01
tags:
  - open
published: true
author: szabgab
---


Open for reading:

```
open my $fh, '<:encoding(utf8)', $filename or die "Could not open '$filename' $!"
```


Open for writing:

```
open my $fh, '>:encoding(utf8)', $filename or die "Could not open '$filename' $!"
```

Open to append:

```
open my $fh, '>>:encoding(utf8)', $filename or die "Could not open '$filename' $!"
```


* [Open and read from file](/open-and-read-from-files)
* Always use [3-argument open](/always-use-3-argument-open)
* Never the [old way](/open-files-in-the-old-way)
</ol>

