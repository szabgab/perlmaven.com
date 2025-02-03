---
title: "CI - Continuous Integration"
timestamp: 2020-11-05T07:30:01
tags:
  - CI
published: true
author: szabgab
archive: true
description: "Mini series to help CPAN authors to set up CI system for their modules"
show_related: true
---


A [Continuous Integration system (aka CI)](/ci) can shorten the feedback cycle you get for your code.

Usually it will run your unit-tests, (or whatever you tell it to run) every time you push code to your VCS - Version Control System. (GitHub, GitLab, BitBucket, or even Subversion.)
It can run it on multiple versions of Perl on the 3 major Operating Systems.

It can run on every Pull-Request so both your contributor and you will know the offered change does not break the code almost immediately.

You can configure it to run the tests of some of the modules that depend on your code to verify that your changes don't break any of the downstream dependencies. Consider this as integration-tests.

It can go further and run your tests even if you have not made any change to verify that changes in the modules your code depends on did not break your code.


## Why do I need a CI if I run my tests before releasing my module to CPAN?

* It can identify problems much earlier.
* It will help you ensure that other people can also easily build your project.
* It can catch issues as simple as forgeting to include a file or relying on some local configuration you long forgot about.


## Avialable CI systems

* GitHub Actions is the integrated CI system GitHub offers.
* Travis-CI is an independent company offering CI system for GitHub repositories.
* Appveyor
* CircleCI
* Azure Pipelines
* GitLab Pipelines
* BitBucket Pipelines


## CI for CPAN mini-series

The goal of this mini-series is to get to the point where all the CPAN modules that use GitHub for
version control have a CI system configured.


* [What is Continuous Integration (CI) and why is it useful?](/what-is-ci)
* What is the difference between the CI systems mentioned above and the [CPAN Testers](http://www.cpantesters.org/)
* What Cloud-based CI systems are available for GitHub users? GitHub Actions, Travis-CI, Appveyor, CircleCI, Azure Pipelines
* [Why use GitHub Actions?](/github-actions)
* What is Travis-CI and how to set it up? See the following articles:
* [Travis-CI for the Markua Parser project](/travis-ci-for-markua-parser) (part of the [Markua](/markua) series)
* [Enable Travis-CI for Continuous Integration](/enable-travis-ci-for-continous-integration) (part of the [Become a co-maintainer](/becoming-a-co-maintainer) series)
* [Using Travis-CI and installing Geo::IP on Linux and OSX](/using-travis-ci-and-installing-geo-ip-on-linux)
* We'll look at a few examples on how various Perl projects use GitHub Actions
* [Setup GitHub Actions for a Perl module](/setup-github-actions)
* [Run on Windows, MacOSX, Linux](/github-actions-running-on-3-operating-systems) based on [Array::Compare](https://github.com/davorg/array-compare/) of Dave Cross
* [Show the error logs of cpanm on Linux, MacOSX, or Windows](/github-actions-showing-error-log-on-linux-mac-windows)
* [Perl Power Tools](https://github.com/briandfoy/PerlPowerTools) of brian d foy
* [GraphViz2](https://github.com/graphviz-perl/GraphViz2/) of Ron Savage and Ed J
* [Docker Perl Tester](https://github.com/Perl/docker-perl-tester) by Nicolas R and Olaf Alders
* Maybe others<a href=""></a>
* We'll also take a look at the [CPAN Dashboard](https://code.perlhacks.com/) Dave Cross has 
* We'll see how to find a CPAN module that does not have CI yet. (Check out the [CPAN::Digger](/cpan-digger) project.)
* How to configure GitHub Actions
* How to send a pull-request

A nice collection of [Tips for testing Perl modules via GitHub Actions](https://github.com/FGasper/perl-github-action-tips) by Felipe Gasper.

## GitLab

* [GitLab CI Pipeline for Perl DBD::Mock using Module::Build](/gitlab-ci-module-build)



