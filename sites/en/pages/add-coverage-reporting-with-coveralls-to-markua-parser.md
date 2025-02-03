---
title: "Add test coverage reporting with Coveralls to Markua Parser in Perl"
timestamp: 2018-03-08T14:30:01
tags:
  - Markua
  - Devel::Cover
  - Coveralls
published: true
author: szabgab
archive: true
---


Writing tests is great. Running them automatically via [Travis-CI](/travis-ci-for-markua-parser) (or one of the other Continuous Integration systems) is better.  Continuously monitoring the test coverage is even better than that.


## Travis-CI

If you have Travis-CI enabled it will help you protect the project from accepting breaking contributions. Both from yourself and from the occasional contributors who send you Pull-Requests. Travis-CI will run your tests every time you push out code and for every Pull-request. That means that even if you forget to fully test your new changes Travis will run the tests for you and report if you broke something. It also means that even before you look at the source code of a contribution you have a chance to see if it breaks something.

You can immediately tell the contributor to improve their PR to make sure all the tests pass.

## Test Coverage

Test coverage measures how much of your application code is executed while the tests are running. If some areas are never executed during any of the test runs that means either they are not even in use by your code, or just that they are never testes. For all you know
they might include totally broken code.

So having a high test coverage is one good approximation for being safe when changing some code. (Just remember 100% code coverage does not mean your code is fully tested or bug free. It just means every line of code was executed at least once.)

Many projects struggle to get their developers write tests and they struggle to get higher test-coverage. And then when finally they manage to add some tests, someone comes along. Contributes a big blob of code without tests and your test coverage is down again.

How do you make sure that when some new code is added (either by you or by an external contributor) the test coverage does not go down?

Having self discipline is key to the problem, but being able to measure the changes in test coverage helps a lot.

[Coveralls](https://coveralls.io/) is a cloud-based system that makes it easy to collect and display test coverage reports.

There is an excellent module called [Devel::Cover](https://metacpan.org/pod/Devel::Cover) that can generate test coverage reports. It can generate beautiful reports locally. See how to add [generate test coverage](/check-test-coverage-add-compile-tests) locally.

Devel::Cover can generate nice text and HTML based reports and the [Devel::Cover::Report::Coveralls](https://metacpan.org/pod/Devel::Cover::Report::Coveralls) module can send the raw data to Coveralls in the format expected by Coveralls.

## Set up Coveralls for the Markua Parser

In order to enable Coveralls on a project visit [Coveralls](https://coveralls.io/), if you have not logged in yet
then click on the "Get Started for Free" button and then on the "GitHub Sign up" button. Tell Github you allow Coveralls to access you projects.

Once logged in click on the "+ Add repos" button on the left hand side of the web site. Search for the name of your repo (in this cases I searched for "perl5-markua-parser" and switch it on. If you can't find the repo you might need to click on the "Sync repos" button in the top right corner and wait a few second till the list is updated.

Once we told Coveralls to monitor this specific repo we also need to tell Travis to send the data to Coveralls.

There are a number of ways you can do that. The simplest I found was adding the following 4 lines to `.travis.yml`.

```
before_install:
  - cpanm --notest Devel::Cover::Report::Coveralls
after_success:
  - cover -test -report coveralls
```

The first 2 lines tell Travis to install the Devel::Cover::Report::Coveralls and all its dependencies.
The second 2 lines tell Travis that once the tests were successful, run the `cover` command that will generate the coverage
report and with the given flags it will also send the data to Coveralls.

If in your project you already have either `before_install` or `after_success` entries, make sure you merge the appropriate sections and don't have two sections of the same name.

{% include file="examples/markua-parser/854277b/.travis.yml" %}

I can now [commit](https://github.com/szabgab/perl5-markua-parser/commit/854277be1e308abbb3f599cd2e8d85746bd720f0) and push out the changes.

$ git add .
$ git commit -m "add coverage reporting with Coveralls"
$ git push


A few seconds after I pushed out the changes Travis Starts to run the tests and when they are successful, it start to run the `cover` command that will run the tests again this time collecting the coverage report. The result is then sent to Coveralls
and can be seen [here](https://coveralls.io/builds/15779846). That's the page related to the current build that corresponds to the current commit.

There is also a general page with the [Coveralls report of the perl5-markua-parser repository](https://coveralls.io/github/szabgab/perl5-markua-parser). At the bottom of this page there is a notification about the missing Coveralls badge.

![](/img/markua-parser-coveralls-badge-your-repo.png)

Yes, it is a nice marketing ploy by the folks at Coveralls. It makes it super easy to add a coveralls badge to your project.
Click on the "Embed" button, select the appropriate snippet (I selected the Markdown snippet as my README file is README.md which is
in Markdown format.)
I've pasted that snippet of code in the README.md just under the Travis-CI badge.

{% include file="examples/markua-parser/a7decfc/README.md" %}

```
$ git add .
$ git commit -m "Add Coveralls badge"
$ git push
```

[commit](https://github.com/szabgab/perl5-markua-parser/commit/a7decfc045a4d849059b42f557c8bd202a762271)

Then we can click on the "refresh" button on the green banner that offered the badge. I think it checks if the badge was installed and if it was then it disappears.

This of course will trigger a new build on Travis and a new report on Coveralls, but we are not worried about that.

The report BTW looks like this:

<img src="/img/markua-parser-coveralls-reoprt-100.png" alt="Coveralls report">

It tells us we have reached 100 test coverage which is rare, but in our case not very surprising. After all we hardly have any code and we wrote a test or two. Later in the project we'll probably fall behind a bit, but this a good start.

In another project where I was much less disciplined I have not started to write tests at the beginning and when I first added coverage reporting I was at 79% test coverage.

