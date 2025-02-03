---
title: "cpan install XML::XPath"
timestamp: 2011-07-06T19:16:50
tags:
  - XML::XPath
published: true
archive: true
---



Posted on 2011-07-06 19:16:50.810831-07 by jagdrummer

Let me start off by saying I know nothing about Strawberry or Perl.
I'm try to run a script (http://code.google.com/p/picasa-upsync-faces/)
to sync facetags for google's picasa but cannot get XPath to install.
I installed strawberry to C:\perl and tried "cpan install XML::XPath"
but strawberry cannot find it. Here is my terminal output:

```
Microsoft Windows [Version 6.1.7600]
Copyright (c) 2009 Microsoft Corporation.  All rights reserved.

C:\Users\Derek>cpan install XML::Xpath
CPAN: LWP::UserAgent loaded ok (v5.835)
CPAN: Time::HiRes loaded ok (v1.9721)
Fetching with LWP:
http://cpan.strawberryperl.com/authors/01mailrc.txt.gz
CPAN: YAML loaded ok (v0.73)
CPAN: CPAN::SQLite loaded ok (v0.199)
Fetching with LWP:
http://cpan.strawberryperl.com/modules/02packages.details.txt.gz
Fetching with LWP:
http://cpan.strawberryperl.com/modules/03modlist.data.gz
Creating database file ...

Gathering information from index files ...
Populating database tables ...
Done!
Warning: Cannot install XML::Xpath, don't know what it is.
Try the command

    i /XML::Xpath/

to find objects with matching identifiers.

C:\Users\Derek>
```

I greatly appreciate any help.

Posted on 2011-07-13 09:51:25.195473-07 by dejonsen in response to 13396

The CPAN command-line utility is case-sensitive, so make sure the capitalization
on the command line matches that on the "use" statement in the Perl script you're
trying to use. Looks like it might be "XML::XPath" rather than "XML::Xpath".

(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/13396 -->

