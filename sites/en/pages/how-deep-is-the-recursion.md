---
title: "How deep is a recursion in Perl?"
timestamp: 2021-07-31T10:30:01
tags:
  - caller
published: true
author: szabgab
archive: true
---


We have discussed [recursion in Perl](/recursion) and the problem with
[recursion that is too deep](/deep-recursion-on-subroutine), but how can you find out the current depth
of the recursion?



In our first solution we are using the [caller](https://metacpan.org/pod/perlfunc#caller) function that can return information about the functions that called the current function. About the whole stack, all the way up to the main body of the Perl script.

`caller(n)` returns information on the n-th parent of the current function. So `caller(0)` returns information about the current function. 

We can use that to figure out what is our own name. We could of course just hard-code the name "fib", but it would not be correct as the name of the function is actually `main::fib`. In addition if we moved the function to a module, the full name would change. Using `caller(0)` to find out our own name solves this problem.

The 4th value returned by `caller` is the name of the function. By enclosing the whole `(caller(0))` in parentheses we can use it as if it was an array and fetch element 3 which is the 4th element of the 0-based array.

Then we have an internal `while` loop that calls `caller` with an ever growing number as long as the returned values indicate that the upper function is the same as the one we have this code in.

{% include file="examples/recursion_depth.pl" %}

In the result the left column is the `$n`, the parameter that was used when the current call was made, the right column is the depth of the call.

<pre>
6 1
5 2
4 3
3 4
2 5
1 5
2 4
3 3
2 4
1 4
4 2
3 3
2 4
1 4
2 3
8
</pre>

## Separate function to calculate the depth

You might want to find out the depth in more than one function. Instead of copy-pasting the whole extra code
we can move it out to an external function. For this to work we slightly had to adjust the numbers because now 
the real function is already 1 level up from the current stack frame of the `depth` function.

{% include file="examples/recursion_depth_external.pl" %}

## Caveat

This won't work if in the recursion we have two or more functions that call each other.


