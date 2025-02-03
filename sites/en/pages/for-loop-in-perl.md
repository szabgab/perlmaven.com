---
title: "Perl for loop explained with examples"
timestamp: 2013-03-26T08:46:13
description: "for(INITIALIZE, TEST, STEP) {} C-style for loops in perl and the foreach loop for iterating over lists"
tags:
  - for
  - foreach
  - loop
  - infinite loop
published: true
books:
  - beginner
author: szabgab
---


In this part of the [Perl Tutorial](/perl-tutorial) we are going to talk
about the <b>for loop in Perl</b>. Some people also call it the <b>C-style for loop</b>,
but this construct is actually available in many programming languages.


## Perl for loop

The <b>for</b> keyword in Perl can work in two different ways.
It can work just as a <b>foreach</b> loop works and it can act
as a 3-part C-style for loop. It is called C-style though
it is available in many languages.

I'll describe how this works although I prefer to write the `foreach`
style loop as described in the section about [perl arrays](/perl-arrays).

The two keywords `for` and `foreach` can be used as synonyms.
Perl will work out which meaning you had in mind.

The <b>C-style for loop</b> has 3 parts in the controlling section.
In general it looks like this code, though you can omit any of
the 4 parts.

```perl
for (INITIALIZE; TEST; STEP) {
  BODY;
}
```

As an example see this code:

```perl
for (my $i=0; $i <= 9; $i++) {
   print "$i\n";
}
```

The INITIALIZE part will be executed once when the execution reaches that point.

Then, immediately after that the TEST part is executed. If this is false,
the whole loop is skipped. If the TEST part is true then the BODY is executed followed by
the STEP part.

(For the real meaning of TRUE and FALSE, check the [boolean values in Perl](/boolean-values-in-perl).)

Then comes the TEST again and it goes on and on, as long as the TEST executes to some true value.
So it looks like this:

```
INITIALIZE

TEST
BODY
STEP

TEST
BODY
STEP

...

TEST
```


## foreach

The above loop - going from 0 to 9 can be also written in a <b>foreach loop</b>
and I think the intention is much clearer:

```perl
foreach my $i (0..9) {
  print "$i\n";
}
```

As I wrote the two are actually synonyms so some people use the `for` keyword
but write <b>foreach style loop</b> like this:

```perl
for my $i (0..9) {
  print "$i\n";
}
```

## The parts of the perl for loop

INITIALIZE is of course to initialize some variable. It is executed exactly once.

TEST is some kind of boolean expression that tests if the loop should stop or if it should go on.
It is executed at least once. TEST is executed one more time than either BODY or STEP are.

BODY is a set of statements, usually that's what we want to do repeated
times though in some cases an empty BODY can also make sense.
Well, probably all those cases can be rewritten in some nice way.

STEP is another set of action usually used to increment or decrement some kind of an index.
This too can be left empty if, for example, we make that change inside the BODY.

## Infinite loop

You can write an infinite loop using the <b>for loop</b>:

```perl
for (;;) {
  # do something
}
```

People usually write it with a `while` statement such as:

```perl
while (1) {
  # do something
}
```

It is described in the part
about the [while loop in perl](/while-loop).

## perldoc

You can find the official description of the for-loop in the
<b>perlsyn</b> section of the
[Perl documentation](http://perldoc.perl.org/perlsyn.html#For-Loops).

## Comments

It isn't called a C-style for loop arbitrarily: C was the first language to use this style of for loop. Sure many languages implement this form, but all other languages that use this for loop copied this pattern from C.

<hr>

This is an extremely decent presentation, unlike most similar pieces of documentation which appear to be written by superior and condescending smart adultsThis is an extremely decent presentation, unlike most similar pieces of documentation which appear to be written . And the author is not even a native English speaker; congratulations!

<hr>

Is it possible (similar to C) put into for loop instruction return?

yes
