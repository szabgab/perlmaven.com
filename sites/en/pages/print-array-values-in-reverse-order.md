---
title: "How to print elements of an array in reverse order in Perl"
timestamp: 2019-11-26T18:30:01
tags:
  - reverse
published: true
author: szabgab
archive: true
---


The [reverse](/reverse) function is an excellent solution, but for a fun exercise you might want to know how to do
that without the built-in **reverse** function.


Given an array of strings we can print the elements in reverse order in a number of ways:

```
my @words = qw(Foo Bar Moo);
```

## Create a reversed array

Reverse the values and store them in another array.

{% include file="examples/reverse_an_array.pl" %}


## Print the values in reversed order

{% include file="examples/print_reversed_array.pl" %}

The output is

```
Moo
Bar
Foo
```

This still first reverses the array, create an reversed version of it
somewhere in the memory without connecting it to some variable name
and then prints the items one-by-one.

## Iterate over one-by-one

Instead of reversing the list of elements in the array, we
could use the index of each element and count down from the
largest index till 0 printing each element.

{% include file="examples/print_array_in_reverse.pl" %}

This code is a bit longer, one can easily make off-by-one errors
(e.g. using greater-than instead of greater-than-or-equal in the condition),
and it is unclear why the author did not use the `reverse` function.

It also has an potential advantage. It does not create a second copy of all
the elements in the array. This could be useful if you have so many elements
that doubling them would not fit in the memory of the computer.

Though I don't remember ever encountering such a situation.

## Which one is faster?

Anyway, if we already implement our own reverse printing code then we should
probably check which one of the above two versions is faster?
For that I created a separate implementation in which each one of the above
solutions is wrapped in a function.

Then I used the `timethese` function of the [Benchmark](https://metacpan.org/pod/Benchmark) module
to run each function many times and then compare the results. As I did not want to measure the time it takes to print
the strings, just the loop, I've replaced each `say` statement by an assignment.

The program expects 3 numbers. The first one is the length of the strings we create. The second is the size of the array we create, the number of elements. The third is the number of times we would like `timethese` to run each function.

The multiplication of the first two numbers gives the approximate value for the size of the memory used for a single copy of the array.
Third number is the number of times we repeat the experiment. The higher the number of times we run the functions, the more accurate the measurement will be. The `timethese` function will let us know if it thinks the number of iteration for the specific  functions is too low to measure accurately.

{% include file="examples/benchmark_array_reversing.pl" %}

## Benchmark results

For a very short list with very short strings we need 1,000,000 iterations make the clock move. The built-in reverse is about twice as fast as the home-made iteration. I am actually surprised that it is only twice as fast.

I experimented a bit with the various values, but could not get them high enough to show how running out of memory impacts the behavior of the functions.

## Conclusion

For now the conclusion is that I still have not found any case where rolling your manual reverse would be beneficial. 

