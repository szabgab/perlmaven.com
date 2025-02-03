---
title: "END block - running code after the application has ended"
timestamp: 2015-05-27T01:00:01
tags:
  - END
published: true
books:
  - advanced
author: szabgab
archive: true
---


Have you ever dreamt to be able to do something after your program exited?

Perl has the tools for you


## END with exception

Let's see an example:

{% include file="examples/end.pl" %}

If we run the above script the output will look like this:

```
hello world
Illegal division by zero at end.pl line 8.
in the END block
```

What happens here is that the line `my $z = $x / $y;` threw an exception.
There was no `eval` statement, nor any form of try-catch statement to capture the exception
so the script will die. Before doing so however, it will still execute the code that was placed
in an `END` block.

Of course you might say, exceptions should be caught by some `eval` block,
and generally speaking you are right.

So let's see another example where we call the `exit()` function.

{% include file="examples/end_with_exit.pl" %}

Running this script will print the following:

```
hello world
in do_something
in the END block
```

As you can see there was no exceptions here. You would not be able to use `eval` to catch it,
but still the code in the `END` block was executed. After `exit()` was called.
None of the other lines (neither inside the function, nor outside of it) were executed, but the
code in the `END` block was.

Actually the same would have happened regardless of where the `END` block was placed.

So this script would have the exact same result:

{% include file="examples/end_with_exit_again.pl" %}

## Multiple END blocks

Unlike regular subroutines, you can put multiple `END` blocks in a script. The surprising thing is
that they will be executed in the reverse order. The last one will be executed first.

Look at this example:

{% include file="examples/end_with_multiple_blocks.pl" %}

And the results running it looks like this:

```
hello world
in do_something
in the second END block
in the first END block
```

Here you can see that the "second" was executed and printed before the "first".

## END blocks and modules

We can also put END blocks in modules.

This module has an `END` block in it.

{% include file="examples/EndModule.pm" %}

This script has two `END` blocks. One of them before the `use` statement,
the other one after the `use` statement.

{% include file="examples/end_with_module.pl" %}

When executing this code, we get the following output:

```
hello world
in some_code
in do_something
in the END block
in END of EndModule
in the END block before use
```

After `exit()` is called in the `do_something()` function, the `END` blocks get executed
in the reverse order of their appearance. The one that was in the module itself is executed between the two `END` blocks
in the main code, because the `use` statement is physically between those two `END` blocks.

## When is this useful?

For example if you want to do some clean-up before exiting the script.
Especially if your code-base has several exit-points, and maybe even a few places where uncaught exceptions might happen.

For example, when I try to test a client-server application, I might have a single script that launches the server in the background,
then acts as the client. Before exiting the client it should make sure the server was shut down. This can be easily accomplished
in an `END` block.

Other cases might include the creation of some temporary data in a database. We might want to make sure that
no matter how our script exits we remove the temporary data.

Maybe even more interesting is when you are creating a module. Then too you might want to make sure that no matter how the user of this
module will exit the main script - something you cannot control - certain pieces of code will be executed.
Then you can put an `END` block in your module and that will make sure that code is always executed.

You might think of it as sort-of a destructor, except that this is not called when an object is destructed. This is called
when the whole script is shutting down.

