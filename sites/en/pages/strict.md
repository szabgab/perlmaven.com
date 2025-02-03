---
title: "Always use strict!"
timestamp: 2013-07-29T23:30:01
tags:
  - strict
published: true
books:
  - beginner
author: szabgab
---


Why should I always <b>use strict</b>?

It is simple. It can save you a lot of time and headache.


`use strict;` is basically a compiler flag that tells the Perl compiler to change its behaviour in 3 important ways.

You can turn on and off the three areas separately, but if you just write `use strict;` at the top of each perl file
(both scripts and modules), then you turn on all 3 of them.

## The 3 parts of use strict

`use strict 'vars';` generates a compile-time error if you access a
[variable without declaration](/variable-declaration-in-perl).

`use strict 'refs';` generates a runtime error if you use
[symbolic references](/symbolic-reference-in-perl).

`use strict 'subs';` compile-time error if you try to use a
[bareword identifier](/barewords-in-perl) in an improper way.


## Turning off strict

While in general it is a good thing to have `strict` in effect in all the code,
there are cases when we would like to use the extra magic power we can have without 
`strict`. For such cases we would like to be able to turn it off.

Once you turned on with `use strict;`, you can selectively turn off some,
or all of the 3 parts in a lexical scope. That is, you can turn off parts of the
strictness within a pair of curly braces `{}`.

```perl
use strict;

if (...) {
   no strict 'refs';
   # do you trick here...
}
```

For examples, see the three articles above.

## hidden strict

There are a number of modules that if you `use` them in a file, it will 
automatically and implicitly turn `use strict` on in that specific file.

Among the modules are [Moose](/moose),
[Moo](/moo), [Dancer](https://metacpan.org/pod/Dancer),
and [Mojolicious](/mojolicious), but there are more.

There is a <a href="https://github.com/szabgab/Test-Strict/blob/master/lib/Test/Strict.pm#L242">
list of such modules</a> in the source of [Test::Strict](https://metacpan.org/pod/Test::Strict).
If you find more such modules, please open a ticket for Test::Strict, or send a pull-request with the fix.

## Perl 5.12 and newer

If a file requires perl 5.12 or later (eg. by having `use 5.012;` or `use 5.12.0;` in the code),
this too implicitly load `use strict;`.

So when you read code, or when you copy examples, please make sure you notice the implicit use of strict.


