---
title: "Dancer 1 echo using GET and testing GET"
timestamp: 2019-04-25T09:40:01
tags:
  - Dancer
  - GET
published: true
books:
  - dancer
author: szabgab
archive: true
---


In this example we'll see how to accept GET parameters in a [Dancer 1](/dancer) application.
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

{% include file="examples/dancer/app3/bin/app.pl" %}


## The code of the application

{% include file="examples/dancer/app3/lib/App.pm" %}


## The test code

{% include file="examples/dancer/app3/t/01-index.t" %}

The call to `dancer_response` returns a [Dancer::Respons](https://metacpan.org/pod/Dancer::Response)
object. Feel free to use its methods.

After testing the index page there are two examples for passing parameters in the test.
The first one uses the same syntaxt you'd see on a URL, in the second one we let Dancer constuct the URL.
Use whichever fits your workflow.

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


