---
title: "Installing Perl modules from the OS vendor - video"
timestamp: 2015-08-10T00:04:42
tags:
  - aptitude
  - yum
  - ppm
types:
  - screencast
published: true
books:
  - beginner_video
author: szabgab
---


installing-modules-from-the-os-vendor


<slidecast file="beginner-perl/installing-modules-from-the-os-vendor" youtube="RiDiOC3N3Ds" />

Vendors: Debian, Ubuntu Fedora, Red Hat

[WWW::Mechanize](http://metacpan.org/pod/WWW::Mechanize).

```
$ aptitude search www-mechanize | grep perl

$ sudo aptitude install libwww-mechanize-perl
```

```
$ yum search Mechanize | grep perl

$ sudo yum install WWW-Mechanize
```

## ActivePerl

```
ppm install WWW::Mechanize
```

