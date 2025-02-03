---
title: "use Path::Tiny to read and write file"
timestamp: 2015-12-14T20:50:01
tags:
  - Path::Tiny
  - slurp_utf8
  - spew_utf8
  - append_utf8
  - openr_utf8
published: true
author: szabgab
archive: true
---


The modern and compact way to [read from a file](/open-and-read-from-files), to 
[read all the content in slurp-mode](/slurp),
to [read the lines in list context](/reading-from-a-file-in-scalar-and-list-context),
to [write to a file](/writing-to-files-with-perl), or to
[append lines to a file](/appending-to-files) is using
[Path::Tiny](https://metacpan.org/pod/Path::Tiny). Let's see the examples.


## Install

Remember, before you can use Path::Tiny, you need to [install it](/how-to-install-a-perl-module-from-cpan).

## Slurp mode

Slurping the content of a file means reading all the content into one scalar variable. If the file has multiple
lines, as usually text files do, then that scalar variable will have new-line characters (represented by `\n`)
in it. This is usually needed if we are looking for some pattern that can spread more than one lines.
One has to remember that this will read the entire content of the file into memory which is only reasonable if the file
is smaller than the available free memory. You can also see the "native" implementation of the [slurp-mode](/slurp).

{% include file="examples/path_tiny_slurp_file.pl" %}

## Read lines into array using "lines"

In another case we might want to have all the content of the file in an array, where
each line in the file is read into an element of the array. (So the first line of the file will be element 0 of the array.)
In this case too, we have to remember that we read all the content into memory which is only reasonable if the
size of the file is smaller that the available free memory. The same can be achieved without any modules
by putting the [file-handle in list context](/reading-from-a-file-in-scalar-and-list-context).

{% include file="examples/path_tiny_lines_file.pl" %}

## Read file line-by-line

If the file is too big to fit in the memory, or for some other reason we would like to
keep the memory usage low we need to read the file line-by-line. The traditional way,
without using any extra modules, would be to [open the file and read from it](/open-and-read-from-files).
The modern way using Path::Tiny would be to get an iterator and use that, but Path::Tiny version 0.068 does
not support that yet. Instead it allows us to open the file in a more readable way than the built-in `open`
function and then we can use the file-handle as we would in the traditional case.

{% include file="examples/path_tiny_read_file.pl" %}

There is an open [feature request](https://github.com/dagolden/Path-Tiny/issues/107) to add file-line iterators
to Path::Tiny.

## Write to file using "spew"

The native way to [write to a file](/writing-to-files-with-perl) is opening the file for writing and the printing
to the file-handle. Path::Tiny provides a function called `spew` that hides the details of this operation. 

{% include file="examples/path_tiny_write_file.pl" %}

## Append to a file using "append"

You can [append lines to a file](/appending-to-files) without using extra modules,
but Path::Tiny makes it cleaner by hiding the details of opening and closing the file.

{% include file="examples/path_tiny_append_file.pl" %}

## Comments

will append write immediately or only after the file is closed?

<hr>

how do you handle the error in case file doesn't exist ?
