---
title: "Open source contribution - Perl - MIME::Lite - GitHub Actions, test coverage and adding more test"
timestamp: 2026-01-25T09:00:02
published: true
description: ""
archive: true
show_related: true
---

{% youtube id="XuwHFAyldsA" file="2026-01-24-open-source-perl-in-english-part1.mp4" %}


* 00:00 Introduction and about [OSDC Perl](https://osdc.code-maven.com/perl)
* 01:50 [Sponsors of MetaCPAN](https://metacpan.org/about/sponsors), looking at some modules on CPAN.
* 03:30 The river status
* 04:10 Picking [MIME::Lite](https://metacpan.org/dist/MIME-Lite) and looking at MetaCPAN. Uses RT, has no GitHub Actions.
* 05:55 Look at the clone of the repository, the 2 remotes and the 3 branches.
* 06:40 GitHub Actions [Examples](https://perlmaven.com/setup-github-actions)
* 08:00 Running the Docker container locally. Install the dependencies.
* 09:10 Run the tests locally.
* 09:20 Add the `.gitignore` file.
* 10:30 Picking a module from [MetaCPAN recent](https://metacpan.org/recent)
* 11:10 [CPAN Digger recent](https://cpan-digger.perlmaven.com/recent)
* 12:20 Explaining about pair-programming and workshop.
* 13:25 CPAN Digger statistics
* 14:15 Generate test coverage report using [Devel::Cover](https://metacpan.org/pod/Devel::Cover).
* 17:15 The `fold` function that is not tested and not even used.
* 18:39 Wanted to open an issue about `fold`, but I'll probbaly don't do it on RT.
* 20:00 Updating the OSDC Perl document with the TODO items.
* 21:13 Split the packages into files?
* 22:27 The culture of Open Source contributions.
* 24:20 Why is the BEGIN line red when the content of the block is green?
* 27:40 Switching to the `long-header` branch.
* 30:40 Finding `header_as_string` in the documentation.
* 32:15 Going over the test with the long subject line.
* 33:54 Let's compare the result to an empty string.
* 36:15 Switching to [Test::Longstring](https://metacpan.org/pod/Test::LongString) to see the difference.
* 37:35 [Test::Differences](https://metacpan.org/pod/Test::Differences) was also suggested.
* 39:40 Push out the branch and send the Pull-request.
* 40:35 Did this really increase the test coverage? Let's see it.
* 43:50 Messing up the explanation about codition coverage.
* 45:35 The repeated use of the magic number 72.
* 47:00 Is the output actually correct? Is it according to the standard?
* 51:45 Discussion about /usr/bin/perl on the first line.
* 52:45 No version is specified.
* 55:15 The sentence should be "conforms to the standard"
