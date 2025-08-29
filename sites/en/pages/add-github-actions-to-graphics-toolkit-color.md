---
title: "Add GitHub Actions (CI) to Graphics-Toolkit-Color Perl module"
timestamp: 2022-10-05T15:30:01
tags:
  - Github
  - CI
  - Dist::Zilla
published: true
types:
  - screencast
author: szabgab
archive: true
show_related: true
---


Earlier we saw how to [use CPAN::Digger to find a Perl project to contribute to](/cpan-digger-and-hacktoberfest).
This time we used [CPAN::Digger](https://cpan-digger.perlmaven.com/) and found the [Graphics-Toolkit-Color](https://metacpan.org/dist/Graphics-Toolkit-Color)
project to which we added a GitHub Actions configuration file to enable Continuous Integration (CI) executing the tests of the module on every push.


{% youtube id="tiCNGmzJRoY" file="perl-add-github-actions-to-graphics-toolkit-color.mp4" %}


I created a fork of the GitHub repository and in a branch I added the following file to be **./github/workflows/ci.yml**.
(copied from the [try-github-actions](https://github.com/szabgab/try-github-actions/) repository.

Once the changes were pushed out the instructions started to run on the servers of GitHub.

When I saw the tests passed I could send the Pull-Request.


{% include file="examples/perl-dzil-for-graphics-toolkit-color.yml" %}

