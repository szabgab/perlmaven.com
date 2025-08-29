---
title: "Which is better perl-CGI, mod_perl or PSGI?"
timestamp: 2013-02-18T22:45:56
tags:
  - CGI
  - mod_perl
  - FastCGI
  - PSGI
  - Plack
books:
  - psgi
  - cgi
  - mod_perl
published: true
author: szabgab
---


I just saw a question asking **Which is the best way? perl-cgi or mod-perl?**. My quick answer would be neither.
Use a PSGI capable web framework and then deploy as you want.


## Perl CGI

A long, long time ago a galaxy far far away, we used CGI (aka. Common Gateway Interface) to create web applications.
It was good as it solved the problems back in the '90s but it was also slow.

People wanted faster solution so there came **mod_perl** which is a module in the Apache web server.
It is capable of fantastic things, but most people used it a turbo-engine for CGI applications.
It could indeed boost the speed of a web site by 100, 200 times. Compared to the plain CGI solution.

There were other solutions to the slowness of CGI. For example **FastCGI**.

All that was good and solved the problems of the early years of the 21st century, but it was hard to move
from one of these systems to another. Then came the modern era.

## PSGI and Plack

[Tatsuhiko Miyagawa](http://bulknews.typepad.com/) created <a href="http://plackperl.org/">PSGI and
Plack</a>. That allows developers to write their code once and deploy in many ways including CGI, mod_perl, FastCGI,
nginx and Starman. Just to name a few.

That somewhat frees the software developer from hard-coding deployment-related code.

## Frameworks

Of course almost no one writes plain Plack/PSGI code. Almost everyone uses one of the web application development
frameworks of Perl.

For lighter application people usually use either [Perl Dancer](/dancer)
or [Mojolicious](/mojolicious).
For bigger applications people use [Catalyst](/catalyst).

Now I "only" need to write my tutorials for all these frameworks ...

(This post was partially based on the response of [Dave Cross](http://perlhacks.com/). Thanks!)

