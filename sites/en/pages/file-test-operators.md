---
title: "What are -e, -z, -s, -M, -A, -C, -r, -w, -x, -o, -f, -d , -l in Perl?"
timestamp: 2016-12-28T09:01:01
tags:
  - -e
  - -z
  - -s
  - -M
  - -A
  - -C
  - -r
  - -w
  - -x
  - -o
  - -f
  - -d
  - -l
published: true
author: szabgab
archive: true
---


Perl has a bunch of strange-looking unary operators that all look like this `-X`.
They can act on any file or directory name or any file or directory handle.

They return various information about the specific file or directory.


Most of them return [true or false](/boolean-values-in-perl) and normally you would write something like this:

```perl
my $filename = "bla/bla/bla.txt";
if (-e $filename) {
    print "The file '$filename' exists\n";
}
```

`-s` returns the size of the file so you could write:

```perl
my $size = -s $filename;
```

The  `-M`, `-A`, `-C` return the modification, access and inode change dates
on Unix/Linux like systems. On Windows, I think only `-M` is available.
In any case they work in a very strange way. Instead of returning the actual time, they
return the number of days between the timestamp and the start of the current script.

So if the file was modified 1 day before we started the script we get 1.
If it was modified half a day before the script started to run we get 0.5.
If the file was modified after the script started to run, e.g. the script
created the file, then we'll get a negative number.

Try this example:

{% include file="examples/try_minus_m.pl" %}

It printed -1.15740740740741e-05 when I ran it.

## -X operators

Description taken from the official documentation of Perl:

* -r  File is readable by effective uid/gid.
* -w  File is writable by effective uid/gid.
* -x  File is executable by effective uid/gid.
* -o  File is owned by effective uid.
* -R  File is readable by real uid/gid.
* -W  File is writable by real uid/gid.
* -X  File is executable by real uid/gid.
* -O  File is owned by real uid.
* -e  File exists.
* -z  File has zero size (is empty).
* -s  File has nonzero size (returns size in bytes).
* -f  File is a plain file.
* -d  File is a directory.
* -l  File is a symbolic link (false if symlinks aren't supported by the file system).
* -p  File is a named pipe (FIFO), or Filehandle is a pipe.
* -S  File is a socket.
* -b  File is a block special file.
* -c  File is a character special file.
* -t  Filehandle is opened to a tty.
* -u  File has setuid bit set.
* -g  File has setgid bit set.
* -k  File has sticky bit set.
* -T  File is an ASCII or UTF-8 text file (heuristic guess).
* -B  File is a "binary" file (opposite of -T).
* -M  Script start time minus file modification time, in days.
* -A  Same for access time.
* -C  Same for inode change time (Unix, may differ for other platforms)

## Video

See also the [shell-x video](/beginner-perl-maven-shell-x).

