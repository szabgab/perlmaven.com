---
title: "Download and install Perl"
timestamp: 2013-01-29T11:45:56
tags:
  - download
  - install
  - Windows
  - Linux
  - UNIX
  - Mac OSX
  - DWIM Perl
  - ActivePerl
  - Citrus Perl
published: true
books:
  - beginner
author: szabgab
---


In this part of the [Perl tutorial](/perl-tutorial) series we are going to
see where to **download Perl** from and how to install it.

Perl is maintained and released by a dedicated team of volunteers who call themselves **Perl 5 Porters**.
Once a year they release a new major version of Perl, and a few more times a year they release minor bug fixes.


At the time of this writing, the latest major version was 5.16 (released in May 2012) with 5.16.2 (November 2012)
being the most recent minor release.
The [README on CPAN](http://www.cpan.org/src/README.html) always contains the most up-to-date information.

You will probably also see a version number higher than the most recent stable release - currently it is 5.17.7.
This is a monthly snapshot release of the development tree. It is only for people who closely follow the development of perl.
Not for regular humans and definitely not for production use!

## Perl 5 Porters and downstream distributors

What the Perl 5 Porters release is the source code of Perl.
This code is then taken by various **distributors** or **vendors** (aka. downstream distributors)
and repackaged in an already compiled, binary format.
Most of us use Perl from such **downstream distributors**.

Usually within a few months of any release the various downstream distributors
include the latest revision of Perl but it does not necessarily get to the end users.

If you use Linux you'll get the new version of Perl only if you upgrade your operating system.
This might happen frequently on a home machine, but less often in corporations and
on servers. They tend to upgrade only after a 2-5 years delay. In some cases the delay can be even longer.

This means that the so called **system Perl** on Linux distributions will be a few years out of date.

## Microsoft Windows

There are a number of distributors of Perl on Windows.

Currently I recommend the [Strawberry Perl](http://strawberryperl.com/) distribution.

Besides coming with Padre, [the Perl IDE](http://padre.perlide.org/), it also includes
[Moose, the postmodern object oriented programming](http://moose.perl.org/) framework of Perl.

Out of the box it allows [web development with Perl Dancer framework](http://perldancer.org/).
There is a post on how to
[get started with Perl Dancer](/getting-started-with-perl-dancer).

It also includes modules to read and write Microsoft Excel files and it comes with a lot more extensions.

In the first episode of the [Perl Tutorial](/perl-tutorial) I explained, and in the screencast
showed, [how to install Perl on Windows](/installing-perl-and-getting-started).

Another Perl distribution for Windows is [ActivePerl](http://www.activestate.com/activeperl).
It was created by [ActiveState](http://www.activestate.com/). It is recommended if
you are planning to buy a support or redistribution license.

Yet another distribution is [Citrus Perl](http://www.citrusperl.com/). It is especially interesting
if you are planning to build a cross-platform desktop application for Windows, Linux and Mac OSX. It includes
[wxPerl](http://wxperl.sourceforge.net/), the Perl
wrapper of [wxWidgets](http://www.wxwidgets.org/) on all 3 platforms.

Upgrading of these Perl distributions for Windows usually involves removing the old ones and installing a new one.
Then installing all the additional modules.


## Linux

Every modern Linux distribution comes with perl already installed. In some cases it is not the full package
that was released by the Perl 5 Porters, and in most cases it is not the most recent version either.

Being a bit out of date would not be a problem, but in some cases you will be stuck with a 5-7 years old version of Perl.
You will encounter such cases especially in Linux distributions with long support policy. For example
the Long Term Support of Ubuntu. Of course, every software in those distributions is very old, not only Perl.
Stability has a price!

One of the drawbacks of having an old version of Perl is that there might be CPAN modules
that don't support that version of Perl any more.

To get started with Perl it will be OK to use the one that came with the operating system,
but at one point you might want to install the newest version of Perl. We will go deeper in this
issue in another article, but for now it is enough to say that this became very easy recently with the
development of [Perlbrew](http://www.perlbrew.pl/).

In some Linux distributions not all "standard" Perl is included by default. For example
many distributions leave out the documentation. You can either read it via the
[perldoc web site](http://perldoc.perl.org/), or you can usually install it with
the standard package management system of your operating system.

For example on Debian or Ubuntu you can install the Perl documentation using:

```
sudo aptitude install perl-doc
```

## Mac OSX

I don't have any experience with Mac OSX but as far as I know the situation is
similar to that on Linux.

## UNIX

On the UNIX side the situation is not that good. Some major UNIX distributions are still supplying Perl
from the 5.005 line which is based on a version released in 1995. If possible download and
install a recent version of Perl and use that for any new development.

## Download, compile and install Perl

You can download the source code of Perl from [CPAN](http://www.cpan.org/src/README.html)
and then follow the instructions on that page:

```
wget http://www.cpan.org/src/5.0/perl-5.16.2.tar.gz
tar -xzf perl-5.16.2.tar.gz
cd perl-5.16.2
./Configure -des -Dprefix=$HOME/localperl
make
make test
make install
```

Once you have done this you can check your new version of perl by typing

```
$HOME/localperl/bin/perl -v
```

to make this the default perl, you'd probably want to add to your .bashrc

```
export PATH=$HOME/localperl/bin/:$PATH
```

## Learn Perl directions

The learn Perl website also has its
[recommended approaches to installing Perl](http://learn.perl.org/installing/).
Check that out too.

