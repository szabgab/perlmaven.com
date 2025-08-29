---
title: "Manipulating Perl arrays: shift, unshift, push, pop"
timestamp: 2013-02-06T14:45:56
description: "push(ARRAY, LIST) - extending the ARRAY with the content of LIST; LAST = pop(ARRAY) - fetching the last element; FIRST = shift(ARRAY); unshift(ARRAY, LIST)"
tags:
  - array
  - shift
  - unshift
  - push
  - pop
published: true
books:
  - beginner
author: szabgab
---


As well as allowing direct access to individual array elements,
Perl also provides various other interesting ways to deal with arrays.
In particular, there are functions that make it very easy and efficient
to use a Perl array as a stack or as a queue.


## pop

The `pop` function will remove and return the last element of an array.

In this first example you can see how, given an array of 3 elements, the `pop` function
removes the last element (the one with the highest index) and returns it.

```perl
my @names = ('Foo', 'Bar', 'Baz');
my $last_one = pop @names;

print "$last_one\n";  # Baz
print "@names\n";     # Foo Bar
```

In the special case of the original array being empty, the `pop` function
will return [undef](/undef-and-defined-in-perl).

## push

The `push` function can add one or more values to the end of an array.
(Well, it can also add 0 values, but that's not very useful, is it?)

```perl
my @names = ('Foo', 'Bar');
push @names, 'Moo';
print "@names\n";     # Foo Bar Moo

my @others = ('Darth', 'Vader');
push @names, @others;
print "@names\n";     # Foo Bar Moo Darth Vader
```

In this example we originally had an array with two elements.
Then we pushed a single scalar value to the end and our array
got extended to a 3-element array.

In the second call to `push`, we pushed the content of the `@others`
array to the end of the `@names` array, extending it to a 5-element array.

## shift

If you imagine the array starting on the left hand side,
the `shift` function will move the whole array one unit to the left.
The first element will "fall off" the array and become the function's return value.
(If the array was empty, **shift** will return [undef](/undef-and-defined-in-perl).) 

After the operation, the array will be one element shorter.

```perl
my @names = ('Foo', 'Bar', 'Moo');
my $first = shift @names;
print "$first\n";     # Foo
print "@names\n";     # Bar Moo
```

This is quite similar to `pop`, but it works on the lower end of the array.

## unshift

This is the opposite operation of `shift`. `unshift` will
take one or more values (or even 0 if that's what you like) and place it at the
beginning of the array, moving all the other elements to the right.

You can pass it a single scalar value, which will become the
first element of the array. Or, as in the second example, you can pass a second
array and then the elements of this second array (`@others` in our case)
will be copied to the beginning of the main array (`@names` in our case)
moving the other elements to higher indexes.

```perl
my @names = ('Foo', 'Bar');
unshift @names, 'Moo';
print "@names\n";     # Moo Foo Bar 

my @others = ('Darth', 'Vader');
unshift @names, @others;
print "@names\n";     # Darth Vader Moo Foo Bar
```

## Comments

how to replace only the 5th element of an array from an variable.. i am looking up on a value and need to update the 5th element... basically i need to translate the value in an array..

---
have you tried to read this  https://perlmaven.com/perl-arrays

---
---
It would be probably easier to help if you showed what was in @values and what are you expecting in @results as I don't know what do you mean by "translate"

@values contains comma delimited strings... 170, test, best, try, 0.1314
@others='CIF'... so i need to translate 4th element of @values(try) to @others('CIF');

so @results =170, test, best, CIF, 0.1314

---

Don't explain with words. Show the actual data. Show a piece of code e.g. @values = ('170, test, best, try, 0.1314');
Is that it? How does @results look like, the one you wrote is not syntactically correct perl.


---

test1.csv
170, test, best, try, 0.1314
171, test, best, try, 0.1695
172, test, best, try, 0.1784

while <file =="" test1.csv="">{
@values = split ',', file ;

@others = 'CIF';

@results = splice @values, 5, 0, @others;
}
O/P:
170, test, best, CIF, 0.1314
171, test, best, CIF, 0.1695
172, test, best, CIF, 0.1784

i hope this is clear.. basically i am looking up for a value..and replacing with the 4th element of an array if the value matches.. just mentioned the high level code..

---

That does not look like working Perl code. Is this what you run?
Do you actually need anything in your perl script or is this your real task: "given a CSV file replace the 4th column with the string 'CIF'" ?

---

yes.. given a CSV file.. replace the 4th column with string 'CIF'.. i have just given a high level code.. string 'CIF' is being looked upon from a table..

---

What table? Based on what do you look it up?
---
that part of code is working fine.. i am looking up value from 4th column of the file.. and replacing it with the output i get from the table..
---
@results = splice @values, 5, 0, @others; what is wrong with this line.. ?

---
You wrote CIF is looked upon from a table but in your example @others is a one-element array. Not a table and there is no "looking up" it seems to be always CIF. So what did you mean by "looked upon from a table"?

---

yes.. i am loading a variable from the table lookup (which i have not mentioned in the code here).. and then passing it to @others which is one element array... so just mentioned string 'CIF' here.. now how can i replace the 4th column of the CSV to the value from @others...?

---

$values[3] = 'CIF';
$values[3] = others[0];

<hr>

Thanks for the explanation, it really helped me a lot.

<hr>

Nice explanation. Thanks man


