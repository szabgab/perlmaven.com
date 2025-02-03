---
title: "Start using the MetaCPAN API Client to fetch the list of most recently uploaded Perl modules"
timestamp: 2020-08-05T17:00:01
tags:
  - MetaCPAN::Client
  - MetaCPAN::API
  - MetaCPAN
published: true
author: szabgab
types:
  - screencast
archive: true
description: "How to locate the module that can be used to access the MetaCPAN API. It is called MetaCPAN::Client."
show_related: true
---


[MetaCPAN](https://metacpan.org/) is the place where you go if you'd like to find a Perl module and if
you'd like to read its documentation.

It also has a public API so we can write a script to search for various things for us.

For example we would like to be able to fetch the most recently uploaded modules.


For this first we need to locate the module that implements the client for the API. It is called
[MetaCPAN::Client](https://metacpan.org/pod/MetaCPAN::Client)

Then we need to install the module

```
cpanm MetaCPAN::Client
```

Then we play around a bit with the documentation and get this script:

{% include file="examples/meta.pl" %}

We found the <b>recent</b> method of [MetaCPAN::Client](https://metacpan.org/pod/MetaCPAN::Client) to return
an instance of [MetaCPAN::Client::ResultSet](https://metacpan.org/pod/MetaCPAN::Client::ResultSet) holding a list
of [MetaCPAN::Client::Release](https://metacpan.org/pod/MetaCPAN::Client::Release) objects.

{% youtube id="7iy5VNpHSZk" file="english-start-using-metacpan-client.mkv" %}

