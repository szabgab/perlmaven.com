---
title: "CPAN Testers or CI system?"
timestamp: 2021-03-07T08:30:01
tags:
  - CPAN Testers
  - CI
  - GitHub Actions
published: true
author: szabgab
archive: true
show_related: true
---


In the recent months I talked quite a lot about setting up CI systems for the development of Perl Modules. I have even sent pull-requests to the Git repositories
to add the configuration of a CI system. Many people accepted the PR, but I hear some people think [CPAN Testers](http://www.cpantesters.org/) are enough.

I think that the CPAN Testers are awesome, but if you care about your project you should not rely on them.


For one thing, the CPAN Testers is a group of volunteer in which each individual might change their preferences at any time and stop sending in reports.
Looking at the [stats](http://stats.cpantesters.org/) you can see that the number of CPAN Testers went down from over 100 in 2015 to around 50 in 2021.

<img src="static/img/cpantesters-attributes-202002.png" alt="cpan testers">


If you look at the raw data then you'll see that the peak was in 2009 with about 160 different testers. Comparing with those numbers the decline is bigger.

Surprisingly, the number of Perl versions and the number of different platforms increased.

So fewer people set up more environments. Getting reports from more environments is certainly nice, but having fewer volunteers just makes the whole thing more risky.


<b>But that is not even my main point.</b>


## After release, can take weeks

CPAN Testers run the test after you release the module and it takes some time - hours, days, sometimes even weeks for all the CPAN Testers to pick up the recent changes.
In the meantime some people might have already tried to install your module and fail. Will they report it to you? Maybe, but having been in the hi-tech world world for
a few years now my experience that most people will just conclude the module is broken, curse you and maybe Perl a bit and try finding an alternative.
So if you can reduce this risk with almost no cost to you then why not do that?

You can upload a dev release, wait a few days/weeks to let the CPAN testers reports arrive and then release a new version, but do you do that?
I don't and I think the majority of people don't do that.

If you do however that just makes your release cycle unnecessary long. These days the (technologically) best companies do it much faster.

## Check Downstream

Another common belief is that CPAN Testers will test your downstream dependencies, the modules that depend on your module.
CPAN Testers generally only test new uploads so they will only test downstream dependencies when those have a new release.

However, your new version might have broken one of your downstream dependencies that is currently on CPAN. The only ones who will
notice this will be people who will try to install that downstream module and fail.

That's even worse as now the person really does not care about your module. They only care about the downstream, but it is "broken".

If you have your own CI it can be configured to test some of the downstream modules with your code <b>before</b> you release it to CPAN.


## Changes in upstream

If your module depends on other modules then you have a risk there too. One of the modules you depend on might make a change
that will impact your code. When will the CPAN testers report this. Only after you release a new version of your module
that might be weeks or months later. At a point when you probably won't be able to get the upstream module author to fix it.

If you have you set up a periodic run of your CI system using a clean perl, then you'll find out about such issues within that period.


## CI systems

There are several cloud-based CI system that offer their service free of charge for Open Source projects and if you are not yet familiar with
how they work there are already quite a few examples in the Perl world that use them. You can start by copying the configuration from
another project.

I've recently set up GitHub Actions for [Perl Dancer 2](https://github.com/PerlDancer/Dancer2/) and an even better
one for [Test::Class](https://github.com/szabgab/test-class). (Check the .github/workflows) directories.

There is also a video [explaining GitHub Actions for Test::Class](/github-actions-ci-job-for-test-class).

## Conclusion

Having CPAN Testers is very valuable, but I think setting up a CI system to get earlier feedback
is a natural step towards improved software, both for open source and proprietary software.

So it is not either or, but having both.

