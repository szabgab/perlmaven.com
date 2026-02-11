---
title: "Setup GitHub Actions with Dist::Zilla, how to advance PRs"
timestamp: 2026-02-11T08:00:02
published: true
description: ""
archive: true
show_related: true
---

{% youtube id="ciQw5DMvRm8" file="2026-02-10-open-source-perl-in-english.mp4" %}

* 00:00 Introduction
* 01:30 [OSDC Perl](https://osdc.code-maven.com/perl), mention last week
* 03:00 Nikolai Shaplov [NATARAJ](https://metacpan.org/author/NATARAJ), one of our guests author of [Lingua-StarDict-Writer](https://metacpan.org/dist/Lingua-StarDict-Writer) on GitLab.
* 04:30 Nikolai explaining his goals about security [memory leak in Net::SSLeay](https://github.com/radiator-software/p5-net-ssleay/pull/509)
* 05:58 What we did earlier. (Low hanging fruits.)
* 07:00 Let's take a look at the [repository of Net::SSLeay](https://github.com/radiator-software/p5-net-ssleay)
* 08:00 Try understand what happens in the repository?
* 09:15 A bit of explanation about adopting a module. (co-maintainer, unauthorized uploads)
* 11:00 [PAUSE](https://pause.perl.org/)
* 15:30 Check the "river" status of the distribution. (reverse dependency)
* 17:20 You can CC-me in your correspondence.
* 18:45 Ask people to review your pull-requests.
* 21:30 Mention the issue with DBIx::Class and how to take over a module.
* 23:50 A bit about the OSDC Perl page.
* 24:55 [CPAN Dashboard](https://cpandashboard.com/) and how to add yourself to it.
* 27:40 Show the issues I opened asking author if they are interested in setting up GitHub Actions.
* 29:25 Start working on [Dancer-Template-Mason](https://metacpan.org/dist/Dancer-Template-Mason)
* 30:00 clone it
* 31:15 perl-tester Docker image.
* 33:30 Installing the dependencies in the Docker container
* 34:40 Create the GitHub Workflow file. Add to git. Push it out to GitHub.
* 40:55 First failure in the CI which is unclear.
* 42:30 Verifying the problem locally.
* 43:10 Open an issue.
* 58:25 Can you talk about dzil and Dist::Zilla?
* 1:02:25 We get back to working in the CI.
* 1:03:25 Add `--notest` to make installations run faster.
* 1:05:30 Add the git configuration to the CI workflow.
* 1:06:32 Is it safe to use `--notest` when installing dependencies?
* 1:11:05 git rebase squashing the commits into one commit
* 1:13:35 `git push --force`
* 1:14:10 Send the [pull-request](https://github.com/yanick/Dancer-Template-Mason/pull/8).


