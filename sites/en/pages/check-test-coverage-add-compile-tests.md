---
title: "Check test coverage - add compile tests"
timestamp: 2016-02-05T08:30:01
tags:
  - Test::Compile
  - Devel::Cover
published: true
books:
  - cpan_co_maintainer
  - testing
author: szabgab
archive: true
---


At this point I had quite some struggle to decide what to do next.

I really wanted to run perltidy and perlcritic, and fix some of code snippets that were bothering me,
in general to make the code more readable, but I knew the "proper" way is to first have a good test coverage.

So I generated the test coverage report. That seemed to indicate a good test coverage.

Except that there were a number of functions not covered and there were a number of modules never loaded to memory.
I could add tests using the code that were not loaded during the tests, but who knows,
maybe those functions are not in use any more.


## First pull request

Before going to the test coverage part though, let's see the first pull-request I've received.

One of the nice things about Git and GitHub is that they make it very easy for people to
contribute small fixes to the code. No one needs to handle issues of permissions and once
the send me a change in the from of a "pull request" I can accept and merge their changes
using one click on the web interface of GitHub. That makes it much easier.

That's what happened. [Henk van Oers](https://github.com/hvoers) noticed that there
is some incorrect information in the README file. He sent a [pull request](https://github.com/szabgab/Pod-Tree/pull/1)
that I have [merged](https://github.com/szabgab/Pod-Tree/commit/1cc51548dc9142b29b8f0ae7875fd51519c2bf57).

## Update README

If we were at the README file, I also updated it removing some old information.
[commit](https://github.com/szabgab/Pod-Tree/commit/e7fdc4122af04c92ee4e7bef5fd7d526e148d689).

## Generating test coverage report

The [Devel::Cover](https://metacpan.org/pod/Devel::Cover) includes a script called `cover`
that can run all the tests, collect data on which lines were executed, and generate a report.

So I installed Devel::Cover and ran `cover -test`.
After finishing the tests it printed an ASCII summary:

<pre>
---------------------------- ------ ------ ------ ------ ------ ------ ------
File                           stmt   bran   cond    sub    pod   time  total
---------------------------- ------ ------ ------ ------ ------ ------ ------
blib/lib/Pod/Tree.pm           76.8   71.0   33.3   76.9  100.0   58.0   76.6
blib/lib/Pod/Tree/HTML.pm      96.7   90.4   72.7   94.6   61.5   26.2   93.8
blib/lib/Pod/Tree/Node.pm      93.1   89.6   84.8   89.4   41.4   15.2   86.5
blib/lib/Pod/Tree/Pod.pm       81.8   75.0    n/a   95.4  100.0    0.4   82.2
Total                          90.4   86.0   78.7   89.9   53.0  100.0   87.0
---------------------------- ------ ------ ------ ------ ------ ------ ------
</pre>

and also create a much nicer and much more detailed HTML report.

This report seems to indicate a nice test coverage, but there are a number of
modules called `lib/Pod/Tree/Perl*.pm` that are not included in the report.
Probably because they were not loaded during the test run.

I checked the reports and the source code. in the report about Tree.pm I can
see that there is a private function call `_add_paragraph` that is never
used. (It is not mentioned anywhere in the whole directory structure. Not even
in the documentation. I could probably remove it or at least comment it out,
but we can also leave it for later. There is no need to be that aggressive
in refactoring.

There are also a number of methods, such as `pop` and `push`
that are mentioned in the documentation but are not used in the source code.
We'll have to add tests using those functions.

Finally the modules. Those modules are used by the `perl2html` command line script.

Before making further changes, I had to add `cover_db/` to `.gitignore` to
avoid adding it to the repository by mistake:

[commit](https://github.com/szabgab/Pod-Tree/commit/05d3b133f442d7ef4ccec8f496a3c2ef3b1bb0bd).

## Check if all the Perl files compile

Usually when I write tests for Perl code, one of the first tests I add is checking if the files
even compile. Having that as the first test script to run can save quite some headache.
It help filtering out the obvious cases when a change left in a syntax error.

The [Test::Compile](https://metacpan.org/pod/Test::Compile) helps with this
providing an easy way to test all the modules and all the script and providing
reports integrated into the Test::More framework.

I've added a file called `t/00-compile.t` with the following content:

```perl
use strict;
use warnings;
use Test::Compile;

my @scripts = qw(mod2html podtree2html pods2html perl2html);
my $test = Test::Compile->new();
$test->all_files_ok();
$test->pl_file_compiles($_) for @scripts;
$test->done_testing();
```

The `all_files_ok` call will check all the `.pm` files found in the
`lib` directory, but it could not recognize the 4 perl scripts we have in the root
directory. Hence I also had to add the names of the files and run `pl_file_compiles`
on each one of them.

I've also added Test::Compile to Makefile.PL as a prerequisite.

[commit](https://github.com/szabgab/Pod-Tree/commit/bd852f7417a404b0300aa8cd3fe6d533e86aeee2)

At first there was also another line `$test->all_pl_files('.');` in the 
test script, but that proved to be unnecessary. Hence I removed it in a
subsequent [commit](https://github.com/szabgab/Pod-Tree/commit/ebe7bca3c81727bea1988b420b5df53d0efcf878).

## New coverage report

Once I made the changes I ran `cover -test` again. This time the result
showed all the modules, but because those modules were only loaded into memory and
never actually used, their test coverage is quite low.


<pre>
---------------------------- ------ ------ ------ ------ ------ ------ ------
File                           stmt   bran   cond    sub    pod   time  total
---------------------------- ------ ------ ------ ------ ------ ------ ------
blib/lib/Pod/Tree.pm           76.8   71.0   33.3   76.9  100.0    4.8   76.6
blib/lib/Pod/Tree/HTML.pm      96.7   90.4   72.7   94.6   61.5    3.4   93.8
blib/lib/Pod/Tree/Node.pm      93.1   89.6   84.8   89.4   41.4    4.2   86.5
blib/lib/Pod/Tree/PerlBin.pm   21.6    0.0    0.0   44.4   71.4    3.6   23.4
.../lib/Pod/Tree/PerlDist.pm   17.2    0.0    0.0   43.7   62.5    5.3   19.1
.../lib/Pod/Tree/PerlFunc.pm   12.5    0.0    0.0   33.3   40.0    7.0   14.7
blib/lib/Pod/Tree/PerlLib.pm   18.9    0.0    0.0   42.1  100.0    8.8   21.5
blib/lib/Pod/Tree/PerlMap.pm   12.5    0.0    0.0   14.2   83.3   10.4   19.1
blib/lib/Pod/Tree/PerlPod.pm   21.0    0.0    0.0   42.1  100.0   10.7   23.5
blib/lib/Pod/Tree/PerlTop.pm   16.2    0.0    n/a   37.5  100.0   12.5   19.8
.../lib/Pod/Tree/PerlUtil.pm   13.0    0.0    0.0   28.5    0.0   14.2    9.6
blib/lib/Pod/Tree/Pod.pm       81.8   75.0    n/a   95.4  100.0   14.6   82.2
Total                          58.1   64.2   43.0   70.5   57.4  100.0   59.9
---------------------------- ------ ------ ------ ------ ------ ------ ------
</pre>

Armed with this I think we can already start doing some real refactoring.
We might just need to pay attention and only change code that has been tested.

