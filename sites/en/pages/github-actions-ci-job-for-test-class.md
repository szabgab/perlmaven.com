---
title: "GitHub Actions CI job for Perl Test::Class - checking downstream dependencies as well"
timestamp: 2021-02-22T17:30:01
tags:
  - Test::Class
  - CI
  - GitHub
published: true
types:
  - screencast
author: szabgab
archive: true
show_related: true
---


[Test::Class](https://metacpan.org/release/Test-Class) is Perl module that allows you to write jUnit or xUnit style tests. Recently I became the maintainer
of the module. The first thing I did, actually even before becomming the maintainer, is setting up a CI system using GitHub Actions that will test the code
on various versions of Perl.

Then it will proceed and test some of the modules that depend on Test::Class to make sue the changes I make don't break those modules.


{% youtube id="YCRljeO0tIA" file="perl-github-actions-ci-job-for-test-class-2021-02-22.mkv" %}


Let me also include here the configuration file.

{% include file="examples/workflows/test_class.yml" %}

