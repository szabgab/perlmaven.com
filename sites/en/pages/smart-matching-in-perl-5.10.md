---
title: "Smart Matching in Perl 5.10"
timestamp: 2012-07-06T11:48:56
tags:
  - ~~
  - smart match
  - v5.10
  - 5.010
published: true
author: szabgab
---


So Perl 5.10 has been released on 18th December 2007,
on the 20th birthday of Perl. There are several interesting
additions to the language.
In [What's new in Perl 5.10? say, //, state](/what-is-new-in-perl-5.10--say-defined-or-state) I already
wrote about a few.
Now I am going to look at something called **Smart Matching**.

In 5.10 there is a new operator that looks like this: **~~**


It is called the **Smart Matching** operator.

Before going further a slight warning. The behavior of the Smart Match operator
has slightly changed between 5.10 and later versions of Perl. Some the changes
are mentioned in this article.

As it is a [commutative](http://en.wikipedia.org/wiki/Commutative)
operator normally you will use ~~ just like you would use "==" or "eq" between
two scalar variables (but not like =~ which is not commutative).

Smart Match will check if the two values are string-equal using "eq",
unless it finds some better way to match them....

so all the following will be true:

```perl
"Foo" ~~ "Foo"
42    ~~ 42
42    ~~ 42.0
42    ~~ "42.0"
```

and all these will be false

```perl
"Foo"  ~~ "Bar"
42     ~~ "42x"
```

And that is already a nice advantage over what we had earlier.

In every operator Perl changes the type of the value based on the operator.
That is == turns both sides to Numerical values and compares them as numbers
while eq turns both side to String values and compares them as strings.

When turning a string to a number Perl looks at the left side of the string and
uses as many characters as it can understand as being a number and warns if there
are more - non-number - characters in the string.

On the other hand ~~ fits the comparison method to the values on the two sides.
<br>
In a smart way.

This means that these are all true:

```perl
42 == 42
42 == 42.0
42 == "42.0"
42 == "42\n"
```

but this is false:

```perl
42 eq "42.0"
42 eq "42\n"
```

and the following are true:

```perl
42 == "42x"
"Foo" == "Bar"
```

albeit with a warning...<br>
if you used **use warnings**...

This behavior while consistent is a bit hard to understand.

On the other hand the new ~~ is strange in another way.
Its comparison is **value driven** as opposed to the other operations in
Perl which are **operator driven**.
<hr>

Let's see it in a different approach: As I wrote ~~ will compare the values
as strings using eq, unless it finds some better way to compare them.

```perl
"Foo" ~~ "Bar"
```

will return false but

```perl
"Moose" ~~ "Moose"
```

will return true. Nothing to surprise us.

So what better ways might be there to compare two scalars?

I wrote a small function that can be used to see what smart matching does.

```perl
sub compare {
    my ($x, $y, $description) = @_;
    my $t = ($x ~~ $y ? "True" : "False");
    $x //= '';
    $y //= '';
    printf("%-4s ~~ %-4s is %-5s   (%s)\n", $x, $y, $t, $description);
}
```

This will get two values (and a description) and compare the two
with smart matching printing the result. So I can now supply two
values two this function and see how are the respective variables compared.

So `"Foo" ~~ "Bar"` is the same as `"Foo" eq "Bar"`,
(this is called `Any ~~ Any` in the documentation)

If one side is a number, it seems to be better to compare them as numbers (using ==)
`42 ~~ 42.0`  are compared using `==` (this is called `Any ~~ Num`)

If one side is Number but the other one is a string (eg. "xyz" or "23xxyz") then
we would be better off comparing with eq and not trying to change them to numbers.
Hence:

```perl
42 ~~ "42.0x"  are compared using eq (this is called Any ~~ Str)
```

But what if the string is actually including a numish value, such as
"42" or "42.0" or even "42\n" to forgive those who forget to chomp()?

The following are all compared as numbers so they are true:

```perl
42 ~~ "42"
42 ~~ "42.0"
42 ~~ "42\n"
42 ~~ "42 "
```

This is called (Num ~~ numish)

There is a strange thing though, and I am not yet sure what is
its purpose but if both are numish then they are compared as strings,
and this will yield false:

```perl
"42" ~~ "42.0"
```

I have a posted a question regarding this on
[PerlMonks](http://perlmonks.org/?node_id=658876) where
you might find the answer.

But ~~ can do more. If one of the values in an == or eq is undef,
Perl will complain about that. Smart Matching on the other hand
understands that an undef is just an undef. So if one of the
values is undef then ~~ checks if the other one is undef too using
defined();

So these are false:

```perl
3 ~~ undef
"x" ~~ undef
```

While this is true:

```perl
undef ~~ undef
```

In addition one can provide a regular expression on
one side and then ~~ will apply the regex so one can write
either of these without any success:

```perl
"Perl 5.10" ~~ /Moose/
/Moose/ ~~ "Perl 5.10"
"Perl 5.10" ~~ qr/Moose/
qr/Moose/ ~~ "Perl 5.10"
```

<hr>

There are more interesting things though.

* What if one of the given values is not a real scalar?
* What if that is actually a reference to an array?

The smart match will do The Right Thing, it will check if the given scalar value is
the same as one of the elements in the Array.  (Str ~~ Array)

```perl
"Moose" ~~ [qw(Foo Bar Baz)]         is false
"Moose" ~~ [qw(Foo Bar Moose Baz)]   is true
```

The way the individual values are compared is based on the type of the scalar.
So if the scalar is a string all the values of the array are compared to the
string using "eq" while if the scalar is a number, all the comparisons will
be done by "==".

(Str ~~ Array   and    Num ~~ Array  in the documentation)

So

```perl
42 ~~ [23, 17, 70]          # false
42 ~~ [23, 17, 42, 70]      # true
42 ~~ [23, 17, "42\n", 70]  # true
42 ~~ [23, 17, "42 ", 70]   # true

42 ~~ [23, 17, "42x", 70]   # in 5.12 this was true with a warning
                            # Argument "42x" isn't numeric in smart match
                            # in 5.14 this is false and no warning
```

I am not fully convinced that the last one is really good, but that's the behavior.
If you would like to read more about that here is the
[PerlMonks](http://perlmonks.org/?node_id=658640) post about that issue.

So that actually means we now have an operator to check if an individual scalar
is represented in an array. It still slower than a hash lookup but it is faster
than a grep that most people use. It is definitely easier to write.

Similarly we can have a hash reference instead of one of the values and
~~ will check if the given scalar is one of the keys in the hash:
That is, using exists();     (Any ~~ Hash)

```perl
'a' ~~ {a => 19, b => 23}        true
42  ~~ {a => 19, b => 23}        false
```

But that is a bit less interesting in this context.

As a side note, instead of reference to Array or reference to Hash
you can actually put there the real Array or the real Hash
(but not a simple list) so this works and it is true:

```perl
my @a = (2, 3);
say 3 ~~ @a ? "T" : "F";
```

but this did not work in 5.10.

```perl
say 3 ~~ (2, 3) ? "T" : "F";
```

It works in 5.14 though.

The obvious question is then, what happens when both sides are
complex data structures Arrays or Hashes?

With Arrays, it will check if each element is the same  (Array ~~ Array)

```perl
["Foo", "Bar"] ~~ ["Foo", "Bar"]          is true
["Foo", "Bar"] ~~ ["Foo", "Bar", "Baz"]   is false
[1,2,3] ~~ [1,2,3]                        is true
```

With hashes it checks if the keys are identical  (Hash ~~ Hash)

This used to work in 5.10 but gives a syntax error in 5.14:

```perl
{Foo => 19, Bar => 23} ~~ {Foo => 23, Bar => 19}     is true
```

and the checking is done in any deep structure:

```perl
["Foo", ["Bar", "Baz"]] ~~ ["Foo", ["Bar", "Baz"]]
```

There are several more cases but even this was probably too much for an introduction.

<hr>

To get more details search for <i>"Smart matching in detail"</i>
after  typing **perldoc perlsyn** on the command line
- you do have 5.10 installed already, don't you,
or after browsing to the [perlsyn](http://perldoc.perl.org/perlsyn.html) page.

## Conclusion

I don't recommend the general usage of the stand-alone smart-match operator in perl 5.10 or 5.12.
I might consider it when we can require 5.14.



