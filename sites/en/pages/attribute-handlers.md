---
title: "Attribute::Handlers to wrap a function"
timestamp: 2021-04-09T11:30:01
tags:
  - Attribute::Handlers
published: true
author: szabgab
archive: true
description: "Attribute Handlers in Perl are like decorators in Python"
show_related: true
---


Attribute Handlers in Perl are like decorators in Python


{% include file="examples/attributes/wrap_function.pl" %}

Output:

```
Before sum(2, 3)
After sum(2, 3) resulting in: (5)
5
Before sum(-1, 1, 7)
After sum(-1, 1, 7) resulting in: (7)
7
```

The Wrap function is marked to be a attribute handler for subroutines (CODE).

Inside we create a new anonymous subroutine and assign it to the variable **$new** and the replace (redefine)
the original function with this new function.

Inside the new function we call the original function by

```
my @results = $referent->(@_);
```

Before that we execute some code then after the original function returned we execute some code.

Then there is a totally ordinary function called "sub" that is marked with our new "Wrap".

Now every time we call **sum()** our "$new" function is going to be called.

## Separating Attribute to module

Probably you'd like to make your wrapper more reusable and move it out to a module:

{% include file="examples/attributes/MyWrapper.pm" %}

Then, as far as I could figure out you need to "inherit" from that module using **base**:

{% include file="examples/attributes/wrap_function_from_module.pl" %}

```
perl -I. wrap_function_from_module.pl
```

## Wrapping recursive function

Wrapping a recursive function can help us see the calls that were made to it and the values it returned.

{% include file="examples/attributes/wrap_function.pl" %}

Output:

```
Before fibonacci(4)
Before fibonacci(3)
Before fibonacci(2)
Before fibonacci(1)
After fibonacci(1) resulting in: (1)
Before fibonacci(0)
After fibonacci(0) resulting in: (1)
After fibonacci(2) resulting in: (2)
Before fibonacci(1)
After fibonacci(1) resulting in: (1)
After fibonacci(3) resulting in: (2)
Before fibonacci(2)
Before fibonacci(1)
After fibonacci(1) resulting in: (1)
Before fibonacci(0)
After fibonacci(0) resulting in: (1)
After fibonacci(2) resulting in: (2)
After fibonacci(4) resulting in: (2)
```

## Wrapper to measure elapsed time

Another example is a wrapper that measures the elapsed time in the real function.

{% include file="examples/attributes/MyTimer.pm" %}

This is how we use it:

{% include file="examples/attributes/wrap_function_time.pl" %}

This is the output:

```
$ perl -I. wrap_function_time.pl

Elapsed time: 4.05311584472656e-06
5
```




