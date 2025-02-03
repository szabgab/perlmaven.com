---
title: "Read section of a file"
timestamp: 2022-09-20T10:15:01
tags:
  - Fcntl
  - SEEK_SET
  - seek
  - read
  - open
published: true
types:
  - screencast
author: szabgab
archive: true
show_related: true
---


I was working on an example script that used a lot of calls to `seek`, but I kept bumping into bugs. I thought it might be a
useful debugging tool to be able to read and print any section of a file given the location of the first byte and the number of bytes.

So here is a quick script I put together.


{% youtube id="S-cI2NxJPDE" file="perl-read-section-of-a-file.mp4" %}

{% include file="examples/read_file_section.pl" %}

The [seek](/seek) command allows you to move the file-reading pointer back and forth in a file so you will be abel to read the file
in an arbitrary order. The `Fcntl` module provides various constants to help you. Using the SEEK_SET constant will tell the
`seek` command to start from the beginning of the file.

The `read` command allows us to read an arbitrary number of bytes from a file into a variable that people usually call a "buffer"
so we used the variable name `$buffer` for it.

This is a sample data file:

{% include file="examples/data/planets.txt" %}


```
$ perl examples/read_file_section.pl examples/data/planets.txt 48 5
'Pluto'

$ perl examples/read_file_section.pl examples/data/planets.txt 48 6
'Pluto
'
```

