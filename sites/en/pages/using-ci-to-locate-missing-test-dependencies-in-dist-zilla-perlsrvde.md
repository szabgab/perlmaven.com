---
title: "Using GitHub Actions (CI) to locate missing test dependencies in Dist::Zilla::PERLSRVDE"
timestamp: 2022-10-05T18:30:01
tags:
  - GitHub
  - Dist::Zilla
published: true
types:
  - screencast
author: szabgab
archive: true
show_related: true
---


Earlier we saw how to [Add GitHub Actions (CI) to a Perl module](/add-github-actions-to-graphics-toolkit-color) that is using Dist::Zilla.
This time I tried to do it another distribution found on [CPAN::Digger](https://cpan-digger.perlmaven.com/).

I found out that the command I used to install the dependencies did not install several modules needed for testing.


{% youtube id="8hUscGjItGM" file="perl-using-ci-to-locate-missing-test-dependencies-in-dist-zilla-perlsrvde.mp4" %}

I am not 100% sure that I used the proper command, so I opened [a ticket reporting the issue](https://github.com/PerlServices/Dist-Zilla-PERLSRVDE/issues/2)
and added an extra command to the GitHub Action configuration file to install the missing dependencies. See the [Pull-Request](https://github.com/PerlServices/Dist-Zilla-PERLSRVDE/pull/3)

The authors of the package will be able to decide if I used the command incorrectly, if they might need to add the test-modules to the Dist::Zilla configuration,
or if the current solution is fine for them.

The extra line is

```
cpanm Test::BOM Test::NoTabs Test::Pod::Coverage Test::Pod Pod::Coverage::TrustPod
```

I've included the whole configuration file here for reference

{% include file="examples/dist-zilla-perlsrvde.yml" %}
