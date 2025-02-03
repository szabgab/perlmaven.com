---
title: "What is my IP address, how to determine the IP address of your computer using Perl"
timestamp: 2015-06-09T05:30:01
tags:
  - Net::Address::IP::Local
  - IPv4
  - IPv6
published: true
author: szabgab
---


Sometimes, when dealing with other network devices I need to find out what is the IP address of my computer.

Actually this question isn't exact, but this is how we usually talk. A computer does not have an IP address.
A network interface has IP address. A computer can have multiple network interfaces, though in the majority
of cases of private computers there is only one working network interface at a time.


Most mobile computers can be connected to the Internet both using a wire via an Ethernet cable or using wifi.
Most of the time you'll have only one of those working.
In case both of them are on, even a mobile computer can have multiple active network devices.

It is much more common for servers to have multiple devices. For example both [Digital Ocean](/digitalocean)
and [Linode](/linode) (two VPS provides I use and recommend) offer additional private IP address for the machines.
These can be very useful when you have more than one machine and you'd like to have them communicate. The private network between
them is probably more secure than the public network and in some of the cases traffic on the private network might not be taken in account
when determining the total network usage of your machines. (Check the details with your provider.)

Routers by definition have multiple network devices. For example at home you might be connected to the Internet
via some broadband (it is funny we still call it that way) provider. There is probably a modem involved, and the modem
is probably connected to a home-router that provides both wired connections and wifi.

But we are not talking about routers now.

## IPv4 vs IPv6

Before we look at the code one more thing. There are two set of network addresses in use. IPv4, the older system and IPv6 the newer one.
Some computers can handle only IPv4, and home networks usually use IPv4 only, but servers can usually handle both.
In that case the same network card will have two addresses. One IPv4 and one IPv6 address. If you want to connect to another
machine, that also supports both then, either of the addresses can be used. Assuming the network between the two also supports both
address spaces.

You can imagine it as if you were in the border area between Germany and France where places have names both in German and in French.

## So how can we determine the IP addresses of these network devices?

And maybe more importantly: How can we know which network device will be used when we would like to reach a certain other machine?

## Net::Address::IP::Local - how to reach specific host?

[Net::Address::IP::Local](https://metacpan.org/pod/Net::Address::IP::Local) provides this information.

The `connected_to` method will try to connect to port 53 (DNS) of the remote server given to it.
If successful, it will return the IP address of the network card that was used for the connection.
If for whatever reason it cannot connect to the remote machine, then it will throw an exception.
Hence we had to wrap the call in an `eval` block.

The method will first check if your computer supports IPv6 and try to connect that way.
If the computer does not support IPv6 the system will try IPv4.

So if your computer supports IPv6 but the remote only support IPv4 then I think this might fail.
There are not separate methods to enforce connecting via IPv4 or IPv6 only.

In addition the code used the default 30sec timeout when trying to connect and I don't see a way
to change that.

```perl
use strict;
use warnings;
use 5.010;

use Net::Address::IP::Local;

my $address = eval { Net::Address::IP::Local->connected_to('perlmaven.com') };
if ($@) {
    say "Could not determine IP address leading to perlmaven.com";
} else {
    say $address;
}
```

## Net::Address::IP::Local - what is my IP address

The module can be also used to just determine the IP address of "the" networking device.
In reality it uses the `connected_to` method with a pre-determined address.

The `public` method will first try to use and IPv6 address. If that fails, it will try to use an IPv4 address.
If that fails too, it will throw an exception.

The `public_ipv4` method will specifically use an IPv4 address and the `public_ipv6` method will 
use a pre-determined IPv6 address.

In all 3 cases we have to make sure we capture the exception thrown if the method failed.

```perl
use strict;
use warnings;
use 5.010;

use Net::Address::IP::Local;

my $address      = eval {Net::Address::IP::Local->public};
if ($@) {
    say "Could not determine IP address";
} else {
    say $address;
}

my $address_ipv4 = eval {Net::Address::IP::Local->public_ipv4};
if ($@) {
    say 'Failed via IPv4';
} else {
    say $address_ipv4;
}


my $address_ipv6 = eval { Net::Address::IP::Local->public_ipv6};
if ($@) {
    say 'Failed via IPv6';
} else {
    say $address_ipv6;
}
```

## P.S.

There is an article on [StackOverflow](http://stackoverflow.com/questions/330458/how-can-i-determine-the-local-machines-ip-addresses-from-perl)
with some more discussion about the topic.


</a>

