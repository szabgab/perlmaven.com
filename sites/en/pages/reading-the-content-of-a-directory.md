---
title: "Reading the content of a directory"
timestamp: 2015-04-26T09:30:01
tags:
  - opendir
  - readdir
  - closedir
published: true
books:
  - beginner
author: szabgab
archive: true
---


If we would like to know the list of file and other things in a given directory we could use the external `ls`
command, but that would make our code platform dependent - Windows has the `dir` command for directory listing -
and it would create an an unnecessary execution of an outside command. Instead of that Perl provide two alternatives.
One of the is called file globbing, and it is usually useful if we are interested in certain subset of files (e.g. all
the files with xml extension), the other one is using the manual `opendir` function with `readdir` and `closedir`.


This approach provides a lower level access than file globbing, and thus it is more flexible.

A directory is quite similar to a file, but it has a special structure, and we cannot just "write to it" as we would
do with a file. Still, before reading the content of this special thing called "directory" we have to ask the
operating system to "open" it. Basically to somehow connect our process to the specific directory.
Perl provides the `opendir` function for this.

It has a slightly strange syntax, similarly to the `open` function but it only accepts two parameters:
the first one is the not-yet defined variable that will hold the `directory handle`, the second is the
relative or absolute path to the directory. Directory handle is quite similar to the file handle we saw
when we [opened a file](/open-and-read-from-files).  In ancient times people used to use
[barewords](/barewords-in-perl) to hold this directory handle, something like `DH` or `DIR`.
Nowadays we use regular lexical scalar variables, usually declared right in the `opendir` like in the following example:

```perl
opendir my $dh, $dir;
```

`opendir` will return true on success, or false on failure setting `$!` with the actual error message
just as `open` does, so a better construct will be to write the following:

```perl
opendir my $dh, $dir or die "Could not open '$dir' for reading: $!\n";
```

## readdir in SCALAR context

Once we have the directory opened we can use the `readdir` function to read the content of
the directory. It can be used either in [list or scalar context](/scalar-and-list-context-in-perl),
just as we were [reading from a file in scalar and list context](/reading-from-a-file-in-scalar-and-list-context).

In scalar context `readdir` will always item one, (the 'next') item from the directory. Once we read everything in,
it will return [undef](/undef-and-defined-in-perl).

A common way to write it is in a `while` loop:

```perl
while (my $thing = readdir $dh) {
    say $thing;
}
```

## readdir in LIST context

The alternative would be to use `readdir` in LIST context. For example, to assign it to an array. In that
case we might want to iterate over it using a `for` loop:

```perl
my @things = readdir $dh;
foreach my $thing (@things) {
    say $thing;
}
```

The big difference is that in the second example, all the content of the directory is read in the memory in one
statement so it uses more memory. This is much less of an issue here than when we reading the content of a file,
as the returned list only contains the names of the things in the directory, which is unlikely to be really big.

Even if we have 100,000 files in a directory, and each one of them has a 10 character long name, it still fits in
1Mb memory.

## closedir

Once we are done reading all the things from the directory we can call `closedir` to officially shut
down the connection between the directory handle and the directory on the disk. We don't have to do this though
as perl will do it for us when the variable holding the directory handle goes [out of scope](/scope-of-variables-in-perl).

## What things?

You might have wondered why did I use a variable name `$thing` instead of `$filename` for the things that `readdir`
returned. The reason is that `readdir` will return everything one can find in a directory.
Those can be filenames, directory names. On Unix/Linux we might have symbolic link and even some other things such as
the things in the `/dev` directory of Unix/Linux. 

The names will also include `.` representing the current directory, and `..` representing the parent directory.

As in most cases we are not interested in those we can skip them using the following snippet:

```perl
if ($thing eq '.' or $thing eq '..') {
    next;
}
```

Let's see the full examples:

## readdir in SCALAR context

{% include file="examples/list_dir_scalar.pl" %}

## readdir in LIST context

{% include file="examples/list_dir.pl" %}

In list context, we might want to employ [grep to filter the unwanted values](/filtering-values-with-perl-grep):

{% include file="examples/list_dir_grep.pl" %}

## what does my $dir = shift // '.' mean?

It is setting a [default value](/how-to-set-default-values-in-perl) to be `.`.

[shift](/shift), if it is outside of any function and does not have a paramater, will return the first element from [@ARGV](/argv-in-perl).
That is the first parameter on the command line.

`//` is the [defined-or operator](/what-is-new-in-perl-5.10--say-defined-or-state). It will return
the value on the left hand side if it is [defined](/undef-and-defined-in-perl). Otherwise it will return the right hand side.

Together this expression says: If there is a value on the command line, put that in `$dir`. If there is no value on the command line
put `'.'` in `$dir` that representes the current directory.


## Comments

what would be te syntax if i want the user to assign the path of the directory

<hr>

could you explain more detail about why '.' represent the current directory not ./ ??

Because that's how it is defined.
AFAIK in most cases they are the same. The trailing slash is optional though in certain shell commands they might behave slightly differently.

<hr>

Good article. One additional thing I think is important to mention is that the $thing you get from readdir is the name of the item, *not* the full path to the item. So if you want to then pass it to open(), a file test operator, or other things expecting a filename, you need to concatenate it to the directory path you opened ($dir in your example). my $path = "$dir/$thing" is usually sufficient but you can also use File::Spec to be portable. It is very common that people miss this when using readdir to iterate.

<hr>

In you book do you highlight the differences between Win32/Linux and Mac OSX or is it Windows or Linux centric

<h2>

Do you have suggestions for adding error handling for the readdir failure in scalar context?

I have been trying to find documentation on how to do error handling for the readdir, but its all a little confusing. I would expect it to be something like:

use strict;
use warnings;
use 5.010;

my $dir = shift // '.';

local $!;
opendir my $dh, $dir or die "Could not open '$dir' for reading '$!'\n";
while (my $thing = readdir $dh) {
if($!) {
die $!;
}
say $thing;
}
closedir $dh;


<hr>


