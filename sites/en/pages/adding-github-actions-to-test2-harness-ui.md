---
title: "Adding GitHub Actions to Test2::Harness::UI"
timestamp: 2022-10-06T08:30:01
tags:
  - GitHub
  - testing
  - CI
published: true
types:
  - screencast
author: szabgab
archive: true
show_related: true
---


[Test2-Harness-UI](https://metacpan.org/dist/Test2-Harness-UI) is a web interface for viewing and inspecting yath test logs.
It is still in development, but it (obviously) has some tests. Those tests will be executed by the [CPAN Testers](http://www.cpantesters.org/)
**after** a new version was released, but we can shorten the feedback cycle by configuring a Continuous Integration (CI) system.

On GitHub it is usually GitHub Actions.


{% youtube id="AIYmgub4QYU" file="perl-adding-github-actions-to-test2-harness-ui.mp4" %}


All what we need to do is to add a YAML file in the **.github/workflows** folder of the project with the instructions.

In this case I added the following file:

{% include file="examples/test2-harness-ui-ci.yml" %}

A quick explanation:

## The name of the file

I used in the repository was **ci.yml**, but any name would do and I think both the yml and yaml extensions work.

## Name

```
name: Perl
```

There must be a name field, but the content is anything you like.

## Trigger
```
on:
  push:
  pull_request:
```

Means the job will run on every push and on every pull-request.


## Jobs

There can be a number of jobs, the names of the jobs can be anything. In our case we have one job and I called it **test**

```
jobs:
  test:
```


## Strategy and Matrix

```
    strategy:
      fail-fast: false
      matrix:
        runner: [ubuntu-latest] # , macos-latest, windows-latest
        perl: [ '5.32' ]
```

The matrix keyword allows us to define several variables (We used the words runner and perl in this case) to define a list of values.
This allows us to run the tests in various conditions. In this case I configured the tests to run on Ubuntu only and on perl version 5.32,
but later both can be extended.

The **fail-fast** parameter tells Github Actions what to do if one of the jobs in the matrix fails.
**false** means to run all the jobs to the end.
**true** would mean to cancel all other jobs if one of the jobs derived from the matrix fails.


## The platform

The **runs-on** keyword is using one of the variables from the matrix to select on which platform to run on.
The **name** uses both variables from the matrix, but it is only used for logging.

```
    runs-on: ${{matrix.runner}}
    name: OS ${{matrix.runner}} Perl ${{matrix.perl}}
```

## steps

In each job there can be a number of steps.


## step: Check out the current repository

The first step is to check out (clone) the current repository.

```
    - uses: actions/checkout@v2
```

## step: Set up Perl


```
    - name: Set up perl
      uses: shogo82148/actions-setup-perl@v1
      with:
          perl-version: ${{ matrix.perl }}
          distribution: ${{ ( startsWith( matrix.runner, 'windows-' ) && 'strawberry' ) || 'default' }}
```

Here we use to pick the version of perl using the variable from the matrix.

## step: Show Perl Version

```
    - name: Show Perl Version
      run: |
        perl -v
```

We display the version of the actually installed perl. Just so we will be able to verify it, if needed.

## step: Install dependencies

We use **cpanm** to install the dependencies. We use the **--notest** flag to reduce the time spent
on installing the dependencies.

```
    - name: Install Modules
      run: |
        cpanm -v
        cpanm --installdeps --notest .
```

## step: Run tests

Finally we have the step to run the tests:

```
    - name: Run tests
      run: |
        perl Makefile.PL
        make
        make test
```

## What to do now?

Once the file is added to the repository (once my pull-request is accepted) on every push GitHub will run this workflow
and it will send the author an email if anything fails with a link to the logs.

There are, of course many other options one can use, but as a first step it is great to get feedback on every push.

The workflow will also run on every pull-request, meaning that the author of the pull-request will be able to get feedback
even before the author has time to review the changes.

