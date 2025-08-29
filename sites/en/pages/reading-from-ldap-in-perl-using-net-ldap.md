---
title: "Reading from LDAP in Perl using Net::LDAP"
timestamp: 2013-12-03T09:30:01
tags:
  - Net::LDAP
published: true
author: szabgab
---


LDAP stands for [Lightweight Directory Access Protocol](http://en.wikipedia.org/wiki/Lightweight_Directory_Access_Protocol). It is usually used to fetch (and sometimes update) data in a directory of people. For example the employees and students of a University.

For example, [Active Directory](http://en.wikipedia.org/wiki/Active_Directory), which is used in Microsoft Windows based networks to hold the accounts of all he users, provides a way to access it via LDAP.

Using Net::LDAP can provide a way to interact with this database. For example you might build an in-house web application and instead of managing your own user database, you could let the users authenticate
using their username/password in the Windows network.



There are several [publicly accessible LDAP servers](http://www.keutel.de/directory/public_ldap_servers.html) you can use to check your code. We are going to use the one published by
The [University of Michigan](https://www.umich.edu/).


## Fetching Data from an LDAP server


```perl
#!/usr/bin/env perl
use strict;
use warnings;

use Net::LDAP;
my $server = "ldap.itd.umich.edu";
my $ldap = Net::LDAP->new( $server ) or die $@;
$ldap->bind;

my $result = $ldap->search(
    base   => "",
    filter => "(&(cn=Jame*) (sn=Woodw*))",
);

die $result->error if $result->code;

printf "COUNT: %s\n", $result->count;

foreach my $entry ($result->entries) {
    $entry->dump;
}
print "===============================================\n";

foreach my $entry ($result->entries) {
    printf "%s <%s>\n",
        $entry->get_value("displayName"),
        ($entry->get_value("mail") || '');
}

$ldap->unbind;
```

Running the above code will print:
```
COUNT: 2
------------------------------------------------------------------------
dn:uid=jrwood,ou=People,dc=umich,dc=edu

      objectClass: umichPerson
                   top
                   person
                   inetOrgPerson
                   posixAccount
              uid: jrwood
               sn: Woodworth
               cn: James R Woodworth
                   James Woodworth
        uidNumber: 75786
        gidNumber: 10
    homeDirectory: /users/jrwood
RealtimeBlockList: TRUE
               ou: Alumni
      displayName: James R Woodworth
          krbName: jrwood@umich.edu
------------------------------------------------------------------------
dn:uid=jwoodnh,ou=People,dc=umich,dc=edu

          krbName: jwoodnh@umich.edu
        uidNumber: 99417910
       loginShell: /bin/csh
               sn: Woodward
               ou: Alumni
             mail: jwoodnh@umich.edu
    homeDirectory: /users/jwoodnh
RealtimeBlockList: TRUE
      displayName: James Alan Woodward
              uid: jwoodnh
        gidNumber: 10
               cn: James Alan Woodward
                   James A Woodward
                   James Woodward
      objectClass: umichPerson
                   inetOrgPerson
                   organizationalPerson
                   person
                   top
                   posixAccount
===============================================
James R Woodworth <>
James Alan Woodward <jwoodnh@umich.edu>
```

First thing is to create a [Net::LDAP](https://metacpan.org/pod/Net::LDAP) object providing the name of the LDAP server. Then we call `bind`. That is where we connect to the LDAP server.
In this example we used an **anonymous** connection. This usually only allows read access.

The `search` method returns a [Net::LDAP::Search](https://metacpan.org/pod/Net::LDAP::Search) object. (This is what gets assigned to the `$result` variable.

The `code` method of the Net::LDAP::Search object returns 
[Net::LDAP::Constant](https://metacpan.org/pod/Net::LDAP::Constant) which is 0 on success.
(Like the exit code of a Unix shell command.) So the Perl code to check for failure is
 
```perl
if ($result->code) {
    die $result->error;
}
```

Or if you prefer:

```perl
die $result->error if $result->code;
```

The example in the documentation uses the shell-style:

```perl
$result->code && die $result->error;
```

that I personally don't find very readable.

If the search was successful the `count` method will return the number of hits.

The `entries` method returns all the hits. Each one is a
[Net::LDAP::Entry](https://metacpan.org/pod/Net::LDAP::Entry) object.

In the first `foreach` loop we just `dump` the results for each entry. This is mostly
useful for debugging purposes, or when we try to explore what kind of fields does the server provide.

In the second `foreach` loop we used the `get_value` method to fetch specific fields
from the entry.

At the end of our interaction we `unbind` (disconnect) from the LDAP server.

## Admin limit exceeded

If we widen our search, for example by searching for `sn=W*` instead of `sn=Woodw*`:

```perl
my $result = $ldap->search(
    base   => "",
    filter => "(&(cn=Jame*) (sn=W*))",
);

die $result->error if $result->code;
```

We will get an `Admin limit exceeded` error code.

## Bad filter

If we don't provide a `filter`, or if it is formatted incorrectly, we get a
`Bad filter` error code.

