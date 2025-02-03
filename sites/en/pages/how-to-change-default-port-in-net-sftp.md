---
title: "How to change default port in Net::SFTP?"
timestamp: 2005-07-01T00:32:37
tags:
  - Net::SFTP
published: true
archive: true
---



Posted on 2005-07-01 00:32:37-07 by dana

Hi! I'm going to try this again. Sorry if this is a duplicate. I'm trying to specific a different port when using Net::SFTP. It looks like you can by passing
in ssh_args parameters. But when I add in `port => '5000'`, it didn't work! What am I doing wrong? Help please!

I figured it out. In case anyone is wondering, the correct syntax is:

```perl
my $sftp = new Net::SFTP( $host, user=>$user, password=>$pass,
debug=>true, ssh_args => [ port => '2300' ] );
```

(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/678 -->

