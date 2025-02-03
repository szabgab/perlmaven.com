---
title: "GitHub Actions for Pinto-Remote-SelfContained"
timestamp: 2022-10-11T10:30:01
tags:
  - Github
published: true
author: szabgab
archive: true
show_related: true
---


Starting off from [CPAN Digger](https://cpan-digger.perlmaven.com/) I wanted to add Github Actions configuration file to [Pinto-Remote-SelfContained](https://metacpan.org/dist/Pinto-Remote-SelfContained).


The initial version of the configuration failed with an error while running

```
dzil authordeps --missing | cpanm --notest
```

After installing many packages I saw an error:

```
121 distributions installed
Error: [PodWeaver] [Support] No bugtracker in metadata! at inline delegation in Pod::Weaver::Section::Support for logger->log_fatal (attribute declared in /opt/hostedtoolcache/perl/5.36.0/x64/lib/site_perl/5.36.0/Pod/Weaver/Role/Plugin.pm at line 58) line 18.
! Finding [PodWeaver] on cpanmetadb failed.
! Finding [PodWeaver] () on metacpan failed.
! Finding [PodWeaver] () on mirror http://www.cpan.org/ failed.
! Couldn't find module or a distribution [PodWeaver]
! Finding [Support] on cpanmetadb failed.
! Finding [Support] () on metacpan failed.
! Finding [Support] () on mirror http://www.cpan.org/ failed.
! Couldn't find module or a distribution [Support]
! Finding No on cpanmetadb failed.
! Finding No () on metacpan failed.
! Finding No () on mirror http://www.cpan.org/ failed.
! Couldn't find module or a distribution No
! Finding bugtracker on cpanmetadb failed.
! Finding bugtracker () on metacpan failed.
! Finding bugtracker () on mirror http://www.cpan.org/ failed.
! Couldn't find module or a distribution bugtracker
! Finding metadata! on cpanmetadb failed.
! Finding metadata! () on metacpan failed.
! Finding metadata! () on mirror http://www.cpan.org/ failed.
skipping N/NW/NWCLARK/perl-5.8.9.tar.gz
! Couldn't find module or a distribution metadata!
Error: Process completed with exit code 1.
```

I am not sure what the problem is here. So I [reported it](https://github.com/reyjrar/Pinto-Remote-SelfContained/issues/2).

I have not sent the Pull-Request yet the configuration has not been finished yet. We'll see what happens.

