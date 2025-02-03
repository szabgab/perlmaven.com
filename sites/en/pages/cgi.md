---
title: "CGI - Common Gateway Interface"
timestamp: 2014-11-16T09:13:12
tags:
  - CGI
  - cgi-bin
published: true
books:
  - cgi
author: szabgab
show_related: false
---


The Common Gateway Interface - also known as CGI - is a language agnostic way to create dynamic web sites.
It was the first technology that enabled web sites to move beyond static pages.

In the early years of the web almost all the dynamic web sites using CGI were written in Perl. Therefore many
people still associate CGI with Perl even though CGI can be used with any programming language.


Since those years various other technologies have been developed.

For a long time mod_perl was used mostly to speed-up CGI requests. In the recent years a few language-specific
interfaces have replaced the plain CGI. Python has [WSGI](https://www.python.org/dev/peps/pep-0333/),
Ruby has [Rack](http://rack.github.io/), and Perl has [PSGI](/psgi).

Nevertheless CGI is still available and in some cases still the appropriate choice. Therefore we have a few
articles and screencasts related to CGI.

Up till version 5.20 the standard Perl distribution included the [CGI](https://metacpan.org/pod/CGI) module.
If  you have a version of Perl that does not come with the module you can either install
[CGI](https://metacpan.org/pod/CGI) from CPAN or you can install
[CGI::Simple](https://metacpan.org/pod/CGI::Simple) which a more light-weight version of the same.

Alternatively you can install [PSGI](/psgi) and if you have no better option, use it in CGI mode.

* [Modern Web with Perl](/modern-web-with-perl)
* [Set up CGI with Apache on Ubuntu Linux](https://code-maven.com/set-up-cgi-with-apache)
* [Perl/CGI script with Apache2](/perl-cgi-script-with-apache2)
* [Which is better perl-CGI, mod_perl or PSGI?](/perl-cgi-mod-perl-psgi)
* [Simple CGI Perl script to send form by e-mail](/simple-cgi-script-to-send-form-by-email)
* [Hello World with plain CGI](/hello-world-with-plain-cgi)
* [Echo with plain CGI](/echo-with-plain-cgi)
* [Testing Perl CGI](/testing-perl-cgi)

