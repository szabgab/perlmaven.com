---
title: "Introduction to Template::Toolkit"
timestamp: 2020-08-19T16:30:01
tags:
  - Template
  - Template::Toolkit
  - FOREACH
  - IN
  - IF
  - END
  - INCLUDE_PATH
published: true
author: szabgab
archive: true
description: "Template::Toolkit is an awesome Perl module to combine data with text or HTML templates to generate pages."
show_related: true
---


[Template::Toolkit](https://metacpan.org/pod/Template::Toolkit) is an awesome Perl module to combine data with text or HTML templates to generate pages.
It has excellent documentation, but it is always nice to see simple but working examples that you can copy-and-paste and start tweaking.


## Install Template Toolkit

Before you start using it you will have to install Template::Toolkit.

## The code

{% include file="examples/tt/create.pl" %}

## The template

{% include file="examples/tt/templates/report.tt" %}

## Directory layout

```
.
├── create.pl
└── templates
    └── report.tt
```


## Execution

```
$ cd to-the-root-dir-where-create.pl-is-located
$ perl create.pl
```

## The Result

```perl
This is your title
===================


Languages
----------------

* English

* Spanish

* Hungarian

* Hebrew



People
----------------

* Foo mail: foo@perlmaven.com
* Zorg
* Bar mail: Bar@perlmaven.com
```


Let me point out the empty rows between the languages. They are there because TT by defaults add a newline at the end of the tag we are inlcuing.
You can change this by adding a dash at the closing part of the expression. This is what happened in the rows of the People where on line 15 you can see
a dash before the last percentage sign: `-%]`.

