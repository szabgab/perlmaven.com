---
title: "How to return nothing (or undef) from a function in Perl?"
timestamp: 2016-03-30T19:30:01
tags:
  - return
  - undef
  - wantarray
  - Perl::Critic
published: true
author: szabgab
archive: true
---


There are two major ways indicating failure in a function. One of them is to throw (or raise) an exception by calling
`die`, `croak`, or some other method. The other one is to return a false value. In Perl this false values is usually an `undef`.

Some people claim that throwing an exception is a better way to indicate error, but in case you (or the people who wrote the code-base) have
decided to return `undef` then the question remains:

How to return `undef`?

Actually returning `undef` from a function is simple, but due to the context sensitivity of perl it has several gotchas.
We just have to decide which one to avoid and which one to fall in.


## Return undef explicitly (and what's wrong with that)

The solution that seems to be obvious to many people, especially who are new to Perl, is to explicitly return `undef` by writing:
`return undef;`. This is what we try in the following example. We have a function called `div` that will attempt to divide two
numbers, but if the denominator is 0, we must signal an error as we cannot divide by 0. In that case we call `return undef;`
We call the `div` function 4 times. Twice we assign the value to a scalar variable and twice we assign it to an array.

Then we check if the result is [true](/boolean-values-in-perl). For a scalar we use (`if (defined $x)`),
but for arrays, we usually check [truth](/boolean-values-in-perl) by checking if the array is empty (`if (@x_results)`).

{% include file="examples/explicit_return_undef.pl" %}

The result looks like this:

```
Success! The results is 3
Failure! We received undef
Success! We can divide 6 by 2
Success! We can divide 42 by 0
```

The first 3 results are correct, but then in the 4th row we see an incorrect result. This code now thinks that perl can divide by 0.

The problem is that our function returned `undef` which got assigned to the `@y_results` array which means the content
of the array became a single `undef`. As if we wrote `@y_results = (undef);`. A one-element array is not empty,
even if that element is `undef`, and thus `if (@y_results)` returned true.

So let's try another solution.

## Return undef implicitly

The only thing we changed is that now, in case of error, we call `return;` without explicitly returning `undef`

{% include file="examples/implicit_return_undef.pl" %}

This time the result is correct:

```
Success! The results is 3
Failure! We received undef
Success! We can divide 6 by 2
Failure!
```

This happens because the parameter-less `return` has the magic feature that in
[scalar context](/scalar-and-list-context-in-perl)
it returns `undef`, but in [list context](/scalar-and-list-context-in-perl)
it returns an empty list `()`.

Sounds perfect.

It is not.

## Prohibit Explicit Return Undef

Before showing the problem with this solution though, let's see how can we avoid the first problem.
How can we make sure that we don't have explicit `return undef;` in our code?

Because this issue was part of the original <b>Perl Best Practices</b> book of Damian Conway,
[Perl::Critic](https://metacpan.org/pod/Perl::Critic) has a policy against it called
[Subroutines::ProhibitExplicitReturnUndef](https://metacpan.org/pod/Perl::Critic::Policy::Subroutines::ProhibitExplicitReturnUndef).

If, following the advice to [check one policy at a time](/perl-critic-one-policy) we run the next command:

```
perlcritic --single-policy Subroutines::ProhibitExplicitReturnUndef  examples/explicit_return_undef.pl 
```

we will get a report:

```
"return" statement with explicit "undef" at line 11, column 5.  See page 199 of PBP.  (Severity: 5)
```

Using this policy in our setup (e.g. in the `.perlcriticrc` file), will help us locate the places where `undef` was
returned explicitely, and it will make sure we get notified if some adds such code to our code-based.

## When implicit return breaks our code

I promised to show when the second solution, the implicit return of `undef`, by calling a simple `return;`
will break our code.

First let's see a code snippet using <b>explicit return undef</b> using `return undef;`:

{% include file="examples/explicit_return_undef_hash.pl" %}

The result is

```
$VAR1 = {
          '42/0' => undef,
          '6/2' => '3'
        };
```

what we expected.

Now lets see the same code but with <b>implicit return undef</b> using `return;`

{% include file="examples/implicit_return_undef_hash.pl" %}

The result is really strange:

```
$VAR1 = {
          '42/0' => '6/2',
          '3' => undef
        };
```

How did '3' become a key and '6/2' a value in this hash?

The only clue we might get is the <b>Odd number of elements in hash assignment ...</b> warning.

The problem here is that we basically have

```
   '42/0' => ,
   '6/2'  => 3,
```

which is the same as 
```
   '42/0', , '6/2', 3,
```

In the first row we don't have a value and perl disregards that place where we have two comma one after the other.
Which means perl actually sees this:

```
   '42/0' => '6/2',
    3 => ,
```

So we have 3 elements in the hash assignment (an odd number) and perl fills in the missing last value with `undef`.

This happens because in this case the `div` calls were in [list context](/scalar-and-list-context-in-perl) and the function returned an
empty list.

So the same thing that helped us earlier, that the empty `return;` gives an empty list in list context, now breaks our code.

So after all this solution isn't perfect either.

## Alway enforce scalar context

The <b>user</b> of our function can solve this by putting the call to `div` into scalar context:

{% include file="examples/implicit_return_undef_hash_with_scalar.pl" %}

The result is correct then:

```
$VAR1 = {
          '42/0' => undef,
          '6/2' => '3'
        };
```

but this means the user has to remember to put `scalar` in front of the call.

It is still probably better than the <b>explicit return undef</b>, but it is not exactly [DWIM](https://en.wikipedia.org/wiki/DWIM).

## Forbid list context

Seeing all this trouble, and seeing that the trouble only manifests when the function is called in list context,
as the author of the `div` function, we can decide to forbid calling the function in list context.

We can use [wantarray](/wantarray) to recognize when is the function called in list context
and throw an exception (using `croak`):

{% include file="examples/prohibit_list_context.pl" %}

The result is that we will soon find all the places where we have called the function in list
context and will be forced to fix those places.

```
3
$VAR1 = {
          '42/0' => undef,
          '6/2' => '3'
        };

Cannot use "div" in list context at examples/prohibit_list_context.pl line 9.
    main::div(6, 2) called at examples/prohibit_list_context.pl line 20
```

Of course this means we cannot use the function in list context, for example we cannot write:

```
print "The result of 6/2 is ", div(6, 2);
```

but we can write

```
print "The result of 6/2 is ", scalar div(6, 2);
```

or even

```
print "The result of 6/2 is " . div(6, 2);
```


