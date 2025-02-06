---
title: "How to get a slice of an array or an array reference?"
timestamp: 2017-08-29T06:30:01
tags:
  - "@array[]"
published: true
books:
  - advanced
author: szabgab
archive: true
---


Given an array listing rulers in the [Kingdom of Jerusalem](https://en.wikipedia.org/wiki/Kingdom_of_Jerusalem)
like this one: `@kings = ('Baldwin', 'Melisende', 'Fulk', 'Amalric', 'Guy', 'Conrad')`. How can we
create one that is built from the 2nd, the 4th and then the 1st element?

One solution is:

`@names = ($kings[2], $kings[4], $kings[1])`


The other, the simpler solution is to use array slices:


`@names = @kings[2,4,1]`

In this case we use the `@` prefix of the array and provide several indexes.
If you are familiar with [arrays in Perl](/perl-arrays),
you surely remember that when we talk about the whole array we put `@` in front of the
name, but when we talk about a single [element of an array](/beginner-perl-maven-array-indexes)
we replace the `@` sigil by the `$` sigil and put square brackets at the end.

When we want create a list of one or more of the elements of the array we use the `@` sigil again, as it represents
"plural" and then we put one or more indexes in the square brackets after the name of the array.

See the full example here:

{% include file="examples/array_slice.pl" %}


## Scalar value @kings[2] better written as $kings[2]

This warning will appear if you try to use an array slice with a single index as in this example:

`my @s = @kings[2];`

This is how [splain](/use-diagnostics-or-splain) explains the warning:

<pre>
Scalar value @kings[2] better written as $kings[2] at array_slice.pl line 14 (#1)
    (W syntax) You've used an array slice (indicated by @) to select a
    single element of an array.  Generally it's better to ask for a scalar
    value (indicated by $).  The difference is that $foo[&bar] always
    behaves like a scalar, both when assigning to it and when evaluating its
    argument, while @foo[&bar] behaves like a list when you assign to it,
    and provides a list context to its subscript, which can do weird things
    if you're expecting only one subscript.
    
    On the other hand, if you were actually hoping to treat the array
    element as a list, you need to look into how references work, because
    Perl will not magically convert between scalars and lists for you.  See
    perlref.
</pre>

If you would like to create a new array using a single element of another array then you should probably write:

`my @s = $kings[2];`

or if you want to make sure readers of your code won't be surprised by the assignment of a scalar to an
array, then you can even put parentheses around the value.

`my @s = ($kings[2]);`


## Slice of an array reference

If we have out data in an ARRAY reference and not in an array, the code will be a bit more complex:

In this case we have a variable called `$kings` which is a reference to an array.

In the plain version, when we use individual elements we just need to dereference the ARRAY reference
for each individual element.

`my @names = ($kings->[2], $kings->[4], $kings->[1]);`


If we would like to use the array slice syntax then first we need to dereference the whole
array putting the `@` sigil in-front of the reference: `@$kings`, but then
we can simply put the square brackets behind that construct: `my @slice = @$kings[2,4,1];`
though I think I prefer the version when we put curly braces around the reference, thereby
making it clear that it is a single unit of expression:

`my @slice = @{$kings}[2,4,1];`

The full example can be seen here:

{% include file="examples/array_ref_slice.pl" %}

## Recent versions of Perl

As [Dave Cross](https://dave.org.uk/) pointed out in the comments in modern versions of Perl
(experimental in 5.20 and 5.22, stable since 5.24), you can also use the
[Postfix Dereferencing Syntax](https://metacpan.org/pod/distribution/perl/pod/perlref.pod#Postfix-Dereference-Syntax).

```
my @slice = $kings->@[2,4,1];
```


