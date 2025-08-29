---
title: "Periodic CI for dormant code"
timestamp: 2021-02-13T07:30:01
tags:
  - Travis-CI
  - GitHub Actions
  - GitLab CI
published: true
author: szabgab
archive: true
show_related: true
---


Usually you use CI to make sure changes you make to your code don't break anything.

Therefore it seems that if you don't make any changes there is no point in running your tests.

That's not entirely true.

If your code depends on other code, maybe on the version of perl itself, or some external system, it
can start breaking even if you don't change it.


Admittedly if your module is in widespread use you'll get complaints quite soon.

Especially if it stops functioning due to a change in a third-party API.

It will take a lot more time if the breakage was caused by some other dependency, maybe another Perl module.

You'll know about this even later if the breakage was caused or triggered by some change in perl itself.

If only some rarely used paths in your code are effected by the change then it might take a really long time till someone encounters it.

## CPAN Testers?

As awesome as they are even the <a href=\"http://www.cpantesters.org/\">CPAN Testers</a> are unlikely to catch this
breakage. After all they almost exclusively test recent uploads to CPAN. So if your code is not changing then
they won't test it.


## Example

For example a few months ago one of the plugins of Dancer started to fail due to an upgrade to Dancer2.

In Python I've recently encountered an even harder to detect issue, when a change to one plugin (of pytest in that case)
broke another plugin.

I have a module called [MetaCPAN::Clients](https://metacpan.org/release/MetaCPAN-Clients).
Version 0.05 was last released on May 15 2014. More than 6 years ago. It has 215 passing reports by CPAN Testers.
The most recent one is from June 12, 2018. More than 2 years ago.

Since then the module that it relied on was deprecated. In this case everything still works,
so this is not the best case to illustrate the problem, but if the deprecation was due to some deeper issue,
maybe a security flaw then the authors of the upstream module might have decided to upload a non-functional
version of the module.

The CPAN Testers would not catch **my** module breaking as they would not test it.

## Solution

Most of the cloud-based CI services (e.g Travis-CI, GitHub Actions, and the GitLab CI) allow you to schedule a job.
You could enable such a schedule run of your CI system once a week or even once a day and get notified within that time-period
if your module starts breaking.

