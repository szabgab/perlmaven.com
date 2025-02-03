---
title: "cpanm"
timestamp: 2020-05-16T21:30:01
tags:
  - cpanm
  - cpanminus
  - App::cpanminus
  - install
published: true
author: szabgab
archive: true
---


There are several ways to install Perl modules on your system from CPAN, but probably the best is to use
[App::cpanminus](https://metacpan.org/pod/App::cpanminus) also known as [cpanmin.us](https://cpanmin.us/)
or just <b>cpanm</b>.


This is the command you need to install cpanminus before you can use it to install additional modules.

```
curl -L https://cpanmin.us | perl - App::cpanminus
```

