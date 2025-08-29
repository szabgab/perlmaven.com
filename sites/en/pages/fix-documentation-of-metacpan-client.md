---
title: "Fix the documentation of the MetaCPAN::Client"
timestamp: 2020-08-17T07:30:01
tags:
  - MetaCPAN
  - Git
  - GitHub
published: true
author: szabgab
types:
  - screencast
description: "Contributing to an open source project does not need to be a huge investment. Making a simple improvement to the documentation of a Perl module on CPAN already counts."
archive: true
show_related: true
---


Earlier we tried to write some code to [fetch the list of most recently uploaded Perl modules](/start-using-metacpan-api-client).

We found that the documentation of [MetaCPAN::Client::Release](https://metacpan.org/pod/MetaCPAN::Client::Release) isn't accurate.

The **name** attribute returns the name including the version number and the **distribution** returns the name only.


In order to fix this we had to find the source on GitHub and the send a pull request. It was accepted within a few hours.

This is the script to see the values of the attributes.

{% include file="examples/meta.pl" %}

{% youtube id="qauLDUHb9xY" file="english-fix-documentation-of-metacpan-client.mkv" %}

