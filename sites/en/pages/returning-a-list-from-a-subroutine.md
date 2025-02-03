---
title: "Returning multiple values or a list from a subroutine in Perl"
timestamp: 2021-08-15T08:30:01
tags:
  - return
  - sub
published: true
books:
  - beginner
author: szabgab
archive: true
---


It is really easy to return multiple values from a subroutine in Perl. One just needs to pass the values to the `return` statement.


## Returning multiple values from a function in Perl

Perl will convert the values into a list that the caller capture in a number of ways.
In the first call the values are captured in an array. In the second we capture them in a list of scalar variables.
Of course you can even mix these two approaches if that fits your application.

{% include file="examples/return_multiple_elements.pl" %}

The result will look like this:

<pre>
$VAR1 = [
          44,
          84,
          40,
          '21'
        ];
sum: 105
mul: 306
sub: 99
div: 34
</pre>

## Returning a an array from a function in Perl

In this example we compute the first N element of the Fibonacci series. Collect them in an array inside the function
and then return the array.

Behind the scenes Perl sees the content of this array and returns the elements as a list.

Usually the caller will assign the result to an array as we did in the first call of `fibonacci(8)`.
This is usually the logical thing to do.

However there is nothing in Perl that would stop us from capturing some of the returned values in individual scalar
as it is done in the second example when calling `fibonacci(6)`.

{% include file="examples/fibonacci_list.pl" %}

<pre>
$VAR1 = [
          1,
          1,
          2,
          3,
          5,
          8,
          13,
          21,
          34
        ];

first: 1
second: 1
$VAR1 = [
          2,
          3,
          5,
          8,
          13
        ];
</pre>

