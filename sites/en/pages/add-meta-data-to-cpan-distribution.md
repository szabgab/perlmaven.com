---
title: "Add META data to a CPAN distribution (Pod::Tree 1.19)"
timestamp: 2015-09-16T09:10:01
tags:
  - ExtUtils::MakeMaker
published: true
books:
  - cpan_co_maintainer
author: szabgab
archive: true
---


The META files (META.yml and META.json) included in the CPAN distributions provide well structured information
about the distribution. Thing such as the dependencies of the distribution and the list of modules the
distribution provides.

[MetaCPAN](https://metacpan.org/) uses the data in these files to provide a searchable
index of all the CPAN distributions.


Among the many things it displays the license of the distribution
based on the information in the META file. It can link to the "homepage" of the distribution if that is available,
it can direct the readers to the preferred bug-tracking system of the author and even link to the version control
system used by the author.

Having this information in a distribution is quite useful, so that's the first thing we are going to add.

For this we only have to change the `Makefile.PL`.
There are two separate articles showing how to do this for the other packaging systems used by CPAN authors:

[How to convince Meta CPAN to show a link to the version control system of a distribution?](/how-to-add-link-to-version-control-system-of-a-cpan-distributions)
and [How to add the license field to the META.yml and META.json files on CPAN?](/how-to-add-the-license-field-to-meta-files-on-cpan)

The specific change I made are these:

## Set the license field in the CPAN META files

```perl
( $ExtUtils::MakeMaker::VERSION >= 6.3002
? ( 'LICENSE' => 'perl' )
: () ),
```

## Link to GitHub, Link to bug tracking system, link to homepage


```perl
(eval { ExtUtils::MakeMaker->VERSION(6.46) } ? (
META_MERGE => {
    'meta-spec' => { version => 2 },
    resources => {
        repository => {
            type       => 'git',
            url        => 'http://github.com/szabgab/Pod-Tree.git',
            web        => 'http://github.com/szabgab/Pod-Tree',
        },
        bugtracker => {
            web        => 'http://github.com/szabgab/Pod-Tree/issues',
        },
        homepage   => 'http://metacpan.org/pod/Pod::Tree',
    },
} ) : ())
```

[commit](https://github.com/szabgab/Pod-Tree/commit/72ab98142bab1e1801c4b2f1d4d0881dcb529038)

After this I could release version 1.19 of Pod::Tree. Shortly after uploading the new version I'll be able to verify
if I have added the fields correctly and if MetaCPAN uses this data.
After less than a  day I will also start to receive reports from the CPAN Testers which is not relevant now, but that's another
good reason to release versions frequently.

[commit](https://github.com/szabgab/Pod-Tree/commit/eafb4d5be0d4c289a3e5b6d8e992851eac23dd2d)


