---
title: "Moo with hash reference as attributes - with or without default values"
timestamp: 2020-07-31T08:13:10
tags:
  - Moo
  - default
  - HASH
published: true
books:
  - moo
author: szabgab
---


TL;DR use: `default => sub { {} }`

Moo can also have attributes where the value is a HASH reference and you might want to ensure that
even if the user has not supplied an HASH reference at the construction time, the attribute still has
an empty hash. So you write this code:


```perl
has children => (is => 'rw', default => {});
```

When you try to create a new Person object in the programming.pl script:

{% include file="examples/moo_with_hash_bad.pl" %}

We get the following exception:

```
Invalid default 'HASH(0x56377da51780)' for Person->children is not a coderef
  or code-convertible object or a non-ref at ...
```

The fix is to wrap the default creation in an anonymous subroutine:

```perl
has children => (is => 'rw', default => sub { {} });
```

{% include file="examples/moo_with_hash_good.pl" %}

And the output looks like this:

```
HASH(0x55bfd7e64e88)
HASH(0x55bfd7e65230)
```

Two different HASH references.


