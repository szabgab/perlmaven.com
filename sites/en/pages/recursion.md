---
title: "Recursion in Perl"
timestamp: 2021-06-20T10:50:01
tags:
  - recursion
published: true
author: szabgab
archive: true
---


[Recursion](https://en.wikipedia.org/wiki/Recursion_(computer_science)) in computer science is when a function calls itself
to resolve the problem. Each recursive call usually tries to solve a simpler version of the original problem till we reach a point
where the solution is obvious and does not need any further recursive calls.

A probably well known game of Google is that if you search for [Recursion](https://www.google.com/search?q=recursion)
that will offer to redirect you to "recursion" again, ad infinitum. Probably the only escape from this is to click on the
definition of [recursion](https://en.wikipedia.org/wiki/Recursion) in Wikipedia</a>


I usually use two very simple examples to explain recursion and how to write recursive functions, even though neither is really useful. If you are interested in some real uses of recursion check out [recursive subroutines to traverse directory trees](/recursive-subroutines).


## Factorial n!

The first example is n-factorial. Known as `n!` in mathematics.
It can be defined in two simple ways. One is the straight forward definition where we say that n! is the value
we get by multiplying all the integers from 1 to n. We can write it like this:

<pre>
n! = n * (n-1) * (n-2) * ....  3 * 2 * 1
</pre>

Another definition is a recursive definition.

<pre>
0! = 1
n! = n * (n-1)!
</pre>

That is, we define a simple (obvious case) that the factorial of 0 is 1 and then we say that in order to 
calculate he factorial of n, we need to first calculate the factorial of (n-1) and then multiply that by n
itself.

An implementation in Perl looks like this:

{% include file="examples/recursive_factorial.pl" %}

The `print` in the function is only there so we can more easily observer the function calls.

If we run this script we'll see the following output:

<pre>
6!
5!
4!
3!
2!
1!
0!
720
</pre>

So we can see the function is being called by an ever decreasing number till it reaches 0 when it returns all the way
through the calling function to the top of the code returning the final result.

## Fibonacci

The second example is the famous [Fibonacci series](https://en.wikipedia.org/wiki/Fibonacci_number).

The common definition is that each element is the sum of the previous two elements. In recursive definition:

<pre>
f(0) = 0
f(1) = 1
f(n) = f(n-1) + f(n-2)
</pre>

Our implementation in Perl looks very similar:

{% include file="examples/recursive_fibonacci.pl" %}

If we run this code we'll get the following output:

<pre>
f(6)
f(5)
f(4)
f(3)
f(2)
f(1)
f(0)
f(1)
f(2)
f(1)
f(0)
f(3)
f(2)
f(1)
f(0)
f(1)
f(4)
f(3)
f(2)
f(1)
f(0)
f(1)
f(2)
f(1)
f(0)
8
</pre>

As you can see there is a lot of waste in here as the function is called twice for f(4), 3 times for f(3), etc.
so computer-resource-wise this is not an ideal solution, but it can illustrate recursion in a really nice way.

## Stop criterion

One critical aspect of every recursive implementation is that we have to have some "simple and obvious case"
that does not require further recursion and that case must be recognized before we call the function in recursion.
Otherwise our recursion will never end and you might think that Perl or your computer is "stuck".

## Comments

I remember in college thinking "When am I ever going to use this recursion bs in any real world situation?" I can say without a doubt that you will. I have written multiple recursive methods over the decades for traversing nested structures and object interfaces. You end up needing this kind of functionality way more than you would think.

<hr>

The Fibonacci example can be made a lot more efficient with caching:

use strict;
use warnings;
use 5.020;
use experimental qw(signatures);

sub fibonacci($n)
{
    say "f($n)";
    state $cache = [0, 1];
    return $cache->[$n] //= fibonacci($n-1) + fibonacci($n-2);
}

say fibonacci(6);


