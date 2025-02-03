---
title: "Dancer 1 test Hello World"
timestamp: 2019-04-25T09:30:01
tags:
  - Dancer
  - Dancer::Response
  - Test::More
  - prove
published: true
books:
  - dancer
author: szabgab
archive: true
---


Writing web applications can be fun. Adding more features can be more fun.

Making mistakes is not fun.

Introducing bugs in parts of the application that was already running is not fun.

Wrting test is fun. Or at least helps you avoid bugs.


## Directory Layout

```
.
├── bin
│   └── app.pl
├── lib
│   └── App.pm
└── t
    └── 01-index.t
```

## Code launching the app

{% include file="examples/dancer/app2/bin/app.pl" %}


## The code of the application

{% include file="examples/dancer/app2/lib/App.pm" %}


## The test code

{% include file="examples/dancer/app2/t/01-index.t" %}

The call to `dancer_response` returns a [Dancer::Respons](https://metacpan.org/pod/Dancer::Response)
object. Feel free to use its methods.

## Running the tests

Be in the root directory of your project. (The common parent directory of bin, lib, and t.) and type:

```
prove -l
```

or

```
prove -lv
```

for more verbose output.


