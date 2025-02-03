---
title: "Becoming a co-maintainer of a CPAN-module"
timestamp: 2015-09-14T12:30:01
tags:
  - Makefile.PL
  - make
  - git
  - Pod::Tree
published: true
books:
  - cpan_co_maintainer
author: szabgab
archive: true
---


The story of becoming a co-maintaner of [Pod::Tree](https://metacpan.org/pod/Pod::Tree), improving its distribution,
refactoring the code and even accepting contributions from other people.


<ol>
  <li>[Becoming a co-maintainer of a CPAN-module - the first steps (Pod::Tree 1.17_01, 1.18)](/becoming-a-co-maintainer-first-steps)</li>
  <li>Update the packaging to [include license and link to repository in the META files](/add-meta-data-to-cpan-distribution). Use GitHub as bug tracking. (Pod::Tee 1.19)</li>
  <li>Add [Travis-CI for Continous Integration](/enable-travis-ci-for-continous-integration)</li>
  <li>[Refactoring the tests to use Test::More](/refactoring-tests-to-use-test-more) (Pod::Tree 1.20)</li>
  <li><a href="/check-test-coverage-add-compile-tests">Check test coverage - add compile tests</li>
  <li>[Run Perl::Tidy on the code to make layout unified.](/run-perl-tidy-to-beautify-the-code) Currently there is a mix of tab and spaces.</li>
  <li>Perl::Critic: [use Path::Tiny instead of ReadFile and WriteFile](/use-path-tiny-instead-of-readfile-and-writefile)</li>
  <li>[use strict; use warnings; no diagnostics](/use-strict-use-warnings-no-diagnostics)</li>
  <li>Perl::Critic: [Move packages to their own files](/move-packages-to-their-own-files) - release Pod::Tree 1.21</li>
  <li>Perl::Critic: fix the most important issues it finds and [enable Test::Perl::Critic](/enable-test-perl-critic)</li>
  <li>Refactor pod and code to [eliminate indirect method calls](/eliminating-indirect-method-calls)</li>
  <li>[Fixing the release, adding a version number (release Pod::Tree 1.22 and 1.23)](/fixing-the-release-adding-version-numbers)</li>
  <li>[Fix Perl::Critic test failures reported by CPAN Testers](/fix-perl-critic-test-failures-reported-by-cpantesters)</li>
  <li>[Enforce consistent version numbers of Perl all the modules in a distribution](/consistent-version-numbers-of-modules)</li>
  <li>[Perl::Critic exclude some policies - fix others](/perl-critic-exclude-policies-fix-others) (Pod::Tree 1.24)</li>
  <li>[How to declare requirements of a CPAN distribution?](/how-to-declare-requrements)</li>
  <li>[Check CPANTS (Kwalitee)](/improve-kwalitee)</li>
  <li>[Eliminate more of the indirect calls](/converting-indirect-calls)</li>
  <li>[Fixing test failure on Windows - Properly quoting regexes - Accepting GitHub pull request](/fixing-test-failure-on-windows)</li>
   <li>[Set minimum version number in every Perl file](/set-minimum-version-in-every-perl-file)</li>


  <li>Make the Changes file standard compliant</li>
  <li>Eliminate extensive [use of short-circuit](http://perlcritic.tigris.org/ds/viewMessage.do?dsForumId=4230&dsMessageId=3119165). For example `is_ok $obj and $node = $obj, last;`</li> 
  <li>Write tests to check round-trip and what might be missing from the round-trip regenerating the original POD.</li>
</ol>


