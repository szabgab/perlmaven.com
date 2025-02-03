---
title: "Installing PadWalker on Windows, Linux and Mac OSX"
timestamp: 2013-10-28T20:42:33
tags:
  - PadWalker
published: true
author: szabgab
---


It seems quite a few people who are probably new to Perl want to install the PadWalker module.
Probably in order to use it with the EPIC plugin of Eclipse.

The installation should be simple but when you are new to Perl you
probably don't know how to do it.

So depending on what Operating System and which Perl distribution
you have, let's see the instructions:


## Strawberry Perl or DWIM Perl on Windows

[Strawberry Perl](http://strawberryperl.com/),
comes with an already configured cpan client.

Open the Command Window (Start -> Run -> type in cmd) When you get the "DOS" prompt
type in `cpan PadWalker`.
Please note, module names are case sensitive,
so typing `cpan padwalker` or `cpan Padwalker`
will <b>not</b> work!

```
c:> cpan PadWalker
```


## ActivePerl

There is a graphical tool for this as well, but it might be more simple just to open the
Command Window (Start -> Run -> type cmd). When you get the "DOS" prompt, type in
`ppm install PadWalker`. Please note, this is case sensitive!

```
c:> ppm install PadWalker
```


## Debian/Ubuntu Linux

If you have <b>root</b> rights then probably the best is to install
from the package management system of your Linux distribution.

You can use either `aptitude` or `apt-get`
depending on your persona preferences:

```
$ sudo apt-get install libpadwalker-perl
```

```
$ sudo aptitude install libpadwalker-perl
```

Alternatively, you can follow the instructions with <b>cpanm</b> below.

## RedHat/CentOS Linux

Using the package management system:

```
$ sudo yum install PadWalker
```

Alternatively, you can follow the instructions with <b>cpanm</b> below.


## Mac OSX

Follow the instructions with <b>cpanm</b> below.


## Using cpanm

This is for Linux and OSX systems:

First, if you don't have it installed yet,
then install [cpan minus](http://cpanmin.us) by typing

```
$ \curl -L http://cpanmin.us | perl - App::cpanminus
```

Once it is installed type:

```
$ cpanm PadWalker
```

If you still have questions, please ask them below!

## Comments

Hi, I am trying to build PadWalker-2.2on Strawberry Perl 5.22.1 (64-Bit) on Windows 7 Professional 64-bit and it seems to be having some issues:


C:\Strawberry\cpan\build\PadWalker-2.2-oZwwJ8>dmake
dlltool --def PadWalker.def --output-exp dll.exp
g++ -o blib\arch\auto\PadWalker\PadWalker.xs.dll -Wl,--base-file -Wl,dll.base -mdll -s -L"C:\STRAWB~1\perl\lib\CORE" -L"C:\STRAWB~1\c\lib" PadWalker.o   "C:\STRAWB~1\perl\lib\CORE\libperl522.a" -lmoldname -lkernel32 -luser32 -lgdi32 -lwinspool -lcomdlg32 -ladvapi32 -lshell32 -lole32 -loleaut32 -lnetapi32 -luuid -lws2_32 -lmpr -lwinmm -lversion -lodbc32 -lodbccp32 -lcomctl32 dll.exp
C:/Strawberry/c/bin/../lib/gcc/x86_64-w64-mingw32/4.9.2/../../../../x86_64-w64-mingw32/bin/ld.exe: cannot find -lgdi32
C:/Strawberry/c/bin/../lib/gcc/x86_64-w64-mingw32/4.9.2/../../../../x86_64-w64-mingw32/bin/ld.exe: cannot find -lcomdlg32
C:/Strawberry/c/bin/../lib/gcc/x86_64-w64-mingw32/4.9.2/../../../../x86_64-w64-mingw32/bin/ld.exe: cannot find -ladvapi32
C:/Strawberry/c/bin/../lib/gcc/x86_64-w64-mingw32/4.9.2/../../../../x86_64-w64-mingw32/bin/ld.exe: cannot find -lcomctl32
C:/Strawberry/c/bin/../lib/gcc/x86_64-w64-mingw32/4.9.2/../../../../x86_64-w64-mingw32/bin/ld.exe: cannot find -lgcc_s
C:/Strawberry/c/bin/../lib/gcc/x86_64-w64-mingw32/4.9.2/../../../../x86_64-w64-mingw32/bin/ld.exe: cannot find -ladvapi32
C:/Strawberry/c/bin/../lib/gcc/x86_64-w64-mingw32/4.9.2/../../../../x86_64-w64-mingw32/bin/ld.exe: cannot find -lgcc_s
collect2.exe: error: ld returned 1 exit status
dmake:  Error code 129, while making 'blib\arch\auto\PadWalker\PadWalker.xs.dll'

<hr>

Doesn't seems to install compltetly!! Have no idea what happened here.

RoosterHeadde-MacBook-Pro:~ rhl$ \curl -L http://cpanmin.us | perl - App::cpanminus
% Total % Received % Xferd Average Speed Time Time Time Current
Dload Upload Total Spent Left Speed
100 298k 100 298k 0 0 662k 0 --:--:-- --:--:-- --:--:-- 662k
!
! Can't write to /Library/Perl/5.18 and /usr/local/bin: Installing modules to /Users/rhl/perl5
! To turn off this warning, you have to do one of the following:
! - run me as a root or with --sudo option (to install to /Library/Perl/5.18 and /usr/local/bin)
! - Configure local::lib in your existing shell to set PERL_MM_OPT etc.
! - Install local::lib by running the following commands
!
! cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
!
App::cpanminus is up to date. (1.7043)
RoosterHeadde-MacBook-Pro:~ rhl$ cpanm Padwalker
-bash: cpanm: command not found
RoosterHeadde-MacBook-Pro:~ rhl$ cpan Padwalker
Reading '/Users/rhl/.cpan/Metadata'
Database was generated on Tue, 22 Aug 2017 05:41:03 GMT
Warning: Cannot install Padwalker, don't know what it is.
Try the command

i /Padwalker/

to find objects with matching identifiers.

---

I sudoed to root by using 'sudo su -' then ran the commands:

$ \curl -L http://cpanmin.us | perl - App::cpanminus
Once it is installed type:

$ cpanm PadWalker

And that worked for me...

<hr>

Hi, the ActivePerl solution is not working any more, ppm is discontinued https://www.activestate.com/blog/goodbye-ppm-hello-state-tool/
Now it seems to be a matter of state auth/init/push/pull/activate, but I can't get it to run.
After "state install PadWalker" "state packages" lists PadWalker, but neither ExtUtils::Installed nor Eclipse finds it.
Any help is appreciated...
