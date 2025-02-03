---
title: "Hello World with Perl Dancer"
timestamp: 2019-04-25T08:30:01
tags:
  - Dancer
  - plackup
published: true
books:
  - dancer
author: szabgab
archive: true
---


[Perl Dancer](/dancer) is a light-weight web framework for Perl. This examples uses Dancer 1.
For new projects you should use [Dancer 2](/dancer).


## Install Dancer

First you need to [install the Dancer](/how-to-install-a-perl-module-from-cpan) module.

In the [archive](/archive)  you'll find more installation methods depending on your situation.

## Directory structure

```
.
├── bin
│   └── app.pl
└── lib
    └── App.pm
```

The two files:

The script to launch the application:

{% include file="examples/dancer/app1/bin/app.pl" %}

The application itself:

{% include file="examples/dancer/app1/lib/App.pm" %}

cd into the root of the project and type:

```
plackup bin/app.pl
```

You can then visit http://localhost:5000/  and see the "Hello World".



