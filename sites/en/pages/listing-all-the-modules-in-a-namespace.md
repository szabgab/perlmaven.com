---
title: "Finding all Plack Middleware or Perl::Critic Policies"
timestamp: 2014-08-31T16:30:01
tags:
  - Plack::Middleware
  - Perl::Critic::Policy
  - Dancer::Plugin
  - Dancer2::Plugin
  - Catalyst::Plugin
published: true
author: szabgab
---


Recently I was working on a patch for [MetaCPAN](https://metacpan.org/),
but then it turned out that I don't need to implement it as it is already working.
I wanted to be able to list all the modules within a namespace.
Apparently it is very easy. I only need to prefix my search with **module:**


A few examples:

* [module:Plack::Middleware](https://metacpan.org/search?q=module:Plack::Middleware)
* [Perl::Critic::Policy](https://metacpan.org/search?q=module:Perl::Critic::Policy)
* [Catalyst::Plugin](https://metacpan.org/search?q=module:Catalyst::Plugin)
* [Dancer::Plugin](https://metacpan.org/search?q=module:Dancer::Plugin)
* [Dancer2::Plugin](https://metacpan.org/search?q=module:Dancer2::Plugin)
* [Mojolicious::Plugin](https://metacpan.org/search?q=module:Mojolicious::Plugin)
* [Padre::Plugin](https://metacpan.org/search?q=module:Padre::Plugin)

Now I only need to figure how to list all of them on a single page.

BTW If you are looking for related articles on the Perl Maven site here are a few links:

* [PSGI - Plack](/psgi)
* [Dancer](/dancer)
* [Mojolicious](/mojolicious)
* [Catalyst](/catalyst)
* or type in Perl::Critic in the box on the top menu

## Caveat

As I Francisco Zarabozo commented and as I also [found out later](/metacpan-search-tricks), the **module:** keyword does not
only match the beginning of the module name. It matches any whole part of the module name. So for example
[module:Plugin](https://metacpan.org/search?q=module:Plugin) will find any module that has Plugin in its name.
