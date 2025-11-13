---
title: "Adding tests to legacy Perl code"
timestamp: 2025-11-11T12:00:02
published: true
description: "Notes from a live-coding session writing tests for the SVG module."
archive: true
show_related: false
---

Notes from the live-coding session


* [SVG](https://metacpan.org/dist/SVG) the module for which we wrote tests.
* [Devl-Cover](https://metacpan.org/dist/Devel-Cover) to generate test coverage report run `cover -test`.
* [Test::More](https://metacpan.org/pod/Test::More)
* [Test::Exception](https://metacpan.org/pod/Test::Exception)
* `done_testing()` or `done_testing(2)`
* [CPAN cover](https://www.cpancover.com/latest/)


## Meeting summary

### Quick recap

The meeting began with informal introductions and discussions about Perl programming, including experiences with maintaining Perl codebases and the challenges of the language's syntax. The main technical focus was on testing and code coverage, with detailed demonstrations of using Devel::Cover and various testing modules in Perl, including examples of testing SVG functionality and handling exceptions. The session concluded with discussions about testing practices, code coverage implementation, and the benefits of automated testing, while also touching on practical aspects of Perl's object-oriented programming and error handling features.

### SVG Test Coverage Analysis

Gabor demonstrated how to use Devel::Cover to generate test coverage reports for the SVG.pm module. He showed that the main module has 98% coverage, while some submodules have lower coverage. Gabor explained how to interpret the coverage reports, including statement, branch, and condition coverage. He also discussed the importance of identifying and removing unused code that appears uncovered by tests. Gabor then walked through some example tests in the SVG distribution, explaining how they verify different aspects of the SVG module's functionality.

