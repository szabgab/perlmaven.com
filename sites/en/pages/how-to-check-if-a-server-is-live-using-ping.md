---
title: "How to check if a server is live using Ping?"
timestamp: 2015-06-16T22:10:01
tags:
  - ping
  - Net::Ping
published: true
author: szabgab
---


[Ping](https://en.wikipedia.org/wiki/Ping_(networking_utility)) is a unix command (though also available on MS Windows) that
helps determine the connectivity between two machines.
It sends a small packet of data to a remote host which is expected to return it. Then the ping program can report
how long did it take for the data to arrive back (the round-trip time) if it arrived at all.

In order to determine if a packet has been lost or it is just taking a looong time to come back, the utility employs a timeout mechanism.
If a packet does not return within the given timeout period, it is considered as lost.


First we are going to use the [Net::Ping](https://metacpan.org/pod/Net::Ping) module:

## Is server alive?

In the simplest example to check if a server is alive, we are only interested if the `ping` call returns
[true or false](/boolean-values-in-perl). 

```perl
#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use Net::Ping;
my $p = Net::Ping->new();
if ($p->ping('perlmaven.com')) {
   say 'alive';
}
```


`ping` accepts the name of a host, or an IP address.

In order to check what happens when the other machine does not answer try to supply an IP address
that is not in use. For example I used the local IP '192.168.1.24'.

```perl
if ($p->ping('192.168.1.24')) {
```

You will notice that it takes quite some time for this to stop trying. In fact the default timeout
of the `ping` method is 5 seconds.

If you feel it is too much (or too little), you can also provide your own timeout by providing another
number after the address. This is the length of the timeout in seconds.

```perl
if ($p->ping('192.168.1.25', 1)) {
```

## Response time or round-trip time

If we call the `ping` method [LIST context](/scalar-and-list-context-in-perl), it will
return 3 values: The return code (that was returned in SCALAR context as well), the elapsed time in seconds
and the IP address of the host we provided.

```perl
#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use Net::Ping;
my $p = Net::Ping->new();
my ($ret, $duration, $ip) = $p->ping('perlmaven.com');
say $ret;
say $duration;
say $ip;
```

This is the result I saw:

```
$ perl ping.pl 
1
0.19641900062561
173.255.196.65
```

In case the ping fails, the `$ret` will be 0, the `$duration` will show the elapsed time
which is going to be quite close, but not exactly the timeout. The resolved IP address will be also returned:
and the

```
$ perl ping.pl 
0
5.00060319900513
192.168.1.25
```

If there is some other problem, for example that the hostname cannot be resolved to an IP address,
all 3 will be [undef](/undef-and-defined-in-perl) so before printing them we should probably
check if they are [defined](/undef-and-defined-in-perl).


## Pinging several times and calculating average

The regular `ping` utilities usually either ping 3 time and calculate
an average, or ping without any limit till the user presses Ctrl-c.

The following example pings the `$hostname` `$n` times and then prints the average elapsed time.
If some of the pings have not returned, it will also print the "packet loss ratio": The number of packets
that have not received a reply divided by the number of packets sent.

```perl
#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use Net::Ping;
my $p = Net::Ping->new();

my $hostname = 'perlmaven.com';
my $n = 5;

my $time = 0;
my $success = 0;
say "Pinging $hostname $n times";
foreach my $c (1 .. $n) {
    my ($ret, $duration, $ip) = $p->ping($hostname);
    if ($ret) {
        $success++;
        $time += $duration;
    }
}
if (not $success) {
    say "All $n pings failed";
} else {
    if ($success < $n) {
        say( ($n - $success), " lost packets. Packet loss ratio: ", int ( 100 * ($n - $success) / $n ));
    }
    say "Average round trip: ", ($time / $success);
}
```

When I run the script I get the following output.

```
$ perl files/ping.pl 
Pinging perlmaven.com 5 times
Average round trip: 0.277459192276001
```

## Pinging multiple servers

Checking if one server is alive is good, but I currently have 5 servers and it would be nice
to ping all 5 of them to see if they are alive.  Not a big issue. We just wrap most of the above
code in a subroutine, appropriately named  `ping` and then call that subroutine for each hostname.

```perl
#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use Net::Ping;
my $p = Net::Ping->new();


my @hosts = map { "s$_.hostlocal.com" } (7, 8, 9, 11, 12);
my $n = 5;

foreach my $h (@hosts) {
    ping($h);
}

sub ping {
    my ($hostname) = @_;
    my $time = 0;
    my $success = 0;
    say "Pinging $hostname $n times";
    foreach my $c (1 .. $n) {
        my ($ret, $duration, $ip) = $p->ping($hostname);
        if ($ret) {
            $success++;
            $time += $duration;
        }
    }
    if (not $success) {
        say "All $n pings failed";
    } else {
        if ($success < $n) {
            say( ($n - $success), " lost packets. Packet loss ratio: ", int ( 100 * ($n - $success) / $n ));
        }
        say "Average round trip: ", ($time / $success);
    }
}
```

The result looks like this

```
$ time perl files/ping.pl 
Pinging s7.hostlocal.com 5 times
Average round trip: 0.332317781448364
Pinging s8.hostlocal.com 5 times
Average round trip: 0.231751680374146
Pinging s9.hostlocal.com 5 times
Average round trip: 0.175983619689941
Pinging s11.hostlocal.com 5 times
Average round trip: 0.190032911300659
Pinging s12.hostlocal.com 5 times
Average round trip: 0.0929935455322266

real    0m5.181s
user    0m0.053s
sys 0m0.017s
```

With 5 hosts it might not be bad, but there is one main issue that impacts us as the number of hosts grow.
We check the hosts sequentially. One after the other. The total elapsed time is the sum of the time spent
with each host. (At first when I saw the above results I was a bit surprised, but then I remembered the numbers
printed there are averages of 5 pings so the total time is 5 times longer for each host meaning 0.5-1.5 second per host.

How can we run these pings in parallel?

## Comments

it appears you now need to add "icmp" to have it work reliably

my $p = Net::Ping->new('icmp');

unfortunately this also seems to require root for some reason


