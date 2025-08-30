---
title: "Travis-CI for the Markua Parser project"
timestamp: 2018-03-05T09:30:01
tags:
  - Markua
  - Travis-CI
  - YAML
published: true
author: szabgab
archive: true
---


It is very useful to write unit-tests for your project, but it is a bit annoying that you have to remember running it every time before you push out a new request. Especially if you'd like to run your tests on multiple versions of Perl and maybe with different values of certain environment variables.

[Travis-CI](https://travis-ci.org/) is a cloud-based Continuous Integration system that will run your tests on every commit
on as many versions of Perl as you like and with as many environment variables as you configure.

Not only that, but every time someone sends you a pull-request the tests will run on the PR as well, so both the contributor and you will
know if the PR would break anything that worked before.

Not only that, but Travis-CI is free for Open Source projects on GitHub.


For simple cases it is quite easy to set up Travis-CI. It involves two steps:

1. Tell Travis-CI to monitor your project
1. Create the Travis Configuration file .travis.yml

## Tell Travis-CI to monitor your project

Visit [Travis-CI](https://travis-ci.org/), log in with your GitHub account and let it sync the list of your GitHub repositories.

If you have already done this earlier, then for a new GitHub project you might need to manually ask Travis to sync the list.

For this visit your [Profile](https://travis-ci.org/profile/) and click on the **Sync account**. After a few seconds you'll
be able to locate the entry of your project.

Look at the relevant switch which is currently off:

![](img/travis-markua-parser-off.png)

and turn it on:

![](img/travis-markua-parser-on.png)

## Create the Travis Configuration file .travis.yml

For every language Travis supports there are instructions on how to set them up.
So there are instructions for [Perl-based projects on Travis](https://docs.travis-ci.com/user/languages/perl/).

Basically you need to create a file called `.travis.yml` in the root of your Git repository with the following content
listing the versions of perl you'd like to be used by Travis:

{% include file="examples/markua-parser/87a69da/.travis.yml" %}

The file is in [YAML](/yaml) format.

```
$ git add
$ git commit -m "add travis configuration file"
$ git push
```

[commit](https://github.com/szabgab/perl5-markua-parser/commit/87a69da4c3c8ec459a6cb0554f577694f996eb1a)

Once you push the file to GitHub it will trigger Travis-CI and that will start a build. Because we requested the build
on 4 different versions of Perl, Travis will spun-off 4 virtual machines and run the builds and the tests in parallel.

Here are the [Travis-CI build results](https://travis-ci.org/szabgab/perl5-markua-parser/builds/348268435) for my first build
of this project.

A screenshot of that page: ![](img/travis-markua-parser-first-success.png)

You will also receive an e-mail confirmation with the first successful build. Such as this one:

![](img/travis-markua-parser-first-success-email.png)

From now on every push to GitHub will trigger the build. If any one of the builds fail you'll get an e-mail notification
so you don't have to do anything, just keep coding.

## Travis badge

It is quite customary that Open Source developers will add a Travis badge to their project. On the results page on Travis
you'll see a badge (it probably will say "build unknown"). If you click on it, you'll get a popup like this allowing you to select
the appropriate code for the badge.

![](img/travis-markua-parser-badge-selector.png)

I've pasted the Markdown example into the README.md file of the project:

{% include file="examples/markua-parser/3986c23/README.md" %}

```
$ git add .
$ git commit -m "add Travis badge"
$ git push
```

[commit](https://github.com/szabgab/perl5-markua-parser/commit/3986c230ed82f7575789db7a0e1f00177c6fe656)

This push will trigger another build on Travis, but what is more interesting for us now is that of someone visits the GitHub page
of the [Perl 5 Markua Parser](https://github.com/szabgab/perl5-markua-parser) project then they will see the up-to-date status
of the project on Travis:

![](img/travis-markua-parser-success-badge.png)



