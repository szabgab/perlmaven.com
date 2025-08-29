---
title: "Separate release branch for App::Puppet::Environment::Updater"
timestamp: 2022-11-06T11:30:01
tags:
  - GitHub
published: true
types:
  - screencast
author: szabgab
archive: true
show_related: true
---


The [CPAN Digger](https://cpan-digger.perlmaven.com/) provides a list of recently uploaded Perl modules and indicates,
among several other things, if they have some kind of a Continuous Integration configured. That's how I arrived to
[App::Puppet::Environment::Updater](https://metacpan.org/pod/App::Puppet::Environment::Updater) and it took me quite some time
till I noticed that it has GitHub Action configured, but not in the default branch.


[Puppet](https://puppet.com/) is a configuration management tool written in Ruby, so it might be a bit strange that ther is a Perl module
dealingwith it, but each person and each situation might require a different solution.

As I wrote it took me some time I spent on trying to configure GitHub Actions for the default branch [this repository](https://github.com/mstock/App-Puppet-Environment-Updater)
before I noticed that the default branch is called **releases** and while that does not have CI configured there is another branch called **master** that has.

I tried to understand what is the story. I even sent an email to the author asking him for a description of the branching and development process so I can learn from it.
What I understand now, before seeing the reply is that:

The project was dormant for about 8-9 years.

A few hours ago GitHub Actions was added replacing the now defunct Travis-CI configuration.

The **master** branch is used for development where Dist::Zilla is being used. A release candidate is created from it which means generating a couple of files
(e.g. Build.PL and LICENSE, META.*) and removing a number of files. (e.g. the GitHub Actions configuration file).

Then these are committed to the **releases** branch.

Running **git diff master releases** helped me understanding this.

I don't know how this is done. Maybe the author has an external script to do this or maybe this is some Dist::Zilla plugin. I don't know.

As to the **why**. I guess the author wants to version control even the generated files of each release. As the generated files should not
be committed to version control together with the original source code, the developer opted to have a separate branch.

I personally think it is rarely needed. After all the generated files can be re-generated later on and they can be also found in the tar.gz file
uploaded to CPAN. However if it is committed, I'd probably make the **master** branch as the default branch.
After all, if users want to contribute to the project they should be basing it on the **master** branch and the **releases** are only there
for sort-of a backup.

In any case I hope the author will have the time to get back to me so I can learn more about his branching and development process.


{% youtube id="XeCF9TAIA6I" file="perl-separate-release-branch-for-app-puppet-environment-updater.mp4" %}

