---
title: "CPAN Digger explained"
timestamp: 2020-11-23T15:30:01
tags:
  - CPAN
  - GitHub
  - GitLab
  - RT
  - VCS
  - CI
published: true
author: szabgab
archive: true
description: "CPAN Digger analyzes some meta information about recently uploaded Perl distributions."
show_related: true
---


The web site of [CPAN Digger](https://cpan-digger.perlmaven.com/) shows the most recently uploaded CPAN distributions. Currently about 110 of them
and some meta information about them. Let me go through quickly what you see there, why is that interesting and what to do about it.



These are the top two rows of the table.

Each row displays a CPAN distribution.

<img src="/img/cpan-digger-20201123.png" alt="CPAN Digger on 2020.11.23" />

## VCS - Version Control System

In the **VCS** column they both have GitHub.

Some other distribution will have a button **Add repo** and some will have **No**.

This indicates if the META.json file of the distribution contained a link to the public Version Control System of the project.
In the cases in the image both distributions had the link and they both linked to GitHub.

If you were to visit the [MetaCPAN](https://metacpan.org/) page of either of these modules, in the top left corner you'd see something like this:

<img src="/img/metacpan-top-left.png" alt="MetaCPAN top left corner" />

They both have a **Repository** link that leads to their GitHub repository.

Having this link in a standard place makes it easier for potential contributors to find the version control of the project and contribute there.

The distributions that have <a href="/how-to-add-link-to-version-control-system-of-a-cpan-distributions">**Add repo**</a> in this column have no such link.

In my opinion it would be useful if the authors also included the link.


Finally, some distributions have **No** there. These are distributions where the author explicitly told me they either have no public VCS or that they are
not interested to include the link in the META files. They prefer potential contributors to contact them first and discuss any potential changes. They also expect
them to send patches via email.

See [all the responses](/cpan-digger) to my inquiry about the public VCS-es.

The statistics show that having public VCS is the common thing, but I can accept if some people don't want to have them.

## Issues

The issues column shows if the META.json file has a link to any bugtracking system and where is it.
If there is a link saying <a href="/how-to-add-link-to-version-control-system-of-a-cpan-distributions">**Add bugtracker**</a>
that means the META.json file does not have the link.

If you visit the MetaCPAN file of a project and look at the top-left corner again, you'll always see a link to **Issues**.

<img src="/img/metacpan-top-left.png" alt="MetaCPAN top left corner" />

It either leads to the place listed in META.json or by default it leads to [RT](https://rt.cpan.org/). It would be a good idea
to set this explicitly even if you are using RT.

Right now there are module where this link uses the default, but their GitHub project also has the issues enabled. That means some of the issues will
be reported to RT and some to GitHub issues. Probably not an ideal situation.

If you prefer to use GitHub then the bed news is that unfortunately we cannot disable the RT queue of our projects, but at least we can direct people to
GitHub issues by adding the link to META.json.

If you prefer to use RT, then it is still a good idea to set it explicitly so it will be clear. In that case you could also disable the "issues" in your GitHub project.

Of course if you like having two places, then don't worry.

## CI - Continuous Integration

Most of the distributions uploaded to CPAN will be checked by the [CPAN Testers](http://www.cpantesters.org/) with a few days, but having a CI system running
every time you push code to the GitHub/GitLab repository can shorten the feedback cycle.

It can help you reduce the chances of uploading distributions that are broken, or that are broken on one of the operating systems.

A CI system can usually test your code on all 3 major operating systems and on multiple versions of Perl.

This column indicates which CI systems are being used by each project and which ones need to <a href="/ci">**Add CI**</a>.


## Dashboard

Finally in the dashboard column you'll see which author has already enabled the [CPAN Dashboard](https://cpandashboard.com/)
for their PAUSE account. I think it is a cool project.

