---
title: "DNS Name resolving - check DNS propagation with Perl"
timestamp: 2015-06-18T14:50:01
tags:
  - Net::DNS
published: true
author: szabgab
---


When someone tries to access a host, for example [meta.perlmaven.com](https://meta.perlmaven.com/) first their computer needs
to find out the [IP address](http://en.wikipedia.org/wiki/IP_address) of that machine. This information comes
from the [authoritative name servers](https://en.wikipedia.org/wiki/Authoritative_name_server#Authoritative_name_server)
of our domain, but it is also cached by name servers on the way and even the computer of that person.


If we move have to change the IP address of our server (for example because we move to another hosting provider),
it takes some time till the all the caches expire and all the people in the world start to see the new IP address.

For some unfortunate historical reason this is referred to as "propagation" by a lot of people and by a lot of documents,
event though what really happens is that the intermediate caches need to expire.

So if we move our site to a new server that means it will have a new IP address. We change the DNS at the authoritative names server,
but here will be a period of time while some people will arrive to the old IP address and some will already arrive to the new IP address.

The question

## How can we check where do people arrive?

If we have both servers running and if we are talking about web servers, then we can look at the log files of each server to
see how many hits each one of them gets. Nevertheless it would be nice to be able to check how far the change has "propagated"?

For this we are going to use [Net::DNS](https://metacpan.org/pod/Net::DNS) to check how various name servers around the
world resolve a specific hostname.

We could check the name resolving at our own DNS server, but that's not very interesting. We can do that even by 
[pinging](/how-to-check-if-a-server-is-live-using-ping) the remote host. Much more interesting is to check this
at other DNS servers. To see how other people will experience it.

There is a list of [Public DNS Server List](http://public-dns.tk/), we pick one that is supposed to be
in Austin, USA with an IP address "207.200.7.21".

```perl
#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;

use Net::DNS ();

my $name_server = '207.200.7.21';
my $hostname = 'meta.perlmaven.com';

my $res = Net::DNS::Resolver->new;
$res->nameservers($name_server);
my $query = $res->search($hostname);

my $result;
if ($query) {
    foreach my $rr ($query->answer) {
        if ($rr->type eq "A") {
            $result = $rr->address;
            last;
         }
    }
}
if ($result) {
    say $result;
} else {
    say 'FAILED';
}
```

Net::DNS exports all kinds of convenience function, but we would like to keep our namespace clean, so when we load Net::DNS we also supply the empty list
of things to be imported. `use Net::DNS ();`

After creating the Net::DNS::Resolver object using the `new` constructor, we need to tell it which name server to use. We can do that with the
`nameservers` method. (It can accept one or more name-servers.)

The `search($hostname)` call contacts the given nameserver and tries to resolve the hostname. If the hostname has a single A record, that will be returned.
If it has a CNAME, then the CNAME will be returned which maps the hostname to another hostname, and the resolution for that other hostname is also returned recursively.
These are of course internal details interesting only to people who might deal with the DNS configuration. For the end-user, and in this case for us, the
only question is, if it could be resolved to an IP address or not.

The `search` method returns a [Net::DNS::Packet](https://metacpan.org/pod/Net::DNS::Packet) object, or `undef`, if the resolution failed.

The `answer` method of this Net::DNS::Packet object will return an object for each entry in the DNS. For every A record it will return
and [Net::DNS::RR::A](https://metacpan.org/pod/Net::DNS::RR::A) object, and for the
CNAME it will return a [Net::DNS::RR::CNAME](https://metacpan.org/pod/Net::DNS::RR::CNAME) object. The `type` method will return the type (A or CNAME).
As in this case we are only interested in the end-result we only check the A-records where we retrieve the `address`. That's the resolved IP address.

Of course some hostnames might resolve to several IP addresses which means they might have several A-records (try for example to resolve google.com), but in
our special case we assume there is only one address so we call `last` when we found the first A-record.

## Checking several DNS servers

From the [Public DNS Server list](http://public-dns.tk/) we can get a few more DNS servers, and then we can wrap the above code
in a loop to check each server separately.

```perl
#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;

use Net::DNS ();

my $hostname = 'meta.perlmaven.com';

my $res = Net::DNS::Resolver->new;
foreach my $name_server ('207.200.7.21', '91.207.40.2') {
    printf "%-20s", $name_server;
    $res->nameservers($name_server);
    my $query = $res->search($hostname);
    
    my $result;
    if ($query) {
        foreach my $rr ($query->answer) {
            if ($rr->type eq "A") {
                $result = $rr->address;
                last;
             }
        }
    }
    if ($result) {
        say $result;
    } else {
        say 'FAILED';
    }
}
```

Here we have a loop that iterates over a list of 2 name servers. Does the name resolving and prints the result.
The additional difference is that we also print the nameserver using `printf "%-20s", $name_server;` so the output
will look like this:

```
207.200.7.21        173.255.196.65
91.207.40.2         173.255.196.65
```

## Check repeatedly

The last thing we might need to do here is to check the results repeatedly. Maybe every 5 minutes during the day following the change
or till all the servers that are being check return the new address. The scheduling could be done using
[cron](/how-to-run-a-perl-script-automatciall-every) on a Unix-like system, but that will make it hard to stop when the time
is up or when the change has "propagated".

We might want to add some notification, for example sending a status report in e-mail every hour and a final report just as we stop
running the job.

## Comments

Can I get the list of hosts for a specified domain with this package or any other alternative way in perl ?


