---
title: "String operators: concatenation (.), repetition (x)"
timestamp: 2014-05-01T01:30:01
tags:
  - x
  - .
  - ++
published: true
books:
  - beginner
author: szabgab
---


In addition to the [numerical operators](/numerical-operators) Perl has two operators specially used for strings. 
One of them is `.` for concatenation, and the other is `x` (the lower-case X) for repetition.


```perl
use strict;
use warnings;
use 5.010;

my $x = 'Hello';
my $y = 'World';

my $z = $x . ' ' . $y;
say $z;
```

Running the above script will yield the following output:

```
Hello World
```

It attached the string from the variables and the literal empty-space thing into one new string.

Actually in the above case we did not have to use the `.` concatenation to achieve this result.
As Perl provides scalar variable interpolation in string, we could just write:

```perl
my $z = "$x $y";
```

and that would yield the same result.

## When interpolation is not the answer

There are of course cases when the concatenation cannot be replaced by interpolation. Take for example this code:

```perl
use strict;
use warnings;
use 5.010;

my $x = 2;
my $y = 3;

my $z = 'Take ' . ($x + $y);

say $z;
```

It will print

```
Take 5
```

On the other hand, if we replace the concatenation with interpolation:

```perl
my $z = "Take ($x + $y)";
```

We get:

```
Take (2 + 3)
```

You might have noticed that I also changed the quotes from single-quote to double-quote when I wanted to
use interpolation. We'll discuss this in a separate article.

## x the repetition operator

The `x` operator expects a string on its left-hand side and a number on its right hand side.
It will return the string on the left hand side repeated as many times as the value on the right hand side.

{% include file="examples/string_repetition.pl" %}

yields:

```
Jar Jar 
Jar Jar Binks
```


I think this operator is rarely used, but it can be quite useful in those rare cases.
For example when you want to add a line the same length as the title of your report:

{% include file="examples/string_repetition_width.pl" %}

Here the line we print under the title is exactly the same lengths (in number of characters) as the title itself.

```
$ perl report.pl 
Please type in the title: hello
hello
-----

$ perl report.pl 
Please type in the title: hello world
hello world
-----------
```

## ++ on a string

Although one might expect the auto-increment operator (`++`) to
[work only on numbers](/numerical-operators), Perl has a special use for the `++` operator
on strings.

It takes the last character and increments it by one according to the ASCII table restricted to letters.
Either lower-case letter or upper-case letters. If we increment a string that ends with the letter
'y' it will change it to 'z'. If the string ends with 'z' then an increment will will change it to be
the letter 'a', but the letter to the left of it will be incremented by one as well.

```perl
use strict;
use warnings;
use 5.010;

my $x = "ay";
say $x;
$x++;
say $x;


$x++;
say $x;

$x++;
say $x;

$x--;
say $x;
```

The result is:

```
ay
az
ba
bb
-1
```

As you can see `--` does not work on strings.


## Comments

I am Vinay from INDIA and avid follower of your blog perl maven. Blog was really helpful and developing my perl scripting skills for which I am very thankful to you.

But, lately i am stuck in a problem. I want know how to convert a string into upper or lower case using string increment and decrement operator. I tried few various options but not quite converging on solution. I kindly request you to help me in this regard.


Hey Vinay,
You can try and use lc(your_string) for lower case and uc(your_string) for upper case, this is without string increments or decrements ofc.


