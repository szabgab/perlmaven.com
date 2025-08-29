---
title: "Using Travis-CI and installing Geo::IP on Linux and OSX"
timestamp: 2014-09-16T10:30:01
tags:
  - Travis-CI
  - Geo::IP
published: true
author: szabgab
---


Since the article published by Neil Bowers on using
[Travis CI for CPAN distributions](http://blogs.perl.org/users/neilb/2014/08/try-travis-ci-with-your-cpan-distributions.html) I fell in love with the
service. It provides early feedback when I break something, and makes me pay more attention to the changes I make. I just wish they had more platforms available.

Anyway, one of my applications uses [Geo::IP](https://metacpan.org/pod/Geo::IP). I keep having problems installing it on my own machines and
when I turned Travis-CI on for this particular distribution everything broke.

Luckily, after 2 hours of fighting I think I managed to establish the correct procedure.


In case you don't know what [Travis-CI](https://travis-ci.org/) is, the CI stands for Continuous Integration. Once you configured the
[GitHub](http://github.com/) repository of your project, every time you **push** some changes to GitHub, Travis-CI will pick up
the new commit, run whatever compilation and testing you configured and send you an e-mail if something broke.

It is awesome and it is free for Open Source projects.

## Installing Geo::IP on Linux

Let's start installing Geo::IP. While my module declares [Geo::IP](https://metacpan.org/pod/Geo::IP) as a
prerequisite, [cpanm](https://metacpan.org/pod/App::cpanminus), cannot install it. The Perl module itself
has two non-perl prerequisites. One is C version of the GeoIP API, the other is the database holding the mapping used by GeoIP.

In order to install the C version of the API I had to visit [GeoIP Legacy Downloadable Databases](http://dev.maxmind.com/geoip/legacy/downloadable/)
where under **MaxMind-Supported APIs** I found a link to the [Source on GitHub](https://github.com/maxmind/geoip-api-c/releases) of the **C** version.
There I found the latest release, which was 1.6.2 at the time of this writing. It has a big green button saying "GeoIP-1.6.2.tar.gz". Instead of left-clicking on the button,
I copied the link to use with **wget**.

Then my steps to install the C API were as follows:

```
$ wget https://github.com/maxmind/geoip-api-c/releases/download/v1.6.2/GeoIP-1.6.2.tar.gz
$ tar xzf GeoIP-1.6.2.tar.gz
$ cd GeoIP-1.6.2
$ ./configure --prefix /opt/geoip-1.6.2
$ make
$ make check
$ sudo make install
```

(Note, the **make check** step used to have some errors, but in 1.6.2 all the tests passed.)

Obviously one does not need to install it on **/opt** which is owned by root. The library could have been installed in
**~/geoip/** as well, and then I would not need to use `sudo` in the last step.


## Install GeoIP database

The next step is to fetch a copy of the GeoIP database required to install the Geo::IP Perl module.

The same page we visited earlier [GeoIP Legacy Downloadable Databases](http://dev.maxmind.com/geoip/legacy/downloadable/)
also had a link to [GeoIP Legacy Country](http://dev.maxmind.com/geoip/legacy/install/country/) that showed the URL
where the database can be found. The steps I had to do are the following:

```
$ wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
$ gunzip GeoIP.dat.gz
$ sudo mkdir -p /opt/geoip-1.6.2/share/GeoIP/
$ sudo mv GeoIP.dat /opt/geoip-1.6.2/share/GeoIP/GeoIP.dat
```

Of coure, here I already assume the location of the GeoIP C library I've installed in the previous step. Here too, I only
need to use **sudo** because I decided to install the C library in **/opt**.

The 3rd step is that I need to install the Geo::IP module manually. I still cannot rely on the default behavior or cpan-minus
as I need to pass the (non-standard) location of the GeoIP C library to the **Makefile.PL**. I visited
[Geo::IP on MetaCPAN](https://metacpan.org/pod/Geo::IP) where I saw the latest version was 1.43. I also saw the 
**Download** linke. Again, instead of left-clicking it, I copied the URL to be used with **wget**.

These are the step I have to execute at the console:

```
$ wget https://cpan.metacpan.org/authors/id/B/BO/BORISZ/Geo-IP-1.43.tar.gz
$ tar xzf Geo-IP-1.43.tar.gz
$ cd Geo-IP-1.43
$ perl Makefile.PL LIBS='-L/opt/geoip-1.6.2/lib' INC='-I/opt/geoip-1.6.2/include'
$ make
$ make test
$ make install
```

This will test and install the Geo::IP Perl module.


## Travis-CI configuration file

Once I know the correct steps I had to execute on the console, I could put together the Travis-CI configuration file.
In the **before_install** section I simple had to list the same steps one-by-one.

```
branches:
  except:
    - gh-pages
language: perl
perl:
  - "5.20"
  - "5.18"
  - "5.16"
  - "5.14"
  - "5.12"
  - "5.10"
before_install:
  # get the C part of the GeoIP API
  - wget https://github.com/maxmind/geoip-api-c/releases/download/v1.6.2/GeoIP-1.6.2.tar.gz
  - tar xzf GeoIP-1.6.2.tar.gz
  - cd GeoIP-1.6.2
  - ./configure --prefix /opt/geoip-1.6.2
  - make
  - make check  #     (Used to have some errors, but not in 1.6.2)
  - sudo make install

  # get the GeoIP database needed for the tests
  - wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
  - gunzip GeoIP.dat.gz
  - sudo mkdir -p /opt/geoip-1.6.2/share/GeoIP/
  - sudo mv GeoIP.dat /opt/geoip-1.6.2/share/GeoIP/GeoIP.dat

  # install Geo::IP manually
  - wget https://cpan.metacpan.org/authors/id/B/BO/BORISZ/Geo-IP-1.43.tar.gz
  - tar xzf Geo-IP-1.43.tar.gz
  - cd Geo-IP-1.43
  - perl Makefile.PL LIBS='-L/opt/geoip-1.6.2/lib' INC='-I/opt/geoip-1.6.2/include'
  - make
  - make test
```

