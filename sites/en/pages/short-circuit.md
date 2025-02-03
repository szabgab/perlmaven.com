---
title: "Short-circuit in boolean expressions"
timestamp: 2014-09-30T10:30:01
tags:
  - or
  - open or die
  - sort
published: true
books:
  - beginner
author: szabgab
---


Short-circuit means that an expression returns a value before evaluating all the parts in the expression. There are several
areas where this can apply. Here we take a look at boolean expressions. Statements with `and`, `or`, and `not` keywords combined.

When there is a complex boolean expression Perl will execute it according to the
[Operator Precedence and Associativity](https://metacpan.org/pod/distribution/perl/pod/perlop.pod#Operator-Precedence-and-Associativity),
and will return some kind of a [true or false](/boolean-values-in-perl) value.

If it finds the final answer before it calculated the whole expression, it will return immediately.


Let's see a real-life example:

{% include file="examples/my_money_my_salary.pl" %}

This code will check if I have a lot of money (some currency) or if I earn a nice monthly sum. If either of this is true,
it will print that <b>I can live well</b>.

That expression is nice, and I check this every time there is a "salary review" at my employer.

But frankly I expect at every "salary review"  I get a raise. I am not greedy, I am ok with a raise of 1.
So I rewrite the expression to use `++`, the auto-increment operator:

{% include file="examples/my_money_my_salary_inc.pl" %}

Of course I check this every few hours, so my salary is raised quite often, but as I said, I am not greedy.


At this point I don't have a lot of money and my salary is not high enough so I don't see anything printed.

Then one day I win a lot of money in the lottery. From that day I start to "live well". I know because I saw it
printed to the screen.

I also keep working as I actually like my work and I keep running the above code as I like to see that "I can live well.".

The one day I lose all the money I had in the bank account, and I have to go back to live off my salary.

But no worry, after all it must have grown a lot since the last time I relied on it.

<b>Except that it didn't.</b>

My salary stayed the same as it was the day I won the lottery.

The reason is the short-circuit. Perl will evaluate the above expression from left to right. First it will check if
the `$my_money &gt; 1_000_000`. When this returned false (before I won the lottery), it checked the other side of
the `or` operator as well. When it executed the `$my_salary++ &gt; 10_000` expression, it also
executed the `++` auto-increment operator and my salary got one bigger.

As the second expression was also false, and because `false or false` is `false`, that's
what the expression returned.

Once I won on the lottery, the first part of the boolean expression `$my_money &gt; 1_000_000` became true.
At that point perl noticed that it does not matter what the second expression will return, the whole expression
will always be true. That's because both `true or false` and `true or true` will return `true`.
If the second expression won't make a difference in the end-result then perl, as a matter of optimization, won't
even bother to execute it. This is what <b>short-circuit</b> means.
Unfortunately for us, this also means that the auto-increment won't be executed either and as long as I have "a lot of money"
I won't get a salary raise.

Some people might think this is the right thing to happen, but I think the salary should reflect the actual performance
of the employee and not her wealth, or lack of it.

In this case we might think that short-circuit bit us. Actually, what bit us was the use of `++`, the auto-increment
operator, inside another expression. While in certain expression this work well, one should be very careful to avoid any
side-effects. It can literally cost you money...


## open or die

Perl actually has a well known expression called `open or die` where we use the short-circuit behavior of the
`or` operator. When we [open a file for reading](/open-and-read-from-files)
we normally have an expression like this:

```perl
open(my $fh, '&lt;', $filename) or die "Could not open file '$filename'\n";
```

This is a boolean expression with the `or` operator, but without an `if` statement, and without anything
that checks the result. That's totally acceptable in Perl.

In this case too perl will first execute the left side of the `or` operator and the it will execute the right side
only if the left side failed. So if the `open` call was successful, then the `die` will <b>not</b> be called
and the statement on the next line gets executed.

If, on the other hand `open` fails and returns false, then the boolean expressing needs to "check" the expression
on the right side of `or` which will call `die` that will [throw an exception](/die).


## sort

When we are sorting with two sorting conditions e.g. we sort the strings according to length, and the
strings with equal length we sort according to the ASCII table, we also use the short-circuit of the `or` operator:

{% include file="examples/sort_short_circuit.pl" %}

Here for every two strings in `$a` and `$b`, we first compare their length using the
spaceship-operator. If they differ in length the result will be either 1 or -1. In either case
that's a [true](/boolean-values-in-perl) value in Perl. Because the expression before the `or`
operator is true, the second part is not checked and the expression returns the value created by the first expression.
1 or -1.

On the other hand, if the two string are the same length then the first expression will return 0. This is
[false](/boolean-values-in-perl) in Perl and so the second expression has to be evaluated as well.
Whatever it returns will be returned by this expression.


