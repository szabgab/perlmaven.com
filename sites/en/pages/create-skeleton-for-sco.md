---
title: "Getting started - Create skeleton for the SCO clone application"
timestamp: 2015-03-26T17:30:01
tags:
  - Test::More
  - SCO
  - Makefile.PL
types:
  - screencast
published: true
books:
  - search_cpan_org
author: szabgab
---


After writing down the [objectives and some plans](/search-cpan-org) for the "building of a search.cpan.org clone" project,
I decided to get started immediately.  At this phase of the project there is such a rush of energy and I am trying to get started quickly.


{% youtube id="Wp1qhb_mJ9s" file="create-skeleton-for-sco" %}

## Create Git repository, add README file

The very first thing was to create a directory called "sco" - I did not have an idea yet how  I am going to call the project.
Then I added a README file with some text explaining what this is about.

```
$ mkdir sco
$ cd sco
$ vim README

....

$ git init
$ git add .
$ git commit -m "start creating the project"
```

The text wasn't fancy (and at this point it was not on GitHub yet), but if you are interested you can take a look
at the [first commit](https://github.com/szabgab/MetaCPAN-SCO/commit/a65ffd70a2eac2b5d0335e1b684c816053d9ecef).


Then I went on and put more of my ideas ["on paper"](/search-cpan-org) and so
I could remove some of the text from the README file.

```
$ vim README

....

$ git add .
$ git commit -m "move some of the ideas to the article on Perl Maven"
```

[this commit](https://github.com/szabgab/MetaCPAN-SCO/commit/89feb412322c4788271d7ceac034ca890bc79f78)
resulted in [this README file](https://github.com/szabgab/MetaCPAN-SCO/blob/89feb412322c4788271d7ceac034ca890bc79f78/README).

## Creating the skeleton application

At this point I thought I should stick to the "rules" and start writing tests that would access the real [search.cpan.org](http://search.cpan.org/)
site. This would provide a test suite that can be used to check if the clone is the same. Of course right from this point I had some doubts too.
For one I the web site is dynamic and I have no control over the data behind it. So for example if I try to access the page of a module to check if
it contains the  information I expect, I cannot really be sure that the module will be on CPAN the next time I run the test. This is quite problematic
and we'll have to deal with it. For now, we can try to write some more generic tests.
Another concern  was that I know I won't create an exact replica. For example I  won't keep the "HTML 4.01" that is used with the current version of S.C.O.
Instead I'll use HTML 5. I am also sure that in many circumstances it will be hard or even impossible to show the same data. Either because of a bug
in S.C.O. that I don't want to reimplement, or because of some information that is not (yet?) available via the MetaCPAN API.

Anyway, let's get started with the skeleton of the application.

## Changes

It has the same layout as a standard distribution on CPAN. so I created a [Changes file](https://github.com/szabgab/MetaCPAN-SCO/blob/4ca4244f6e51aa8ac0129ee72ad1000e79b105aa/Changes)
with some simple text. The Changes files have been standardized to some extent and there is a [specification](https://metacpan.org/pod/CPAN::Changes::Spec). I usually
add the date to the version number when I actually release a module. In this case I am not sure if there are going to be real releases or if I'll just run the project
from a clone of the Git repository. In any case a Changes file can be useful.

### lib/SCO.pm

Created the [lib/SCO.pm](https://github.com/szabgab/MetaCPAN-SCO/blob/4ca4244f6e51aa8ac0129ee72ad1000e79b105aa/lib/SCO.pm) file. As I wrote, at this point I was not really
sure how I am going to call the project, but SCO seemed to be obvious. (Obviously bad, but I did not want to get stuck on the name. I can change it later.)

The code in **lib/SCO.pm** is quite standard for a module. Let's see it here:

```perl
package SCO;
use strict;
use warnings;

our $VERSION = '0.01';

=head1 NAME

SCO - search.cpan.org clone

=cut

1;
```

`package` declares the [name-space](/packages-modules-and-namespace-in-perl) of the module.
`use strict;` and `use warnings;` are the standard we [always add](/strict).
Creating the [safety net](/installing-perl-and-getting-started) for your perl program.

The there is `our $VERSION = '0.01';` declaring the version number of the module. We are going to manually increment this
at the official release and distribution of the module. It is important to have it in the file (either manually added as we are doing here
or automatically added by [Dist::Zilla](http://dzil.org/)) for two reasons. One of them is that Makefile.PL
is going to rely on this version number to know what is the version number of the whole distribution. The other is that
when someone complains about a bug, this version number can help quickly identify which version of the release they might be using.

Then a simple section of [POD](/pod-plain-old-documentation-of-perl) is added. This section declares
the "abstract" of the module. This is important as various places show this text. Read the suggestions of Neil Bowers about
[good abstracts](http://blogs.perl.org/users/neilb/2014/07/give-your-modules-a-good-abstract.html).
The section head is `NAME` an the content of the section should be: The name of the module/package/name-space,
followed by space-dash-space, followed by one line of text:

```
Module::Name - The abstract comes here
```

The module must end with some kind of a [true](/boolean-values-in-perl) value. The number 1 is quite standard for this.

You can read more about [creating a module](/how-to-create-a-perl-module-for-code-reuse).

### Test skeleton: t/10-sco.t

A module, or an application can't really be without unit or acceptance tests, so we also add a skeleton file
where we can later add tests.

[t/10-sco.t](https://github.com/szabgab/MetaCPAN-SCO/blob/4ca4244f6e51aa8ac0129ee72ad1000e79b105aa/t/10-sco.t)

The standard place of tests is in the **t/** subdirectory of the project and the standard extension is **.t**.
The name of the file does not really matter, but as the tests are normally run in alphabetical order, many people
add a numerical prefix to the filename to set the default order of the tests. This file is planned to
to have tests accessing the real search.cpan.org hence I called it `sco.t`.

**t/10-sco.t**

```perl
use strict;
use warnings;

use Test::More;
use Test::WWW::Mechanize;

plan tests => 1;

pass;
```

The content is just a skeleton tests script loading [Test::More](http://metacpan.org/pod/Test::More), declaring one test and calling `pass` just to make sure
the test script is successful. I also loaded [Test::WWW::Mechanize](https://metacpan.org/pod/Test::WWW::Mechanize) as I was planning to use it
to write tests that access [search.cpan.org](http://search.cpan.org/). We'll see that later. For a gentle introduction to testing
follow the articles in the [testing](/testing) series.


## Makefile.PL

The largest file I added in this step was the Makefile.PL which is used to package modules and to install them.
It is part of [Minimal requirement to build a sane CPAN package](/minimal-requirement-to-build-a-sane-cpan-package).

You can see the full version of [Makefile.PL](https://github.com/szabgab/MetaCPAN-SCO/blob/4ca4244f6e51aa8ac0129ee72ad1000e79b105aa/Makefile.PL) as it
was when I added it. I am working on separate article that will explain the parts of it, but let me point out a few items:

`NAME   => 'SCO',` because I had no better idea than to call the project **SCO**. This sets the name of the tar.gz file that will be created
if we create distribution out of this.

`AUTHOR  => 'Gabor Szabo <szabgab@cpan.org>',` just sets the author in the META files that will be included in the distribution.

`VERSION_FROM => 'lib/SCO.pm',` instruct ExtUtils::MakeMaker to fetch the `$VERSION` number from the `lib/SCO.pm` file.
This version number will be included in the META files and it will be used as part of the tar.gz filename.

`PREREQ_PM` will hold the list of modules we are using but so far we don't use anything for the skeleton code.

Later in the Makefile.PL we maintain a variable called `%test_requires` that holds the list of modules need to run the tests.

I think these are the most important parts of the Makefile.PL file as it is in this version.

Then, before adding all these to Git, I wanted to make sure these all work together as expected so I ran


```
$ perl Makefile.PL
$ make
$ make test
```


```
t/10-sco.t .. ok
All tests successful.
Files=1, Tests=1,  0 wallclock secs ( 0.02 usr  0.01 sys +  0.15 cusr  0.03 csys =  0.21 CPU)
Result: PASS
```

This showed me that everything was ok, but it also created a number of files that I don't need to have in Git.
So the last thing I did, before adding to Git was to create
[.gitignore](https://github.com/szabgab/MetaCPAN-SCO/blob/4ca4244f6e51aa8ac0129ee72ad1000e79b105aa/.gitignore)
and list all the files and directories I don't want to add to Git:

```
/MYMETA.*
/Makefile
/blib/
/pm_to_blib
```

Then I could run  the following to add the new files to Git:

```
$ git add .
$ git commit -m "Skeleton of a badly named module. Skeleton test"
```

resulting in [this commit](https://github.com/szabgab/MetaCPAN-SCO/commit/4ca4244f6e51aa8ac0129ee72ad1000e79b105aa).


## The full version of Makefile.PL

```perl
use strict;
use warnings;
use ExtUtils::MakeMaker;

my %conf = (
    NAME         => 'SCO',
    AUTHOR       => 'Gabor Szabo <szabgab@cpan.org>',
    VERSION_FROM => 'lib/SCO.pm',
    ABSTRACT_FROM => 'lib/SCO.pm',
    PREREQ_PM    => {
    },
);

if (eval { ExtUtils::MakeMaker->VERSION(6.3002) }) {
    $conf{LICENSE} = 'perl';
}


#if (eval { ExtUtils::MakeMaker->VERSION(6.46) }) {
#    $conf{META_MERGE} = {
#        'meta-spec' => { version => 2 },
#        resources => {
#            repository => {
#                type       => 'git',
#                url        => 'http://github.com/szabgab/Module-Name.git',
#                web        => 'http://github.com/szabgab/Module-Name',
#                license    => 'http://dev.perl.org/licenses/',
#            },
#            bugtracker => {
#                web        => 'http://github.com/szabgab/Module-Name/issues',
#            },
#            homepage   => 'https://perlmaven.com/',
#        },
#        x_contributors => [
#            'Peti Bar <petibar@cpan.org>',
#        ],
#        x_IRC => 'irc://irc.perl.org/#perl',
#        x_MailingList => 'http://lists.perl.org/list/perl-qa.html',
#    };
#}

my %configure_requires = (
    'ExtUtils::MakeMaker' => '6.64',
);
my %build_requires = ();
my %test_requires = (
    'Test::More'      => '1.00',
    'Test::WWW::Mechanize' => '0',

    # standard modules:
    #'File::Temp' => 0,
);

###   merging data "standard code"
if (eval { ExtUtils::MakeMaker->VERSION(6.52) }) {
    $conf{CONFIGURE_REQUIRES} = \%configure_requires;
} else {
    %{ $conf{PREREQ_PM} } = (%{ $conf{PREREQ_PM} }, %configure_requires);
}

if (eval { ExtUtils::MakeMaker->VERSION(6.5503) }) {
    $conf{BUILD_REQUIRES} = \%build_requires;
} else {
    %{ $conf{PREREQ_PM} } = (%{ $conf{PREREQ_PM} }, %build_requires);
}
if (eval { ExtUtils::MakeMaker->VERSION(6.64) }) {
    $conf{TEST_REQUIRES} = \%test_requires;
} else {
    %{ $conf{PREREQ_PM} } = (%{ $conf{PREREQ_PM} }, %test_requires);
}

WriteMakefile(%conf);
```


