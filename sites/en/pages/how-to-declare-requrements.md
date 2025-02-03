---
title: "How to declare requirements of a CPAN distribution?"
timestamp: 2016-03-08T20:30:01
tags:
  - ExtUtils::MakeMaker
published: true
books:
  - cpan_co_maintainer
author: szabgab
archive: true
---


After [releasing version 1.24 of Pod::Tree](/perl-critic-exclude-policies-fix-others), the CPAN Testers
reports started to flow in. Most of them [reported success](http://www.cpantesters.org/distro/P/Pod-Tree.html?oncpan=1&distmat=1&version=1.24&grade=2),
but there were a few [failure reports](http://www.cpantesters.org/distro/P/Pod-Tree.html?oncpan=1&distmat=1&version=1.24&grade=3) as well.

Like [this report](http://www.cpantesters.org/cpan/report/fcd487c9-6bfc-1014-9bdf-5360fbbcbeb0).


They all seemed to complain about the same thing:

```
Can't locate object method "new" via package "Test::Compile" at t/00-compile.t line 6.
t/00-compile.t ......
Dubious, test returned 255 (wstat 65280, 0xff00)
No subtests run
```

That was strange, but I recalled a [similar report](https://github.com/hvoers/Pod-Tree/commit/61beb53ff389b83dbb491264b7537a2397b6d026) earlier
by Henk van Oers. Back then we did not do anything with it, he has just upgraded [Test::Compile](https://metacpan.org/pod/Test::Compile)
to the latest release and that fixed the issue for him. I have not asled him how he even got to the situation where his version of Test::Compile
was older than what I put as requirement into `Makefile.PL` that looked like this:

```
'Test::Compile'  => 1.2.1,
```

I figured, maybe he has not run `perl Makefile.PL` or for some reason disregarded when `Makefile.PL` ask him to upgrade
the module. That happens when we do things manually, but that does not require any fixing in Pod::Tree.

However this time the automated smoke-test gave similar error messages so
I went to the [test report](http://www.cpantesters.org/cpan/report/fcd487c9-6bfc-1014-9bdf-5360fbbcbeb0) again and
looked at the "PREREQUISITES" section that looked like this:

<pre>
------------------------------
PREREQUISITES
------------------------------

Prerequisite modules loaded:

requires:

    Module              Need  Have    
    ------------------- ----- --------
    File::Find          1     1.23    
    HTML::Stream        1.49  1.60    
    IO::File            1     1.16    
    IO::String          1     1.08    
    Path::Tiny          0.068 0.068   
    Pod::Escapes        1.02  1.04    
    Test::Compile       0     0.24    
    Test::More          1     1.001002
    Text::Template      1     1.46    

build_requires:

    Module              Need  Have    
    ------------------- ----- --------
    ExtUtils::MakeMaker 0     6.84    

configure_requires:

    Module              Need  Have    
    ------------------- ----- --------
    ExtUtils::MakeMaker 0     6.84    
</pre>

Specifically the "Need" column.

For every other module Makefile.PL has correctly set the "Need" to the number we have in Makefile.PL except for Test::Compare.

Obviously if the requirement is to have version 0 and a machine already has version 0.24 then it won't be upgraded and then
we'll get the error Henk received and the CPAN Tester received. The question then

## Why does Makefile.PL think 1.2.1 is 0 ?

I asked it on the [CPAN Testers discussion list](http://lists.perl.org/list/cpan-testers-discuss.html) and I got a few
responses in [this thread](http://www.nntp.perl.org/group/perl.cpan.testers.discuss/2015/05/msg3630.html).

I got several answers, one of them from [Alexandr Ciornii](http://chorny.net/), the owner of that smoke-machine. It's nice to get a quick response from
people who are so involved.

Normally 1.2.1 should be seen as a so-called v-string, but old versions of [ExtUtils::MakeMaker](https://metacpan.org/pod/ExtUtils::MakeMaker)
don't recognize it and assume 0.

The recommended solutions were either to add quotes around the thing (I can't really call it a number, can I?) and write

```
'Test::Compile'  => '1.2.1',
```

or it could be written in decimal form:

```
'Test::Compile'  => 1.002001,
```

A third alternative would be to just use one decimal point and disregard the extra digit, though this is not exactly
the same requirement.

```
'Test::Compile'  => 1.2,
```


At the same time I also received a [pull request](https://github.com/szabgab/Pod-Tree/pull/3) from
[Alexandr Ciornii](http://chorny.net/) using the [quotes around the version number](https://github.com/chorny/Pod-Tree/commit/4710266078da5e09986cc7757f7b059df4ea83dc).
He even sneaked in a change [adding use 5.006](https://github.com/chorny/Pod-Tree/commit/a9fbb8d8221944c13a3c5a1e5ab0798491fbd6bc) to `Makefile.PL`

I have accepted the pull request and [merged it](https://github.com/szabgab/Pod-Tree/commit/e384fbf900e8000f2389777d5a4e918ad2e3d7a2).

## Do not declare test prereqs as runtime prereqs

In addition to the above pull-request, I've also received a new [issue](https://github.com/szabgab/Pod-Tree/issues/4).

The thing is that I've added several modules to the `PREREQ_PM` of the `Makefile.PL` that we only need for testings.
For example Test::More and Test::Compile that we just had issues with.
This means people who install the module will also need to install those modules and not just in a temporary directory.
This means that downstream distributors (e.g. Linux distributions, and BSDs) that want to re-distribute the Pod-Tree distribution will
have to set all these modules as runtime prerequisites.

I don't think it is a big issue, disk space is very cheap, but I think it is better to state the requirements properly.

So I changed the `Makefile.PL` a bit. Created a main `%config` that will be later passed to the `WriteMakefile` function.
Moved the list of test-modules to a separate hash and added them back to the `%config` based on the version number of ExtUtils::MakeMaker.

```perl
my %config = (
    NAME         => 'Pod::Tree',
    VERSION_FROM => 'lib/Pod/Tree.pm',    # finds $VERSION
    DISTNAME     => 'Pod-Tree',
    ...
    PREREQ_PM => {
        'File::Find'     => 1,
        'HTML::Stream'   => 1.49,
        'IO::File'       => 1,
        'IO::String'     => 1,
        'Pod::Escapes'   => 1.02,
        'Text::Template' => 1,
    },
    ...
);
my %test_requires = (
    'Test::More'    => 1,
    'Test::Compile' => '1.2.1',
    'Path::Tiny'    => 0.068,
);

if ( eval { ExtUtils::MakeMaker->VERSION(6.64) } ) {
    $config{TEST_REQUIRES} = \%test_requires;
}
else {
    $config{BUILD_REQUIRES} = \%test_requires;
}

WriteMakefile(%config);
```

[commit](https://github.com/szabgab/Pod-Tree/commit/3bdb082dbdc51ade68d68585595a9e932eacdced)

I hope this will work correctly.

