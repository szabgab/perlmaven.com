---
title: "Add META data, .gitignore and GitHub Actions to Common::CodingTools"
timestamp: 2026-02-01T22:00:02
published: true
description: ""
archive: true
show_related: true
---

[OSDC Perl](https://osdc.code-maven.com/perl).

{% youtube id="fW3uCc-Vw-g" file="osdc-perl-2025-12-26-part-1.mp4" %}

* 00:00 Introduction to OSDC
* 01:30 Introducing myself [Perl Maven](https://perlmaven.com/), [Perl Weekly](https://perlweekly.com/)
* 02:10 The earlier issues.
* 03:10 How to select a project to contribute to?
* 04:50 Chat on [OSDC Zulip](https://osdc.zulipchat.com/)
* 06:45 How to select a Perl project?
* 09:20 [CPAN::Digger](https://cpan-digger.perlmaven.com/)
* 10:10 Modules that don't have a link to their VCS.
* 13:00 Missing CI - GitHub Actions or GitLab Pipeline and Travis-CI.
* 14:00 Look at Term-ANSIEncode by Richard Kelsch - How to find the repository of this project?
* 15:38 Switching top look at Common-CodingTools by mistake.
* 16:30 How MetaCPAN knows where is the repository?
* 17:52 Clone the repository.
* 18:15 Use the [szabgab/perl](https://github.com/szabgab/perl-docker-on-ubuntu/) Docker container.
* 22:10 Run `perl Makefile.PL`, install dependency, run `make` and `make distdir`.
* 23:40 See the generated `META.json` file.
* 24:05 Edit the `Makefile.PL`
* 24:55 Explaining my method of cloning first (calling it `origin`) and forking later and calling that `fork`.
* 27:00 Really edit `Makefile.PL` and add the `META_MERGE` section and verify the generated `META.json` file.
* 29:00 Create a branch locally. Commit the change.
* 30:10 Create a fork on GitHub.
* 31:45 Add the `fork` as a remote repository and push the branch to it.
* 33:20 Linking to the PR on the [OSDC Perl report page](https://osdc.code-maven.com/perl).
* 35:00 Planning to add `.gitignore` and maybe setting up GitHub Action.
* 36:00 Start from the `main` branch, create the `.gitignore` file.
* 39:00 Run the tests locally. Set up GitHub Actions to run the tests on every push.
* 44:00 Editing the GHA configuration file.
* 48:30 Commit, push to the fork, check the results of GitHub Action in my fork on GitHub.
* 51:45 Look at the version of the [perldocker/perl-tester](https://hub.docker.com/r/perldocker/perl-tester/) Docker image.
* 54:40 Update list of Perl versions in the CI. See the results on GitHub.
* 55:30 Show the version number of perl.
