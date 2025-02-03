---
title: "Crypt::SSLeay and HTTPS_PROXY Problem"
timestamp: 2012-09-19T06:09:26
tags:
  - Crypt::SSLeay
  - HTTPS_PROXY
published: true
archive: true
---



Posted on 2012-09-19 06:09:26.512359-07 by ulmi

After upgrading an Ubuntu system from 10.04 to 12.04 I can no longer
get the HTTPS_PROXY option from Crypt::SSLeay (via LWP::UserAgent) to work.
I have the following example script, which works in 10.04:

```perl
#!/usr/bin/perl
use warnings;
use strict;
use WWW::Mechanize;
use Data::Dumper;
use Net::SSL;
BEGIN {
  $Net::HTTPS::SSL_SOCKET_CLASS = "Net::SSL"; # Force use of Net::SSL
}

my $ua = WWW::Mechanize->new( autocheck => 0,);
$ENV{'HTTPS_PROXY'} = 'http://10.8.0.194:8080';
$ua->ssl_opts( verify_hostname => 0 );
my $response = $ua->get('https://10.8.142.7');
```

On a stock ubuntu 12.04 this script fails with:

```perl
$VAR1 = 'read failed:  at /usr/share/perl5/Net/HTTP/Methods.pm line 256
 at /usr/lib/perl5/Net/SSL.pm line 210
    Net::SSL::die_with_error(\'LWP::Protocol::https::Socket=GLOB(0x13ce178)\', \'read failed\') called at /usr/lib/perl5/Net/SSL.pm line 223
    Net::SSL::read(\'LWP::Protocol::https::Socket=GLOB(0x13ce178)\', \'\', 1024, 0) called at /usr/share/perl5/Net/HTTP/Methods.pm line 256
    Net::HTTP::Methods::my_readline(\'LWP::Protocol::https::Socket=GLOB(0x13ce178)\', \'Status\') called at /usr/share/perl5/Net/HTTP/Methods.pm line 343
    Net::HTTP::Methods::read_response_headers(\'LWP::Protocol::https::Socket=GLOB(0x13ce178)\', \'laxed\', 1, \'junk_out\', \'ARRAY(0x13a5d78)\') called at /usr/share/perl5/LWP/Protocol/http.pm line 378
    LWP::Protocol::http::request(\'LWP::Protocol::https=HASH(0x1379f70)\', \'HTTP::Request=HASH(0x13460a8)\', undef, undef, undef, 180) called at /usr/share/perl5/LWP/UserAgent.pm line 192
    eval {...} called at /usr/share/perl5/LWP/UserAgent.pm line 191
    LWP::UserAgent::send_request(\'WWW::Mechanize=HASH(0x12505d0)\', \'HTTP::Request=HASH(0x13460a8)\', undef, undef) called at /usr/share/perl5/LWP/UserAgent.pm line 274
    LWP::UserAgent::simple_request(\'WWW::Mechanize=HASH(0x12505d0)\', \'HTTP::Request=HASH(0x13460a8)\', undef, undef) called at /usr/share/perl5/LWP/UserAgent.pm line 282
    LWP::UserAgent::request(\'WWW::Mechanize=HASH(0x12505d0)\', \'HTTP::Request=HASH(0x13460a8)\') called at /usr/share/perl5/WWW/Mechanize.pm line 2503
    WWW::Mechanize::_make_request(\'WWW::Mechanize=HASH(0x12505d0)\', \'HTTP::Request=HASH(0x13460a8)\') called at /usr/share/perl5/WWW/Mechanize.pm line 2217
    WWW::Mechanize::request(\'WWW::Mechanize=HASH(0x12505d0)\', \'HTTP::Request=HASH(0x13460a8)\') called at /usr/share/perl5/LWP/UserAgent.pm line 410
    LWP::UserAgent::get(\'WWW::Mechanize=HASH(0x12505d0)\', \'https://10.8.142.7\') called at /usr/share/perl5/WWW/Mechanize.pm line 407
    WWW::Mechanize::get(\'WWW::Mechanize=HASH(0x12505d0)\', \'https://10.8.142.7\') called at ./ssl.pl line 27
```

I then tried upgrading Crypt::SSleay via cpanm to version 0.64. After upgrading my little script just blocks forever.
Strace shows a blocking 'read(3,'. A tcpdump shows that the proxy server sends the correct '200 Connection established' response,
but that the Client then does nothing (it should start the SSL 'handshake'):

```
00000000  43 4f 4e 4e 45 43 54 20  31 30 2e 38 2e 31 34 32 CONNECT  10.8.142
00000010  2e 37 3a 34 34 33 20 48  54 54 50 2f 31 2e 30 0d .7:443 H TTP/1.0.
00000020  0a 0d 0a                                         ...
    00000000  48 54 54 50 2f 31 2e 31  20 32 30 30 20 43 6f 6e HTTP/1.1  200 Con
    00000010  6e 65 63 74 69 6f 6e 20  65 73 74 61 62 6c 69 73 nection  establis
    00000020  68 65 64 0d 0a 41 63 63  65 70 74 2d 52 61 6e 67 hed..Acc ept-Rang
    00000030  65 73 3a 20 6e 6f 6e 65  0d 0a 43 6f 6e 6e 65 63 es: none ..Connec
    00000040  74 69 6f 6e 3a 20 63 6c  6f 73 65 0d 0a 0d 0a    tion: cl ose....
```

The versions of some possibly relevant CPAN packages are:

```
Net::SSL: 2.85
Crypt::SSLeay: 0.64
Net::SSLeay: 1.42
LWP::UserAgent: 6.03
WWW::Mechanize: 1.71
IO::Socket::SSL: 1.53
```

Can anyone help me out with either one of these two problems? I've pretty much run out of ideas; even just some hints on where I could debug further would be great.

Posted on 2012-09-28 08:01:54.837295-07 by ulmi in response to 13808

I was able to resolve my first problem by upgrading Net::HTTP to 6.03 (fixes this bug: https://rt.cpan.org/Public/Bug/Display.html?id=72790 ).
As far as I can tell the second one seems to be a problem / bug in newer versions of Crypt::SSLeay.


(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/13808 -->


