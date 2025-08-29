---
title: "Neat trick to jump from search.cpan.org to metacpan.org"
timestamp: 2014-04-04T14:30:01
tags:
  - DDG
  - MetaCPAN
published: true
books:
  - metacpan
  - search_cpan_org
author: szabgab
---


When searching in CPAN, I prefer to use [MetaCPAN](http://metacpan.org/) over search.cpan.org because it looks better, and because it is open source.
If there is a bug that really bothers me, I can send a patch. If I want to add a feature, I can do that. If is accepted by the developers, then everyone will benefit
from it, but I could even run a private instance of MetaCPAN.

Nevertheless, there are many cases when I use Google or [DuckDuckGo](https://duckduckgo.com/) when looking for a solution.
In many cases they will provide a link to search.cpan.org. Almost never to MetaCPAN.

Given that link, how can we easily jump to the respective page on MetaCPAN?


## It's easy

If after searching Google or DuckDuckGo, you reach a URL on search.cpan.org,
something like [this](http://search.cpan.org/~capttofu/DBD-mysql-4.027/lib/DBD/mysql.pm),
you can add the letter **m** in-front of the word cpan in the URL to have [this link](http://search.mcpan.org/~capttofu/DBD-mysql-4.027/lib/DBD/mysql.pm)
that will redirect you to the respective page on MetaCPAN.

This is the change you need to make in the URL:

<pre>
http://search.cpan.org/~capttofu/DBD-mysql-4.027/lib/DBD/mysql.pm
http://search.mcpan.org/~capttofu/DBD-mysql-4.027/lib/DBD/mysql.pm
             ^^^
</pre>


I did not remember this, but apparently Dave Cross [wrote about this already](http://perlhacks.com/2013/01/give-me-metacpan/),
and even showed a Firefox plugin that will do this automatically for you.

