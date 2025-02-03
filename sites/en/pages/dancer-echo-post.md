---
title: "Dancer 1 echo using POST and testing POST"
timestamp: 2019-04-25T09:50:01
tags:
  - Dancer
  - POST
published: true
books:
  - dancer
author: szabgab
archive: true
---


In this example we'll see how to accept  POST parameters in a [Dancer 1](/dancer) application.
We'll also see how to write tests for it.


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

{% include file="examples/dancer/app4/bin/app.pl" %}


## The code of the application

{% include file="examples/dancer/app4/lib/App.pm" %}


## The test code

{% include file="examples/dancer/app4/t/01-index.t" %}

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


