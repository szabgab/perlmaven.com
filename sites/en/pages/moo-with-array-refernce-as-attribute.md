---
title: "Moo with array reference as attributes - with or without default values"
timestamp: 2020-07-31T07:13:10
tags:
  - Moo
  - default
  - ARRAY
published: true
books:
  - moo
author: szabgab
---


TL;DR use: `default => sub { [] }`

Moo can also have attributes where the value is an ARRAY reference and you might want to ensure that
even if the user has not supplied an ARRAY reference at the construction time, the attribute still has
an empty array. So you write this code:


```perl
has children => (is => 'rw', default => []);
```

When you try to create a new Person object in the programming.pl script:

```perl
use Person;

my $joe = Person->new;
say $joe->children;

my $pete = Person->new;
say $pete->children;
```

We get the following exception:

```
Invalid default 'ARRAY(0xcbf708)' for Person->children not a coderef
   or a non-ref or code-convertible object at .../Method/Generate/Accessor.pm line 588.
Compilation failed in require at programming.pl line 5.
BEGIN failed--compilation aborted at programming.pl line 5.
```

This is the same problem as we faced with `time()`, but here Moo can already recognize
the problem and stop us before hurting ourselves.

The fix is similar, wrap the default creation in an anonymous subroutine:

```perl
has children => (is => 'rw', default => sub { [] });
```

And the output looks like this:

```
ARRAY(0x27b26b0)
ARRAY(0x27b26f8)
DONE
```

Two different ARRAY references.

