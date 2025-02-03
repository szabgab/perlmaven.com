---
title: "GitLab CI for Perl projects"
timestamp: 2020-11-24T20:30:01
tags:
  - GitLab
  - CI
published: true
author: szabgab
archive: true
show_related: true
---


According to [CPAN Rocks](https://cpan.rocks/) there are 29 CPAN modules that use GitLab as their bug-tracking system. That probably means those
are the projects that use GitLab as a VCS.


The following ones have GitLab CI enabled:

* [App-perldebs](https://metacpan.org/release/App-perldebs)
* [Art-World](https://metacpan.org/release/Art-World)
* [Dist-Zilla-Plugin-Test-NoBOM](https://metacpan.org/release/Dist-Zilla-Plugin-Test-NoBOM)
* [Dist-Zilla-PluginBundle-Author-IOANR](https://metacpan.org/release/Dist-Zilla-PluginBundle-Author-IOANR)
* [Linux-Systemd](https://metacpan.org/release/Linux-Systemd)
* [Log-Any-Plugin-Format](https://metacpan.org/release/Log-Any-Plugin-Format)
* [Perl-Critic-Policy-Modules-ProhibitUseLib](https://metacpan.org/release/Perl-Critic-Policy-Modules-ProhibitUseLib)
* [RxPerl](https://metacpan.org/release/RxPerl)

I am going to review all of them to see what can I learn from all of these [CI](/ci) configurations and what can be use for the other distributions.

