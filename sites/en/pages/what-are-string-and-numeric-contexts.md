---
title: "What are string and numeric contexts?"
timestamp: 2014-01-23T19:30:01
tags:
  - context
published: true
author: ovid
---


We've already talked about <a href="/scalar-and-list-context-in-perl">scalar
and list context</a>, but what are numeric and string context?


## Understanding "pseudo" contexts in Perl

What do you think the following lines of code print?

```perl
use strict;
use warnings;
use 5.010;

my @first  = ( 'foo', 'bar', 'baz' );
my @second = ( 'this', 'that' );
say @first + @second;
say @first . @second;
```

That prints `5` on one line and `32` on the second! What the
heck is going on?

If you were to spend your day reading <a
href="http://perldoc.perl.org/perlglossary.html#S">perldoc perlglossary</a>
(and who wouldn't?), you would notice this entry for `scalar context`:

<blockquote>The situation in which an expression is expected by its
surroundings (the code calling it) to return a single value rather than a list
of values. See also context and list context. A scalar context sometimes
imposes additional constraints on the return value—see string context and
numeric context.</blockquote>

In other words, after scalar context is applied to a variable, Perl then
decides whether it should be treated as a string or a number. This is part of
the reason why Perl uses the dot (`.`) instead of the plus (`+`)
for concatenation: if it used the plus sign for both concatenation and
addition, how would it know whether or not to treat the scalars as numbers or
strings? `3 + 3` could evaluate to `6` or `33`

Let's look at our example again:

```perl
my @first  = ( 'foo', 'bar', 'baz' );
my @second = ( 'this', 'that' );

say @first + @second; 
say @first . @second; 
```

The first `say` uses a plus and the second uses the dot operator. In
`perldoc perlop`, under the second <a
href="http://perldoc.perl.org/perlop.html#Additive-Operators">Additive
Operators</a>, it says "binary + returns the sum of two numbers" and "binary .
concatenates two strings". Since we have to evaluate something in scalar
context before we treat it as a string or number, the `@first` array,
having three elements, evaluates to `3` and the `@second` array,
having two elements, evaluates as `2`. The plus operator adds them,
giving us `5` for the first `say`, and the dot operator
concatenates them, giving us `32` for the second `say`.

<hr>
<blockquote>
Curtis "Ovid" Poe offers Perl training and consulting services via [All Around The World](http://www.allaroundtheworld.fr/),
a consultancy based in France. Though having programmed in many languages, he's specialized in Perl for over a
decade and wrote the test harness that ships with Perl. He recently wrote the popular book
[Beginning Perl](http://www.wrox.com/WileyCDA/WroxTitle/productCd-1118013840.html) (Wrox Press) and is one of the authors of
[Perl Hacks](http://shop.oreilly.com/product/9780596526740.do) (O'Reilly).
Ovid sits on the Board of Directors of The Perl Foundation.
</blockquote>
