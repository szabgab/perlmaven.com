---
title: "Why does this code not work? (split, array slice) - Solution"
timestamp: 2018-02-27T11:30:01
tags:
  - split
  - warnings
  - strict
published: true
author: szabgab
archive: true
---


Earlier I've posted a problem asking <b>Why does this code not work</b>
using [split and array slices](/why-does-this-code-not-work).

Read that and try to solve it yourself before reading this.

Here is my solution:


Let's try the first script:

{% include file="examples/split_on_the_fly.pl" %}

```
$ perl split_on_the_fly.pl
root

```

## Always use strict and use warnings

As I've mentioned in other places, one should [always use strict](/strict)
and [always use warnings](/always-use-warnings) in Perl 5.

Adding them to this script will yield this code:

{% include file="examples/split_on_the_fly_warnings.pl" %}

And this output:

```
$ perl split_on_the_fly_warnings.pl

Argument "0,4" isn't numeric in list slice at split_on_the_fly_warnings.pl line 7.
root
Use of uninitialized value $real_name in concatenation (.) or string at split_on_the_fly_warnings.pl line 9.
```

That in itself might not help with the exact solution, but at least it points in some direction.
We can read about the [Argument ... isn't numeric in numeric ...](/argument-isnt-numeric-in-numeric) warning, the first in our output.

That and reading again the article about [split](/perl-split) and about
[array slicing](/array-slices) might lead us to the realization that instead
of a string in which we separate numbers by a comma, we need to use a list of numbers 
(which in the Perl syntax are separated by a comma) as the index in the array slice.

That's what we do in our solution. We replaced the `$indexes` scalar by
the `@indexes` array, and instead of the string `"0,4"` we
have the individual numbers `(0, 4)`.

{% include file="examples/split_on_the_fly_fixed.pl" %}

Running the script looks like this:

```
$ perl split_on_the_fly_fixed.pl
root
System Administrator
```


## Stand-alone Array slice

The second experiment, that as I assume was an attempt to simplify the code and find
a solution that way, had another issue.

I find it funny when that happens to me.
When I add some code to 'debug' the original problem and then I just add more bugs in the debugging code.
Anyway, this was the code:

{% include file="examples/array_slice_not_working.pl" %}

```
$ perl array_slice_not_working.pl
root

```

Here too we start by adding [use strict](/strict)
and [use warnings](/always-use-warnings).

{% include file="examples/array_slice_strict.pl" %}

The result is more spectacular:

```
$ perl array_slice_strict.pl

Global symbol "$num" requires explicit package name (did you forget to declare "my $num"?) at array_slice_strict.pl line 7.
Global symbol "$num" requires explicit package name (did you forget to declare "my $num"?) at array_slice_strict.pl line 8.
Execution of array_slice_strict.pl aborted due to compilation errors.
```

The error [Global symbol requires explicit package name](/global-symbol-requires-explicit-package-name) tells us that the variable `$num` has not been declared using `my`

We do that and run the script again:

{% include file="examples/array_slice_warnings.pl" %}

This time we get the warnings that are already familiar from the previous attempt:

```
$ perl array_slice_warnings.pl
Scalar value @fields[...] better written as $fields[...] at array_slice_warnings.pl line 8.
Argument "0,4" isn't numeric in array slice at array_slice_warnings.pl line 8.
root
Use of uninitialized value $real_name in concatenation (.) or string at array_slice_warnings.pl line 11.
```

Instead of passing a string of numbers we need to pass a list of indexes. We can either create an array of indexes manually: 

```perl
my @indexes = (0, 4);
```

Or, if we receive the indexes as a string, we can split that string into a list of numbers:

```perl
my $num="0,4";
my @indexes = split /,/, $num;
```


{% include file="examples/array_slice_fixed.pl" %}

Running this version will yield the expected answer:

```
$ perl array_slice_fixed.pl
root
System Administrator
```

## Conclusion

[Always use strict and use warnings in your perl code!](/always-use-strict-and-use-warnings)

