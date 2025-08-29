---
title: "Fix Perl::Critic test failures reported by CPAN Testers"
timestamp: 2016-02-26T15:30:01
tags:
  - Perl::Critic
published: true
books:
  - cpan_co_maintainer
author: szabgab
archive: true
---


At the end of the previous article we have [released version 1.23 of Pod::Tree](/fixing-the-release-adding-version-numbers)
and we had hopes that this works. A few hours later failing reports started to show at the
[CPAN Testers](http://www.cpantesters.org/distro/P/Pod-Tree.html?oncpan=1&distmat=1&version=1.23&grade=3).

Looking at any one of the [test reports](http://www.cpantesters.org/cpan/report/754508bc-6bf8-1014-8d3e-98944acd6126)
showed a Perl::Critic policy violation. How could that happen if we have checked on the development machine and also on Travis-CI
that the code was PC violation free?


[Perl::Critic](/perl-critic) includes lots of policies, but there are quite a few additional policies in other modules.
When we run `perlcritic` it will check the code for all the available policies. Apparently, the person who runs the smoker
had a number of these additional policies installed.

It wouldn't be a big issue if this was "only" the CPAN testers, but this means, Perl::Critic test might fail during installation
at any "end-user" due to issue we probably don't care. After all, if we did care, we would have included
those in our own Perl::Critic rules.

## Violated extra policies

At this point I did not go into checking what were these policy violations, but later I check out both the
[Private Member Data shouldn't be accessed directly](/private-member-data-shouldnt-be-accessed-directly) violation
and the 
[Three-argument form of open used and it is not available until perl 5.6.](/three-argument-form-of-open-used-and-it-is-not-available-until)
violation.

## Avoid failing developer tests during installation

There are a whole class of so called "developer tests" that have similar issues, for example in
our case the test checking tidyness also falls in this category. Later we are going to add a test that checks if the version numbers
in all the modules are the same. Some people add tests to check if every function has documentation in POD format.
For now let's discuss specifically the Perl::Critic tests here.

## Avoid Perl::Critic errors during installation

There are a couple of strategies to avoid the Perl::Critic errors on machines you don't have control over.
Probably the most obvious one is to run these tests only during development and releases. For that there are several strategies.

<h3>Put the tests in xt/</h3>

So far we put all the test scripts in the t/ directory, but there is actually a fairly standard recommendation to put the "developer test"
in the xt/ directory. (Still with .t extension though.) Normally, when we run "make test" these test would not be executed.

On the other hand if we run `prove -l t/ xt/` it will execute all the tests. Both in the `t/` and in the `xt/` directory.

If we used this solution, I'd probably change the Perl::Critic test script to always run. That is, I'd remove the "

```perl
## no critic
eval 'use Test::Perl::Critic 1.02';
plan skip_all => 'Test::Perl::Critic 1.02 required' if $@;
```

part and replace it with

```perl
use Test::Perl::Critic 1.02;
```

<h3>Don't distribute the tests at all</h3>

Another solution, that might make even more sense, especially if the project has a public version control system, is to
leave the "developer tests" in the `t/` directory, but to exclude them from the distribution.
That way the CPAN Testers and the regular end-users won't run them at all, but on the other hand the developers won't
have to make special effort to run them. Regular `make test` will execute these tests as well.

In this case I am not sure if I would leave the "eval" part in the tests or not.

If I take them out, that will ensure
these tests are always executed by every developer and every contributor. That might make it more difficult to contribute
as more modules will have to be installed to test even the smallest patch. OTOH this will ensure you, the main developer
won't have to deal with issues that are relatively low level requirements for your code-base.

If I leave the "eval" that means the test will be skipped if Perl::Critic is not installed. That makes it easier for the
contributors, but then if I work on a new machine or a newly compiled perl where Perl::Critic is not installed,
I'll probably miss the fact that some of my tests did not run. Having Travis-CI configured to install Perl::Critic might
eliminate the danger as that means even if I don't run the Perl::Critic tests, Travis-CI will the first time I push out my changes.

<h3>Use environment variable to control the tests</h3>

There is also the possibility to only let the "developer tests" run if a certain environment variable is set.
For example like this:

```perl
plan skip_all => 'DEV_TESTS' if not $ENV{DEV_TESTS};
```

Then, CPAN Testers and people who just install the module won't run the tests by mistake and the developers could run the tests
by typing

```
DEV_TESTS=1 make test
```

I think this has similar aspects as the tests in the `xt/` but this is probably an inferior solution.


<h3>Supply the configuration file needed for Perl::Critic</h3>

In the `.perlcriticrc` we had the configuration of Perl::Critic,
but that file was not included in the distribution so when the Perl::Critic tests ran on the CPAN Testers machine,
they used the default options.
That mean every policy with severity 5 or higher. (There are some non-standard [Perl::Critic policies](/perl-critic)
at severity level 6.) Because there were some additional policies installed on the testers machine, they were also checked.

In the `.perlcriticrc` file we further restricted the policies by setting `theme = core`, but because we have not
included this file in our distribution, this restriction did not apply there and some non-core policies were taken in account.


At this point I decided to go with this approach and see how it works, even though later I'll probably switch to the
"don't distribute the developer tests" approach.

So the next [commit](https://github.com/szabgab/Pod-Tree/commit/9ad8a73f92900eb37f6d571e502ba85cb50e78ce) was to
**include the rc files in the MANIFEST**.

