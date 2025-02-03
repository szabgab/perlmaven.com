---
title: "Contributing to the Open Source Perl Ecosystem"
timestamp: 2015-10-06T13:30:01
tags:
  - GitHub
  - CPAN
  - MetaCPAN
published: true
author: szabgab
archive: true
---


There are plenty of people who would like to contribute to Open Source and especially to Perl,
but don't know what and how to start. In this page I am going to collect some of my suggestions.

If you are interested, pick one of them and run with it. If you need further help how to get started
with one of the tasks, ask me in the comment section.


Just to clarify, under "Open Source Perl Ecosystem" I mean the Perl 5 core, Perl 6 (e.g. Rakudo Perl 6), modules on CPAN.
Perl 6 modules that are not on CPAN. Any [Perl based open source application](/perl-based-open-source-products)
and any [web site powered by Perl](/web-sites-powered-by-perl-with-open-source-code-base) with publicly available source code.

* [Link to Version Control system](#vcs)
* [Add Travis-CI to GitHub repository](#travis)
* [Fix any issue reported against the distribution](#issues)
* [Add tests to increase test coverage](#tests)
* [Improve documentation, examples for common use cases](#pod)
* [Adopt a CPAN module](#adopt)
* [Perl 5 core](#p5p)
* [Perl 6](#perl6)
* [CPAN PR Challenge](#cpan-prc)
* [Adding examples to Rosetta Code](#rosetta)

<h2 id="vcs">Link to Version Control system</h2>

For some distributions [MetaCPAN](https://metacpan.org/) shows a link to the version control system where the code is maintained.
The link is usually called "Clone repository". It is taken from the `META.json` file included in the distribution.
Having this link makes it easier to everyone to contribute to the distribution. The task here is to look at the 
[recently uploaded distributions](https://metacpan.org/recent) if they have this link or not.
If not, then try add add it.

<ol>
  <li>Try to find the repository:
    <ol>
      <li>Check if other distributions of the same author have such link. If yes, the repository of this distribution might be next to it.</li>
      <li>In [GitHub](https://github.com/) search for the name of the distribution and/or the name of the module.</li>
      <li>Send an e-mail to the author (more specifically the person who uploaded the most recent version of the distribution) and ask them.</li>
    </ol></li>
  <li>Patch the code using the explanation in the article on [how to link to the version control system of a CPAN distribution](/how-to-add-link-to-version-control-system-of-a-cpan-distributions) and send the patch (or the pull request) to the current maintainer.</li>
</ol>

Required skills:

* Communication in English with the author.
* Basic Perl
* Probably Git, Mercury, or Subversion depending on the actual version control system.

Relevant to CPAN modules.

<h2 id="travis">Add Travis-CI to GitHub repository</h2>

[Travis-CI](https://travis-ci.org/) provides continuous integration for any code hosted on GitHub. It is free of charge
if the code is in a public repository.

* Look at the [recently uploaded distributions](https://metacpan.org/recent) if they have a GitHub repository and if that repository does not have a `.travis.yml` file.<li>
* Fork and then clone the repository.
* Run the tests locally on your computer. Learn which modules are recommended for the testing that are not required. You can tell Travis to install those before running the tests.
* Send a pull request with a well constructed `.travis.yml` file.

You could write a script that would fetch the list of CPAN modules from MetaCPAN that have a GitHub link.
Then the script could go to each one of the repos and check if it already has a .travis.yml file.
If not, that's a distribution you might want to patch.

A number of articles about Travis-CI and Perl:

* [Enable Travis-CI for continuous integration](/enable-travis-ci-for-continous-integration)
* [Using Travis-CI and installing Geo::IP on Linux and OSX](/using-travis-ci-and-installing-geo-ip-on-linux)
* [Try Travis CI with your CPAN distributions](http://blogs.perl.org/users/neilb/2014/08/try-travis-ci-with-your-cpan-distributions.html)
* [Travis-CI and latest version of Perl 5](http://blogs.perl.org/users/gabor_szabo/2015/09/travis-ci-and-latest-version-of-perl-5.html) (see the comments)

Required skills:

* Know how to use Git and GitHub
* Being able to install CPAN modules. (The dependencies of the module being patched.)
* Understand how testing works in Perl.

Relevant to any Perl-based project that has GitHub repository.

Sample `.travis.yml` file that requires mongodb to be installed:

```
branches:
  except:
    - gh-pages
language: perl
sudo: false
perl:
  - "blead"
  - "5.20"
  - "5.18"
  - "5.16"
  - "5.14"
  - "5.12"
  - "5.10"
before_install:
  - eval $(curl https://travis-perl.github.io/init) --auto
  - cpanm --notest Test::Code::TidyAll 
  - cpanm --notest Test::Perl::Critic
  - cpanm --notest Test::Version
services:
  - mongodb
```

You can take a look at the [list of most recent releases](/recent) where you can find which ones have no Travis-CI configuration.
Fixing those, "while they are hot" is a good approach.

<h2 id="issues">Fix any issue reported against the distribution</h2>

When looking at the page of any of the distributions on [MetaCPAN](https://metacpan.org/) you will find a link to "issues", usually with a number next to it. Click on the link
to see the list of open "issues": bugs, feature requests, and the occassional spam.

These issues will range from very simple to very complex. Pick a module that you use. That will be probably easier to handle as you are already somewhat familiar with it.
Try to reproduce a bug. If you managed to reproduce a bug write a test-case. You can already send that test to the author or maintainer of the module. That's already a huge help.

Then if you know how to fix it do that too.

Required skills:

* The testing system of Perl
* The level of Perl is very much depends on the complexity of the bug. For writing a test you probably don't need such deep understanding of Perl.
* XS and maybe C - for modules that are not pure Perl, you will 


<h2 id="pod">Improve documentation, examples for common use cases</h2>

Most modules come witha <b>SYNOPSIS</b> that shows the basic usage of the module, but in many cases that's not a full example and it
only show a very limited usage of the module.

Some modules come with examples file usuall in the `eg/` or `examples/` subdriectory of the modules.

Many modules don't come with examples and even the ones that have examples could make those more visible.

So this task would be to add more and better documentation, espacially with full examples embedded and explained in the POD.

Required skills:

* Understanding how the module works and what it does.
* Perl at a level to be able to explain the code.
* The capability to see things as a beginner (for that particular module)


<h2 id="tests">Add tests to increase test coverage</h2>

* Using [Devel::Cover](https://metacpan.org/pod/Devel::Cover) check which parts of the code have been exercised during the test execution.
* Check the areas that were never called. Are they in use? Could they be removed? If they can be removed, send that as a patch to the author.
* If they are still in use then write test cases that exercise those parts of the code.


<h2 id="adopt">Adopt a CPAN module</h2>

This might be more than "low hanging fruit", but adopting a CPAN module and becoming its maintainer is a great way to contribute.
There is a [list of CPAN modules](http://neilb.org/adoption/) that can be good candidates for
[taking over maintenance](http://neilb.org/2013/07/24/adopt-a-module.html), but in general if you find a module
that does not have a recent release, especially if the author did not have any activity on CPAN, thos modules are probably
good candidates for adoption.

On [MetaCPAN](https://metacpan.org/) you can find the date of the most recent release of each distribution,
and the when looking at the page of each individual author, you can see what was the last time s/he upload any module.


<h2 id="p5p">Perl 5 core</h2>

The core perl is maintained by a group of people who call themselves [Perl 5 Porters](http://dev.perl.org/perl5/). Check out there.Check out there.Check out there.Check out there.

Required skills: Perl, C.


<h2 id="perl6">Perl 6</h2>

[Perl 6](http://perl6.org/) is getting close to its official release. You can help there with plenty of things while learning
this new languages, or this new version of the old language. 

<ol>
   <li>[Install Rakudo Perl 6](http://perl6maven.com/tutorial/perl6-installing-rakudo)</li>
   <li>[Pick one of the modules](http://modules.perl6.org/)</li>
   <li>Try writing something with it</li>
   <li>Submit bug reports, feature requests</li>
   <li>Fix the bugs, implement the features</li>
</ol>

Required skills:

* You'll need to know Perl 6, but that's the whole points, isn't it? To have an excuse to learn Perl 6


<h2 id="cpan-prc">CPAN PR Challenge</h2>

[Neil Bowers](http://neilb.org/) runs the [CPAN Pull Request challenge](/2015-cpan-pull-request-challenge)
You can join that and get a CPAN module assigned to you. As far as I know Neil does not give you any specific thing you need to
do with the module. Which might fit you better.

<h2 id="rosetta">Adding examples to Rosetta Code</h2>

Not directly the ecosystem, but very helpful: adding examples for both Perl 5 and Perl 6 to Rosetta Code.
Next to a good programming language, good modules, good documentation, we also need good examples.
[Perl 6](http://www.perl6.org/community/rosettacode) and [Rosetta Code](http://rosettacode.org/wiki/Rosetta_Code).



