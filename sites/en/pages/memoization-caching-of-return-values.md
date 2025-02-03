---
title: "Memoization - speeding up function calls by caching of return values"
timestamp: 2016-04-03T22:30:01
tags:
  - Memoize
  - &
  - \&
  - *{}
published: true
author: szabgab
archive: true
---


<a href="https://en.wikipedia.org/wiki/Memoization"><b>Memoization</b></a> is the name
of a technique to speed up function calls by caching the return values.
The idea is that if there is a function that we call with the same parameters several
times during the life of our process, we can cache the result and eliminate the processing time.


More specifically, for every set of input, the first time the function is called,
we let it compute the result, but then we store it in memory and the next, and subsequent
times the function is called we just return the already computed data.

Using this technique assumes that for any given input the function is expected to return the same result.
So no randomization involved. Time of execution is not involved. No other external information is
taken in account. Not even the previous calls to this function have any impact on the result.

One of the most obvious, and not very useful, example is improving the speed of a recursive
implementation of the [Fibonacci](https://en.wikipedia.org/wiki/Fibonacci_number) series.

Another example would be computing the family tree of people based on hierarchical database,
or building the pedigree of dogs based on raw data stored in an Relational Database such as MySQL.

## Fibonacci numbers

Let's see the case of the Fibonacci series.

{% include file="examples/fibonacci.pl" %}

I've also include an extra `say` statement so we can see how many times
was the function called.

The result of calling `fibonacci(6)` can be seen here:

```
fibonacci(6)
fibonacci(5)
fibonacci(4)
fibonacci(3)
fibonacci(2)
fibonacci(1)
fibonacci(2)
fibonacci(3)
fibonacci(2)
fibonacci(1)
fibonacci(4)
fibonacci(3)
fibonacci(2)
fibonacci(1)
fibonacci(2)
8
```

As you can see `fibonacci(3)`, which was called 3 times and `fibonacci(2)` was called 5 times.
A total of 15 calls for `fibonacci(6)`.

While in this case the computation is not heavy, but you can imagine that if calculating each
function call took 1 second then we would be quite frustrated when we ran `fibonacci(1000)`

## Fibonacci numbers - cached

In this solution we manually added caching to the function computing the Fibonacci series.
Not very nice, but it might help understanding the solution later on.

{% include file="examples/fibonacci_with_cache.pl" %}

We had to used a <a href="/static-and-state-variables-in-perl">state` variable introduced
in [perl 5.10](/what-is-new-in-perl-5.10--say-defined-or-state).

The specialty of the `state` variables is that they are initialized only once
and they retain their content between calls to the `fibonacci` function.

In the code we check if the `%cache` already has a value for the current `$n`,
if not we compute it using the recursive function calls and store it in the cache
After that we can safely return `$cache{$n}` it will have the previously
computed value.

If during the recursive calls we encounter a call that we have already computed
we don't need to calculate it again. We just return the already calculated value.
The output looks like this:

```
fibonacci(6)
fibonacci(5)
fibonacci(4)
fibonacci(3)
fibonacci(2)
fibonacci(1)
fibonacci(2)
fibonacci(3)
fibonacci(4)
8
```

This is already an improvement 9 calls instead of 15, but we still have a few duplicate
calls. That's because in some cases the function is called again before the previous call with
the same parameter had a chance to return and to update the cache.

There is another issue with this solution. We have to think about the caching during
the implementation and the maintenance of the function. This made the function more
complex. We could not use the `return .. if ..` statements any more.
For more complex functions, where you have several points of `return` it will
be even harder to add the caching.

The function also does now two things: computes Fibonacci numbers and caches results.
Usually it is recommended that every function should do exactly one thing.

So let's separate the caching from the implementation of Fibonacci.

## Fibonacci numbers - external cache

{% include file="examples/fibonacci_with_external_cache.pl" %}

In this version we have two functions. The one called `fibonacci` is
actually the one caching the results, the other one called `_fibonacci`
is a "helper function" that users should not call directly and that's what is
computing the fibonacci.

`fibonacci` has the `%cache`, it checks if it already has the
results for `$n` and calls `_fibonacci($n)` if it does not have
the value yet.

`_fibonacci` implements the recursive computation of the Fibonacci numbers.
It could be returned to the more simple syntax even using the
`return .. if ..` constructs, but instead of calling itself, it calls `fibonacci`.

We have to do this because we wanted the recursive calls to be cached as well.

The result is what we expected, calling fibonacci() once for each number.

```
fibonacci(6)
fibonacci(5)
fibonacci(4)
fibonacci(3)
fibonacci(2)
fibonacci(1)
8
```

The separation of these two function is an improvement, but they are still interconnected.
The developer and the maintainer of the `_fibonacci` function still needs to know
about the caching. It also means that we cannot reuse our caching function.

Let's further separate the two.


## Memoize manually

In this version we have implemented a function called `memoize` that will
accept the name of a function as a parameter and will change the behavior of
that function adding caching to it. This technique requires some advanced
knowledge, so if you are not interested in the the behind the scenes, then skip
ahead to the next title.

{% include file="examples/fibonacci_memoize_manually.pl" %}

The `memoize` function receives the name of a function as a parameter.
Using the `\&{$func};` expression we copy the reference to the function
to a temporary variable called `$original`. We need it saved so later
we can call the original function.

Then we create a new anonymous function and assign it to the variable `$sub`.
We are going to replace the original subroutine with this one. This new function
accepts a single value `$n`.

Inside the new subroutine we check the cache and if the value for `$n`
has not yet been computed we call the original function and pass the value of `$n`
to it. The returned value is saved in the cache.

Then we use the expression `*{$func} = $sub;` to replace the function name
in `$func` by the newly created function.

We had to add `no strict 'refs'` to avoid the
[Can't use string ... as a symbol ref while "strict refs" in use at ...](/symbolic-reference-in-perl)
error and we had to add `no warnings 'redefine';` to avoid the `Subroutine main::fibonacci redefined` warning.
After all we <b>want</b> to redefine the function.

You might have noticed that instead of having a `state` variable, this time `%cache` was defined with
a simple `my` statement. This is because `%cache`, just as `$original` are variables
that are accessed from inside the anonymous function. As long as that function exists there variables will exist
and they are going to be private for the anonymous function. They are part of the <b>closure</b> we have created
here.

The result looks good:

```
fibonacci(6)
fibonacci(5)
fibonacci(4)
fibonacci(3)
fibonacci(2)
fibonacci(1)
8
```

While in this case the two functions don't access each other directly and in that way the `memoize` function
is generic, there is still a slight problem with this solution.  The internal function created by the `memoize`
function assumes that there is going to be exactly one parameter. This is true for the `fibonacci` function,
and this is true for many other functions, but this implementation of `memoize` is still limited that
it can only handle functions with a single parameter.

## Memoize Fibonacci

In this version we use the generic `memoize` function of the [Memoize](https://metacpan.org/pod/Memoize)
module to add caching to the function generating the Fibonacci numbers:

{% include file="examples/fibonacci_memoize.pl" %}

The result is the same as above.

```
fibonacci(6)
fibonacci(5)
fibonacci(4)
fibonacci(3)
fibonacci(2)
fibonacci(1)
8
```

There is not much to say here. It just works.

## Caveat

Memoization trades memory for speed. It uses more memory by caching results of previous computations
in order to eliminate some code execution. You'll need to take in account the actual memory use
if the memoized version if it is acceptable and if it is worth the effort.

Memoization has its overhead in CPU usage as well.
If the original computation is very short then it might not worth the extra effort.

Memoization is an optimization technique.
["Premature optimization is the root of all evil"](http://c2.com/cgi/wiki?PrematureOptimization).
Think hard before doing it. Better yet, measure processing time before and after to see if
you have gained anything.

If the original function depends on external factors, or even on the previous calls of itself,
then memoization will alter the results.
