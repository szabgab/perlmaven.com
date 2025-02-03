---
title: "seek - move the position in the filehandle in Perl"
timestamp: 2020-06-10T23:30:01
tags:
  - seek
  - tell
  - Fcntl
  - SEEK_SET
  - SEEK_CUR
  - SEEK_END
  - eof
published: true
books:
  - beginner
author: szabgab
archive: true
---


In most of the cases we deal with text-files and read them sequentially from the beginning to the end, but sometimes we might need some more complex operations on files.

When you open a file for reading, the operating system maintains an internal variable, the current position in the file.
Every read starts from this position and every read-operation updates the position.

The [seek](https://metacpan.org/pod/distribution/perl/pod/perlfunc.pod#seek)function provided by Perl allows you to move this position without actually reading the content of the file (so without the data transfer from the disk to the memory) and it also allows you to move the position backwards.

The accompanying [tell](https://metacpan.org/pod/distribution/perl/pod/perlfunc.pod#tell) function will always return the index of the current position in the file.


When calling `seek` you need to give it 3 parameters.
* The filehandle that connects you to the file.
* The relative (!) index where to move to. Usually referred to as "POSITION" or "OFFSET".
* The place the index is relative to referred to as "WHENCE" in the documentation of Perl.

It might have been more logical to put the offset after the whence, but this is how it is.

The source (or WHENCE) can have any of the following 3 values:

* 0 beginning of the file (use SEEK_SET)
* 1 current position (use SEEK_CUR)
* 2 end of file (use SEEK_END)

It is better to load the 3 names from the `Fcntl` module than to use the numbers. Using the names make your code
more readable and more portable. (In case we encounter an operating system where different numbers represent the above
locations using the numbers will make your code break.)

The position or offset can be any integer (positive or negative) that makes sense.

{% include file="examples/seek.pl" %}

At first we use the [-s](/how-to-get-the-size-of-a-file-in-perl) operator to fetch the [size of the file](/how-to-get-the-size-of-a-file-in-perl) just to see that the other results make sense.

Then we'll call `seek` with various parameters.

We'll use the following input text file to work on:

{% include file="examples/data/planets.txt" %}

The results are:

```
perl examples/seek.pl examples/data/planets.txt
```

```
file size: 74
0
Ceres
6
-- go to 0
0
Ceres
6
-- go to 20
20
upiter
27
-- go back 14
13
Earth
19
-- go to the end
74
1
-- go 12 from the end
62
ranus
68
```

After opening the file [tell](/tell) will return 0 as we are at the beginning of the file.
Then we read a line (and chomp off the newline from the end). This is "Ceres".
`tell` now returns 6 as our read operations stopped after the newline which is 1 character on Linux and Unix.
so we read the 5 characters of Ceres and the newlines.

The first `seek` call moves the position 0 characters from the beginning of the file (SEEK_SET). That is the beginning of the file. This allows us to read the first line again. (Well, I know this example does not make much sense in any program, this is only here to show you the technique. At the bottom of this page you'll find links to a few more real-world-like examples.)

In the next section we start from the beginning of the file again (SEEK_SET), but this time we move to position 20.
As the return value of `tell` shows this worked. Then we read using the "read to the end of the line" operator of Perl.
This will read from the current position till the next newline character (including that newline character) or the end of the file.
The result is "upiter". At the end of the read `tell` returns the new position which is 27.

In the next section we start from the current position (SEEK_CUR) and go backwards 14 characters. (Being a negative number indicates the direction to `seek`)

In the next section we jump to the end of the file by telling `seek` to start from the end of the file `SEEK_END` and move 0. In all the other places `eof()` would have returned a [false](/boolean-values-in-perl) value, but here it returns a [true](/boolean-values-in-perl) value. (specifically here it returned 1). Here `tell` will return the same number as we got from `-s`, the size of the file.

In the last section we start from the end of the file again (`SEEK_END`) and move 12 characters backwards to position 62
and then read ahead again.


## Move to the beginning of a file

```
seek $fh, 0, SEEK_SET;
```

## Move to the end of a file

```
seek $fh, 0, SEEK_END;
```


## Examples using seek

Other, more real-world like examples can be found in some other articles:

The article about [opening a file to read and write in Perl](/open-to-read-and-write) has an example of using `seek</a>
with [truncate](/truncate).

