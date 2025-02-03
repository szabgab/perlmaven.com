---
title: "Set minimum version number in every Perl file"
timestamp: 2016-06-11T09:30:01
tags:
  - Perl::Critic
  - Compatibility::PerlMinimumVersionAndWhy
published: true
books:
  - cpan_co_maintainer
author: szabgab
archive: true
---


After [hiding the Perl Critic issues reported by the CPAN Testers](/fix-perl-critic-test-failures-reported-by-cpantesters)
I wanted to check what were those?

One of them was [Private Member Data shouldn't be accessed directly](/private-member-data-shouldnt-be-accessed-directly)
and the other one [Three-argument form of open used and it is not available until perl 5.6.](/three-argument-form-of-open-used-and-it-is-not-available-until)

The second policy lead me to the [Compatibility::PerlMinimumVersionAndWhy](https://metacpan.org/pod/Perl::Critic::Policy::Compatibility::PerlMinimumVersionAndWhy)
policy which seemed to be useful. It analyzes the source code and reports features that are only available in recent versions of perl.
For example the <a href="/what-is-new-in-perl-5.10--say-defined-or-state">defined-or (`//`)</a> appeared in perl 5.10.

The policy requires us to explicitly state the minimal version of perl in each one of our files.


I know, I've [removed the use use 5.005 statement](/use-strict-use-warnings-no-diagnostics) earlier
and now I am adding similar use-statements. I am not really convinced that adding the minimum version to
every file is that useful, but that allows me to use this policy.

The question:

## How to use the Compatibility::PerlMinimumVersionAndWhy policy?

After installing the [Perl-Critic-Pulp](https://metacpan.org/release/Perl-Critic-Pulp) distribution I could run:

```
perlcritic --single-policy Compatibility::PerlMinimumVersionAndWhy .
```

that generated quite a few lines, but all of them were versions of these lines:

```
[Compatibility::PerlMinimumVersionAndWhy] _perl_5006_pragmas requires 5.006 at line 2, column 1.
[Compatibility::PerlMinimumVersionAndWhy] _Pulp__for_loop_variable_using_my requires 5.004 at line 13, column 1.
[Compatibility::PerlMinimumVersionAndWhy] _Pulp__open_my_filehandle requires 5.006 at line 52, column 2.
[Compatibility::PerlMinimumVersionAndWhy] _three_argument_open requires 5.006 at line 52, column 2.
```

That means adding `use 5.006;` to all the files will silence this policy, but before we do that, let's see how
can we convince `perlcritic` to use this policy.

In the `.perlcriticrc` file we need to enable the `compatibility` theme as well:

```
theme = core + compatibility
```

That's not enough because the severity level of this specific policy was quite low. I think it was 2.
We had to tell perlcritic to use a higher severity:

```
[Compatibility::PerlMinimumVersionAndWhy]
severity = 5
```

that's fine, and now `perlcritic .` already started to report the validations,
but now it also reported about other violations. I had to turn the one I found off:

```
[-Compatibility::ProhibitThreeArgumentOpen]
```

Lastly, in order to get Travis-CI run these tests too I had to add

```
  - cpanm --notest Perl::Critic::Policy::Compatibility::PerlMinimumVersionAndWhy
```

to the `.travis.yml` file which I've actually failed at first, hence I had
to make a second commit fixing `.travis.yml`. 


[commit: set minimum version number in every perl file](https://github.com/szabgab/Pod-Tree/commit/72ffc7db0e1ad0f379050a5186055a0fef9fe6b5)

[commit: proper module name (in travis.yml file)](https://github.com/szabgab/Pod-Tree/commit/e0ab83ff25dce044c45f69ac47c62412a99f1b2e)
