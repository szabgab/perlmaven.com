---
title: "Install Term::ReadLine::Gnu"
timestamp: 2021-02-16T13:30:01
tags:
  - Term::ReadLine::Gnu
published: true
author: szabgab
archive: true
description: "It is not always easy to install the Perl module Term::ReadLine::Gnu"
show_related: true
---


[Term-ReadLine-Gnu](https://metacpan.org/release/Term-ReadLine-Gnu) is used by quite a few modules, including Dist::Zilla,
but it isn't always clear how to install it. Here I collected some of the instructions and tested them on
using Github Actions in [this repository](https://github.com/szabgab/testing-Term-ReadLine-Gnu/actions).


## Show Installed version

Before we see how to install it, let's see how can we display the version after we installed it:

```
perl -MTerm::ReadLine -e 'print "Term::ReadLine $Term::ReadLine::VERSION\n"'
perl -MTerm::ReadLine -e 'print "Term::ReadLine::Gnu $Term::ReadLine::Gnu::VERSION\n"'
```


## Ubuntu system perl

```
sudo apt-get install libterm-readline-gnu-perl
```

## Ubuntu other Perl

Check if the **$TERM** environment variable is set. If not set it:

```
export TERM=xterm-256color
```

Install the development files of the readline C library:

```
apt-get install -y libreadline-dev
```

```
cpanm Term::ReadLine::Gnu
```

## Centos system Perl

```
yum install -y perl
yum install -y epel-release
yum install -y perl-Term-ReadLine-Gnu
```


