---
title: "Improve Kwalitee (Pod::Tree 1.25)"
timestamp: 2016-03-09T07:30:01
tags:
  - CPANTS
published: true
books:
  - cpan_co_maintainer
author: szabgab
archive: true
---


There is a service called [CPANTS](http://cpants.cpanauthors.org/) (not to be confused with [CPAN Testers](http://cpantesters.org/))
that checks various "Kwalitee-metrics" of every CPAN distribution as it is uploaded. The idea behind this service was to look for issues with CPAN distributions
that can be indicators of low qualitee. Unfortunately, I think, in some cases people fix the issues reported by CPANTS - thus eliminating the indicator,
without making other changes to the distribution that would increase the real qualitee.

This decreeses the value of CPANTS as a tool to measure qualitee, but nevertheless, fixing the issues it reports is a good thing.


Before we get there though, there were a few other changes I made.

I made some minor changes to the documentation. Mostly eliminating indirect calls from it:

[commit](https://github.com/szabgab/Pod-Tree/commit/789e67649ffe3881f5c5adbb0392ce3496dcebf7)


## Number the test files

I've also renamed the test files to have a number prefix.
for example `t/cut.t` was renamed to `t/10-cut.t`.
I did this for a couple of reasons. One is that it makes them stand-out more from the other items listed in the `t/` directory.
(Though I was thinking I should move all the internal directories to some other place.)

Another reason is that people usually put numbers at the beginning of the test-file names to indicate order.
By default, when we run `make test` or `prove` the test scripts are executed in alpha-betical order.
Having these numbers at the beginning means it is easier for us to control the order of the tests which should usually be from simpler
to more complex. That's why I named the test checking for syntax errors `00-compile.t` so it will be the first to run.

[commit](https://github.com/szabgab/Pod-Tree/commit/6978911024f34d88bb4e4580388fa338b4fab48f)

Have you noticed what did I forget in that change?

I forgot to make the same change in the MANIFEST file. That was done in another
[commit](https://github.com/szabgab/Pod-Tree/commit/d2bdf644e816661fa6ca1d63a279ab8b82fc09e4).

## Kwalitee metrics

Soon after a distribution is uploaded the CPANTS bot downloads it and analyzes it looking for issues.
Then it creates a page for the distribution. The Pod::Tree module have [this page](http://cpants.cpanauthors.org/dist/Pod-Tree)
and within there is a tab called [Errors](http://cpants.cpanauthors.org/dist/Pod-Tree/errors). That's where you can find
the issues.

When I looked at it after releasing version 1.24 of Pod-Tree it had one issue:

```
manifest_matches_dist ["MANIFEST (204) does not match dist (203):","Missing in MANIFEST: ","Missing in Dist: META.yml"]
```

I looked at the MANIFEST file and I looked at the whole distribution. The distribution had the META.yml file
and the MANIFEST also had it listed. Twice.

When I looked at the MANIFEST file in the repository, it had META.yml only once but it did not have META.json.

I know that when I run `make dist` it automatically adds the the lines for META.yml and META.json to MANIFEST
with a comment "Module meta-data (added by MakeMaker)" if they were not there. Maybe there is a bug in ExtUtils::MakeMaker
that only checks if META.json is there and if it missing then it adds both META.yml  and META.json
I am not sure about that, but it seems quite obvious that reporting the duplicate META.yml in MANIFEST as missing META.yml
is a bug.

So I reported this as a [bug in CPANTS](https://github.com/cpants/www-cpants/issues/74).

I've also edited the MANIFEST file, removed the second META.yml entry and added a META.json entry.

<a href="https://github.com/szabgab/Pod-Tree/commit/bd4a308520aac8a0e89863150e2cbc623a0921b7"">commit</a>


I was actually surprised that this was the only Kwalitee failure, and I might need to look more closely at the CPANTS
site, but I went ahead and released version 1.25 of Pod::Tree

[commit](https://github.com/szabgab/Pod-Tree/commit/ac80b853abbeadd3c61cc4baf3e7bfe1ba23df6c).

Later I checked the CPANTS site again, and version 1.25 did not have any error.


