---
title: "while loop"
timestamp: 2013-03-12T12:45:51
tags:
  - while
  - while (1)
  - loop
  - infinite loop
  - last
published: true
books:
  - beginner
author: szabgab
---


In this episode of the [Perl tutorial](/perl-tutorial) we are going to see <b>how does the while loop work in Perl</b>.


{% include file="examples/while_loop.pl" %}

The `while` loop has a condition, in our case checking if the variable $counter is larger than 0,
and then a block of code wrapped in curly braces.

When the execution first reaches the beginning of the while loop it checks if the condition is
[true or false](/boolean-values-in-perl).
If it is `FALSE` the block is skipped and the next statement, in our case printing 'done' is executed.

If the condition of the `while` is `TRUE`, the block gets executed, and then the execution goes back
to the condition again. It is evaluated again. If it is false the block is skipped and the 'done'
is printed. If it is true the block gets executed and we are back to the condition ...

This goes on as long as the condition is true or in sort-of English:

`while (the-condition-is-true) { do-something }`

## Infinite loop

In the above code we always decremented the variable so we knew that at one point the condition will become false.
If for some reason the condition never becomes false you get an `infinite loop`. Your program will be stuck in a
very small block it can never escape.

For example if we had forgotten to decrement the `$counter`, or if we were incrementing
it while still checking for a lower boundary.

If this happens by mistake, that's a bug.

On the other hand, in some cases using an infinite loop <b>on purpose</b> can make our program more simple to write, and
easier to read. We love readable code!
If we would like to have an infinite loop we can use a condition that's always true.

So we can write:

```perl
while (42) {
  # here we do something
}
```

Of course people lacking the
[proper cultural reference](http://en.wikipedia.org/wiki/Answer_to_Life,_the_Universe,_and_Everything#Answer_to_the_Ultimate_Question_of_Life.2C_the_Universe.2C_and_Everything_.2842.29)
will wonder why 42 so the more generally accepted, albeit slightly boring way is to always use the number 1 in infinite loops.

```perl
while (1) {
  # here we do something
}
```

Naturally, seeing that the code has no escape from this loop, one will wonder how can that program ever end without
killing it from the outside?

For that, there are a number of ways.

One of them is calling the `last` statement inside the while loop.
That will skip the rest of the block and won't check the condition again.
Effectively ending the loop. People usually put it in some kind of a condition.


{% include file="examples/infinite_while_loop.pl" %}

In this example we ask the user a question and hope he will be able to
answer it using the correct case. He will be stuck with this question
forever if he cannot type 'Perl'.

So the conversation might go on like this:

```
Which programming language are you learning now?
$ Java
Wrong! Try again!
Which programming language are you learning now?
$ PHP
Wrong! Try again!
Which programming language are you learning now?
$ Perl
done
```

As you can see once the user typed the correct answer, `last` was called, the rest of the block
including `say 'Wrong! Try again!';` was skipped and the execution continued after the
`while loop`.


