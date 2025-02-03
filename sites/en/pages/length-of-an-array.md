---
title: "Length of an array in Perl"
timestamp: 2014-11-26T08:20:56
description: "In Perl the length function is only used for strings. In order to get the length of an array use the scalar function."
tags:
  - length
  - scalar
published: true
books:
  - beginner
author: szabgab
---


In Perl the <b>length</b> function is only used for strings (scalars). In order to get the length of an array use the <b>scalar</b> function,
or put the array in SCALAR context by some other means.


See this example and note the printed results are shown in the comments:

```perl
use 5.010;

my $one_string = "hello world";
say length $one_string;    # 11

my @many_strings = ("abc", "cd", "e", "fg", "hi", "hello world");
say length @many_strings;  # 1
say scalar @many_strings;  # 6

say scalar $one_string;    # hello world
```

As you can see the `length` function worked on a scalar variable (one starting with a `$` sign) but it gave incorrect result
when it was used for an [array](/perl-arrays) (starting with a `@` sign).

On the other hand, using the `scalar` function on the array worked well and `say scalar @many_strings;` printed the number of elements
in the array.
Probably even more strangely using `scalar` on a scalar variable got us printing the content of the variable.


So what happened there? Why did `say length @many_strings;` print 1 and why did `say scalar $one_string;` print "hello world"?

## How to avoid?

Before trying to explain with my own words let's see what does Perl say?
What if we add `use strict;` and `use warnings` to the beginning of the script just as
I recommend in the [first episode](/installing-perl-and-getting-started) of the [Perl tutorial](/perl-tutorial).

Then this is the output:

```
length() used on @many_strings (did you mean "scalar(@many_strings)"?) at ... line 10.
11
1
6
hello world
```

If you also turn on [diagnostics](/use-diagnostics-or-splain) then this will be the output:

```
length() used on @many_strings (did you mean "scalar(@many_strings)"?) at ...  line 11 (#1)
    (W syntax) You used length() on either an array or a hash when you
    probably wanted a count of the items.
    
    Array size can be obtained by doing:
    
        scalar(@array);
    
    The number of items in a hash can be obtained by doing:
    
        scalar(keys %hash);
```

Please always [use warnings and use strict](/strict)!


## The explanation

Perl works differently than other languages for the good and the bad. One needs to learn how Perl thinks in order to enjoy it and to take the most out of it.
Specifically Perl has [scalar and list context](/scalar-and-list-context-in-perl).

The `length` function always works on strings and it creates `SCALAR` context for its parameters. Hence if we pass an array as a parameter,
that array will be placed in `SCALAR` context and it will return the [number of elements](/scalar-and-list-context-in-perl) in it.
In our example the array had 6 elements thus the expression `say length @many_strings;` was converted to `say length 6;` and the length
of the number 6 is the same as the length of the string "6" which is 1. That's why `say length @many_strings;` printed 1.

Try this:

```perl
#use strict;
#use warnings;
#use diagnostics;
use 5.010;

my @many_strings = ("abc", "cd", "e", "fg", "hi", "hello world", "abc", "cd", "e", "fg", "hi", "hello world");

say length @many_strings;  # 2 
say scalar @many_strings;  # 12
```

After deliberately turning off `use strict; use warnings; use diagnostics;` we created an array with 12
elements. `say length @many_strings;` printed 2 because that's the length of the number 12.


The other strange issue might be the fact that `say scalar $one_string;` printed the content of the variable
`$one_string`, but if you know that the `scalar` function only creates SCALAR context and does not
do anything else, but it already had a scalar value as a parameter so it just returned the content of that
scalar variable.

So the `scalar` function returns the length of an array because an array in scalar context returns its size.

## Conclusion

<b>Always use strict and use warnings.</b>

