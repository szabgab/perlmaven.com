---
title: "Reading and writing binary files in Perl"
timestamp: 2019-04-07T12:30:01
tags:
  - open
  - binmode
  - raw
published: true
books:
  - beginner
author: szabgab
archive: true
---


Most of the Perl code you'll write will deal with [text files](/what-is-a-text-file) only rarely will
you have to deal with [binary files](/what-is-a-text-file).

Even if you need to deal with binary files, most likely they will be of some standard format, e.g. an image, a zip-file,
an excel file, etc. For most of the standard formats there are specialized libraries that can read and write them.
So you will have high-level abstraction and you won't need to deal with the binary files directly.

Nevertheless it might be useful to take a quick look how binary files can be handled in Perl.


## Opening a binary file for reading

On Unix, Linux, OSX systems the opening of text and binary files are the same.
Only on DOS and MS Windows based system do you need to give some special treatment to the files.

You can do that in either of the following ways:

Open normally, then call `binmode`:

```perl
open my $fh, '<', $filename or die;
binmode $fh;
```

Set the `:raw` layer during the `open` call.

```perl
open my $fh, '<:raw', $filename or die;
```

The `binmode` way was around for longer time, but they have the same effect.

On DOS and Windows systems these both change the filehandle to be in binary mode. On Unix, Linux, and OSX
the `binmode` call or the `:raw` layer have no effect as those are the default anyway.


## Opening a binary file for writing

Open for writing is the same, just use the greater-than sign instead of the less-than sign.

Open normally, then call `binmode`:

```perl
open my $fh, '>', $filename or die;
binmode $fh;
```

Set the `:raw` layer during the `open` call.

```perl
open my $fh, '>:raw', $filename or die;
```

## Reading from a binary file

The big difference between text and binary files is the way we read from them.
When dealing with text-files we usually read line-by-line, or use the [slurp mode](/slurp) to read all the lines
into a single scalar variable.

Binary files have no notion of lines. There might be records or some other sections of the data, but not lines.
Therefore we don't use the same readline operator as we used for the text files.

Instead we use the `read` function that has a weird way of use.

`read FILEHANDLE,SCALAR,LENGTH`

or 

`read FILEHANDLE,SCALAR,LENGTH,OFFSET`

We pass the already open filehandle, then we pass a scalar variable we have already declared and then we tell the function how many bytes to read in.
The function will try to read that many bytes from the file and put them in the scalar variable replacing whatever we had there.

Optionally we can also supply a number to be "OFFSET", telling the `read` function where in scalar variable it should put the newly read bytes.
If we supply the current size of the scalar using the `length` function, then we append the newly read bytes to the end of the scalar variable.

If we read that way repeatedly then we can read the whole content of the file into a single scalar variable. (Of course assuming the file can fit in the
free memory of our computer.)

The following script expects two filenames on the command line and then reads the content of the first file in the `$cont` variable in chunks of 100 bytes.
By the end of the loop the whole file will be in the `$cont` variable.
Then it saves the content to the second file. Effectively copying the content.

{% include file="examples/read_write_binary.pl" %}

Inside the infinite while loop, first we try to read 100 bytes and we assign the value indicating our success or failure to the variable called `$success`.
If `read` returned [undef](/undef) it means there was an error during the read operation. We raise an exception by calling `die`.

If `read` was successful, but it returned 0 that means there were no more bytes to read. We arrived to the end of file, we can leave the loop by calling `last`.

Otherwise we go for another iteration.

After saving the content we print out the size of the two files using the `-s` operator and the size of the scalar variable.
They should be all the same number.

## Meaning of the binary data

Reading and writing binary data is not complicated at all. What is hard is to interpret the meaning of the content properly.
That's why you will prefer ready-made libraries instead of rolling your own code in every case it is possible.

