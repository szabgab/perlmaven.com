---
title: "Perl Infrastructure"
timestamp: 2017-10-22T11:30:01
tags:
  - Web sites
published: true
books:
  - beginner
author: szabgab
archive: true
---


Information about some of the machines serving Perl developers around the world.
To suggest updates check out [the source](https://github.com/szabgab/perlmaven.com/blob/main/sites/en/pages/perl-infrastructure.txt).


## What kind of information?

This page is (going to be) a collection of information about the hardware and software serving people who are using Perl.

In particular, it should contain information about the following aspects:

* Hardware - what kind of machines are used to provide the service? (VPS-es would be included here)
* Who maintains them? Who and how should be contacted in case the service is malfunctioning?
* What software does the machine run to provide the service?
* Is the source code of the service available to the public somewhere? (e.g. GitHub repository)
* Who pays the bills? Is there a sponsor? Someone pays from her/his own pocket?

## MetaCPAN

[metacpan.org](https://metacpan.org/), the Open Source search engine of CPAN. It has several sub-projects hosted
in the [CPAN-API](https://github.com/CPAN-API/) GitHub organization.
[metacpan-web](https://github.com/CPAN-API/metacpan-web) is the front-end written using [Catalyst](/catalyst),
and [cpan-api](https://github.com/CPAN-API/cpan-api/) is the back-end.

Servers and hosting, donated by Bytemark and Liquid Web.
For details see the [list of servers](https://github.com/CPAN-API/network-infrastructure/blob/master/servers.md).

Everything is deployed via Puppet. Source code is in [GitHub](https://github.com/CPAN-API/metacpan-puppet).

There are Vagrant development boxes for getting people started. See [MetaCPAN developer environment](https://github.com/CPAN-API/metacpan-developer),

Every site sits behind [Fastly CDN](http://www.fastly.com/)

Everything is on [GitHub](https://github.com/CPAN-API/)


## PerlMonks

[perlmonks.org](http://www.perlmonks.org/) is based on a version of Everything. According to  [this node](http://www.perlmonks.org/?node_id=955375)
a different version of Everything (Everything2) is now open source, but there are some PerlMonks specific things that are not open source.

The website is hosted via three webservers in DNS rotation, with a MySQL backend. The webservers are provided by pair.com.
The domains are provided by [TPF](http://perlfoundation.org/) and managed by [noc.perl.org](http://noc.perl.org/).

Emergency contact: perlmonks.org at gmail.com

## Strawberry Perl

[strawberryperl.com](http://strawberryperl.com/) is just a few static pages.
[GitHub repository](https://github.com/StrawberryPerl/strawberryperl.com)

The Webserver:

* DreamHost webhosting (some pricing plan with unlimited storage)
* Adam Kennedy pays for the hosting + domain

There is also build server and CPAN smoker:

* VPS from www.wedos.com (Czech Republic)
* Windows 2012 R2, 80GB HDD/SSD, 16GB RAM, 4 CPUs
* the cost was approx. 700 USD/year
* paid by Enlightened Perl Organisation

A couple of [GitHub repos](https://github.com/StrawberryPerl).

## Perl Dancer

[perldancer.org](http://perldancer.org/), the web framework. The source code of its own web site is
in the [perldancer-website](https://github.com/PerlDancer/perldancer-website)
repository.

[advent.perldancer.org](http://advent.perldancer.org/) is itself based on [Dancer](/dancer).
Its source code is in the [advent-calendar](https://github.com/PerlDancer/advent-calendar)
repository.

Both sites run on the server of [David Precious](http://www.preshweb.co.uk/).

## perl.org sites

Under the maintenance of Robert and Ask as listed on the
[noc.perl.org](http://noc.perl.org/) ([GitHub](https://github.com/perlorg/perlweb/tree/master/docs/noc):

* [www.perl.org](http://www.perl.org/) [GitHub](https://github.com/perlorg/perlweb/tree/master/docs/www)
* [dev.perl.org](http://dev.perl.org/) [GitHub](https://github.com/perlorg/perlweb/tree/master/docs/dev)
* [cpanratings.perl.org](http://cpanratings.perl.org/) [GitHub](https://github.com/perlorg/perlweb/tree/master/docs/cpanratings)
* [dbi.perl.org](http://dbi.perl.org/) [GitHub](https://github.com/perlorg/perlweb/tree/master/docs/dbi)
* [qa.perl.org](http://qa.perl.org/) Perl Quality Assurance Projects [GitHub](https://github.com/perlorg/perlweb/tree/master/docs/qa)

* [jobs.perl.org](http://jobs.perl.org)
* [www.nntp.perl.org](http://www.nntp.perl.org/) news groups and the archive of the mailing lists hosted by noc.perl.org
* [rt.perl.org](http://rt.perl.org/) Request Tracker for Perl 5 and Perl 6
* <a href="http://svn.perl.org/>svn.perl.org</a> (not in use any more)
* [moose.perl.org](http://moose.perl.org/) (redirects to moose.iinteractive.com) 
* [learn.perl.org](http://learn.perl.org/) [GitHub](https://github.com/perlorg/perlweb/tree/master/docs/learn)
* [lists.perl.org](http://lists.perl.org/) A list of Perl-related, topic-oriented mailing lists. [GitHub](https://github.com/perlorg/perlweb/tree/master/docs/lists)
* [use.perl.org](http://use.perl.org/) old blog server of the Perl community. It is now static.
* [history.perl.org](http://history.perl.org/)
* [debugger.perl.org](http://debugger.perl.org/) [GitHub](https://github.com/perlorg/perlweb/tree/master/docs/debugger)
* [pause.perl.org](http://pause.perl.org/) The Perl Authors Upload Server, the thing that feeds CPAN, has its source code on [GitHub](https://github.com/andk/pause/).
* [auth.perl.org](http://auth.perl.org/)
* [perldoc.perl.org](http://perldoc.perl.org/) The standard documentation of Perl in HTML format. [GitHub](https://github.com/perlorg/perldoc.perl.org)

* [www.perlfoundation.org](http://www.perlfoundation.org/)
* [news.perlfoundation.org](http://news.perlfoundation.org/)
* [perl-foundation.org](http://perl-foundation.org/) (redirects to perlfoundation.org)
* [news.perl-foundation.org](http://news.perl-foundation.org/) (redirects to news.perlfoundation.org)</a>

* [cpan.org](http://cpan.org/)
* [search.cpan.org](http://search.cpan.org/)
* [ftp.cpan.org](http://ftp.cpan.org/)
* [rt.cpan.org](https://rt.cpan.org/), the default bug-tracking system of every CPAN distribution runs [RT](http://bestpractical.com/rt/).
    Source code can be found [here](http://bestpractical.com/rt/git.html).


[bitcard.org](http://bitcard.org/) perl.org authentication service

[www.perl.com](http://www.perl.com/)

[pm.org](http://pm.org/) The central site of the Perl Mongers [GitHub](https://github.com/perlorg/www.pm.org)

[www.annocpan.org](http://www.annocpan.org/) AnnoCPAN is a service to easily annotate the documentation of CPAN modules.

## Perl 6

[perl6.org](http://perl6.org/), the main Perl 6 website, consists
of static pages generated from [perl6/perl6.org](http://github.com/perl6/perl6.org/)

[doc.perl6.org](http://doc.perl6.org/), the Perl 6 documentation site consists of static pages generated from
[this repository](https://github.com/perl6/doc/).

[modules.perl6.org](http://modules.perl6.org/) the list of available Perl 6 modules. Static pages generated by
[this code](https://github.com/perl6/modules.perl6.org/).

[testers.perl6.org](http://testers.perl6.org/) the CPAN Testers from Perl 6.
This is a dynamic site. The source code is in [this repository](https://github.com/perl6/cpandatesters.perl6.org).

All perl6.org pages are served from the <a href="http://www.p6c.org/">Perl 6
community server</a>, funded by community donations, and run by <a
href="https://github.com/perl6/infrastructure-doc/blob/master/hosts/hack.p6c.org.pod#administration">several</a>
[volunteers](https://github.com/perl6/infrastructure-doc/blob/master/hosts/www.p6c.org.pod#administration).

[irclog.perlgeek.de](http://irclog.perlgeek.de/) logs IRC channels. It uses [ilbot](http://moritz.faui2k3.org/en/ilbot). Source code
is [here](https://github.com/moritz/ilbot/).

## Perl Tutorial

[perl-tutorial.org](http://perl-tutorial.org/)

Maintained by [Christian Walde](http://cat.eatsmou.se/) ([Mithaldu](https://metacpan.org/author/MITHALDU))
and [Tina Müller (Tinita)](https://github.com/perlpunk). Information about the system can be found in their
[about](http://perl-tutorial.org/about/) page.

## Perl News

[perlnews.org](http://perlnews.org/)

Maintained by [Leo Lapworth (Ranguard)](http://leo.cuckoo.org/)


## blogs.perl.org

[blogs.perl.org](http://blogs.perl.org/), the shared blog site of the Perl community runs on the 
Professional Edition of [Movable Type](http://movabletype.com/) which is not open source.
Though it might be the open source version with a few extra (proprietary) extensions.

Nevertheless the templates of the site are available [here](https://github.com/blogs-perl-org/blogs.perl.org).
There is also a version of Movable Type on [GitHub](https://github.com/movabletype/movabletype), but it is unclear to
me what is the license of that, and what is the relation of that to the one used on blogs.perl.org.

The site runs on a dedicated server at [Hetzner](https://www.hetzner.de/en/).
It is an Intel i7 with four cores (plus hyper-threading), 8 GB of RAM, and software RAID. It's currently running Ubuntu.

The server is maintained by [Dave Cross](http://dave.org.uk/) and [Aaron Crane](http://aaroncrane.co.uk/).
They also cover the expenses.


## CPAN Testers

[cpantesters.org](http://cpantesters.org/)


<h3>deps.cpantesters.org</h3>

The [CPANdeps](http://deps.cpantesters.org/) project run by [David Cantrell](http://www.cantrell.org.uk/david/),
has its source code in [GitHub](https://github.com/DrHyde/CPANdeps).
It is on a dedicated server provided for free by UK2.net. It has 4GB RAM, 0.5TB disk, and some species of dual-core processor.
It runs Debian Linux, MySQL, Apache and perl.

<h3>cpXXXan</h3>

The [cpXXXan.barnyard.co.uk](http://cpxxxan.barnyard.co.uk/) site run by 
[David Cantrell](http://www.cantrell.org.uk/david/),
has its source code in [GitHub](https://github.com/DrHyde/cpXXXan)
cpXXXan is similar to CPANdeps and also provided for free by UK2.net. The hardware is identical apart from only 2GB of memory. It uses the same software.

<h3>matrix.cpantesters.org</h3>

[Slaven Rezic](http://rezic.de/) runs 
[matrix.cpantesters.org](http://matrix.cpantesters.org) on a small
one-CPU VM. Actually this VM
is dedicated to another service of Slaven and the matrix is just a guest
there. The alternative version of the matrix
([the "log.txt" view](http://217.199.168.174/cgi-bin/cpantestersmatrix.pl))
runs on another
machine setup by Barbie and sponsored by Webfusion (see the banner on
that page). A possible task for the [QA hackathon](http://qa-hackathon.org/) would be to move the
regular matrix also to this machine, as it is bigger and dedicated to
perl QA stuff (IIRC a physical machine with eight CPUs).

The matrix is an old-fashioned CGI running in an old-fashioned Apache
server. It's also possible to run it as a PSGI application, but
currently there's no pressing need to do so. The software is at 
[GitHub](https://github.com/eserte/cpan-testers-matrix).

## CPAN Testers - smokers

**[David Cantrell](http://www.cantrell.org.uk/david/)**:
<i>
My testing is done in a Linux VM running on a dedicated server that I rent. It nominally has 8GB RAM and 4 CPUs. The underlying hardware has 32GB and 8 CPUs. Virtualisation is done with Xen.
Unfortunately I no longer test on any other OSes.
</i>

**[Slaven Rezic](http://rezic.de/)**:
<i>
I maintain four regular smokers (two FreeBSD + two Linux, with several
perl versions ranging from 5.8.9 to 5.21.10), all running in VMs. Three
of them are located on my personal workstation and one is running on a
server of another Berlin perl monger. Typically the machines are running
24/7 except when I am on vacation. In these periods the "specialties"
of my smokers (that is: provide first reports very quickly after PAUSE
upload, and provide reports for a rather rare platform, FreeBSD) have to
be done by other people (in this case, by Andreas Koenig and Chris
Williams).

The smokers are based on [CPAN.pm](https://metacpan.org/pod/CPAN) and
[CPAN::Reporter](https://metacpan.org/pod/CPAN::Reporter), but I don't use
[CPAN::Reporter::Smoker](https://metacpan.org/pod/CPAN::Reporter::Smoker).
Instead I have a couple of wrapper scripts
(cpan_smoke_modules_wrapper3, cpan_smoke_modules) which may be found
on [GitHub](https://github.com/eserte/srezic-misc/tree/master/scripts).
There's no real documentation for these, primarily because I doubt that
my workflow is appealing to other people.
</i>

See also the [CPAN OpenBSD Smoker](https://github.com/glasswalk3r/cpan-openbsd-smoker)
and the [Docker Metabase Relayd](https://github.com/glasswalk3r/docker-metabase-relayd).
Both by Alceu Rodrigues de Freitas Junior.


## CPANTS - A CPAN Testing Service

(Unrelated to CPAN Testers above!)

[cpants.cpanauthors.org](http://cpants.cpanauthors.org/) check various kwalitee metrics
about CPAN modules.
The service is maintained by [Kenichi Ishigaki (charsbar)](http://d.hatena.ne.jp/charsbar/).
The source code of the web-site is in [GitHub](https://github.com/cpants/www-cpants/).

## CPAN::Changes Kwalitee Service

[changes.cpanhq.org](http://changes.cpanhq.org/) maintained by [Brian Cassidy](http://blog.alternation.net/)
Source code in [GitHub](https://github.com/bricas/cpan-changes-web).


<h2 id="act">ACT</h2>

Most [Perl conferences](http://act.mongueurs.net/conferences.html) (YAPCs, Workshops etc) run on [Act - A Conference Toolkit](http://act.mongueurs.net/).
Its source code is in [the Act repository](https://github.com/book/Act). The server is run by the [The French Perl Mongueurs](http://mongueurs.pm/):
[Sébastien Aperghis-Tramoni (maddingue)](https://github.com/maddingue), [Philippe Bruhat (BooK)](http://philippe.bruhat.net/),
and [Éric Cholet](https://metacpan.org/author/CHOLET).

In case the service is not available you can ask for help on the `#act` channel on irc.perl.org. Specifically you might want to ping `maddingue` there.

## YAPC::EU

[yapc.eu](http://yapc.eu/) and [www.yapceurope.org](http://www.yapceurope.org/)
are the home page(s) of the YAPC::Europe Foundation. They are also used as the domain for the YAPC::EU events while the actual sites of the events
are hosted on the central [ACT](#act) server. 

[Philippe Bruhat (BooK)](http://philippe.bruhat.net/):
<i>
The /$year/ URLs are pointing either to the corresponding Act website,
or a static archive of the site. The static data is stored here:
https://github.com/yapceurope/yapc-eu-archives (the only missing site is
the one for Belfast 2004, but I have it on my todo-list to grab the
data from archive.org and eventually add it there).

Every act.yapc.eu URL actually points to Act. The webserver has a complex
config canonicalizing URLs back and forth. Some of it handled by Act.
For example, http://perlworkshop.nl/ and  http://act.yapc.eu/nlpw2015
will redirect to http://www.perlworkshop.nl/nlpw2015/.
</i>

The source code is in [GitHub](https://github.com/yapceurope/yef-www)

The actual website is generated by a 15 years old script running ttree.


## YAPC and Perl Workshops

[yapcna.org](http://yapcna.org/) the domain for YAPC::NA. The actual sites are based on ACT and are hosted on the central [ACT](#act) server.

[yapc.org](http://yapc.org/) Is a nice-looking, but outdated site linking to other YAPCs and Perl Workshops. 

[yapcrussia.org](http://yapcrussia.org/) redirects to the ACT instance used to manage YAPC::Russia</a> events.

[yapc.tv](http://yapc.tv/).

[www.perlworkshop.nl](http://www.perlworkshop.nl/) NLPW - Dutch Perl Workshop.

[dcbpw.org](http://dcbpw.org/) DC-Baltimore Perl Workshop.

[perl-workshop.ch](http://perl-workshop.ch/) Swiss Perl Workshop.

[qa-hackathon.org](http://qa-hackathon.org) QA Hackathon.

<h3>YAPC::Asia</h3>

[Daisuke Maki (lestrrat)](http://lestrrat.github.io/):
<i>
[yapcasia.org](http://yapcasia.org/) hosts (or at least redirects to) all of the past YAPC::Asia Tokyo's that have been held, dating back to 2006. Up to 2009.
The system behind was ACT, so the actual site lived with other YAPCs that it hosts.

Since 2010, YAPC::Asia Tokyo's site's static content has been built using MovableType, and the dynamic content including user registration, payment (only for 2010 and 2011),
talk submission and listing have been built using either bare PSGI servers that does the minimum job or a simple Mojolicious based application.
Payments are handled by Peatix, Inc since 2012 -- until then we used to use a handmade QR-code solution.
There's absolutely no fancy engineering behind them because we did not intend to put resources in the engineering side of the conference.

A single nginx server handles all the frontend marshaling.

In 2015, all the infrastructure has been moved to a Docker based architecture just for the heck of it, but in hindsight this was unnecessary,
except for the fact that the yours truly learned a lot about how to use Docker :)

The infrastructure is hosted under [Sakura VPS](http://sakura.ad.jp/).
</i>


## Japan Perl Association

[Daisuke Maki (lestrrat)](http://lestrrat.github.io/):
<i>
[perlassociation.org](http://perlassociation.org) the site of Japan Perl Association, doesn't have much content in it, so it's built with a simple Mojolicious application and nginx, running on a VPS at CPI (http://www.cpi.ad.jp/scalable/). Most of what we do under the perlassociation.org domain is actual shuffling documents and so forth, so we use Google Apps to to handle this.
</i>

## Mojolicious

[Mojolicious](http://mojolicious.org/), the web framework. The source code of its own web site is in the [Mojolicious](https://github.com/mojolicio/mojo)
repository.


## Catalyst

[catalystframework.org](http://catalystframework.org/)

## Perl Maven

[perlmaven.com](https://perlmaven.com/). The site (along with a few smaller sites of [Gabor Szabo](https://szabgab.com/))
is hosted on  [Linode](/linode) instance with 4Gb memory 4 CPUs.
It is based on [Dancer 2](/dancer) its source code is available on [GitHub](https://github.com/szabgab/Perl-Maven).
The content is also available on [GitHub](https://github.com/szabgab/perlmaven.com)

[perl6maven.com](http://perl6maven.com/) runs on [Baildor](http://perl6maven.com/bailador), a partially
implemented Perl Dancer clone in Perl 6. Its source code is available [on GitHub](https://github.com/szabgab/Perl6-Maven).
It is hosted on  [Linode](/linode) instance with 2Gb memory 2 CPUs, along with a few other sites of
[Gabor Szabo](https://szabgab.com/).


## Perl Weekly

[perlweekly.com](http://perlweekly.com/) is the curated weekly newsletter about Perl. It is hosted on a [Linode](/linode)
instance along with a few other domains. Source code is in [GitHub](https://github.com/szabgab/perlweekly)


## Resources and other information

Some GitHub repositories

* [tpf](https://github.com/tpf)
* [perlorg](https://github.com/perlorg)

Especially note the [docs repository](https://github.com/tpf/docs) that has a list of domain names important to the Perl world
and a list of web-sites belonging to [The Perl Foundation](http://www.perlfoundation.org/).


* [grep.cpan.me](https://grep.cpan.me/) (and [grep.metacpan.org](https://grep.metacpan.org/) when the former doesn't work)
* [www.irc.perl.org](http://www.irc.perl.org) as an introduction to the Perl community on IRC
* [perl6intro.com](http://perl6intro.com/) as a place to dip one's toes into the Perl 6 pool
* [perl.meetup.com](https://perl.meetup.com/) run by the Meetup company.
* [Perl on Reddit](https://www.reddit.com/r/perl/) and [Perl 6 on Reddit](https://www.reddit.com/r/perl6/). Can be useful to share links, ask Perl-related questions, or ask around why one of the other services does not work.


