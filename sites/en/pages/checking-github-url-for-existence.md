---
title: "Checking a GitHub URL for existence"
timestamp: 2020-11-04T10:30:01
tags:
  - LWP::UserAgent
  - Test::More
  - GET
  - HTTP
published: true
author: szabgab
archive: true
description: "Check the status code of an HTTP GET request using Perl"
show_related: true
---


In the [CPAN::Digger](/cpan-digger) project I've encountered an issue. The process cloning the repositories will ask for a "Username"
and get stuck whenever an incorrect URL was supplied. This could happen by a plain typo, if the repository was made private, and maybe other cases.

If someone has renamed a repository and forgot to update the URL in the META files the clone should still work, at least for some time.
This is what's happening to the old name of the CPAN::Digger repository.

All of these cases must be reported, but they should not cause the checking process to get stuck.

One of the fixes I have applied is checking if the repository URL returns **"OK 200"** when accessing with a simple GET requests.


This is a sample code showing 3 different ways how to do it and how to verify that code.

In this example we use [LWP::UserAgent](https://metacpan.org/pod/LWP::UserAgent) to send a GET request and then we check
if the response was **"200 OK"** or **"404 Not Found"**.

In the default behavior of the LWP::UserAgent it allows for redirects and reports the results of the last call. This is
what you can see in the first solution.

In the second solution we set the **max_redirect** to be 0 and thus the response we got was **"301 Moved Permanently"**.

The CPAN::Digger should probably report these cases so the author can notice them and fix them.

{% include file="examples/check_git_url.t" %}

Remember, you pick one of the 3 functions, whichever feels more convenient to you. Or you roll your own.
