---
title: "Setup GitHub Actions for CPAN modules"
timestamp: 2020-10-28T07:30:01
tags:
  - GitHub
  - Actions
  - CI
published: true
author: szabgab
archive: true
description: "GitHub actions is the integrated CI system GitHub offers to all of its users. Authors of Perl modules can use it to get fast feedback to changes they make to their code."
show_related: true
---


Continuous Integration (CI) means you create a very tight loop to get feedback for changes made to the code.

A good CI system will run every time you make some changes to the source code (or precisely every time you push it out to
the hosted copy of your source code.)



It can then run your reguler test, your release tests, your author tests and even more. (You don't wait for it, it does not take up CPU on your computer.)

A CI can be testing your code on multiple platforms (GitHub Actions support Ubuntu Linux, MacOS, MS Windows), on multiple Perl versions, and as many configurations
as you like. For every change you make. Long before you release to the public.

If you set it up to run on pull-requests as well, it will give automated feedback to your contributors event while you are at sleep. Soon after they sent the pull-request.
So they know their code change does not break the code on any of the platforms and any of the Perl versions you'd like to support.

It can periodically check if updates to the dependencies have not broken your otherwise unchanged code.

It can make it easy to test that your code does not break any of the (public) packages that depend on your code. Long before you release your new version.

## Minimal requirement

If you already use GitHub to store the source code of your project the only thing you need is to create a directory called **.github/workflows/** and put
one (or more) appropriately formatted YAML file in the directory. Once you push out the change GitHub will start running the tests you configured.

It will send you e-mails if something is broken, but you can also follow it via the **Actions** link on your repository.

The following are a few sample YAML files.

## GitHub Actions for projects with Makefile.PL

* Run on every **push** and on every **pull_request**.
* Create a strategy listing the versions of Perl we would like to use.
* Use the [perl-tester docker image](https://hub.docker.com/r/perldocker/perl-tester) that already contains a bunch of testing modules for Perl. Use the version numbers from the matrix to generate the tags used to identify the Docker container.
* Make the system check out the source code of your prokeject with the pre-defined [checkout action](https://github.com/actions/checkout).
* Using cpanm install all the prerequisites and then run the regular steps starting with **perl Makefile.PL**
* As a separate step, run the same tests, but this time RELEASE_TESTING enabled.
* You can enable the `schedule` with a standar cron configuration. It can help noticing when a new version of one of the dependencies breaks your code.

{% include file="examples/workflows/makefile_tester.yml" %}

## Makefile.PL Native (Windows, macOS, Linux)

* This workflow will run natively on Windows, macOS, Linux. On MS Windows it uses `gmake` instead of `make`.

{% include file="examples/workflows/makefile_native.yml" %}

## GitHub Actions for projects using Dist::Zilla

* Similar to the one with Makefile.PL, this one runs the Dist::Zilla commands

{% include file="examples/workflows/dzil_tester.yml" %}


## GitHub Actions for projects using Build.PL

{% include file="examples/workflows/build_tester.yml" %}

## Dist::Zilla Native

{% include file="examples/workflows/dzil_native.yml" %}


