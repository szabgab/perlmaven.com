---
title: "MetaCPAN URLs and Issues"
timestamp: 2014-10-25T08:30:01
tags:
  - MetaCPAN
  - RT
types:
  - screencast
published: true
books:
  - metacpan
author: szabgab
---


[MetaCPAN](https://metacpan.org/) has a standard URL scheme. After the domain name we can type <b>pod/</b> and then the name of a module,
for example [https://metacpan.org/pod/DBIx::Class](https://metacpan.org/pod/DBIx::Class) with the <b>::</b> with the correct case. This
will always show the documentation of the latest version of this module.

If we add <b>release/</b> after the domain name and the name of a CPAN release (in the correct case and with - between the words)
then we reach the most recent release of this distribution. For example: [https://metacpan.org/release/DBIx-Class](https://metacpan.org/release/DBIx-Class)


{% youtube id="qT7WdlJlgvM" file="metacpan-urls-and-issues" %}

MetaCPAN also has a link to the [Request Tracker of CPAN](https://rt.cpan.org/) where each CPAN distribution has its own queue. The link also
include the number of open bug reports. Module authors might want to use a different bug tracking system. They can tell about it via the
META files in their distribution. Then MetaCPAN will link to this other bug tracking system. For example [MongoDB](https://metacpan.org/pod/MongoDB)
uses a Jira installation.


