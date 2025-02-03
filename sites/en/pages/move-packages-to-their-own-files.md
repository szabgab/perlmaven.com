---
title: "Move packages to their own files - release Pod::Tree 1.21"
timestamp: 2016-02-16T19:50:01
tags:
  - Perl::Critic
  - perlcritic
published: true
books:
  - cpan_co_maintainer
author: szabgab
archive: true
---


After fixing the [use strict; use warnings;](/use-strict-use-warnings-no-diagnostics) we can go back to using Perl::Critic.
I ran `perlcritic lib/Pod` that provides some issues to be fixed.


## perlcritic

The output of `perlcritic lib/Pod` looked like this:

```
lib/Pod/Tree/HTML.pm: Package declaration must match filename at line 11, column 1.  Correct the filename or package statement.  (Severity: 5)
lib/Pod/Tree/HTML.pm: "return" statement with explicit "undef" at line 229, column 12.  See page 199 of PBP.  (Severity: 5)
lib/Pod/Tree/HTML.pm: "return" statement with explicit "undef" at line 234, column 12.  See page 199 of PBP.  (Severity: 5)
lib/Pod/Tree/Node.pm source OK
lib/Pod/Tree/PerlBin.pm source OK
lib/Pod/Tree/PerlDist.pm: Bareword file handle opened at line 155, column 3.  See pages 202,204 of PBP.  (Severity: 5)
lib/Pod/Tree/PerlDist.pm: Two-argument "open" used at line 155, column 3.  See page 207 of PBP.  (Severity: 5)
lib/Pod/Tree/PerlDist.pm: Bareword file handle opened at line 184, column 2.  See pages 202,204 of PBP.  (Severity: 5)
lib/Pod/Tree/PerlDist.pm: Two-argument "open" used at line 184, column 2.  See page 207 of PBP.  (Severity: 5)
lib/Pod/Tree/PerlFunc.pm source OK
lib/Pod/Tree/PerlLib.pm source OK
lib/Pod/Tree/PerlMap.pm source OK
lib/Pod/Tree/PerlPod.pm source OK
lib/Pod/Tree/PerlTop.pm: Package declaration must match filename at line 6, column 1.  Correct the filename or package statement.  (Severity: 5)
lib/Pod/Tree/PerlUtil.pm: Integer with leading zeros: "0755" at line 10, column 24.  See page 58 of PBP.  (Severity: 5)
lib/Pod/Tree/Pod.pm source OK
lib/Pod/Tree.pm: Package declaration must match filename at line 5, column 1.  Correct the filename or package statement.  (Severity: 5)
lib/Pod/Tree.pm: "return" statement with explicit "undef" at line 25, column 19.  See page 199 of PBP.  (Severity: 5)
```

## Package declaration must match filename

This is usually happens when we have  more than one `package` statements in a file. It works, but usually it is a lot more <b>readable</b>
if every `package` is in its own file.

I've moved the content of `package Pod::Tree::BitBucket;` to the `lib/Pod/Tree/BitBucket.pm` and
the content of `package Pod::Tree::StrStream;` was moved to `lib/Pod/Tree/StrStream.pm`.
In both cases I already had `use strict;` and `use warnings;` in the package. That's what
I did in the [earlier](/use-strict-use-warnings-no-diagnostics), but I still had to add
`1;` at the end of the files to let it [return true](/how-to-create-a-perl-module-for-code-reuse).

Instead of those I put a
`use Pod::Tree::BitBucket;` and `use Pod::Tree::StrStream;` statements in the lib/Pod/Tree/HTML.pm

[commit](https://github.com/szabgab/Pod-Tree/commit/c1fd646f731b7f78a9ff91bedf32d842d90f9c26)

The next step was to do the same and factoring out the `package Pod::Tree::Stream;` from `lib/Pod/Tree.pm`
to `lib/Pod/Tree/Stream.pm` replacing it with a `use Pod::Tree::Stream;` statement.

[commit](https://github.com/szabgab/Pod-Tree/commit/fe47cb47f48af612ee88d25d89d3b736ef1a36f9)

Then there was the separation of `package Pod::Tree::HTML::PerlTop;` as well.

[commit](https://github.com/szabgab/Pod-Tree/commit/d2747ddae5861610a834631a81bda7804e4f4ee2).

After each such step, before committing the changes I've ran the tests and after committing the changes
and pushing them out to GitHub, it has also triggered Travis-CI to build and test the code.

This, along with the decent test coverage provides me the necessary confidence to make bold changes and move forward.

## perlcritic again

I ran `perlcritic lib/Pod` again. This time the output was much smaller:

```
lib/Pod/Tree.pm source OK
lib/Pod/Tree/BitBucket.pm source OK
lib/Pod/Tree/HTML.pm: "return" statement with explicit "undef" at line 197, column 12.  See page 199 of PBP.  (Severity: 5)
lib/Pod/Tree/HTML.pm: "return" statement with explicit "undef" at line 202, column 12.  See page 199 of PBP.  (Severity: 5)
lib/Pod/Tree/Node.pm source OK
lib/Pod/Tree/PerlBin.pm source OK
lib/Pod/Tree/PerlDist.pm: Bareword file handle opened at line 155, column 3.  See pages 202,204 of PBP.  (Severity: 5)
lib/Pod/Tree/PerlDist.pm: Two-argument "open" used at line 155, column 3.  See page 207 of PBP.  (Severity: 5)
lib/Pod/Tree/PerlDist.pm: Bareword file handle opened at line 184, column 2.  See pages 202,204 of PBP.  (Severity: 5)
lib/Pod/Tree/PerlDist.pm: Two-argument "open" used at line 184, column 2.  See page 207 of PBP.  (Severity: 5)
lib/Pod/Tree/PerlFunc.pm source OK
lib/Pod/Tree/PerlLib.pm source OK
lib/Pod/Tree/PerlMap.pm source OK
lib/Pod/Tree/PerlPod.pm source OK
lib/Pod/Tree/PerlTop.pm source OK
lib/Pod/Tree/PerlUtil.pm: Integer with leading zeros: "0755" at line 10, column 24.  See page 58 of PBP.  (Severity: 5)
lib/Pod/Tree/Pod.pm source OK
lib/Pod/Tree/StrStream.pm source OK
lib/Pod/Tree/Stream.pm: "return" statement with explicit "undef" at line 21, column 19.  See page 199 of PBP.  (Severity: 5)
lib/Pod/Tree/HTML/PerlTop.pm source OK
```

We can go forward making changes, but I think it is also a good idea to make use of the [CPAN Testers](http://cpantesters.org/).

So I've release version 1.21.

[commit](https://github.com/szabgab/Pod-Tree/commit/3b7c800429d9b74350e8b3e5f16669115e94da0f)


