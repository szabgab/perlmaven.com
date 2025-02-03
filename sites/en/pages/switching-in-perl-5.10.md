---
title: "Switching in Perl 5.10"
timestamp: 2013-11-06T23:30:01
tags:
  - v5.10
  - switch
  - case
  - given
  - when
published: true
author: szabgab
---


TL;DR

There is <b>no case/switch statement on Perl</b>. Use if/elsif/elsif/...

One of the complaints about Perl was always that it lacks a real
case or switch statement. While you could always fake one, people
were not satisfied. Even though Python does not have one either...

In any case, in Perl version 5.10 the `given` statement was
added and then in version 5.18 is was marked as experimental
and started to emit warnings.

The article below was added mostly to replace an older version of
the same article and to include the recommendation:

<b>Please, don't use the `given` statement until the experimental
flag is removed.</b>


So in accordance with the Perl 6 design perl will NOT have a case
or switch. It will have a <b>given</b> keyword. It will also behave
differently than the usual case. It will do The Right Thing (tm).

The syntax is quite simple:

```perl
use 5.010;

given($value) {
    when(3) { say "Three"; }
    when(7) { say "Seven"; }
    when(9) { say "Nine"; }
    default { say "None of the expected values"; }
}
```

We are taking the value in $value and comparing it to the 
values within the when() statements. When we find one that 
matches, the block after the when() is executed AND the
given statement is terminated. That is, no more when()
is checked.

If non of the when() cases fit then the (optional)
default {} block is executed.

Let's see another example:

```perl
use 5.010;

given($value) {
    when(/^\d+$/)            { say "digits only"; }
    when(/^\w+$/)            { say "Word characters"; }
    when(/^[a-zA-Z0-9.-]+$/) { say "Domain namish"; }
    default { say "None of the expected"; }
}
```

It is very similar but now we have regular expressions instead
of fixed values in the when() statement. Each regex on its 
turned is tried against the value. When one of them matches
its block is executed and the given() statement is terminated.


Yes, what you are suspecting is right. The when() statements 
are actually applying ~~, the smart match operator.

I have already written about it earlier in
[Smart Matching in Perl 5.10](/smart-matching-in-perl-5.10).
So you can use any kind of value in the when() statement.
A number will check numeric equality using ==, a string will use
eq, a regex will try to match the <b>given value</b> and if you
supply a subroutine reference then Perl will call that subroutine
using the <b>given value</b> as a parameter and check the true-ness
of the return value.

See this example:

```perl
use 5.010;

given($value) {
    when(10) {
        say "Number 10";
    }
    when([11, 23, 48]) {
        say "In the list";
    }
    when(/^\d+$/) {
        say "digits only";
    }
    when(\&is_number) {
        say "Is number";
    }
    default {
        say "None of the above";
    }
}

sub is_number {
    return $_[0] =~ /\d/ and $_[0] =~ /^[+-]?\d*\.\d*$/;
}
```

There are few more minor issues:

Perl will automatically <b>break</b> out from the `given()`
statement after the execution of block. If you would like to
force checking the additional `when()` statements use the
`continue` keyword.

On the other hand if you would like to break out from a `given()`
statement before reaching the end of the `when()` block, you can use the
`break` statement yourself.

The `given()` actually assigns the `$value` to `$_` so you can use that 
as well to write when clauses such as this:

```perl
when($_ < 18) { say "Less than 18"; }
```

`when()` can be used outside the `given()` block as well.

For further details see the documentation of the
[Switch statements](http://perldoc.perl.org/perlsyn.html#Switch-statements).

