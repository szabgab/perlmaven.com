---
title: "Understanding recursive subroutines - traversing a directory tree"
timestamp: 2013-09-18T15:00:00
tags:
  - sub
  - return
  - recursive
  - opendir
  - readdir
published: true
books:
  - beginner
author: szabgab
---


Understanding recursive subroutines was one of the major
break-through in my programming studies. It took me quite a while to understand them,
but once that happened, suddenly a lot of things
became easier. As if a strict limitation was released from me.

I hope the following explanation will help you too:


## A better solution

Just to be clear, if you are reading this because you really
want to <a href="/finding-files-in-a-directory-using-perl">
go through a directory tree</a>, then you should probably
read the article about
[Path::Iterator::Rule](/finding-files-in-a-directory-using-perl).
What you read here is a more manual approach to the problem, that helps
us learn about <b>recursion</b>.

The problem:

## Traversing a directory tree

We have a directory tree hat looks like this:

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

Given the path to the root of this directory tree,
we would like to be able to go through all the elements and do
something with each one of them. For example we would like to print
them.
Even better, we would like to print the above representation of the
directory structure.

Doing

## Traversing a directory tree recursively

Traversing a tree - for example a directory tree - can become complex.
At least until we realize, that the traversing function does not need to know
where it is in the tree. For the traversing subroutine every sub-tree should be the same.

We can have two approaches thinking about this. Let's start with a bottom-up approach.

Let's try to print the content of a directory that has only files in it. No subdirectories.
The following code prints out a flat directory. The script can get a path as its command line
parameter or defaults to the current directory. Inside the `traverse` subroutine we
called it a `$thing` because the user might pass the name of
a file instead of the name of the directory. Therefore we even check if the given thing is a
directory and return immediately, without even giving a warning if it is not:
`return if not -d $thing;`.

Then, we use the `opendir` function to open the directory, and then use the
`readdir` function to read the entries of this directory one-by-one.
Every directory listing contains the `.` representing the current directory,
and `..` representing the parent director. We want to skip them, so we call
`next` when we encounter either of those. Then we print whatever we found in
the directory.

{% include file="examples/flat.pl" %}

What happens if we run it with a path to one of the bottom directories?
It will print the content.

```
$ perl flat.pl root/a/foo
root/a/foo/bar.txt
root/a/foo/baz.txt
```

What happens if we go one step up, and call with the parent directory of that directory:
It prints out all the files and directories immediately in the `root/a` directory.

```
$ perl flat.pl root/a
root/a/aa.txt
root/a/foo
root/a/foo.txt
```

What we need now is to combine the two. What we need is that when the script recognizes
that it found a directory (`root/a/foo` in our case), then it should run the same
function passing to it the path to `root/a/foo`. That is we need out function
to <b>recursively</b> call itself.

We would like to see an output like this:

```
$ perl tree.pl root/a
root/a/aa.txt
root/a/foo
root/a/foo/bar.txt
root/a/foo/baz.txt
root/a/foo.txt
```

For this the only thing we need to do is to add a call to
`traverse("$thing/$sub");`, right after we printed the name of
that directory. The full script will look like this:

{% include file="examples/tree.pl" %}

If we happen to call this on the root directory, we'll see the following:

```
$ perl tree.pl root
root/a
root/a/aa.txt
root/a/foo
root/a/foo/bar.txt
root/a/foo/baz.txt
root/a/foo.txt
root/b.txt
root/c
```

Almost exactly what we wanted to create. the only difference is
that this printout does not include the `root` directory we passed
as a parameter to the script.

Let's see another approach that might help further see how the recursion works.

## Top down approach

In this approach we start by creating a subroutine called `traverse()` that
can get the name of a directory or a file and print it out.

```perl
use strict;
use warnings;
use 5.010;

my $path = shift || '.';

traverse($path);

sub traverse {
    my ($thing) = @_;

    say $thing;
    return;
}
```

We then take this subroutine and extend it. If the given `$thing`
is not a directory then we are done after the printing. If it is a directory
then we go over its immediate content using the `opendir/readdir` pair.
Each item is again needs the exact same treatment as the current one gets, so
we can call `traverse()` for each item in the `while` loop:
This is the additional code:

```perl
    opendir my $dh, $thing or die;
    while (my $sub = readdir $dh) {
        next if $sub eq '.' or $sub eq '..';

        traverse("$thing/$sub");
    }
    close $dh;
```

Each one of the calls to `traverse()` will print the current item
and if it was a directory, it will go over all the elements in it and call
`traverse()` on each subdirectory.

And so on.

It could go on forever but we know at some point it will reach the leafs of the tree,
a directory in which there are no more directories. Then it won't call itself again,
and slowly it will return to the top-most level.

The condition when the recursive function is not called again, in our case the directories
without subdirectories, is usually called the <b>halting condition</b> of the
recursion. A function without such halting condition, will recurse forever.
(Well, not exactly forever as most system would run out of memory before that.
In addition Perl will give a warning `Deep recursion on subroutine` when the
code reaches 100 level depth. If `use warnings;` is in effect.

The full code of the top-down approach looks like this:

{% include file="examples/recurse.pl" %}

And the result of its run is exactly what we wanted:

```
$ perl recurse.pl root
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


## Recursive function

Just to put it together in a concise way. A recursive function
has two major parts. The first one checks for some condition and
returns if that condition was met. This is called the `halting condition`,
or `stop condition`. Then at some later point in the function it calls
itself with a different set of parameters than it was called earlier.

## Other solution using a queue

Besides using recursion this problem can also be solved by
[using a queue](/traversing-the-filesystem-using-a-queue).


And remember, if you really want to
[traverse a directory tree](/finding-files-in-a-directory-using-perl),
you are probably better off using a module that already does that.

## Comments

HI,
Is there any way to change directory path permanently using perl?

For example chdir(path) will do the same but once the perl program gets executed the parent directory will remain the same. My requirement is to change the directory path permanently to a new path. Please help me if any means is there to do that.


---
You cannot do that in any programming language except in the current shell. One needs to understand how processes work in order to understand this. BTW Why post an unrelated question on a random page?

https://perlmaven.com/change-directory-in-perl

<hr>

Hi,
I hope you would not recognize this question as "off topic". I want to go manually trough directories, so I've found your page.
My intention was (for learning and better understanding) to do a system call in each directory. I know that there are other ways to do that.
Now I have the case, that my script seems to run trough the directories in the deep but does not return.
Maybe you can see at first or second view what I am doing wrong.
Thanks in advance, Thomas.
https://pastebin.com/gfxya2nU
PS: my call was: perl eachdir.pl find /i \"sonar\" pom.xml
PPS: The output was
eachdir.pl - Thomas Hofmann 2018 - do it for every dir beneath
startdir [D:\work\perl\eachdir]
in [D:\work\perl\eachdir] - call [find /i "sonar" pom.xml]
Datei POM.XML nicht gefunden
in [D:\work\perl\eachdir/project1] - call [find /i "sonar" pom.xml]

---------- POM.XML
<sonardir>d:\programme\sonar</sonardir>
in [D:\work\perl\eachdir/project1/_main] - call [find /i "sonar" pom.xml]

---------- POM.XML
*** END ***
_________________________________
the tree structure is:
[.]
+-- project1
|....+-- _main
+-- project2
.....+-- _main
__________________________________
PPPS: under linux it would be:
find . -name pom.xml -type f| xargs grep -i sonar

---

Start by reading this: https://perlmaven.com/always-use-strict-and-use-warnings and include print statements with Data::Dumper to show what is the current value of each variable. That will help.

---
Hello Gabor,
Thanks for the hints. I've added strict and warnings, did not change anything. And I changed from simple print to Data::Dumper. The same values are visible as with print.
_______________________
# print "\t in [$startdir] - call [".join(' ',@comm)."]\n";
print Dumper( $startdir, @comm), "____________________\n";
_______________________
The behaviour is the same. It goes from start dir D:\work\perl\eachdir to sub dir D:\\work\\perl\\eachdir/project1 and further to sub sub dir D:\\work\\perl\\eachdir/project1/_main and ends. It does not go back and process the sibling dir of project1 which would be project2 with another child dir _main. Why could it be that the script does not process the former call for dir eachdir?
My assumption was that perl would instanciate a new instance of sub routine dodir and also new instances of the variables defined with my. In this case Perl should return to the calling instance of dodir and process next sub directory. Am I wrong?
Thanks in advance, Thomas


