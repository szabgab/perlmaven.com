---
title: "Variable number of parameters in Perl subroutines"
timestamp: 2013-07-02T18:08:08
tags:
  - sub
  - "@_"
published: true
books:
  - beginner
author: szabgab
---


While Perl does not provide any built-in facilities to declare the parameters of a subroutine,
it makes it very easy to pass any number of parameters to a function.

This makes it almost trivial to write functions such as `sum` where all we expect is 0 or more
of the same type of value. (e.g. numbers in case of the `sum` function, or "filename", or
"email addresses" etc. for other functions).

This is not how you accept [multiple different parameters in a function](/passing-multiple-parameters-to-a-function).


## Variable-length parameter lists of functions in Perl

{% include file="examples/variable_parameters.pl" %}

In this example, in the first call we passed four numbers to the `sum` subroutine, and in the second call
we passed an array that has three numbers in it.

The subroutine itself receives the parameters in the standard `@_` variable.
In this case we do not copy the values to private variables as the function is really simple.
We just iterate over the values using a `foreach` loop and add each value the `$sum` variable
we declared at the beginning of the subroutine.

The `return` call will pass the value of `$sum` to the caller.

## Private array

We could have copied the content of `@_` to a private variable declared within
the subroutine, but it was not necessary in this example.

```perl
sub sum {
   my @values = @_;
   ...
```


## Passing more than one array

Unfortunately, if you'd like to pass two arrays to a function like in the following example,
you are in trouble.

```perl
my @good = ('Yoda', 'Luke', 'Leia');
my @evil = ('Darth Vader', 'Emperor');
print award(@good, @evil), "\n";
```

The subroutine will see all the values ('Yoda', 'Luke', 'Leia', 'Darth Vader', 'Emperor')
in the `@_` array, and there will be no easy way to tell which value
came from the first array, and which from the second.
In order to solve this we'll need to learn about [array references](/array-references-in-perl)
in general or read about [passing two arrays to a function](/passing-two-arrays-to-a-function).

