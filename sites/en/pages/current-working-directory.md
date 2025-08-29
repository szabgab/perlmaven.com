---
title: "Current working directory in Perl (cwd, pwd)"
timestamp: 2017-03-18T12:30:01
tags:
  - Cwd
  - cwd
  - getcwd
  - pwd
published: true
books:
  - beginner
author: szabgab
archive: true
---


Every process and every application running on your computer is associated with a directory on the filesystem, called the "current working directory".

On Microsoft Windows, if you open a **Command Shell** (by running `cmd`) you'll see the current working directory of this shell in the prompt.
(e.g. `c:\users\Foo Bar\Desktop>` indicates that the working directory of this `cmd` window is `c:\users\Foo Bar\Desktop>`.
When configuring a new launcher icon, one can set what should be the initial working directory of the process.

On Linux, Apple OSX, and Unix in general the command `pwd` means **print working directory** and it is used to fetch the current working directory.


Perl has a standard module called [Cwd](http://metacpan.org/pod/Cwd) that provides this functionality via a number of functions.

## cwd

```perl
use Cwd qw(cwd);
my $dir = cwd;

print "$dir\n";
```

## getcwd

```perl
use Cwd qw(getcwd);
my $dir = getcwd;

print "$dir\n";
```


## cwd or getcwd?

In most cases cwd and getcwd will return the same path, but there can be differences.
Specifically if symbolic links are involved.

Let's say we create a directory called "abc" and a **symbolic link** pointing to that directory:

```
$ mkdir abc
$ ln -s abc def
$ ls -l

drwxr-xr-x    2 gabor  staff     68 Aug  9 09:29 abc
lrwxr-xr-x    1 gabor  staff      3 Aug  9 09:30 def -> abc
```

The resulting directory structure looks like this:

<pre>
dir/
   abc
   def -> abc
</pre>


Now let's see what do `cwd` and `getcwd` return if we are in either of those directories.

{% include file="examples/cwd.pl" %}

```
$ cd abc
$ perl ../cwd.pl
   /dir/abc
   /dir/abc
```

```
$ cd ../def
$ perl ../cwd.pl
   /dir/def
   /dir/abc
```

In other words  `cwd` will return the symbolic link (the logical path to where we are) while `getcwd`
will resolve the symbolic link and return the real directory (the hard link) of where we are.

