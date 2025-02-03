---
title: "Expect_before amd expect_after with perl and expect.pm"
timestamp: 2006-01-20T20:40:59
tags:
  - Expect
published: true
archive: true
---



Posted on 2006-01-20 20:40:59-08 by manuel

Hi, I usually use expect_after and expect_before with expect to control
timeout's and eof in my scripts:

```perl
! /usr/bin/expect

spawn ssh manuel@linux01
set timeout 2

expect_before  {
        timeout {puts "timeout before"; exit}
}
expect_after  {
        eof {puts "eof after"; exit}
}


expect {
        "assword: " {send "password"}
}
...
```

I tried something similar with expect.pm, but it doesn't work:

```perl
use strict;
use Expect;

my $exp = new Expect();


my @param=qw(root@linux);
$exp->spawn("ssh",@param) || die ("error en comando: $! \n");

$exp->exp_before( 'timeout', \&timeout);

$exp->exp_after( 'eof', \&eof);

$exp->expect(2,'-re',"bssword");
...

sub timeout {
print "algo por timeout\n";
exit;
}

sub eof {
print "algo por eof\n";
exit;
}
```

Why exp_before don't work like expect_before? Regards

Posted on 2006-02-06 10:34:12-08 by rgiersig in response to 1669

Short answer: I didn't need exp_before and exp_after
(I prefer to use the callback style and write out all the possibilities explicitely),
so I didn't invest anything into the code (just took the code that Austin had written).

How about writing it like this:

```perl
$exp->expect(2,
             [ "assword", sub { $exp->send("$password\r\n"); } ],
             [ 'timeout', \&timeout ],
             [ 'eof', \&eof ],
            );
```

Posted on 2006-03-04 16:36:31-08 by manuel in response to 1760

It's not what I want, but it works. thank's


(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/1669 -->


