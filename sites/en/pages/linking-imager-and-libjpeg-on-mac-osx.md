---
title: "Linking Imager and libjpeg on MacOS-X"
timestamp: 2012-01-04T22:39:41
tags:
  - Imager
published: true
archive: true
---



Posted on 2012-01-04 22:39:41.870354-08 by clanmills

Good news: I have 2 solutions, so I'm not asking anybody to do any work!
I hope this might somebody else - or another reader may wish to share another solution.

## The Issue

The MakeMaker tool (perl Makefile.PL; make ; sudo make install) wants to build
a "universal" binary (compiled for i386 and x86_64). However, libjpeg-7 wouldn't
build as a universal - so we get linker errors. I think (although I'm not certain),
that MakeMaker "learns" its archflags from the file
/System/Library/Perl/5.12/darwin-thread-multi-2level/Config_heavy.pl

## My Environment

I keep the Imager-0.87 and jpeg-7 in the ~/gnu directory
(however the name of the directory is of no significance)

```
644 rmills@rmills-mbp:~/gnu $ dir | egrep -e Imager -e jpeg
drwxr-xr-x@ 118 rmills  staff   3.9K Jan  4 21:44 Imager-0.87/
drwxr-xr-x@ 304 rmills  staff    10K Jan  4 19:56 jpeg-7/
```

(I can't remember from where I downloaded this)

## SOLUTION 1

(which took longer to find)

step a) build jpeg-7 (default = x86_64)

```
$ cd ~/gnu/jpeg-7
$ make clean
$ ./configure
$ make
$ sudo make install
```

step b) build Imager (however tell him to only build x86_64)

```
$ cd ~/gnu/Imager-0.87/
$ env "ARCHFLAGS=-arch x86_64" perl Makefile.PL
...
Libraries found:
  FT2
  GIF
  JPEG
  PNG
  TIFF
Libraries *not* found:
  T1
  Win32
$ make
$ sudo make install
```


## SOLUTION 2

(more complicated and what I thought of first)

build libjpeg.7.dylib for i386 and x86_64 separately and use lipo to combine them.

step a) build "universal libjpeg.7.dylib

```
$ cd ~/gnu/Imager-0.87/
$ make clean
$ ./configure CC=gcc "CFLAGS=-arch i386" --enable-shared
$ make ; cp ./.libs/libjpeg.7.dylib libjpeg.7.dylib.i386
$ make clean
$ ./configure CC=gcc "CFLAGS=-arch x86_64" --enable-shared
$ make
$ cp ./.libs/libjpeg.7.dylib libjpeg.7.dylib.x86_64
$ sudo make install
$ sudo rm ./.libs/libjpeg.7.dylib
$ lipo -arch i386 libjpeg.7.dylib.i386 -arch x86_64 libjpeg.7.dylib.x86_64 -create -output libjpeg. 7.dylib
$ sudo cp libjpeg.7.dylib /usr/local/lib
$ ls -alt *jpeg* | grep dylib

-rwxr-xr-x  1 rmills  staff  659224 Jan  4 19:56 libjpeg.7.dylib
-rwxr-xr-x  1 rmills  staff  376600 Jan  4 19:55 libjpeg.7.dylib.x86_64
-rwxr-xr-x  1 rmills  staff  276748 Jan  4 19:54 libjpeg.7.dylib.i386
```

step b) build Imager

```
$ cd ~/gnu/Imager-0.87
$ make clean
$ perl Makefile.PL
...
Libraries found:
  JPEG
Libraries *not* found:
  FT2
  GIF
  PNG
  T1
  TIFF
  Win32
$ make
$ sudo make install
```

Posted on 2012-01-04 23:45:59.100916-08 by tonyc in response to 13588

A simpler solution is to supply the CFLAGS to configure:

```
./configure --disable-dependency-tracking CFLAGS='-arch x86_64 -arch i386 -arch ppc'
```

when building libjpeg.

I only recently worked this out, solving the same issue for
[RT #73371](https://rt.cpan.org/Ticket/Display.html?id=73371).

Posted on 2012-01-05 07:33:35.615887-08 by clanmills in response to 13588

I received the following very helpful email from Tony. Indeed this works well on Lion.
This is what I used on Snow Leopard:

```
./configure --disable-dependency-tracking CFLAGS='-arch x86_64 -arch i386 -arch ppc'
```

Since Lion doesn't support ppc, you can skip that safely there:

```
./configure --disable-dependency-tracking CFLAGS='-arch x86_64 -arch i386'
```

I only solved this recently, solving
[RT #73371](https://rt.cpan.org/Ticket/Display.html?id=73371)


(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/13588 -->



