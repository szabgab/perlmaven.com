---
title: "How to contribute to an Open Source Perl project"
timestamp: 2020-07-10T18:30:01
tags:
  - Open Source
  - MetaCPAN
  - CPANCover
  - Travis-CI
published: true
author: szabgab
archive: true
---


In the article on [how to prepare for a Perl job interview](/how-to-prepare-for-a-perl-job-interview),
I mentioned, one of the best ways to improve your **hire-ability** is to constantly learn new things, and constantly improve yourself.

There is a generic article on [how to contribute to an Open Source project](https://code-maven.com/how-to-contribute-to-an-open-source-project).

Let me collect a few specific related to Perl.


## Low hanging fruit vs. a more involved contribution?

If you have never contributed to any Open Source project then I think the best thing is to start by small and relatively external contributions.
Find a small and relatively new CPAN module and contribute something small. e.g. a test-case for which you "only" need to know how to use the module
you don't need to understand the code.

You could also write an example on how to use the module and improve the documentation.

In any case I'd select a recently uploaded module to [MetaCPAN](https://metacpan.org/) because you have more chances of finding an active author
and thus you have abetter chance for your contribution to be dealt with soon.

Alternatively you could pick a large and complex project you have already used and try to fix a bug there or add a feature. It requires a lot more involvement
and a lot more time investment, but the potential reward is also bigger.

I'd probably start with small projects and once I got used to the idea and once I had a few successes I'd get more involved in the small projects and
then move on to larger ones.


## Finding a project

There are tons of Perl modules on [CPAN](https://metacpan.org/),
that would benefit from better documentation and/or working examples.

[MetaCPAN](https://metacpan.org/) itself is written in Perl and you can contribute to it.

If you need more directed suggestions, there are plenty of modules on the
[CPAN Adoption Candidates list](http://neilb.org/adoption/index.html) created and maintained by [Neil Bowers](http://neilb.org/).

MetaCPAN provides the list of [recently uploaded modules](https://metacpan.org/recent). You can look around there and find a module that you are interested in. You can event send an e-mail to the person who uploaded the most recent version, asking them if you could help.

Instead of sending an e-mail, you could also already send some improvements. But what and how?

## What to contribute?

MetaCPAN links to the bug-tracking system of each module. You can find reported bugs there
and sometimes even feature requests.
You can try to fix a bug or implement those features.

Even if you cannot fix the bug, you could write a test case that will reproduce the bug.
The [testing](/testing) series will introduce you to the testing system of Perl.

Alternatively, using [Devel::Cover](https://metacpan.org/pod/Devel::Cover), you can create a report
to see which parts of the code have tests. You could even go to [CPAN Cover](http://cpancover.com/)
where you'll find test-coverage reports generated for each CPAN distribution.
You could write a test case for a part of the code that is not covered yet, even if there is no reported bug in that area.

## How to contribute?

Most Perl Modules use Git and GitHub as their version control system.
If that's the case for the module you selected then there will be a link to it called "Repository"
on the left-hand side of its MetaCPAN page.

A while ago I've prepared a screencast showing an example on
[how to contribute to a Perl module](/contributing-to-a-perl-module-on-cpan-using-vim-and-github).
Watch that and follow those steps.

## Adopting a module

Adopting a module might feel to be too big a step if you have not published anything on CPAN yet, but nevertheless that's
a good path for your self-education.

## License and link to GitHub

A low hanging fruit is to [add a license](/how-to-add-the-license-field-to-meta-files-on-cpan) to the META files of
a distribution, or if it does not have a link to its GitHub repository then
[add a link to GitHub](/how-to-add-link-to-version-control-system-of-a-cpan-distributions).

## Continuous Integration

[Enable Travis-CI](/enable-travis-ci-for-continous-integration) for Continuous Integration on Linux and OSX. [Enable Appveyor](http://blogs.perl.org/users/eserte/2016/04/testing-with-appveyor.html) for CI on Windows.

## Other resources

There are tons of articles written by [Neil Bowers](http://neilb.org/) covering topics related to CPAN
and contributing to CPAN. Check out his writings.


## Tasks that you could do

### CPAN Cover Site - order by date

It would be nice if we could look at [CPAN Cover](http://cpancover.com/) and see the information about the most recently uploaded
modules, or at least we could look at the list of modules there ordered by their upload date. The logic is that recently uploaded modules
are maintained more actively so contributing there would more likely to be accepted.

### CPAN Cover site - order by coverage

It would be nice if on [CPAN Cover](http://cpancover.com/) we could see the modules listed in order of the test coverage they have.
The idea that contributing to modules with low coverage is probably easier and have bigger impact on that specific module.

### Link from MetaCPAN to CPAN Cover

It would be nice if each module on [MetaCPAN](https://metacpan.org/) would link to its information on [CPAN Cover](http://cpancover.com/).

### Fix Kwalitee of a module

Find a module on [MetaCPAN](https://metacpan.org/), (looking at the recently uploaded modules could be a good idea), follow
the link to its Kwalitee metric on the top left side. Try to improve this metric.

### Add test to a module

Find a module on [MetaCPAN](https://metacpan.org/) that has no tests, or that has low test-coverage.
(See [CPAN Cover](http://cpancover.com/) for that information).
Add tests to the module to increase test coverage.

### Add CI to a CPAN module

Find a module on [MetaCPAN](https://metacpan.org/) that already has test and check if the module has any
of the CI systems enabled. e.g. [Travis-CI](https://travis-ci.org/). If not, fork the module, make sure it
can be tested on Travis-CI and then send a Pull-request explaining the author what to do.
Here is an explanation how to [enable Travis-CI for Continuous Integration](/enable-travis-ci-for-continous-integration)










