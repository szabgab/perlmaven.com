---
title: "Crypt::SSLeay - 500 Can't connect to ____ (Crypt-SSLeay can't verify hostnames)"
timestamp: 2012-07-25T07:46:09
tags:
  - Crypt::SSLeay
published: true
archive: true
---



Posted on 2012-07-25 07:46:09.991024-07 by jiman

Hello,

I'm writing a client on top of an API that uses Crypt::SSLeay to connect to a https site.
Could you please give some clarification on what this error message means, and further,
what typically causes this? I looked through your perldoc and did not see it documented.

Thank you for your time and assistance,
-Jiman

Posted on 2012-07-29 20:38:17.656048-07 by nanis in response to 13754

Yes, it means that you have to explicitly tell LWP::UserAgent not to verify hostnames
(if you need verification, you should use IO::Socket::SSL for now).


```perl
my $ua  = LWP::UserAgent->new(
    ssl_opts => { verify_hostname => 0 },
);
```


(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/13754 -->


