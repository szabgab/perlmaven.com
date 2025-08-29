---
title: "CPAN Monitor"
timestamp: 2015-02-01T07:30:02
tags:
  - CPAN
published: true
books:
  - perl
author: szabgab
archive: true
---


The CPAN Monitor will send details about the distributions released in the last 24 hours and filtered
according to various rules. Each such rule-set is called a "subscription".

(These are some old plans that were never implemented.)


Each user can have several "subscriptions".

Each "subscription" has a "title" that will be used in the subject line of the e-mail for easy identification of the monitor.

Each "subscription" has one or more of the following rules:

* **all**      - (True/False.) All the recently uploaded distributions. Probably the same as the [recent on MetaCPAN](https://metacpan.org/recent).
* **unique**   - (True/False.) Filter the distribution to include each one only once. (In case more than one version was uploaded recently.)
* **new**      - (True/False.) This is the first time the distribution was released. [MetaCPAN also provides this](https://metacpan.org/recent?f=n).
* **modules**  - (A list of module names.) Include distributions that provide any of the listed modules.
* **author**   - (A list of PAUSE ids.) Include distributions released by any of the given authors.
* **partials** - (A list of regexes.) Any disribution where either the distribution name or any of the provided modules match the given regex. The regex can currently use `^` and `$` anchors and anything mathching [a-zA-Z0-9].


## Use cases

* Monitor modules you use for updates
* Monitor all the modules that match `^Test`

