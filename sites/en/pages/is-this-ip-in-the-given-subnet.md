---
title: "Is this IP in the given subnet?"
timestamp: 2016-08-03T11:30:01
tags:
  - Net::Subnet
  - IP
  - CIDR
types:
  - screencast
published: true
author: szabgab
---


In various situation, it is important to check if a given IP address is within a predefined subnet.
For example if we would like to allow access from only a specific range of IP addresses we would create
a "white list" of those addresses.

Similarly if we would like to deny access based on a set of rules regarding the IP address of the visitor.


{% youtube id="M7Ki3r8g5-o" file="is-this-ip-in-the-given-subnet" %}

## Fixed list of IP add resses

To create a "white-list" we could simply list all the IP addresses that we allow and then look up if the
given IP address is in this list. For example:

```perl
use 5.010;

my $ip = '1.2.3.4';

my @white_list = ('1.2.3.4', '3.71.5.42', '21.22.23.24');
if (grep { $ip eq $_ } @white_list) {
    say 'Allow access';
} else {
    say 'Deny access';
}
```

Of course if the `@white_list` has a lot of elements, every look-up will be time consuming.

We could improve it using the `any` function of [List::MoreUtils](https://metacpan.org/pod/List::MoreUtils)
which similar to the `all` function, [short-circuits](/does-all-really-short-circuit).

```perl
use 5.010;
use List::MoreUtils qw(any);

my $ip = '1.2.3.4';

my @white_list = ('1.2.3.4', '3.71.5.42', '21.22.23.24');
if (any { $ip eq $_ } @white_list) {
    say 'Allow access';
} else {
    say 'Deny access';
}
```

Alternatively, and gaining even more peformance boost, we could build a look-up hash:

```perl
use 5.010;

my %white_list = map { $_ => 1 } ('1.2.3.4', '3.71.5.42', '21.22.23.24');
if ($white_list{$ip}) {
    say 'Allow access';
} else {
    say 'Deny access';
}
```

That's possible, but if we would like to allow (or disallow) all the IP addresses in a given class-A subnet, listing all of them will use-up quite some memory.


## Using  Net::Subnet

The [Net::Subnet](https://metacpan.org/pod/Net::Subnet) module solves this problem. It exports several function,
but this time we'll look only at the `subnet_matcher` function.
It received a list of <b>IP/mask</b> pairs and returns an anonymous function. We can assign this anonymous function
to a scalar variable (`$white_list` in our example) and then use this function reference to check if a
given IP address is in the defined ranges. The <b>mask</b> part of these expressions can be either what is called
the <b>subnet mask notation</b> that looks like an IP address (for example `1.2.3.0/255.255.255.0`) or
it can be a number indicating the number of significant bits. (also called <b>CIDR notation</b>)
(for example `1.2.3.0/24`).


In the first example we just give a list of IP addreses. Each one using the `255.255.255.255` mask,
meaning we are looking for eact match of the IP address.

```perl
use strict;
use warnings;
use 5.010;

use Net::Subnet qw(subnet_matcher);

my $white_list = subnet_matcher qw(
    1.2.3.4/255.255.255.255
    3.71.5.42/255.255.255.255
    21.22.23.24/255.255.255.255
);

say $white_list->('1.2.3.4') ? 'yes' : 'no';       # yes
say $white_list->('1.2.3.5') ? 'yes' : 'no';       # no
say $white_list->('3.71.5.42') ? 'yes' : 'no';     # yes
```

## Matching subnets

The more interesting case is when we would like to defined a whole subnet. For example all the IP addresses
where the first 3 numbers are `1.2.3` ( 1.2.3.0, 1.2.3.1, 1.2.3.2, ..., 1.2.3.255)

We can denote this as `1.2.3.4/255.255.255.0` or as `1.2.3.4/24` and will get the following result:

```perl
use strict;
use warnings;
use 5.010;

use Net::Subnet qw(subnet_matcher);
 
my $white_list = subnet_matcher qw(
    1.2.3.4/255.255.255.0
    3.71.5.42/255.255.255.255
);

say $white_list->('1.2.3.4') ? 'yes' : 'no';    # yes
say $white_list->('1.2.3.5') ? 'yes' : 'no';    # yes
say $white_list->('1.2.33.5') ? 'yes' : 'no';   # no
say $white_list->('3.71.5.42') ? 'yes' : 'no';  # yes
```

And just to check the more border cases:

```perl
say $white_list->('1.2.3.0') ? 'yes' : 'no';    # yes
say $white_list->('1.2.3.1') ? 'yes' : 'no';    # yes
say $white_list->('1.2.3.255') ? 'yes' : 'no';  # yes
```

## Invalid IP

If the given IP is invalid, the function will just return
[false](/boolean-values-in-perl) without raising an exception or even giving a warnings:

```perl
say $white_list->('1.2.3.256') ? 'yes' : 'no';  # no
say $white_list->('1.2.3.-1') ? 'yes' : 'no';   # no
say $white_list->('1.2.3.x') ? 'yes' : 'no';    # no
```


## Invalid mask

On the other hand if the given mask is invalid, the function just returned [true](/boolean-values-in-perl).

```perl
my $white_list = subnet_matcher qw(
    1.2.3.4/255.255.256.0
    3.71.5.42/255.255.255.255
);
say $white_list->('1.2.33.5') ? 'yes' : 'no'; # yes
```

Even if the mask contains something that is not even a number:

```perl
my $white_list = subnet_matcher qw(
    1.2.3.4/255.255.x.0
    3.71.5.42/255.255.255.255
);
say $white_list->('1.2.33.5') ? 'yes' : 'no';
```

On this subject the author of the module wrote "garbage in, garbage out".
So be careful with your input.


## IPv6

The [Net::Subnet](https://metacpan.org/pod/Net::Subnet) module also supports IPv6, but currently I only needed
to handle IPv4 addresses.

