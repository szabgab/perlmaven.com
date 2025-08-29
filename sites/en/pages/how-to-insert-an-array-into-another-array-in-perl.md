---
title: "How to insert an array into another array in Perl?"
timestamp: 2015-02-04T19:05:01
tags:
  - splice
published: true
books:
  - beginner
author: szabgab
archive: true
---


Given an array called `@names = qw(Foo Bar Baz);` and another array called `my @languages = qw(Perl Python Ruby PHP);` how can
the `@languages` array be inserted in the "middle" of the `@names` array?

Of course I think the "middle" only means - "somewhere" and not that "the same distance from the beginning and from the end",
but we have another issue with the task.


There can be two types of insertions. **Flattening**, when the elements of `@language` become elements of `@names`, and thus
at the end of the operation `@names` will have 7 elements; or it can be **non-flattening**, that will create a sort-of
two-dimensional array. In this case `@names` will have 4 elements after the operation, one of them is a reference
to an internal array that holds the elements of `@languages`.

The solution to the two cases is quite similar. They both use the
[splice](/splice-to-slice-and-dice-arrays-in-perl) function.
Maybe we just need to adjust how we call the operation:

In the first case we

## Insert an array in another array

{% include file="examples/insert_array_in_array.pl" %}

in the second case we

## Insert and array reference in another array

{% include file="examples/insert_array_ref_in_array.pl" %}

The difference in the two code snippets is that in the first one we insert `@languages` and in
the second one we insert `\@languages`. Note the leading backslash.

If we run the scripts:

The first one generates a simple, flat array:

```
$ perl examples/insert_array_in_array.pl

$VAR1 = [
          'Foo',
          'Perl',
          'Python',
          'Ruby',
          'PHP',
          'Bar',
          'Baz'
        ];
```

The second one generates a two-dimensional array:

```
$ perl examples/insert_array_ref_in_array.pl 

$VAR1 = [
          'Foo',
          [
            'Perl',
            'Python',
            'Ruby',
            'PHP'
          ],
          'Bar',
          'Baz'
        ];
Ruby
$VAR1 = [
          'Perl',
          'Python',
          'Ruby',
          'PHP'
        ];
```

in which we can reach the values of the inserted array by using the the appropriate index
on the main array.


Beside one leaving a one-dimensional array behind and the other one creating a two-dimensional array, there is another
big difference between the two. What if after inserting the array we change the original `@languages` array?

## Changing the content of the array

In the first case, the content of `@languages` changes but the content of `@names` remains the same
as it was after the call to `splice`.

{% include file="examples/insert_array_in_array_change.pl" %}

```
$ perl examples/insert_array_in_array_change.pl 

$VAR1 = [
          'Foo',
          'Perl',
          'Python',
          'Ruby',
          'PHP',
          'Bar',
          'Baz'
        ];

$VAR1 = [
          'Perl',
          'Python',
          'JavaScript',
          'PHP'
        ];
$VAR1 = [
          'Foo',
          'Perl',
          'Python',
          'Ruby',
          'PHP',
          'Bar',
          'Baz'
        ];
```

## Changing the content of the references array

On the other hand, if we take the case when we inserted a an array reference in the
array and created a two dimensional array, then the internal array remains "connected"
to the original array. Thus if we change the `@languages` array (setting element 2
to be JavaScript) this change will be reflected both in `@languages` and in
the internal array of `@names`. (See JavaScript in the 2 last dumps below)

{% include file="examples/insert_array_ref_in_array_change.pl" %}

```
perl examples/insert_array_ref_in_array_change.pl 

$VAR1 = [
          'Foo',
          [
            'Perl',
            'Python',
            'Ruby',
            'PHP'
          ],
          'Bar',
          'Baz'
        ];
Ruby
$VAR1 = [
          'Perl',
          'Python',
          'Ruby',
          'PHP'
        ];

$VAR1 = [
          'Perl',
          'Python',
          'JavaScript',
          'PHP'
        ];
$VAR1 = [
          'Foo',
          [
            'Perl',
            'Python',
            'JavaScript',
            'PHP'
          ],
          'Bar',
          'Baz'
        ];
```

This happens because in the second case we have copied the reference of the array but now both `@languages` and
`$names[1]` point to the same location in the memory. So if we change the content of either of those, the
other one will change too.

