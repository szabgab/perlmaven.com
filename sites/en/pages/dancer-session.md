---
title: "Dancer Simple Session and testing a session"
timestamp: 2019-04-26T22:30:01
tags:
  - Dancer
  - Session
published: true
books:
  - dancer
author: szabgab
archive: true
---


In this example you'll see how to use a <b>session</b> to store some information sent in by a user and how to retreive
it in another request. You'll also see how to test it.


## Directory Layout

```
.
├── bin
│   └── app.pl
├── lib
│   └── App.pm
└── t
    ├── 01-index.t
    └── 02-psgi.t
```

## Code launching the app

{% include file="examples/dancer/app5/bin/app.pl" %}


## The code of the application

{% include file="examples/dancer/app5/lib/App.pm" %}


## The test code

{% include file="examples/dancer/app5/t/01-index.t" %}

## Testing with Test::WWW::Mechanize::PSGI

[Test::WWW::Mechanize::PSGI](https://metacpan.org/pod/Test::WWW::Mechanize::PSGI) is an excellent testing
library that makes it easy to create more complex interactions and to represent more than one browsers at the same time.
So you can observe that while one user (`$mech1`) sees the newly set text use two `$mech2` does not.

{% include file="examples/dancer/app5/t/02-psgi.t" %}

## Running the tests

Be in the root directory of your project. (The common parent directory of bin, lib, and t.) and type:

```
prove -l
```

