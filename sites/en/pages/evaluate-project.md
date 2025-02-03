---
title: "Evaluate Perl project for new client - assessment"
timestamp: 2020-12-30T07:30:01
tags:
  - Perl
published: true
author: szabgab
archive: true
description: "How to evaluate a Perl-related project at a new potential client?"
show_related: true
---


Recently a number of people have contacted me with various Perl-based projects. I had the opportunity to have an email exchange with them
to try to understand what they need and if I can provide the help. A few question came up and for my future reference I wrote them down.

These were almost always old projects that needed some new feature added.


* Which Operating system does the project expected to run? Windows, Linux, Mac OSX? Something else? Which Linux distribution? Which version of the OS?
* Which version of Perl is the project currently using? 5.6? 5.32? Which should it support?
* Can we install new software on the production boxes?
* More specifically, can we install new modules from CPAN? Does the system have access to CPAN?
* Can I get access to the production system or a system similar to it? Do I need to set it up myself?
* Do I get access to all the source files or is the client only dripping them piece by piece? Do they even know what belongs to the code-base?
* Do I get access to the full list of libraries (and their version numbers) in use?
* Does the current version only work if I install it on Windows from an installer?
* If this is some kind of a batch-job, do I get a reasonable variation of input files and expected output files?
* Does the code use strict and warnings?
* Is there some kind of version control system in use?
* Are there any tests for this application? Can I run them? Do they pass?
* Is there a CI system set up?
* How will we know the job is done and nothing else broke? Who and how will this be verified?

And a few more:

* Do I get a clear description of what is needed?
* Is the client going to be available for questions and clarifications?

Non-Perl dependencies

* Does the application assume specific web server? (e.g. Apache + CGI or mod_perl)
* What databases are used by the project?
* What other softtware (and which version) is used by the project?
* Does the project have a well defined release and deployment process? Is it automated?
* How long does it take to release a newly committed piece of code?

