---
title: "How to build perl from source on Linux"
timestamp: 2014-10-17T07:30:01
description: "Compiling Perl from source code on RedHat, Fedora, CentOS, Ubuntu, Debian and other Linux distributions."
tags:
  - Linux
published: true
author: szabgab
---


Most Linux distributions come with a version of perl, which is often referred as **system perl**. For certain tasks and in
certain cases that's exactly what you need, but there are cases when it's better to build your own copy of Perl. For example,
you might want to use a different version of perl than the one supplied by your vendor. Or you need a threaded (or a non-threaded) version.
Something different from what the vendor of the operating system supplies.

There are even some Linux distributions that by default don't come with perl.
For example the CentOS 5.10 system provided by [Digital Ocean](/digitalocean) does not come with Perl preinstalled.

You could install it using **yum install perl**, but instead of that's let's see how can we **compile perl from source**.
As we would not want to assume an existing installation of Perl, we cannot use [Perlbrew](http://perlbrew.pl/).


Perl, the compiler/interpreter and the various extras that we usually think about when we say "The Perl programming language",
is maintained by a group of people called **Perl 5 Porters**. They regularly release new versions that we can download from
[this page on CPAN](http://www.cpan.org/src/README.html).

At the time of writing this article, the latest production release was **5.20.1**.

That page actually has the instructions how to build perl from source code, but we need a few more things before that will work.

Specifically, we need to install **make** and **gcc**.

On the CentOS system I tried this I had to use the following commands:

```
yum -y install make
yum -y install gcc
```

These are the only commands you need to run as **root**. The rest can be executed either as **root** or as any regular
user.

Once these are installed we can download the source code of perl, and then we can compile it with the following instructions:

```
wget http://www.cpan.org/src/5.0/perl-5.20.1.tar.gz
tar -xzf perl-5.20.1.tar.gz
cd perl-5.20.1
./Configure -des -Dprefix=$HOME/localperl
make
make test
make install
```

This will install perl in the directory **$HOME/localperl**.
This means if you'd like to run this perl you'll need to run

`$HOME/localperl/bin/perl`

(for example `$HOME/localperl/bin/perl -v`)

Alternatively, you can change the `PATH` environment variable:

```
export PATH=$HOME/localperl/bin:$PATH
```

and then you can type `perl -v`.

If you want to make this change persistent, add this line to $HOME/.bashrc

## Threads

By default the above commands will build a non-threaded perl.
If you'd like to have threading compiled into perl, you'll need to change the line running `Configure` to be the following:

```
./Configure -des -Dprefix=$HOME/localperl -Dusethreads
```

For other configuration options check out the [INSTALL](https://metacpan.org/pod/distribution/perl/INSTALL)
file that comes with the source code of perl.

## Faster testing

The `make test` step will run a few hundred thousands unit-tests that come with the source code of perl. This can take
a while, but if you have multiple cores, you can take advantage of them by running the tests in parallel. 
In order to run 3 tests at a time, instead of `make test`, run the following:

```
TEST_JOBS=3 make test_harness
```

## CPAN modules

Once you have (this new) perl in your PATH you can install [CPAN Minus](http://cpanmin.us/) by running the following
command:

```
curl -L http://cpanmin.us | perl - App::cpanminus
```

**CPAN minus** is a client that can easily install third-party modules found on [CPAN](http://www.cpan.org/).

Once the above was done, you can install modules using:

```
cpanm Module::Name
```

## Too much work?

Up till this point it is not really a lot of work, but it can take some time depending on the CPU in your Linux box.
Installing the necessary modules can take quite a lot of time, and some of them will need extra, stuff
to be [installed as root](/install-perl-modules-without-root-rights-on-linux-ubuntu-13-10).

## Comments

How do we build perl with a custom gcc compiler. i.e., with a non out of compiler in the distribution. I need to build latest perl on CentOS 7 with gcc 6.4.0. I have built gcc 6.4.0 and is available in /opt/gcc-6.4.0.

---

Make sure the right gcc comes first in the PATH so when you type
"which gcc" it show the path of the one you'd like to use. That should
be enough.

