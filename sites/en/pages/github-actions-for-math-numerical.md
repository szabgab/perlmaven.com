---
title: "Adding GitHub Actions to Math::Numerical"
timestamp: 2022-10-11T11:50:01
tags:
  - Github
published: true
author: szabgab
archive: true
show_related: true
---


Starting at [CPAN::Digger](https://cpan-digger.perlmaven.com/) I found the [Math::Numerical](https://metacpan.org/dist/Math-Numerical) distribution
without any Continuous Integration configured.


Adding GitHub Actions to this project was quite straigh forward except for two things:

## Adding prerequisites

I had to manually install some prerequsites that were needed for the tests:

```
    - name: Install Modules
      run: |
        cpanm -v
        cpanm --installdeps --notest .
        cpanm --notest Test2::V0
        cpanm --notest Test2::Tools::PerlCritic
        cpanm --notest Test::Pod
        cpanm --notest IPC::Run3
        cpanm --notest Readonly
```

This has been bothering me for some time now so I asked both on [Reddit](https://www.reddit.com/r/perl/comments/y13dgb/cpanm_installing_testdependencies/) and
on [PerlMonks](https://perlmonks.org/?node_id=11147339).

## Disable Windows

I think at the time I was doing this there was some problem with the Windows infrastructure of GitHub Actions or the Perl
that was supposed to be installed on Windows so I had to disable the Windows runner.
The author of the module can later enable it to see if the isses were fixed already.

## Speed

It took 9-10 minutes to run the job on OSX.  (5 min on Ubuntu Linux) The main time consuming part is the installation of the test prerequisites.
I added the <b>--notest</b> flag to the <b>cpanm</b> commands that reduced the run-time to 2 minutes.

## Full configuration file

{% include file="examples/math-numerical-ci.yml" %}

