---
title: "Adding list of contributors to the CPAN META files"
timestamp: 2013-02-27T20:45:56
tags:
  - META
  - x_contributors
  - contributors
  - ExtUtils::MakeMaker
  - Module::Build
  - Module::Install
  - Dist::Zilla
published: true
books:
  - metacpan
author: szabgab
---


The META.json and META.yml files of the CPAN distributions are very important sources
of automated information. For example it can list
[license](/how-to-add-the-license-field-to-meta-files-on-cpan) of the distribution
and [link to the version control system](/how-to-add-link-to-version-control-system-of-a-cpan-distributions)
of the distribution.

These fields are listed in the [CPAN::Meta::Spec](https://metacpan.org/pod/CPAN::Meta::Spec).

There is no field specified for listing the contributors of a distribution,
but there is a way to add arbitrary fields. They just need to start with x_ or X_.


## Why should I list the contributors in the META file too?

After all they are already listed either in the Changes file or in
the POD of the module.

Having the list in the META files will allow someone to extract this automatically,
patch [Meta CPAN](https://metacpan.org/) and show the list there.

This will make it easier to find the areas a person has contributed.
Even if she never released a module.

## How?

I asked [David Golden](http://www.dagolden.com/), and he suggested to use the name <b>x_contributors</b>
to list the contributors the same way they are in the 'authors' section in the module POD. (Name &lt;email>)

Let's see how can this be achieved by the major packaging systems.

## ExtUtils::MakeMaker

The most recent release of [Test::Strict](https://metacpan.org/release/Test-Strict)
already has this in the call of WriteMakefile:

```perl
    META_MERGE        => {
       x_contributors => [
        'Foo Bar <foo@bar.com>',
        'Zorg <zorg@cpan.org>',
       ],
    },
```

## Module::Build

I've added the appropriate section to [XML::Feed](https://metacpan.org/release/XML-Feed)
though it has not been released since.

Add this in the <b>Module::Build->new</b> call:

```perl
    meta_merge =>
         {
            x_contributors => [
                'Foo Bar <foo@bar.com>',
                'Zorg <zorg@cpan.org>',
             ],
         },

```

## Module::Install

I just added this to the upcoming release of [Padre, the Perl IDE](http://padre.perlide.org/).

```perl
Meta->add_metadata(
    x_contributors => [
        'Foo Bar <foo@bar.com>',
        'Zorg <zorg@cpan.org>',
    ],
);
```


## Dist::Zilla

When I started this there was no manual way to add an extra field with multiple values,
but David Golden quickly released  Dist::Zilla::Plugin::Meta::Contributors that allows you to write this:

```perl
[Meta::Contributors]
contributor = Foo Bar <foo@bar.com>
contributor = Zorg <zorg@cpan.org>
```


