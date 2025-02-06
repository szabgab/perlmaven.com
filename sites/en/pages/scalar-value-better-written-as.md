---
title: "Scalar value ... better written as ..."
timestamp: 2018-11-11T12:00:01
tags:
  - "@_"
published: true
author: szabgab
archive: true
---


If you [use warnings](/always-use-warnings) in your Perl code you might encounter this strange warning. It is especially strange as the code seems to be working as expected.
Nevertheless this is one of the [common warnings in Perl](/common-warnings-and-error-messages). You'd better understand it and get rid of it.

Without disabling warnings.


## Access element of an array

In this most simple example we have an array called `@names` and we try to print the first element in the array by accessing `@names[0];`.

{% include file="examples/array_index1.pl" %}

The output looks like this:

```
Scalar value @names[0] better written as $names[0] at array_index1.pl line 6.
Foo
```

So we get the correct value printed, but we also get a warning.

In Perl, when you talk about a whole [array](/perl-arrays) or about a [slice of an array](/array-slices) you use the `@` sigil,
but when you try to access a single [element of an array](/perl-arrays) you need to use the `$` sigil.
So the proper way to access the first element of the `@names` array is to use `$names[0]`.

## Array element in dereference

In the second example we have slightly more complex expression, 

{% include file="examples/array_index2.pl" %}

Running this code we only get the warning but no output. The function does not even get executed, the warning is already emitted.

```
Scalar value @_[0] better written as $_[0] at array_index2.pl line 5.
```

Here too, instead of `@_[0]` we should have written `$_[0]`. Not to be confused with [$_ the default variable of Perl](/the-default-variable-of-perl)
that does not have a square-bracket nor curly braces after it.

## Correct way to access elements of an array in Perl

The correct way can be seen in this code:

{% include file="examples/array_index.pl" %}

## Comments

I've always viewed it as telling perl what I want returned. If I just want a single element of an array then I tell Perl I wan a scalar, $. If I want the whole array or a slice I tell Perl I want an array, @. And likewise if I want the whole hash...

