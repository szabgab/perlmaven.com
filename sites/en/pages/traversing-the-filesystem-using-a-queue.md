---
title: "Traversing the filesystem - using a queue"
timestamp: 2013-09-21T16:30:01
tags:
  - queue
  - opendir
  - readdir
published: true
books:
  - beginner
author: szabgab
---


If you really need to traverse a directory tree, please read the
article about [Path::Iterator::Rule](/finding-files-in-a-directory-using-perl).
This article is mostly for those who would like to see the use a simple queue,
for the generic problem of traversing a tree-like structure.


In another article you can find a solution using [recursion](/recursive-subroutines).
This time we are going to use a queue. That is a data structure where we can `push`
new items to the end and `pull` items from the beginning. In the computational world
such data structures are called [FIFO - First in First out](http://en.wikipedia.org/wiki/FIFO),
because the first item that gets in the queue is the first that will leave it. Even if that happens
later on. In general the sooner an item gets in the queue, the sooner it will get processed. 

In Perl, a regular <b>array</b> can be used as a <b>queue</b>. We can use the
[>push](/manipulating-perl-arrays) function to
add more elements to the "end" of the array (the side where the index has the highest number),
and we can use the [shift](/manipulating-perl-arrays) function to fetch a value
from the "beginning" of the array. The value at index 0.

## Directory

We will use the same directory structure we used with the
[recursive solution](/recursive-subroutines).

```
root
root/a
root/a/aa.txt
root/a/foo
root/a/foo/bar.txt
root/a/foo/baz.txt
root/a/foo.txt
root/b.txt
root/c
```


```perl
use strict;
use warnings;
use 5.010;

my $path = shift || '.';

traverse($path);

sub traverse {
    my @queue = @_;

    while (@queue) {
        my $thing = shift @queue;
        say $thing;
        next if not -d $thing;
        opendir my $dh, $thing or die;
        while (my $sub = readdir $dh) {
            next if $sub eq '.' or $sub eq '..';
            push @queue, "$thing/$sub";
        }
        closedir $dh;
    }
    return;
}
```

The beginning is simple, we allow the user to supply the directory name on
the command line, we `shift` it out from [@ARGV](/argv-in-perl),
but if no value was supplied we default to `'.'` which is the current directory.

Then we call the `traverse()` function and pass the starting path to it.
Actually we don't have to have a subroutine for this, but having subroutines usually
leads to cleaner code. Certainly more reusable code.

Inside the subroutine we declare the `@queue` array with the values
we just got from the caller. (In our case this will be one value.)
The `while` loop will as long as there are items in the queue.
(An array in scalar context will return the number of elements it contains.
If it has any elements then it is a positive number which is considered
[true](/boolean-values-in-perl). When the array
is empty the number of elements is 0 which is considered
[false](/boolean-values-in-perl) in Perl.

`my $thing = shift @queue;` fetches the first element, and then we print it.
If this is NOT a directory, we can skip the rest of the loop and go to handle
the `next` item.

The next section then will read in the items from the immediate subdirectory
and add them to the end of the queue.

```perl
   opendir my $dh, $thing or die;
   while (my $sub = readdir $dh) {
       next if $sub eq '.' or $sub eq '..';
       push @queue, "$thing/$sub";
   }
   closedir $dh;
```

## How can we know the queue will end?

We know we are handling a tree structure that has a limited depth
and we know every directory has a limited number of entries in it.
(We also assume no loops created by symbolic links.)
So we know we have a limited number of items to print.
Once all of them were processed the `@queue` array will
become empty and the main `while` loop will end.

## The result

Running `perl queue.pl root` gives the following output:

```
$ perl queue.pl root
root
root/a
root/b.txt
root/c
root/a/aa.txt
root/a/foo
root/a/foo.txt
root/a/foo/bar.txt
root/a/foo/baz.txt
```

The list of items is exactly the same as in the case of the
[recursive solution](/recursive-subroutines), though the
order of the items is different.

