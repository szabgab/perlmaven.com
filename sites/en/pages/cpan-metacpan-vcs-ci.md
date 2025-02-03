---
title: "Perl modules on CPAN having links to VCS and having CI configured"
timestamp: 2020-09-21T07:30:01
tags:
  - CPAN
  - MetaCPAN
  - VCS
  - CI
  - PerlWeekly
published: true
types:
  - screencast
author: szabgab
archive: true
description: "Modules that arrive to CPAN can have meta-data that includes a link to their VCS where they might have a CI system set up."
show_related: false
---


{% youtube id="fz1SeFJrpdk" file="english-cpan-metacpan-vcs-ci.mkv" %}

* [Perl Weekly](https://perlweekly.com/)
* [MetaCPAN](https://metacpan.org/)
* [Perl Weekly MetaCPAN statistics](https://perlweekly.com/metacpan.html)

Module authors can [indicated the location of their VCS (Version Control System)](/how-to-add-link-to-version-control-system-of-a-cpan-distributions).

In the script used for the stats on the PerlWeekly site we are checking some of the following files:

* <b>.travis.yml</b> for Travis CI
* <b>.appveyor.yml</b> or appveyor.yml for Appveyor
* Something in <b>.github/workflows</b> for GitHub actions (but may not be CI)
* <b>.circleci/config.yml</b> for Circle CI
* <b>.gitlab-ci.yml</b> for Gitlab Pipelines
* <b>Jenkinsfile</b> for Jenkins
* ...

There is a lot more work to do with that script.

