---
title: "Rename the SCO cloning project"
timestamp: 2015-04-14T08:00:01
tags:
  - Git
  - SCO
types:
  - screencast
published: true
books:
  - search_cpan_org
author: szabgab
---


Once I started to work on the project I quickly realized that calling the project 'sco' and calling the perl module implementing it 'SCO.pm' is not
a good idea. As this implementation is going to use the MetaCPAN API as its back-end, I thought it might better to call it `MetaCPAN::SCO`.
And thus I had to rename the already existing parts of the project.


{% youtube id="s16pT3J1hRo" file="rename-the-sco-project" %}

Create lib/MetaCPAN and move lib/SCP.pm to lib/MetaCPAN/SCO.pm

In Makefile.PL change the NAME, the VERSION_FROM, the ABSTRACT_FROM to match the new name

As now I feel confident in the name, I can also create a repository on GitHub called [MetaCPAN-SCO](https://github.com/szabgab/MetaCPAN-SCO),
enable the link to GitHub in the Makefile.PL (and make sure they link to this repository).


```
$ mkdir lib/MetaCPAN
$ git mv lib/SCO.pm lib/MetaCPAN/
$ git add .
$ git commit -m"Have a change of hart and start calling the project MetaCPAN::SCO"
```
[commit](https://github.com/szabgab/MetaCPAN-SCO/commit/94b257cdb6930c056bf07278d6560e067d6e316b)

Then push the whole repository out to GitHub:

```
$ git remote add origin git@github.com:szabgab/MetaCPAN-SCO.git
$ git push -u origin master
```



## Makefile.PL

The new version of the file.

```perl
use strict;
use warnings;
use ExtUtils::MakeMaker;

my %conf = (
    NAME         => 'MetaCPAN::SCO',
    AUTHOR       => 'Gabor Szabo <szabgab@cpan.org>',
    VERSION_FROM => 'lib/MetaCPAN/SCO.pm',
    PREREQ_PM    => {
    },
);

if (eval { ExtUtils::MakeMaker->VERSION(6.3002) }) {
    $conf{LICENSE} = 'perl';
}


if (eval { ExtUtils::MakeMaker->VERSION(6.46) }) {
    $conf{META_MERGE} = {
        'meta-spec' => { version => 2 },
        resources => {
            repository => {
                type       => 'git',
                url        => 'http://github.com/szabgab/MetaCPAN-SCO.git',
                web        => 'http://github.com/szabgab/MetaCPAN-SCO',
                license    => 'http://dev.perl.org/licenses/',
            },
            bugtracker => {
                web        => 'http://github.com/szabgab/MetaCPAN-SCO/issues',
            },
            homepage   => 'https://perlmaven.com/',
        },
    };
}

my %configure_requires = (
    'ExtUtils::MakeMaker' => '6.64',
);
my %build_requires = ();
my %test_requires = (
    'Test::More'           => '1.00',
    'Test::WWW::Mechanize' => '0',
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

WriteMakefile(%conf)
```


## change package name as well

Later, as I worked on the code a bit more, I noticed that I've forgotten to change the package name in the module to match the new name.
So I edited `lib/MetaCPAN/SCO.pm` and replaced `package SCO;` by `package MetaCPAN::SCO;`.

Not a big change but it is worth to add it to Git.

```
$ git add .
$ git commit -m "change package name as well"
```

[commit](https://github.com/szabgab/MetaCPAN-SCO/commit/d8b2b3bfc94e2e73259d1840f12ec4c734059274)

Actually, I could have amended the previous commit with this change to have both the rename of the file and the change of the
package in a single commit, but at this point I did not find that too important.

