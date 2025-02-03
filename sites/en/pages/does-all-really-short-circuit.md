---
title: "Does the 'all' function of List::MoreUtils really short-circuit?"
timestamp: 2014-11-19T07:30:01
tags:
  - List::MoreUtils
  - all
published: true
author: szabgab
---


The other day, someone on a mailing list asked [how to check several regexes on many strings](/check-several-regexes-on-many-strings).
In that article I recommended the use of the `all` function of [List::MoreUtils](https://metacpan.org/pod/List::MoreUtils)
as a more compact way to write that code, but the question remained: Does it short-circuit?

Will that check all the values even if after checking two it already knows the answer?


We could of course read the source code of that module, but I found it more interesting to write a script that will allow us
to see it in action.

The following script has two arrays, in `@yes` every value is [true](/boolean-values-in-perl),
in `@not` they are all true, except one of them: the number 0 is [false](/boolean-values-in-perl).

At first we check two solutions, one of the is using [grep](/filtering-values-with-perl-grep) to return
the list of values that are true: `grep { $_ } @array`. Then we compare that with the original array
using `==`. This puts them in [scalar context](/scalar-and-list-context-in-perl) which means we
are actually comparing the number of elements in the original array and the number of element `grep` returned.
`@array == grep { $_ } @array`. We could have been more explicit with the scalar context writing:
`(scalar @array == scalar grep { $_ } @array`

We print the result of the comparison.

In the second solution we just use the `all` function imported from [List::MoreUtils](http://metacpan.org/pod/List::MoreUtils):
`all { $_ } @array`

```perl
use strict;
use warnings;
use 5.010;

use List::MoreUtils qw(all);

my @yes = (1, 2, 3, 4, 5);
my @not = (6, 7, 0, 8, 9);

say 'yes: ', (@yes == grep { $_ } @yes);   # yes: 1
say 'no:  ', (@not == grep { $_ } @not);   # no:

say 'all yes: ', all { $_ } @yes;          # all yes: 1
say 'all no:  ', all { $_ } @not;          # all no:
```

Next to each line I added the result. As you can see, they yes-lines printed 1 (the true value)
and the no-lines printed only the text. They returned false.

Now let's add a print-statement (or rather a say-statement) to both solutions.
We now have `{ say; $_ }` in each expression.
That is, in each block we have two statement. The first is `say` without any parameter.
It will default to print the content of `$_`. The second statement is `$_` itself
that needs to be examined by `grep` and `all`.

This way, as `grep` and `all` iterate over the elements in the `@yes` and `@not` arrays,
we will also see them printed. (I also added a separation line to make it easier to see what was printed from the "grep"
and what from the "all".

```perl
use strict;
use warnings;
use 5.010;
use List::MoreUtils qw(all);

my @yes = (1, 2, 3, 4, 5);
my @not = (6, 7, 0, 8, 9);

say 'yes: ', (scalar @yes == scalar grep { say; $_ } @yes);
say 'no:  ', (scalar @not == scalar grep { say; $_ } @not);
say '----';

say 'all yes: ', all { say; $_ } @yes;
say 'all no:  ', all { say; $_ } @not;
```

The output:

```
1
2
3
4
5
yes: 1
6
7
0
8
9
no:
----
1
2
3
4
5
all yes: 1
6
7
0
all no:
```

Before the separation line all the numbers were printed. 1-5 from `@yes` and 6,7,0,8,9 from `@not`.
Below the separation line all the number were printed from `@yes`, but in the `@not` array the printing
has stopped after the first false value was found.

## Conclusion

The `all` function imported from List::MoreUtils will only check the cases as long as they return true.
If any of them returns false `all` will already know that it needs to return `false` and returns it immediately.
This is especially important when there are lots of elements in the array to be checked and/or when each comparison is
expensive.


