---
title: "Upgrading perl on Linux or OSX - installing perl using perlbrew without being root"
timestamp: 2019-04-29T07:30:01
description: "Installing new version of Perl on RedHat, CentOS, Debian, Ubuntu, Fedora, or any other Linux distribution."
tags:
  - perlbrew
published: true
author: szabgab
---


Most Linux distribution already come pre-installed with a version of perl, but even if it is not part of the core distribution you
can install perl using `yum install perl` or `apt-get install perl` depending on your package management system.
This will give you a version of perl your vendor has built which can be several years old. In many cases using this perl is a good
choices, but sometimes you'd like to <b>upgrade perl</b> and install a newer version.

Your options are:



* Upgrade the system perl (replacing it by a newer version of Perl) that will make you regret the day you started to use computers. (see below)
* You can [compile Perl from source manually](/how-to-build-perl-from-source-code)
* You can use [Perlbrew](http://perlbrew.pl/) for this.

## Upgrading Perl

Actually, we don't usually "upgrade" perl. We install a newer (or different) version of perl and leave the one
we already had on the system intact. This is usually much better than replacing that version of perl with one we build.
The one that came with the operating system is usually referred to as the <b>system perl</b> and it is there because several
parts of the operating system depend on this perl. Usually it is better to just leave it alone and install another
copy of. If you do change it, be prepared that some of the most important tools in your OS (e.g. apt-get) will stop
functioning properly. It is a fantastic exercise in wasting time.

## Build Perl manually from source

There is another article explaining [how to compile and install perl manually](/how-to-build-perl-from-source-code).

## Using Perlbrew

There is a separate article with an example for [Perlbrew on Linux](/perlbrew-on-linux) that shows an example
where we used the perlbrew that was supplied by the OS.

In this article we are going to us [Perlbrew](http://perlbrew.pl/) that hides some of the steps we had to do in the
manual process and makes it easy to manage the installation and the use of several versions of perl.

## Prerequisites

While we can run perlbrew as any regular Linux/Unix/OSX user, there are a couple of things we will need to install as root.
Specifically we need to have <b>make</b> and <b>gcc</b>.

On CentOS these can be installed by running the following as `root` or using `sudo`

```
yum -y install make
yum -y install gcc
```

On Ubuntu we need these:

```
apt-get -y install build-essential
```

## Install Perlbrew

I've followed the instructions on the web site of [Perlbrew](https://perlbrew.pl/).

It printed the following:

```
## Download the latest perlbrew

## Installing perlbrew
Using Perl </usr/bin/perl>
perlbrew is installed: ~/perl5/perlbrew/bin/perlbrew

perlbrew root (~/perl5/perlbrew) is initialized.

Append the following piece of code to the end of your ~/.profile and start a
new shell, perlbrew should be up and fully functional from there:

    source ~/perl5/perlbrew/etc/bashrc

Simply run `perlbrew` for usage details.

Happy brewing!

## Installing patchperl

## Done.
```

## Perlbrew

Once the installation was ready and I source-ed the configuration with:

```
source ~/perl5/perlbrew/etc/bashrc
```

I could run `perlbrew`

Some of the commands:

`perlbrew available` - lists all the versions of perl that are available in source code format on CPAN for you to
use to brew (build).

`perlbrew list`  - lists all the already brewed perl installations that you can use.

`perlbrew install` - install a new version of perl.

An example how to compile and install a version of Perl:

```
perlbrew install -v perl-5.28.2 -Dusethreads --as perl-5.28.2_WITH_THREADS
```

```
long processing
...
```


## Switch to the newly brewed perl

```
perlbrew switch perl-5.28.2_WITH_THREADS
```

## Switch back to system-perl

```
perlbrew switch-off
```


That's it.

