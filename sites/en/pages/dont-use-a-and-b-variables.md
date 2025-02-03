---
title: "Don't use $a and $b outside of sort, not even for examples"
timestamp: 2015-07-07T12:30:01
tags:
  - $a
  - $b
published: true
books:
  - beginner
author: szabgab
archive: true
---


`$a` and `$b` are special variables used in
[various forms](/search/$a) of [sort](/sorting-arrays-in-perl), in the `reduce` function
provided by [List::Util](https://metacpan.org/pod/List::Util) and maybe in a few other places.

Because of that they are two variables that can be used without declaration even when [use strict](https://perlmaven.com/strict)
is in effect.


While it might be cool that you use variables without declaration, but if that's what you want then just go without `use strict;`
and then don't be surprised that few people will be ready to help you fixing your code.

So assuming you want the effect of `use strict` that requires you to declare every variable before use, then you might notice
it won't require the declaration of `$a` or `$b`.

In other words, this code will work:

```perl
use strict;
use warnings;

$a = 23;
$b = 19;
print $a+$b, "\n";   # 42
```

The problem is not really in the use of these variable outside of `sort` and the other special cases.
They won't be even changed by a call to `sort` as they are going to be localized for the duration of `sort` as you can see here:

```perl
use strict;
use warnings;

$a = 23;
$b = 19;

print $a+$b, "\n";    # 42

my @numbers = sort {$a <=> $b } 1, 3, 2;
print "@numbers\n";  # 1 2 3 
print $a+$b, "\n";   # 42
```


It's just the confusion they might cause to someone who is not familiar with their special behavior,
and the bad example we provide to others.

Therefore a long time ago I've decided that I won't use `$a` or `$b` even in short snippets or sample code.
If I want to use short and meaningless variables names, there are plenty of other letters in the abc.

BTW Not using `$a` and `$b` is one of the suggestions if you'd like to
[improve your code](/how-to-improve-my-perl-program).


