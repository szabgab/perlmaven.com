---
title: "CPAN Digger and the Hacktoberfest"
timestamp: 2022-10-04T17:00:01
tags:
  - CPAN
  - Hacktoberfest
published: true
types:
  - screencast
author: szabgab
archive: true
show_related: true
---


[Hacktoberfest](https://hacktoberfest.com/) is a month-long event to encouage people to contribute to Open Source projects by creating useful Pull-Requests.

You can use the [CPAN Digger](https://cpan-digger.perlmaven.com/) to find recently uploaded Perl CPAN distributions that can be contributed to.


There are number of other post such as the one introducting [CPAN Digger, the CPAN Dashboard, and CPAN Rocks](/cpan-digger-dashboard-rocks)
the [explanation of CPAN::Digger](/cpan-digger-explained), and the post about [Hacktoberfest 2019 and Perl](/hacktoberfest-2019).

You can also see the call to participate in the [584th issue of the Perl Weekly newsletter](https://perlweekly.com/archive/584.html).

Command to run after cloning the [CPAN Digger repository](https://github.com/szabgab/CPAN-Digger) if for some reason you prefer the command-line report.

```perl
perl -I lib bin/cpan-digger --recent 1000 --report --days 7 --vcs
```

{% youtube id="DJrWj6LNlaM" file="perl-cpan-digger-and-hacktoberfest.mp4" %}

I am looking forward to blog posts about the pull-requests you created during Hacktoberfest for any Perl-related project.

