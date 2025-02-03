---
title: "IO::Socket::INET configuration failed"
timestamp: 2015-09-17T09:15:30
tags:
  - IO::Socket::INET
  - Net::SMTP::SSL
published: true
author: szabgab
archive: true
---


I am trying to connect to [SMTPS](https://en.wikipedia.org/wiki/SMTPS) using [Net::SMTP::SSL](https://metacpan.org/pod/Net::SMTP::SSL) library.
While trying to connect I am getting an error which says.

```
IO::Socket::INET configuration failederror:00000000:lib(0):func(0):reason(0)
```

I am able to connect to SMTP. I have tried the same with telnet and telnets which was successful.
Can anyone please give me some ideas about this error?

(Problem was fixed with [IO::Socket::SSL](https://metacpan.org/pod/IO::Socket::SSL) version 1.06.)


## Are you sure you talk to an SMTP server which talks SSL directly?

There are two ways to do SSL within SMTP, one is to just tunnel SMTP within an SSL connection (this is what Net::SMTP::SSL supports)
and the other is to have a normal SMTP server (usually sitting at port 25), start a unencrypted session and then switch with
STARTTLS command to an SSL session. This is unsupported by Net::SMTP::SSL.

If you are sure that you try to use Net::SMTP::SSL in the intended way (tunnel SMTP through SSL instead STARTTLS on plain connection)
you could post an example program which shows your problem (please with the real server) so I could have a look at it.

-- Steffen

## Posted by keanan007

I have the exact same issue here's my test program:

```perl
use Net::SMTP::SSL;

$IO::Socket::SSL::DEBUG = 1;

my $smtp = Net::SMTP::SSL->new( 'SMTP',
Host => "mail.peakpeak.com",
Debug => 1,
Port => '465');

if(defined $smtp)
{
        print "'$smtp'\n";
} else {

        die "SMTP is undefined\n$@$!";

}

$smtp->quit;
```

Here's the output of this program:

```
CA file certs/my-ca.pem not found, using CA path instead.
IO::Socket::INET configuration failederror:00000000:lib(0):func(0):reason(0)
 at test.pl line 5
SMTP is undefined
Net::SMTP::SSL: Bad service '' at test.pl line 15.
```


Also some additional information: I get the same exact error when I have the initial call as:

```perl
my $smtp = Net::SMTP::SSL->new(
Host => "mail.peakpeak.com",
Debug => 1,
Port => '465');
```

or

```perl
my $smtp = Net::SMTP::SSL->new("mail.peakpeak.com",
Debug => 1,
Port => '465');
```

And I have another perl program on the same machine (In the same directory even) that uses
IO::Socket::SSL to make https requests (Via LWP::UserAgent), which works perfectly. I'm not actually sure this is an issue
directly related to IO::Socket::SSL and not Net::SMTP or Net::SMTP::SSL (Although the latter simply substitutes IO::Socket::SSL for IO::Socket::INET in the former)

Posted on 2007-04-30 07:51:31-07 by noxxi in response to 5004

Problem is fixed with [IO::Socket::SSL](https://metacpan.org/pod/IO::Socket::SSL) version 1.06 which I just uploaded to CPAN.

Problem was, that IO::Socket::SSL "sanitized" the Arguments it gets by setting undef stuff to ''.
This way it gave a LocalPort of '' to IO::Socket::INET which did not like it.
This was probably broken long long ago.

-- Steffen

(This article was rescued from CPAN::Forum)
<!-- from http://cpanforum.com/threads/3706 -->


