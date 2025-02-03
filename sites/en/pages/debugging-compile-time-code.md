---
title: "Debugging compile time code (debugging BEGIN block, debugging module body)"
timestamp: 2019-05-06T14:30:01
tags:
  - -d
  - $DB::single
published: true
author: szabgab
archive: true
---


Using the debugger feature of Perl to <a href="/add-debugger-breakpoint-to-your-code">add a breakpoint to our code we
can even debug code that is executed during compilation.

Using the [BEGIN block](/begin) Perl allows us to write code that will be executed even before the rest
of the code is compiled. It is rarely needed, but it is a very powerful tool.

However if you try to use the built-in debugger of Perl you will notice that the first statement it stops
at is the first statement in your main code. By that time it already executed or tried to execute the BEGIN blocks.

How can you debug that code?


## Debug code in BEGIN-block

In this rather stupid example we have a few statements in the BEGIN block

{% include file="examples/begin_block_code.pl" %}

If I run this normally:

```
$ perl begin_block_code.pl
```

I get the expected output:

```
Hello World 42
DONE
```


If I run it with the debugger:

```
$ perl -d begin_block_code.pl
```

I get the debugger prompt, but as you can observe, it already printed the "Hello World 42" that comes from the BEGIN
block.

{% include file="examples/begin_block_code_1.txt" %}

Adding an enabling the following line:

```
$DB::single = 1;
```

as the first statement of the BEGIN-block will tell the debugger, to stop at that point and let you debug:

```
$ perl -d begin_block_code.pl
```

{% include file="examples/begin_block_code_2.txt" %}

Here you can see that the next statement to be executed is the first statement of the BEGIN-block.

## Debugging code in the body of a module

In this example we don't have a `BEGIN` block. We have something much less obvious. We have a module that has
code outside of any function definition:

{% include file="examples/Factorial.pm" %}

We then have a script that uses that module.

{% include file="examples/use_factorial.pl" %}

The `use lib '.';` is necessary as recent version of Perl have removed the current directory from the list of
places where perl looks for modules.

Then we print a line "before" we "use" the module.

Running the script gives us this:

```
Doing some stuff here
Doing some other stuff here
Before use
24
```


The key issue here is that the code in the body of the module, the two print statements, were executed before the
print-statemen that is located before the "use"-statement.

How can this happen?

A [use statement adds an implicit BEGIN-block](/use-require-import) that is executed during compile time.

Just as with explicit BEGIN-blocks we can add

```
$DB::single = 1;
```

Then if we run the code using the buit-in debugger:

```
perl -d use_factorial.pl
```

It will pause execution at that assignment statement. Then we can use the regular instructions of the debugger
to look around and to make progress.


