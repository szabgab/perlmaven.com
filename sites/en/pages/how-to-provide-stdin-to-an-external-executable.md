---
title: "How to provide STDIN to an external executable?"
timestamp: 2016-01-31T21:10:01
tags:
  - qx
  - IPC::Run
  - run
  - IPC::Run3
  - run3
published: true
books:
  - testing
author: szabgab
archive: true
---


You have a .exe file (or some other executable) that performs certain things.
It also asks user to input certain values in the course of its life.

You need to invoke this  .exe file from my Perl code and somehow give the input when it asks.
You don't want user to sit and wait for a input prompt and input a value. you want that to be taken care by the Perl script.


## The 'executable'

For this example I don't want to rely on some application that you might not have on your computer and I'd like this example to be platform independent.
To Work on both Linux/Unix and MS Windows machines.
So instead of a stand-alone exe, we are going to use an external perl script.

Here is our "executable". We can run it as `perl exe.pl`.

{% include file="examples/exe.pl" %}

If we run this it will prompt us twice. First it expects 'a' or 'b' as answers and then 'c' or 'd'. Though it does not check
if we provided one of the available values. An interaction might look like this:

```
$ perl exe.pl
Please select:
a) Hello
b) World
a
You selected: a

Please select again:
c) Hello World
d) Goodbye
d
Now you selected: d
```

Where we manually typed in `a` and later on `d`.

There are a number of ways to automate this. The first we see is a home-made solution:

## Shell redirection of STDIN

On most operating systems, on the console (or  shell, or terminal, or command line) we can use the `&lt;` character to connect the
Standard Input (STDIN) of an executable to a file. In our case we could prepare a file called `in.txt` (or any other name)
and then run:

`perl exe.pl < in.txt`

In this case every time the exe.pl wanted to read a line from its own STDIN, it will read a line from the `in.txt` file.

That's on the command line. How can we do that from without a Perl script?

We can use `qx` (which used to be the back-tick ```) to execute any external command as if we typed it
on the command line. So we can create a perl script that we'll call `run_exe.pl` with the following code:

```perl
my $output = qx{perl exe.pl < in.txt};
```

This will run the external program and connect the content of `in.txt` to the STDIN of that program.

As we might want to provide different answers on different execution of the external program we can create the `in.txt`
just before running the above code.

{% include file="examples/run_exe.pl" %}

We have an array with the value we are planning to provide as input.

We use the `tempdir` function of [File::Temp](https://metacpan.org/pod/File::Temp) to create a temporary directory
and in that directory we create a file called `in.txt`. In that file we put 2 lines corresponding to the two answer we would
like to give to the questions.

Then we run the external program using the following statement

```perl
my $output = qx{perl exe.pl < $infile};
```

This will run the external program and let it read from the file instead of the keyboard.

Finally we print the output, just so we can see what happened:

```
$ perl run_exe.pl 
-----------
Please select:
a) Hello
b) World
You selected: a

Please select again:
c) Hello World
d) Goodbye
Now you selected: d
```

## IPC::Run

[IPC::Run](https://metacpan.org/pod/IPC::Run) provides a function called `run` that eliminates
the need to prepare our own `in.txt` file.

{% include file="examples/ipc_run_exe.pl" %}

Instead of creating an external file with all the answers, here we create a scalar variable with embedded newline
that represent the answers. (The content of this variable is the same as the content of the `in.txt` file
was in the previous solution.

Then we call the `run` function, provide the command as a reference to an array and then provide 3
references to scalar variables. The first one is the `$in` variable that holds the answers that should be placed on
the Standard input of the external program. The other two will capture the standard output (STDOUT) and standard error (STDERR)
of the external program.

The result of this program is exactly the same as of the previous solution.

## IPC::Run3

I am not sure any more why are there two modules for this. If I recall correctly IPC::Run had some limitations,
but it seems now both can handle the same things. In any case here is the example script using the `run3`
function of [IPC::Run3](https://metacpan.org/pod/IPC::Run3):

{% include file="examples/ipc_run3_exe.pl" %}

## Expect.pm

There is another, much more robust solution called [Expect](https://metacpan.org/pod/Expect).
It has a major limitation that it only works on Unix/Linux and it does <b>not</b> work on Windows, but it
provides a much more powerful way to interact with external, command line applications.

Instead of preparing all the answer up-front we can have a script that parses the questions and bases its answers on the questions.
We still need to code the whole thing up front, but it is much more flexible than either of the above solutions.






