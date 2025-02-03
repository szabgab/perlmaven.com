---
title: "GitHub Actions for CPAN modules"
timestamp: 2023-05-29T07:30:01
tags:
  - GitHub
  - CI
published: true
archive: true
show_related: true
---


[GitHub Actions](https://docs.github.com/en/actions) is a system provided by GitHub to automate virtually any process you like.
Including the possibility to create [Continuous Integration (CI)](/ci) systems for CPAN distributions.

While Perl developers who upload their code to CPAN will greatly benefit from the volunteers behind [CPAN Testers](https://www.cpantesters.org/)
setting up a CI system has a number of benefits even for CPAN developers.


## Why use CI in general?

* A CI system can help you prevent uploading broken releases to CPAN.
* It can give you feedback to the changes you made within minutes after you pushed them out to GitHub.
* It can help verify that a pull-request does not break anything even before you look at it. Indeed the sender of the pull-request will also be able to see if things went wrong and correct them before you spend time on the PR.
* You can configure it to use various services, so for example you can setup a Postgres or MySQL database for the duration of the tests.
* You can store secrets, such as API keys, so the tests can even access APIs that require authentication.
* You can even automate the release to PAUSE, if that's what you'd like to do.

## Why use GitHub Actions?

* GitHub Actions can run on every push and every pull-request, and there are other triggers as well that you can configure.
* It can run natively on Linux, Windows, or macOS or inside any Docker container, allowing you to verify your code on several operating systems and several different versions of Perl.
* GitHub Actions is free (of charge) for public repositories hosted on GitHub.
* You can find a bunch of [sample GitHub Action](https://code-maven.com/github-actions) configurations.
