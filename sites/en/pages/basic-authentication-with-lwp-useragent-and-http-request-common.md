---
title: "Basic Authentication with LWP::UserAgent and HTTP::Request::Common"
timestamp: 2016-09-28T12:10:01
tags:
  - LWP::UserAgent
  - HTTP::Request::Common
published: true
author: szabgab
archive: true
---


A while ago I wrote an article on [LWP::UserAgent and Basic Authentication](/lwp-useragent-and-basic-authentication) and posted it on
Reddit as well, where a user pointed to an even simpler solution, one that I did not find in the documentation myself.
It uses [LWP::UserAgent](https://metacpan.org/pod/LWP::UserAgent) and [HTTP::Request::Common](https://metacpan.org/pod/HTTP::Request::Common)
which is a dependency of LWP::UserAgent anyway.


(Actually, I think I saw and used this or a similar solution a few years ago, but I did not remember or could not find it again when I wrote the previous article.
Now I seem to recall there was an issue with this solution when the request redirected to another URL that requred Basic Authentication,
but I am not entirly sure. The point is that I think this solution works in most of the cases, but in the rare special cases you might still
need the [other solution](/lwp-useragent-and-basic-authentication).)

{% include file="examples/basic_authentication.pl" %}

## Debugging the script

If you have problems running the script, there are some nice techniques to make
[UserAgent Debugging Easy](http://www.olafalders.com/2016/09/29/useragent-debugging-made-easy/).

## Comments

This line doesn't look right!

my $request = GET 'https://pause.perl.org/pause/authenquery';

Don't we need something like this?

my $request = HTTP::Request->new( GET => 'https://pause.perl.org/pause/authenquery');

---

This works too - and looks better :)


