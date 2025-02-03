---
title: "Variable declaration in Perl"
timestamp: 2013-07-23T07:50:01
tags:
  - my
  - strict
  - declaration
  - our
  - state
  - use vars
  - vars
published: true
books:
  - advanced
author: szabgab
---



One of the 3 features of `use strict` which is also called `use strict 'vars';`
requires that you declare every variable before you use it. Well, sort of.


## The trouble

Let's see first an example why is this important.


```perl
$l1 = 42;

$ll++;

print "$l1\n";
```

We assign 42 to a variable. Later we increment it by one, and then print it. Surprisingly the variable still contains 42.

The author might even know that he has to declare the variables using `my` so maybe the code looks like this:

```perl
my $l1 = 42;

$ll++;

print "$l1\n";
```

but the result is the same.

Now imagine that it is not in a 3 lines long example, but in a 1000 lines long
script that you can find in many established places. You'd have a very hard time noticing that the
auto-increment used the letter l twice, while the first and third rows had
a variable with a letter and a number 1.

## use strict

If we add a `use strict` requirement at the beginning of the file,

```perl
use strict;

my $l1 = 42;

$ll++;

print "$l1\n";
```

we will get the following compile-time error message when we try to run the script:

```
Global symbol "$ll" requires explicit package name at ... line 6.
```

Seeing that error message isn't that clear either, at least not for the beginners,
we'll see later where does it come from. In the meantime, if you are interested,
you can read more about the error
[global symbol requires explicit package name](/global-symbol-requires-explicit-package-name).

In practical terms it means that you have not declared your variable `$ll`. Of course
running to your editor and declaring `my $ll` won't do any good. You'll have to understand
that this is actually a typo and the real variable name is `$l1`.

We might be still frustrated by the original developer who used a variable name that's
hard to differentiate from a letter, but at least we don't spend hours banging
our head against the wall.

## The exceptions

As in any living languages (such as English and French) there are exceptions from the rules. In Perl too.

The variables `$a` and `$b` are special variables used in the `sort` function of Perl
and, for historical reasons, are exempt from the requirement to declare them.
I am not saying having such exceptions is a good thing, but it probably cannot be changed without breaking
all the code written in the past 20+ years.
So I'd strongly recommend <b>never using $a and $b</b> in any code except in connection to `sort`.

Not even in examples!

You can declare variables using `our`, `use vars`, and since 5.10 using `state` as well.
They have different meaning though.

You can also access variables with their fully qualified name (`$Person::name` in the next example):

{% include file="examples/fully_qualified_name.pl" %}

And the output is

```
42
37
100
Foo
```

No warning, no error.

We used the <b>explicit package name</b> in the last example. That's, by-the-way where the error
message ([global symbol requires explicit package name](/global-symbol-requires-explicit-package-name))
came from, but in the <i>real world</i> you rarely need that form.
You are way better off always declaring your variables using `my`, and not
using this "fully qualified" form of the variable.

## The danger of the explicit package name

As `use strict` does not apply to the package variables, you can easily make a typo
as I actually did when I wrote the first version of the example:

{% include file="examples/fully_qualified_name_with_typo.pl" %}

and it printed nothing. No error. No warning. Nothing.

In general relying on fully qualified names can be dangerous. Of course they can be useful in
some places, but we'll talk about that another time.

## use warnings

Anyway, this brings me to the importance of the `use warnings` pragmata. If we used that too,

{% include file="examples/fully_qualified_name_with_warnings.pl" %}

we would get the following run-time warnings:

```
Name "Person::name" used only once: possible typo at ...  line 6.
Name "Perlson::name" used only once: possible typo at ... line 7.
Use of uninitialized value $Perlson::name in say at ... line 7.
```

Might not be the best solution, but at least we get some indication that something went wrong.

Even that warning can disappear if I am extremely bad at typing.

{% include file="examples/fully_qualified_name_bad_typing.pl" %}

Here I made the exact same typo twice (maybe a copy paste?) and the result is

```
Moo
```

No error. No warning. Still incorrect behavior.

## Always use strict

My conclusion is to always use strict by default.

In other articles you can read about [symbolic references](/symbolic-reference-in-perl)
and [barewords](/barewords-in-perl) in Perl, the other two
issues `strict` helps to avoid.


## Comments

print $latitude # 36°00'N

How do I detect the location of the degree sign?

<hr>

One important caveat of use strict 'vars' is that the requirement for variable declaration doesn't apply if you reference the variables using the "main" package name.

For example, Perl will happily let you use

$main::some_variable = 1

without complaining.


