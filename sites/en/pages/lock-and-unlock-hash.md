---
title: "Lock and unlock hash using Hash::Util"
timestamp: 2026-01-28T18:00:02
published: true
description: "lock_hash and unlock_hash to avoid accidental changes"
archive: true
show_related: true
---


If you don't like the [autovivification](/autovivification) or simply would like to make sure the code does not accidentally alter a
hash the [Hash::Util](https://metacpan.org/pod/Hash::Util) module is for you.

You can `lock_hash` and later you can `unlock_hash` if you'd like to make some changes to it.

In this example you can 3 differen actions, each one would raise an exception if someone tries
to call them on a locked hash. After we unlock the hash we can execute thos actions again.

{% include file="examples/locking_hash.pl" %}

```perl
$VAR1 = {
          'lname' => 'Bar',
          'fname' => 'Foo'
        };
Foo Bar
fname exists 1
language exists
$VAR1 = {
          'language' => 'Perl',
          'fname' => 'Peti'
        };
```

