---
title: "Use Perl::Tidy module in your application"
timestamp: 2020-11-27T07:30:01
tags:
  - Perl::Tidy
published: true
author: szabgab
archive: true
description: "Perl::Tidy is usually used as a stand-alone program, but sometimes, for example when you'd like to build a GUI for it, you need to be able to use it as part of your application."
show_related: true
---


[Perl::Tidy](https://metacpan.org/pod/Perl::Tidy) is usually used as a stand-alone program to [beautify your Perl code](/run-perl-tidy-to-beautify-the-code).
Sometimes, for example when you'd like to [build a GUI for it](/introducing-perltidy-tk-project), you need to be able to use it as part of your application.

This is a simple example showing how to do it.


## Just some random Perl code

{% include file="examples/tidy/code.pl" %}


## Using the Perl::Tidy module

{% include file="examples/tidy/tidy.pl" %}

