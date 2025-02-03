---
title: "Finish Perl::Critic cleanup, set up Test::Perl::Critic"
timestamp: 2016-02-17T23:50:01
tags:
  - Test::Perl::Critic
published: true
books:
  - cpan_co_maintainer
author: szabgab
archive: true
---


We finished the [previous step](/move-packages-to-their-own-files) with another run of perlcritic on the modules.
It complained about several things. We are going to deal with these issues now.


## Bareword file handles

One of the issues reported by perlcritic was the pair  `Bareword file handles` and `Two-argument "open"` in `lib/Pod/Tree/PerlDist.pm`
They are somewhat related.  I agree that one should [always use the 3-argument open](/always-use-3-argument-open), so that's the first step now.

Instead of

```perl
open( FILE, $source )
```

we'll write

```perl
open( my $FILE, '<', $source )
```


[commit](https://github.com/szabgab/Pod-Tree/commit/a091e954f7185141b17805e8b8f7a8212f23f381)

## Integer with leading zeros: "0755"

`0755` is better written as `oct(755)` as then it is clear that we really want it to be an octal number.

[commit](https://github.com/szabgab/Pod-Tree/commit/700ea7e05f050e42232e082cd2040c120d988ce2)

## "return" statement with explicit "undef"

This is a rather controversial rule among the Perl::Critic rules. It suggests we should call `return;` instead of `return undef;`
because the former, in [LIST context](/scalar-and-list-context-in-perl) will return an empty list and the latter always
returns and `undef`. This means in LIST context it will return a list of one element which, if assigned to an array and checked using
`if (@result)` will return `true`. In many cases it might be indeed better to just call `return`, but if someone uses
the function as part of a hash creation then returning nothing will break the code.

```perl
my %h = (
  'field1' => func(),
  'field2' => 42,
);
```

If in the above code `func` calls `return;` without any argument, then it will return the empty list and the
hash creation will complain about
[Odd number of elements in hash assignment](https://perlmaven.com/creating-hash-from-an-array), but much worse,
it will create a hash as if we had

```perl
my %h = (
  'field1' => 'field2',
  '42'     => undef,
);
```

So I'd rather leave the `return undef;` statements and tell Perl::Critic that it is ok.

Normally, when we run `perlcritic` we get the following report:

```
"return" statement with explicit "undef" at line 21, column 19.  See page 199 of PBP.  (Severity: 5)
```

We can run with a higher verbosity (e.g. with level 8) `perlcritic --verbose 8 lib/Pod/Tree/Stream.pm` in
which case the output will include the name of the rule:

```
[Subroutines::ProhibitExplicitReturnUndef] "return" statement with explicit "undef" at line 21, column 19.  (Severity: 5)
```

We can then edit the `lib/Pod/Tree/Stream.pm` file and add ` ##no critic (ProhibitExplicitReturnUndef)` to the
end of the line where the violation happens. This will tell `perlcritic` to stop complaining about this issue.

## Don't forget to tidy the code!

Then I ran the test `make test` and got the following failures:

```
t/95-tidyall.t .. 1/40 # [checked] lib/Pod/Tree/HTML.pm
# *** needs tidying

#   Failed test 'lib/Pod/Tree/HTML.pm'
#   at t/95-tidyall.t line 10.
# *** needs tidying
# [checked] lib/Pod/Tree/Stream.pm
# *** needs tidying

#   Failed test 'lib/Pod/Tree/Stream.pm'
#   at t/95-tidyall.t line 10.
# *** needs tidying
# Looks like you failed 2 tests of 40.
t/95-tidyall.t .. Dubious, test returned 2 (wstat 512, 0x200)
Failed 2/40 subtests
```

This means I have to run `tidyall -a` to let it rearrange the code.

[commit](https://github.com/szabgab/Pod-Tree/commit/6ca07b09c1c261da8a672e6cf6af76296326c9d1)

With that change the the main code is "Perl Critic clean" on the most gentle level.

## perlcritic of the tests

Let's go back to the tests and run `perlcritic t/*.t`. The result is

```
t/00-compile.t source OK
t/95-tidyall.t source OK
t/cut.t source OK
t/html.t source OK
t/load.t source OK
t/mapper.t: Package declaration must match filename at line 39, column 1.  Correct the filename or package statement.  (Severity: 5)
t/option.t source OK
t/pod.t: Package declaration must match filename at line 24, column 1.  Correct the filename or package statement.  (Severity: 5)
t/pod2html.t: Bareword file handle opened at line 52, column 2.  See pages 202,204 of PBP.  (Severity: 5)
t/pod2html.t: Two-argument "open" used at line 52, column 2.  See page 207 of PBP.  (Severity: 5)
t/pod2html.t: Bareword file handle opened at line 53, column 2.  See pages 202,204 of PBP.  (Severity: 5)
t/pod2html.t: Two-argument "open" used at line 53, column 2.  See page 207 of PBP.  (Severity: 5)
t/pods2html.t: Bareword file handle opened at line 128, column 2.  See pages 202,204 of PBP.  (Severity: 5)
t/pods2html.t: Two-argument "open" used at line 128, column 2.  See page 207 of PBP.  (Severity: 5)
t/pods2html.t: Bareword file handle opened at line 129, column 2.  See pages 202,204 of PBP.  (Severity: 5)
t/pods2html.t: Two-argument "open" used at line 129, column 2.  See page 207 of PBP.  (Severity: 5)
t/template.t source OK
t/tree.t source OK
```

Both `t/pod2html.t` and `t/pods2html.t` had the `Bareword` and the `Two-argument "open"`
violations reported in a function that provides the same functionality. They both look similar to this code:

```perl
sub Cmp {
    my ( $a, $b ) = @_;

    local $/ = undef;

    open A, $a or die "Can't open $a: $!\n";
    open B, $b or die "Can't open $b: $!\n";

    <A> ne <B>;
}
```

While `perlcritic` has not reported this, one should <b>not</b> use `$a` and `$b` in any situation
except when calling `sort`. Otherwise they can just confuse the readers. So we rename those to `$x` and `$y`,
and the `open` calls were also changed, and even the name of the function was changed to be the same in both file.

```perl
sub FileCmp {
    my ( $x, $y ) = @_;

    local $/ = undef;

    open my $fx, '<', $x or die "Can't open $x: $!\n";
    open my $fy, '<', $y or die "Can't open $y: $!\n";

    return <$fx> ne <$fy>;
}
```

[commit](https://github.com/szabgab/Pod-Tree/commit/a7aae8addbd5f04cf4825e2989f55d8f97a60179)

## RequireFilenameMatchesPackage

The remaining two violation were all related to test having `package` keywords in them.
As this might be important for the test, we let those violations stay and we just tell Perl::Critic
`## no critic (RequireFilenameMatchesPackage)`

[commit](https://github.com/szabgab/Pod-Tree/commit/322c41e57b882c36f6f35429a753b6497e642ebf)

## perlcritic .

Finally we can run `perlcritic .` and it will check all the perl-files, including the tests, the modules,
the scripts and even Makefile.PL. The result is:

```
./Makefile.PL: Code before strictures are enabled at line 6, column 1.  See page 429 of PBP.  (Severity: 5)
./mod2html source OK
./perl2html source OK
./pods2html source OK
./podtree2html source OK
t/00-compile.t source OK
t/95-tidyall.t source OK
t/cut.t source OK
t/html.t source OK
t/load.t source OK
t/mapper.t source OK
t/option.t source OK
t/pod.t source OK
t/pod2html.t source OK
t/pods2html.t source OK
t/template.t source OK
t/tree.t source OK
lib/Pod/Tree.pm source OK
t/pod2html.d/values.pl: Code before strictures are enabled at line 1, column 1.  See page 429 of PBP.  (Severity: 5)
t/pods2html.d/values.pl: Code before strictures are enabled at line 1, column 1.  See page 429 of PBP.  (Severity: 5)
t/tree.d/code.pm source OK
lib/Pod/Tree/BitBucket.pm source OK
lib/Pod/Tree/HTML.pm source OK
lib/Pod/Tree/Node.pm source OK
lib/Pod/Tree/PerlBin.pm source OK
lib/Pod/Tree/PerlDist.pm source OK
lib/Pod/Tree/PerlFunc.pm source OK
lib/Pod/Tree/PerlLib.pm source OK
lib/Pod/Tree/PerlMap.pm source OK
lib/Pod/Tree/PerlPod.pm source OK
lib/Pod/Tree/PerlTop.pm source OK
lib/Pod/Tree/PerlUtil.pm source OK
lib/Pod/Tree/Pod.pm source OK
lib/Pod/Tree/StrStream.pm source OK
lib/Pod/Tree/Stream.pm source OK
t/pods2html.d/pod/A.pm source OK
t/pods2html.d/podR/A.pm source OK
t/pods2html.d/podR_exp/A.pm source OK
lib/Pod/Tree/HTML/PerlTop.pm source OK
```

There were only 3 violations.


Before fixing those though, let's add a test script that will run `perlcritic`
that will ensure no violation is added.

## Test::Perl::Critic

For this we add a test script `t/96-perl-critic.t` with the following content:

```perl
use strict;
use warnings;
use Test::More;

## no critic
eval 'use Test::Perl::Critic 1.02';
plan skip_all => 'Test::Perl::Critic 1.02 required' if $@;

# NOTE: New files will be tested automatically.

# FIXME: Things should be removed (not added) to this list.
# Temporarily skip any files that existed before adding the tests.
# Eventually these should all be removed (once the files are cleaned up).
my %skip = map { ( $_ => 1 ) } qw(
);

my @files = grep { !$skip{$_} } ( Perl::Critic::Utils::all_perl_files(qw( Makefile.PL bin lib t )) );

foreach my $file (@files) {
    critic_ok( $file, $file );
}

done_testing();
```

I think originally I took this script from the source code of MetaCPAN where there were a few modules
that were not "perl critic clean" and that's why they needed to skip some of them.
We'll use this to get started.

I also created a file called `.perlcriticrc`

```
# please alpha sort config items as you add them

severity = 5
theme = core
verbose = 11
```

This is the file where we can configure the rules of Perl::Critic.
For now we only set the `severity` to be the most gentle, and the `theme` to be `core`.
That will make sure that even if additional Perl::Critic rules are installed on a system, our script
won't pick them up.

If I run `prove t/96-perl-critic.t` I get a rather verbose (level 11) version of the 3 violations we
saw earlier.

```
air:Pod-Tree gabor$ prove t/96-perl-critic.t
t/96-perl-critic.t .. 1/?
#   Failed test 'Makefile.PL'
#   at t/96-perl-critic.t line 20.
#
#   Code before strictures are enabled at line 6, near 'WriteMakefile('.
#   TestingAndDebugging::RequireUseStrict (Severity: 5)
#     Using strictures is probably the single most effective way to improve
#     the quality of your code. This policy requires that the `'use strict''
#     statement must come before any other statements except `package',
#     `require', and other `use' statements. Thus, all the code in the entire
#     package will be affected.
#
#     There are special exemptions for Moose, Moose::Role, and
#     Moose::Util::TypeConstraints because they enforces strictness; e.g.
#     `'use Moose'' is treated as equivalent to `'use strict''.
#
#     The maximum number of violations per document for this policy defaults
#     to 1.
t/96-perl-critic.t .. 16/?
#   Failed test 't/pod2html.d/values.pl'
#   at t/96-perl-critic.t line 20.
#
#   Code before strictures are enabled at line 1, near '$Pod::Tree::HTML::color = 'black';'.
#   TestingAndDebugging::RequireUseStrict (Severity: 5)
#     Using strictures is probably the single most effective way to improve
#     the quality of your code. This policy requires that the `'use strict''
#     statement must come before any other statements except `package',
#     `require', and other `use' statements. Thus, all the code in the entire
#     package will be affected.
#
#     There are special exemptions for Moose, Moose::Role, and
#     Moose::Util::TypeConstraints because they enforces strictness; e.g.
#     `'use Moose'' is treated as equivalent to `'use strict''.
#
#     The maximum number of violations per document for this policy defaults
#     to 1.
#   Failed test 't/pods2html.d/values.pl'
#   at t/96-perl-critic.t line 20.
#
#   Code before strictures are enabled at line 1, near '$Pod::Tree::HTML::color = 'black';'.
#   TestingAndDebugging::RequireUseStrict (Severity: 5)
#     Using strictures is probably the single most effective way to improve
#     the quality of your code. This policy requires that the `'use strict''
#     statement must come before any other statements except `package',
#     `require', and other `use' statements. Thus, all the code in the entire
#     package will be affected.
#
#     There are special exemptions for Moose, Moose::Role, and
#     Moose::Util::TypeConstraints because they enforces strictness; e.g.
#     `'use Moose'' is treated as equivalent to `'use strict''.
#
#     The maximum number of violations per document for this policy defaults
#     to 1.
t/96-perl-critic.t .. 32/? # Looks like you failed 3 tests of 36.
t/96-perl-critic.t .. Dubious, test returned 3 (wstat 768, 0x300)
Failed 3/36 subtests
```


## Avoid Perl::Critic by skipping files

In order to avoid the above test failure we can either fix the code or we can
ask the test to skip the specific files. In the next step we are going to fix the
files, but that's not always possible. Sometimes fixing all the files takes
a long time. In that case you can add the failing files to the skip-list and
remove them one-by-one as you manage to clean up the code.

The only thing we need to do is to edit the `t/96-perl-critic.t` and
change the creation of `%skip` hash listing the 3 files in violation:


```perl
my %skip = map { ( $_ => 1 ) } qw(
    Makefile.PL
    t/pod2html.d/values.pl
    t/pods2html.d/values.pl
);
```


Running `prove t/96-perl-critic.t` will now result in `All tests successful.`.

We could commit this to Git, but we still need to tell Travis to install the
[Test::Perl::Critic](https://metacpan.org/pod/Test::Perl::Critic) before running the
test. For this we change the `.travis.yml` to look like this:

```
before_install:
  - cpanm --notest Perl::Tidy
  - cpanm --notest Test::Code::TidyAll
  - cpanm --notest Test::Perl::Critic
```

[commit](https://github.com/szabgab/Pod-Tree/commit/e6b2efede6a2aa3642eeb921d8c81625ce3fe07a)


## Fixing the last 3 violations

Now that we have Perl::Critic testing in the project we can fix the 3 violations we left in
earlier and we can remove the 3 filenames from `t/96-perl-critic.t`. All 3 were complaining
about the lack of `use strict;` in the code.
Once I added `use strict;` and `use warnings;` there were no more violations reported.

Then before committing I wanted to run the test again so I started as usual:
`perl Makefile.PL` and got a bunch of errors:

```
Bareword "File::Find" not allowed while "strict subs" in use at Makefile.PL line 45.
Bareword "HTML::Stream" not allowed while "strict subs" in use at Makefile.PL line 45.
Bareword "IO::File" not allowed while "strict subs" in use at Makefile.PL line 45.
Bareword "IO::String" not allowed while "strict subs" in use at Makefile.PL line 45.
Bareword "Pod::Escapes" not allowed while "strict subs" in use at Makefile.PL line 45.
Bareword "Text::Template" not allowed while "strict subs" in use at Makefile.PL line 45.
Execution of Makefile.PL aborted due to compilation errors.
make: *** [Makefile] Error 255
```

Indeed Makefile.PL had a has using strings such a `HTML::Stream` as hash keys without putting
them in quotes. It looked strange to be but I wanted to see something complaining about that.

So I went in and added sigle-quotes around the names: `'File::Find' => 1`.

After that `perl Makefile.PL` could be executed without any warning or error
so I ran the usual cycle:

```
$ perl Makefile.PL
$ make
$ make test
```

And reached the next [commit](https://github.com/szabgab/Pod-Tree/commit/d25db61c0c7d80f5adf898ba155be172c912e695).

