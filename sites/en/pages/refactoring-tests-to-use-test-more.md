---
title: "Refactor the tests to use Test::More (Pod::Tree 1.20)"
timestamp: 2016-02-02T22:30:01
tags:
  - Test::More
published: true
books:
  - cpan_co_maintainer
  - testing
author: szabgab
archive: true
---


A long time ago people used to write tests by printing out "ok" and "not ok" lines and a counter manually.
That's how they generated [TAP](/tap-test-anything-protocol).

There are still some distributions on CPAN that use that technique, usually because the author did not have the time to move them
over to be using [Test::Simple](/introducing-test-simple) and then onto
[Test::More](/moving-over-to-test-more).

We are going to that now.


## Converting first test to Test::More

Converting `t/cut.t`, the first step script in the `t/` directory was quite simple.
Within the code that was actually exercising the Pod::Tree module, it had the following lines

```perl
my $N = 1;
sub Not { print "not " }
sub OK  { print "ok ", $N++, "\n" }

print "1..6\n";

...

$actual eq $expected or Not; OK;
...
$actual eq $expected or Not; OK;
...
$actual eq $expected or Not; OK;
```

Every test was comparing two scalars using `eq` and using the [short circuit](/short-circuit)
of the boolean `or` it called the `Not` function only if the two scalars were not equal. It then
called the `OK` function. Having the two statements on one line was a bit confusing at first, but they
are separated with a semi-colon `;` so it is clear there are two independent statement on every line:
`$actual eq $expected or Not; OK;`

We could replace that line by `is $actual, $expected;`

The `print "1..6\n";` line just prints the expected number of tests. This is what the
`use Test::More tests => 6;` statement.

The `$N` is the counter. We won't need that as Test::More counts automatically.

Replacing all that was quite simple.

Then I could run `prove -l t/cut.t`.
When I saw that all tests are still passing I wanted to commit the changes and push it out to let Travis-CI
run them.

Before doing that I also had to add Test::More as a prerequisite to `Makefile.PL`.

[commit](https://github.com/szabgab/Pod-Tree/commit/964f99398e7d497c28fd7a528cd6f42c714bfe25)

This triggered [Travis-CI](https://travis-ci.org/szabgab/Pod-Tree/builds/63045749) which reported all test passing.

## Converting more tests to Test::More

`t/load.t`, `t/option.t`, `t/pod.t`, and `t/template.t` had exactly the same lines so they
needed the same changes. [commit](https://github.com/szabgab/Pod-Tree/commit/b3dcdeb7883b0db4e67e0292607cf47c31ec2dce).

`t/tree.t` had another type of test-case:

```perl
($tree->has_pod xor $expected) and Not; OK;
```

Because this uses `and` for [short circuit](/short-circuit) this could be converted to

```perl
ok !($tree->has_pod xor $expected);
```

with the negation in-front of the `xor` expression.

`t/pod2html.t` had lines like this:

```perl
Cmp($html, $exp) and Not; OK;
```

I did not want to go deeper in this refactoring and did not want to change the `Cmp` function,
and here too `and` was used for the [short circuit](/short-circuit),
so I replaced those types of expressions with the following expression:

```perl
ok ! Cmp($html, $exp);
```

`t/pods2html.t` had a variable `$Skip` declared, but never used. Probably a left-over from some previous
version of the code. I could get rid of it.

In addition it had several lines that looked like this one:

```perl
RDiff("$d/html_exp", "$d/html_act") and Not; OK;
```

Which again could be replaced with a negated `ok` call.

```perl
ok ! RDiff("$d/html_exp", "$d/html_act");
```

[commit](https://github.com/szabgab/Pod-Tree/commit/b8369da7886e2386885b400833979910dbba95df)

The remaining two test files `t/html.t` and `t/mapper.t` aren't that different either.
Basically the only difference is that the their `OK` function looks like this:


```perl
sub OK  { print "ok ", $N++, ' ', (caller 1)[3], "\n" }
```

The `caller` function of perl will return the given entry in the call-stack of the currently
executing code. `caller 1` will return the entry from the previous call. The 4th element of the returned
array (index 3) is the name of the function. So basically this snippet will print the calling function as the name
if the test. As the name of the test is only relevant to the person who is looking at the results I could just get rid
of this, but this information is needed in order to make it easier for the user to locate a failing test.

In the Test::More environment we don't need this as Test::More automatically ads this information to the failing tests.

So we can really just get rid of that extra part as well.

[commit](https://github.com/szabgab/Pod-Tree/commit/13b5cba30d5316216c563c4c49a1d9bb42f22844)

## Gitignore .swp files

While I was editing the test files using vim, once in a while I ran `git status` and notices it reported
on some `...swp` not being tracked. I don't want to add these files by accident so I added
`*.swp` to the `.gitignore` file.

[commit](https://github.com/szabgab/Pod-Tree/commit/ab30f3e2d2e0c2da214f1880b6bd46c89709de10)

## Release of 1.20

Then I've updated the version number in `lib/Pod/Tree.pm` to 1.20, included information in the Changes file
and released version 1.20.

[commit](https://github.com/szabgab/Pod-Tree/commit/fc727154350867ea3c4dcbaefd4696b03df948f2)


