---
title: "Run Perl::Tidy to beautify the code"
timestamp: 2016-02-10T19:30:01
tags:
  - Perl::Tidy
  - Code::TidyAll
  - Test::Code::TidyAll
published: true
books:
  - cpan_co_maintainer
  - testing
author: szabgab
archive: true
---


When contribution to the code of someone else we are supposed to stick to the same layout that was used by the original author,
but when you take over a module and start to maintain yourself you might feel more freedom to change the layout.

In this case the source code already had a mix of style, or at least a mix in the indentation.
Some lines used tabs some used spaces. This make the code very hard to read an maintain.

It is far better to stick to a well defined layout that can be easily generated.

Hence we use Perl::Tidy to beautify the code


The [Code-TidyAll](https://metacpan.org/release/Code-TidyAll) distribution provides a command line script
called [tidyall](https://metacpan.org/pod/distribution/Code-TidyAll/bin/tidyall) that will use
[Perl::Tidy](https://metacpan.org/pod/Perl::Tidy) to change the layout of the code.

This tandem needs 2 configuration file.

The `.perltidyrc` file contains the instructions to `Perl::Tidy` that describes the layout
of a Perl-file.  We used the following file copied from the source code of the Perl Maven project.

```
-pbp
-nst
-et=4
--maximum-line-length=120

# Break a line after opening/before closing token.
-vt=0
-vtc=0
```


The `tidyall` command uses a separate file called `.tidyallrc` that describes
which files need to be beautified.

```
[PerlTidy]
select = {lib,t}/**/*.{pl,pm,t}
select = Makefile.PL
select = {mod2html,podtree2html,pods2html,perl2html}
argv = --profile=$ROOT/.perltidyrc

[SortLines]
select = .gitignore
```

Once I installed [Code::TidyAll](https://metacpan.org/release/Code-TidyAll)
and placed those files in the root directory of the project,
I could run `tidyall -a`.

That created a directory called `.tidyall.d/` where it stores cached versions of the files,
and changed all the files that were matches by the `select` statements in the `.tidyallrc` file.

Then, I added `.tidyall.d/` to the `.gitignore` file to avoid adding that subdirectory
to the repository and ran `tidyall -a` again to make sure the `.gitignore` file is sorted.

Before commiting the files, I ran the test cycle again:

```
$ perl Makefile.PL
$ make
$ make test
```

[commit](https://github.com/szabgab/Pod-Tree/commit/417c49b0215730187175ad87cdf575a4e98b274c)

## Beauty contest or testing tidyness

It is not enough to run perltidy once. We have to make sure we keep the source code in the same level of tidyness.
We can ensure that by adding a test file that will check if the code is tidy.

In order to run this test we have to make sure the machine has Code::TidyAll installed, but there is no good reason
to run this on multiple machines. So it is probably better to write the test script in a way that will only run
if Code::TidyAll is installed.

The `t/95-tidyall.t` with the following content is just like that:

```perl
use strict;
use warnings;

use Test::More;

## no critic
eval 'use Test::Code::TidyAll 0.20';
plan skip_all => "Test::Code::TidyAll 0.20 required to check if the code is clean." if $@;
tidyall_ok();
```

It tries to load the [Test::Code::TidyAll](https://metacpan.org/release/Code-TidyAll) module,
and skips the tests if it could not load the test module. We can now run `make test`
and in addition to the regular tests, it will also check if the code is tidy.

What would be really good though is if this test also ran on [Travis-CI](/enable-travis-ci-for-continous-integration).

No problem, we only have to tell Travis-CI to install the [Test::Code::TidyAll](https://metacpan.org/release/Code-TidyAll) module,
before running the tests. We can do that by adding the following lines to `.travis.yml`

```
before_install:
  - cpanm --notest Test::Code::TidyAll
```

Then I [commited](https://github.com/szabgab/Pod-Tree/commit/3451d9166170f3d861e7255e9d77046615d5baff) the changes and went for a walk.

## Travis failure

When I cam back and e-mail was already waiting for me, showing a
[failure on Travis](https://travis-ci.org/szabgab/Pod-Tree/builds/63151328).

Clicking though one of the reports I saw this failure:

```
t/95-tidyall.t .. could not load plugin class 'Code::TidyAll::Plugin::PerlTidy':
   Can't locate Perl/Tidy.pm in @INC (you may need to install the Perl::Tidy module)
```

This surprised me a bit. Apparently [Test::Code::TidyAll](https://metacpan.org/pod/Test::Code::TidyAll)
does not automatically install [Perl::Tidy](https://metacpan.org/pod/Perl::Tidy).
So I changed `.travis.yml` to install Perl::Tidy as well:


```
before_install:
  - cpanm --notest Perl::Tidy
  - cpanm --notest Test::Code::TidyAll
```

and [commtted](https://github.com/szabgab/Pod-Tree/commit/5e2f3c1da03a76538c320444e9d364ea713da3d6) it.

That [fixed Travis](https://travis-ci.org/szabgab/Pod-Tree/builds/63154941).

## Keep tidy

From now on, we will have to remember to run `tidyall -a` every time before committing a change.
That way our code will always stay tidy. If we forget and we made a change that make the code untidy,
(and we forget to run the tests) then once we push it out to GitHub, Travis will fail and will tell us
about the lack of tidyness. Then we'll be able to run `tidyall -a` and make a new commit.
This will also ensure that people who might want to contribute to our code will use the same layout.



