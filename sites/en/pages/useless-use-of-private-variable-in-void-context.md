---
title: "Useless use of private variable in void context"
timestamp: 2018-06-23T08:30:01
tags:
  - warnings
  - B::Deparse
published: true
author: szabgab
archive: true
---


This is another version of the [Useless use of hash element in void context](/useless-use-of-hash-element-in-void-context)
warning that you might get if you follow my suggestion and turn on [warnings in Perl](/always-use-warnings).


This example:

{% include file="examples/set_default.pl" %}

was taken from the article where you can see how adding [use warnings](/always-use-warnings) to some
code can uncover bugs. For example if we run the above code we see no output at all, but if we enable `use warnings`
or run the code using the `-w` flag of Perl then we get the following:

```
perl -w examples/set_default.pl
Useless use of private variable in void context at ...
```

As with the [other example](/useless-use-of-hash-element-in-void-context), here too
we can use [B::Deparse](https://metacpan.org/pod/B::Deparse) to uncover the truth:

```
perl -MO=Deparse,-p examples/set_default.pl

use strict;
(my $default_code = 42);
((my $code = get_code()) or $default_code);
sub get_code {

}
```

The precedence of `=` is higher than that of `or` and so the `or $default_code`
has no impact on anything.

## This or That

An even simpler case of the problem can be seen here:

{% include file="examples/this_or_that.pl" %}

## Solution

The solution is to use `||` or `//` instead of `or`
and to [always use warnings](/always-use-warnings)!


## Comments

I'm surprised by this, I would expect $x or $y to return 1 or 0 regardless. And I can't imagine using it in an assignment. It's just not very readable.

## 

Another cause for this warning took me a while to track down ...
As $n was already defined, I started a for loop like this:

for( $n; $n <= $endDateVal; $n += $secsInt ) {


This resulted in the warning, which could be cleared by either of the following:

for( ; $n <= $endDateVal; $n += $secsInt ) {


or

for( $n = $n; $n <= $endDateVal; $n += $secsInt ) {

and thanks for your articles.

## 
Thanks for the great info, but I too triggered this warning using a technique not described above. I declared a sub called 'write' and the warning pointed at the line where I called it. Renaming my sub from 'write' to 'writestuff' resolved it. Yay.

## 
Even weirder case of this:

use strict;
use warnings;

my $i = 0;
for ($i = 0; $i => 4; $i++) {
print $i;
}

Problem is caused by the '=>' that should be a '>='. However the warning is indicated at the end of the loop to confuse matters.
