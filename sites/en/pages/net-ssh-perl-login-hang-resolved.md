---
title: "Net::SSH::Perl - Login Hang Resolved!"
timestamp: 2006-07-24T22:34:20
tags:
  - Net::SSH::Perl
  - Crypt::DH
published: true
archive: true
---



Posted on 2006-07-24 22:34:20-07 by dougreed


Several people have reported a login hang in Net:SSH::Perl in several threads, with no resolution.
The problem is described as a long hang after:

stephanie: Algorithms, c->s: 3des-cbc hmac-sha1 none stephanie: Algorithms, s->c: 3des-cbc hmac-sha1 none
hang here...

I have seen this in other forums as well...
The problem is Crypt-DH-0.06 ...
I backed off to version Crypt-DH-0.03 (which I knew worked) and the problem cleared.
I am not sure which version caused the problem (between .03 to .06),
but Crypt-DH is the problem for sure.

Posted on 2006-09-07 14:44:42-07 by gorfou in response to 2689

Downgrading to Crypt::DH 0.03 also solves a "Segmentation Fault" problem
when Entering Diffie-Hellman Group 1 key exchange on a SunOS 5.9 & perl 5.6.1 system.

Posted on 2006-09-20 02:37:01-07 by surpdeh in response to 2957

Downgrading from Crypt::DH 0.06 to 0.03 also fixed an intermittent "Segmentation Fault"
problem on a Redhat 7.3 Perl 5.6.1 system. Running the program in
perl -d would have the software work. It would sometimes work when run from strace.
It would basically never work when run standalone.


(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/3706 -->


