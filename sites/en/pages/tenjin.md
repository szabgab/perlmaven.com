---
title: "Tenjin templating system"
timestamp: 2021-04-06T09:00:01
tags:
  - Tenjin
published: true
author: szabgab
archive: true
show_related: true
---


The [Tenjin templating system](https://metacpan.org/release/Tenjin) allows you to embed Perl code in your HTML templates.


Here is a sample template and a sample script:

The template:

{% include file="examples/tenjin/templates/simple.html" %}

The code to fill it:

{% include file="examples/tenjin/tenjin.pl" %}


The resulting output:

{% include file="examples/tenjin/output.html" %}




