---
title: "Reverse an array, a string or a number"
timestamp: 2014-04-11T17:10:01
tags:
  - reverse
published: true
books:
  - beginner
author: szabgab
---


Given an array of values `my @words = qw(Foo Bar Moo);`, how can we reverse the order of the values
to get `Moo Bar Foo`?

Given a string `my $str = 'stressed';`, how can I get the characters in reverse order to get `'desserts'`?

Given a number: `3.14`, how can I reverse it to get `41.3`?


As Perl does not care much if the content of a scalar variable is a string or a number, reversing a string or
a number is the same. So we only have two cases: reversing a scalar and reversing an array.

The function `reverse` can be used in both cases:

## Reverse array

{% include file="examples/reverse_array.pl" %}

And the output is:

```
Foo Bar Moo
Moo Bar Foo
```

## Reverse a scalar: string or number

{% include file="examples/reverse_scalar.pl" %}

And the output is:

```
stressed
desserts
3.14
41.3
```

So the same function can be used for two similar things. This is nice, but it also has some pitfalls.

## The pitfalls

The two behaviors of `reverse` are not decided by its parameter, but by the construct that is on the left hand side.

If you try to reverse an array but put the assignment in [SCALAR context](/scalar-and-list-context-in-perl),
the result might surprise you:

```perl
my $str = reverse @words;
say $str; 
```

```
ooMraBooF
```

The same if you try to reverse a string, but put the assignment in [LIST context](/scalar-and-list-context-in-perl):

```perl
my $str = 'stressed';
my @words = reverse $str;
say $words[0];
```

```
stressed
```

Of course, it is not very likely that you'll write code like in the latest example, but what about these examples:

```perl
my $str = 'stressed';
say reverse $str;
```

```
stressed
```

Looks strange. As if `reverse` had no impact.

What about this one?

```perl
my @words = qw(Foo Bar Moo);
say reverse join '', @words;
```

It prints

```
FooBarMoo
```

That might be surprising. Did the reverse not work there, or were the words already reversed?
What if we do the same, but without the call to `reverse`:

```perl
my @words = qw(Foo Bar Moo);
say join '', @words;
```

```
FooBarMoo
```

That would be baffling. As if `reverse` has not impact.
Indeed, if you try to reverse a string (the result of [join](/join) in this case), but put
the call in `LIST context` created by the `say` function, then it tries to reverse the
list given to it string-by-string. Like in this case:

```perl
my $str = 'stressed';
my ($rev) = reverse ($str);
say $rev;
```

Which prints

```
stressed
```

In order to fix the above issues, we need to make sure `reverse` is called in 
SCALAR context which can be achieved using the `scalar` function:

```perl
my $str = 'stressed';
say scalar reverse $str;

my @words = qw(Foo Bar Moo);
say scalar reverse join '', @words;
```

resulting in

```
desserts
ooMraBooF
```

(Thanks to [Jonathan Cast](http://www.linkedin.com/in/jonathancast) reminding me to add these examples.)

## Semordnilap

BTW words like "stressed" and "desserts" are called 
[Semordnilap](http://en.wikipedia.org/wiki/Palindrome#Semordnilap). They are a
a strange form of [Palindrome](http://en.wikipedia.org/wiki/Palindrome) where the
reversed version of a word has a different, but valid meaning.

## Conclusion

Remember, the behavior of `reverse` depends on its <b>context</b>.
On what is on its left-hand side.

