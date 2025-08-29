---
title: "Construct the path to a file in the same directory as the current script"
timestamp: 2015-01-24T22:30:01
tags:
  - FindBin::Bin
  - File::Basename
  - File::Spec
  - Path::Tiny
published: true
author: nanis
archive: true
---


<i>
This is a guest post by [A. Sinan Unur](https://www.unur.com/) who usually writes about Perl on his
[Perl blog](http://blog.nu42.com/).
</i>

Perl and CPAN provide a plethora of tools to help you deal with directories
and files in a portable way. Using them also makes your intentions much
clearer than some random regexp pattern that "works" for you.


## Motivation

We live in a world where most developers can do just fine pretending that
everything runs on a kind of a Unixy operating system.  This seems to have
led to programmers forgetting, or never learning, some important lessons in
how to deal portably with operations involving files and directories.

Even if you do not care about your code being able to run on a system that
has different rules, using the facilities Perl and CPAN provide would add a
much needed amount clarity to your code which I regard as a worthy goal in
and of itself.

## A couple of cases in point

<p>Can you tell what each of the following lines of code does?</p>

(<a id="exampleA" href="https://bitbucket.org/jpeacock/version/src/d0a8bd97c2d89b0f72a314d39e10f237b2768f55/t/00impl-pp.t?at=default#cl-10">source of example A</a>)
```perl
(my $coretests = $0) =~ s'[^/]+\.t'coretests.pm';
```

<p>and</p>

(<a id="exampleB" href="https://github.com/ingydotnet/testml-pm/blob/80bda24252882194342a8bb1384d7c6e0e09a93f/lib/TestML/Runtime.pm#L19">source of example B</a>)
```perl
$self->{base} ||= $0 =~ m!(.*)/! ? $1 : ".";
```

[Example&nbsp;A](#exampleA) is from [version.pm](https://metacpan.org/pod/version)
and [example&nbsp;B](#exampleB) is from [TestML](https://metacpan.org/pod/TestML).

A lot of modules on CPAN depend on `version.pm`. On the other
hand, `TestML` seems to be a sneaky dependency for the new
`Inline::C` via Pegex. I am mentioning this to underline the fact
that these are not modules no one cares about.

Yet, their test code includes these unportable and opaque lines. I only
became aware of these due to unexpected test failures on my <a
href="http://blog.nu42.com/2014/11/64-bit-perl-5201-with-visual-studio.html">perl
5.20.1 built using Microsoft's Visual Studio 2013 Community Edition</a> on
 my Windows 8.1 system.

But, let's get back to the topic: What do these lines do?

[Example&nbsp;A](#exampleA) is an attempt to construct a path to
the file `coretests.pm` which is assumed to be in the same directory as the
current script. This is similar to
[adding a directory relative to the current script's location](/how-to-add-a-relative-directory-to-inc).

This file whose path is thus constructed is then <a
href="https://metacpan.org/pod/perlfunc#require ">require</a>d on the
subsequent line. Of course, there are many ways the substitution
`s'[^/]+\.t'coretests.pm'` can fail to work as intended, but the
most straightforward cause of failure would be due to code being run on a
system that does not use **/** as a directory separator in file names.

It is true that internal Windows APIs do not mind if you give them Unix
style paths. But, programs invoked via the shell do not offer that luxury.
Instead, most Windows console programs, following the DOS tradition, use the
**/** character for command line options.

When this test script is invoked as ```t\00impl-pp.t</code>, the
substitution ends up replacing the entire path in `$coretests` with
`'coretests.pm'`, and therefore the following
`require` looks for this file in the wrong directory.

Similarly, the code in [example&nbsp;B](#exampleB) simply tries
to capture the path to the directory containing the current executable. Once
again, this fails on Windows because the path in `$0` is unlikely
to contain a **/** in the right spot. In fact, much hilarity can
ensue if the path contains a mixture of **\** and **/** as
directory separators.

## Solutions

There are a number of ways of figuring out the directory in which the
currently running script is located. Each and every one of these would be a
better solution than these regular expression patterns.

First, their use would make it clear to the person reading your code the
intent behind the code. Second, if some other operating system with some
other directory separator became popular, you wouldn't have to locate each
and every place where you have used a string operation on a file name to
make your code work again. Third, these methods are likely to be a lot more
robust than your regular expression based solution.

For example, suppose you were running the test file from version.pm in the
following fashion:

```
prove product/stage.test/version-xyz/t/test.t
```

What would the substitution do then? Instead of having to consider this
question anew every time you want to construct the path to a file in the
same directory as the current script, you can use the facilities offered by
Perl and CPAN, and enjoy the benefits of the correctness and clarity they
offer.

Here are some alternatives. This is not an exhaustive list. In fact, I have
purposefully omitted a few for the sake of stimulating some discussion.

### Good old $FindBin::Bin

[FindBin](https://metacpan.org/pod/FindBin) has been in the core
since 5.00307. It used to have [an annoying aspect](http://www.perlmonks.org/?node_id=41213) which
has been <a href="http://blogs.perl.org/users/tinita/2015/01/findbin-is-fixed.html">fixed
in recent Perl distributions</a>. The bug resulted in the `$PATH` being
searched if `$0` contained a relative path, so you may want to
avoid it in code that is expected to run on older ```perl</code>s.

You can then use `File::Spec->catfile`:

```perl
use FindBin qw( $Bin );
use File::Spec;

my $coretests = File::Spec->catfile($Bin, 'coretests.pm');
```

### Even older File::Basename

[File::Basename](https://metacpan.org/pod/File::Basename) has
been in the core since 5.000. You can simply do:

```perl
use File::Basename ();
my $bindir = File::Basename::dirname($0);
```

This function tries to emulate the shell function by the same name, and you
can't rely on whether the returned path includes a trailing directory
separator, so, it may not be suitable in all circumstances, but, if anything
does go wrong, at least the person who is trying to diagnose your code
will know what you were trying to do.

Keep in mind that, as with `$FindBin::Bin` we still need a facility
to portably concatenate a file name to this path. Therefore, you may just
want to move directly to `File::Spec`.

One could also take advantage of the [lib](https://metacpan.org/pod/lib)
module to avoid having to explicitly construct the path to the file to be required:

```perl
use File::Basename ();
use lib File::Basename::dirname( $0 );

# ...

require coretests;
```

### File::Spec

[File::Spec](https://metacpan.org/pod/File::Spec) has been in the
core since 5.00405. You can simply do:

```perl
my ($volume, $bindir, undef) = File::Spec->splitpath($0);
```

then use

```perl
my $coretests = File::Spec->catpath($volume, $bindir, 'coretest.pm');
```

and your code will do the right thing on all operating systems
`File::Spec` knows about.

The `File::Spec` solution is portable, but it does feel a little
clunky due to the need to explicitly handle the possibility that the path may
include a volume name.

You can eliminate the temporary variables, but the resulting code is no less
clunky:

```perl
my $coretests = File::Spec->catpath(
    (File::Spec->splitpath($0))[0,1], 'coretests.pm'
);
```

Especially if your code deals with a lot of filesystem related operations,
and you are comfortable adding a non-core dependency to your project, you
may want to consider `Path::Class` or `Path::Tiny`.

### Path::Class

[Path::Class](https://metacpan.org/pod/Path::Class) is a
beautiful module. Using it, you can simply write:

```perl
my $coretests = file(file($0)->parent, 'coretests.pm');
```

`Path::Class` uses `File::Spec` internally, but hides
a lot more of the ugliness. It also provides various convenience methods so
you don't have to, say, re-invent `slurp` in every new module.

### Path::Tiny

[Path::Tiny](https://metacpan.org/pod/Path::Tiny) is an elegant
module that offers a nice, clean interface. It makes no guarantees for
anything other than Unix-like, and Win32 systems. It does allow you to write:

```perl
    my $coretests = path($0)->parent->child('coretests.pm');
```

to obtain the path to a file that is in the same directory as the current
script.

## Conclusion

In this post, motivated by a couple of examples, we looked at the question
of how to compose the path to a file that is in the same directory as the
currently executing script.

As is always the case with Perl, there are multiple ways of doing this. They
are all better than rolling your own incomplete method based on a simple
regular expression pattern. Not only does using using these modules make
your code more portable, and easier to understand, they have the benefit of
catering to corner cases you may not consider when you are busy banging out
regular expression patterns.

I care about this because I like Perl, and I consider it a missed
opportunity when `cpanm Some::Module` doesn't work due to an obscure
test failure in some other module because of an unwarranted assumption that
Unix style paths work everywhere.

Keep in mind the advice from <a
href="https://metacpan.org/pod/perlport#Files-and-Filesystems">perldoc
perlport</a>:

<blockquote>If all this is intimidating, have no (well, maybe only a little)
fear. There are modules that can help. The File::Spec modules provide
methods to do the Right Thing on whatever platform happens to be running the
program.</blockquote>

<h4>Notes:</h4>

The bug in ```TestML</code> was <a
href="https://github.com/ingydotnet/testml-pm/commit/7bf3fc8e5c42a64b9c97cc5eb2b89a9b725a9e39#diff-78c6c5047ddcc89d35ed9b341fdd10f3L19">fixed
in 0.52</a>.

A <a
href="https://bitbucket.org/jpeacock/version/pull-request/1/fix-test-failures-due-to-hard-coded/diff">pull
request against version</a> has been submitted.

