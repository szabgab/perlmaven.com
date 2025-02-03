---
title: "PDE - Perl Development Environment"
timestamp: 2015-02-01T07:30:01
tags:
  - Vagrant
  - VirtualBox
published: true
author: szabgab
archive: true
---


PDE - The Perl Development Environment - is a VirtualBox image of a Linux machine
created to make developing Perl-based applications easy.


## What's in the box?

* Ubuntu 2015.04 32 bit
* [MySQL](http://dev.mysql.com/)
* [MongoDB](https://www.mongodb.org/)
* [Elasticsearch](https://www.elastic.co/)
* [Redis](http://redis.io/)

* Perl 5.22.0
* [Rakudo Perl 6](http://rakudo.org/) 2015.09

List of [Perl 5 Modules and their versions](https://github.com/szabgab/PDE/blob/master/releases/pde-1.1.0.txt)
that were explicitely installed. (In addition there are many others that were pulled in as dependencies of these modules.

## How to install or upgrade

* [Install Vagrant Perl Development Environment](/vagrant-perl-development-environment)
* [Upgrade Vagrant Perl Development Environment](/upgrade-vagrant-perl-development-environment)


## Sources

The code that is need to build and rebuild PDE can be found in
[this GitHub repository](https://github.com/szabgab/PDE/) along with the instructions.
If something is not clear to you then ask. It probably means it was not clear to me either and I'd better
fix it.

## Version 1.1.0

Released on 2015.10.02

* Upgraded the OS we used to Ubuntu 2015.04.
* Added Rakudo Perl 6 2015.09.
* Added NodeJS 4.1.1.
* Added several Perl 5 Modules.
* Upgraded all the other Perl 5 Modules.

[announcement](http://blogs.perl.org/users/gabor_szabo/2015/10/vagrant-perl-development-environment-v110-released.html)

## Version 1.0.0

Released on 2015.08.24

* OS: Ubuntu 12.04
* Perl 5.22.0



## Version 0.0.1

Released on 2015.03.25

Back then it was called PMDE (Perl Maven Development Environment), but later I dropped the M.
It was announced exclusively to the [Perl Maven Pro](https://perlmaven.com/pro/) subscribers.

