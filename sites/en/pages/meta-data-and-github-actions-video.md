---
title: "Open Source contribution - Perl - Tree-STR, JSON-Lines, and Protocol-Sys-Virt - Setup GitHub Actions"
timestamp: 2026-01-25T11:00:02
published: true
description: ""
archive: true
show_related: true
---

See [OSDC Perl](https://osdc.code-maven.com/perl)

{% youtube id="Y1La0sfcvbI" file="2026-01-24-open-source-perl-in-english-part2.mp4" %}

* 00:00 Working with Peter Nilsson
* 00:01 Find a module to add GitHub Action to. go to [CPAN::Digger recent](https://cpan-digger.perlmaven.com/recent)
* 00:10 Found [Tree-STR](https://metacpan.org/dist/Tree-STR)
* 01:20 Bug in CPAN Digger that shows a GitHub link even if it is broken.
* 01:30 Search for the module name on GitHub.
* 02:25 Verify that the name of the module author is the owner of the GitHub repository.
* 03:25 Edit the Makefile.PL.
* 04:05 Edit the file, fork the repository.
* 05:40 Send the Pull-Request.
* 06:30 Back to CPAN Digger recent to find a module without GitHub Actions.
* 07:20 Add file / Fork repository gives us "unexpected error".
* 07:45 Direct fork works.
* 08:00 Create the `.github/workflows/ci.yml` file.
* 09:00 Example [CI yaml file](https://perlmaven.com/setup-github-actions) copy it and edit it.
* 14:25 Look at a GitLab CI file for a few seconds.
* 14:58 Commit - change the branch and add a description!
* 17:31 Check if the GitHub Action works properly.
* 18:17 There is a warning while the tests are running.
* 21:20 Opening an [issue](https://github.com/ehuelsmann/perl-protocol-sys-virt/issues/1).
* 21:48 Opening the PR (on the wrong repository).
* 22:30 Linking to output of a CI?
* 23:40 Looking at the file to see the source of the warning.
* 25:25 Assigning an issue? In an open source project?
* 27:15 Edit the already created issue.
* 28:30 USe the Preview!
* 29:20 Sending the [Pull-Request](https://github.com/ehuelsmann/perl-protocol-sys-virt/pull/2) to the project owner.
* 31:25 Switching to Jonathan
* 33:10 CPAN Digger recent
* 34:00 Net-SSH-Perl of BDFOY - Testing a networking module is hard and Jonathan is using Windows.
* 35:13 Frequency of update of CPAN Digger.
* 36:00 Looking at our notes to find the GitHub account of the module author LNATION.
* 38:10 Look at the modules of [LNATION on MetaCPAN](https://metacpan.org/author/LNATION)
* 38:47 Found [JSON::Lines](https://metacpan.org/pod/JSON::Lines)
* 39:42 Install the dependencies, run the tests, generate test coverage.
* 40:32 Cygwin?
* 42:45 Add Github Action copying it from the previous PR.
* 43:54 `META.yml` should not be committed as it is a generated file.
* 48:25 I am looking for sponsors!
* 48:50 Create a branch that reflects what we do.
* 51:38 commit the changes
* 53:10 Fork the project on GitHub and setup git remote locally.
* 55:05 `git push -u fork add-ci`
* 57:44 Sending the Pull-Request.
* 59:10 The 7 dwarfs and Snowwhite. My hope is to have a 100 people sending these PRs.
* 1:01:30 Feedback.
* 1:02:10 Did you think this was useful?
* 1:02:55 Would you be willing to tell people you know that you did this and you will do it again?
* 1:03:17 You can put this on your resume. It means you know how to do it.
* 1:04:16 ... and Zoom suddenly closed the recording...


