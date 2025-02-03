---
title: "Github Actions for Module::Install and showing error log on Linux, Mac OSX, and Windows"
timestamp: 2020-11-16T07:30:01
tags:
  - Module::Install
published: true
author: szabgab
archive: true
show_related: true
---


Earlier we saw how to create [GitHub Actions to run on Linux, Windows, and Mac OSX](/github-actions-running-on-3-operating-systems).
I used that idea on an old module of I maintain that is uses [Module::Install](https://metacpan.org/pod/Module::Install) for packaging.

At first it failed due to missing Module::Install, and even though I had a guess of the source of the problem, I thought it would be a good
opportunity to check how could I see the content of the cpanm log files after a failing installation.


This is what I cam up with. It is used in the repository of the [Math-RPN](https://github.com/szabgab/Math-RPN) module.


{% include file="examples/workflows/perl-os-matrix-show-logs.yml" %}

The thing that is new here, compared to the [annotated example](/github-actions-running-on-3-operating-systems)
is that we have 3 conditional steps. They all run only if one of the previous steps failed.
Each one will run on a particular Operating system.

Each one will show the content of all the log-files created by cpanm in the respecive location on the specific Operating System.

The actual running of the tests come after it as we don't want to see the installation logs if the problem was only in running our own
tests.


We also had to install Module::Install before we tried to install any of our dependencies as that's what
developers who use Module::Install need to do.


Actually the use of Module::Install is discouraged by its current maintainer,
but if you are already using it and don't want to change it now, then this is what you need to do.
