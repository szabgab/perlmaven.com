---
title: "Standard output, standard error and command line redirection"
timestamp: 2013-06-25T12:50:10
tags:
  - STDOUT
  - STDERR
  - /dev/null
  - $|
  - buffering
published: true
books:
  - beginner
author: szabgab
---


When you run a program on the command line it automatically has two separate output channels.
One of them is called **Standard Output**, the other is **Standard Error**.

By default both are connected to the screen (in the shell, terminal or command line window)
and thus they mix, but the user of the program can decide to separate them,
and **redirect** one or both of them to a file.


The idea is, that the regular output of the application goes to the Output channel,
and all the warnings and error messages go to the Error channel.

As a programmer you need to decide which output is considered being part of the regular
flow of your program. You will send that to the Standard Output channel. The rest, that
are the irregularities, will be sent to the Standard Error channel.

If the user wants to see only the regular output, they can redirect the error channel to a file
and examine it later, separately.

## How to print error messages?

In Perl, when a perl program starts, these two output channels are represented by two symbols:
`STDOUT` represents the Standard Output, and `STDERR` represents the Standard Error.

From within the Perl program, you can print to each one of these channels by putting
STDOUT or STDERR right after the `print` keyword:

```perl
print STDOUT "Welcome to our little program\n";
print STDERR "Could not open file\n";
```

(Please note, there is no comma `,` after the words STDOUT and STDERR in this expression!)

If you run this script (`perl program.pl`) you will see this on the screen:

```
Welcome to our little program
Could not open file
```

You won't see that they went to different output channels.

## Default output channel

Actually, you could even leave out the word `STDOUT` from the above script
and only write:

```perl
print "Welcome to our little program\n";
print STDERR "Could not open file\n";
```

When your perl script starts, STDOUT is set to be the **default output channel**.
This means any print operation that was not told specifically where to print, will
be printed to STDOUT.

## Redirecting Standard Output

(The below examples assume you use some bash compatible shell. Other shells might behave in a different way.)

As a user, without looking inside the code, you can separate the two channels:
If you run `perl program.pl > out.txt` the `>` symbol will **redirect**
the output channel to the file out.txt. So on the screen you will see only the
content of the Standard Error:

```
Could not open file
```

If you open the out.txt file (e.g. with Notepad, or vim or any other text editor)
you will see it has `Welcome to our little program` in it.

## Redirecting Standard Error

On the other hand if you run the script as `perl program.pl 2> err.txt`,
then the `2>` symbol will **redirect** the error channel to the file err.txt.

On the screen you will see this:

```
Welcome to our little program
```

If you open the err.txt file, it will have this content: `Could not open file`.

## Redirecting both

You can even redirect both channels at the same time using both symbols on
the command line.

Running the script as `perl program.pl > out.txt 2> err.txt`, the
screen will remain empty. All the content printed to the standard output
channel will be in the out.txt file, and all the content printed
to the standard error channel will be in the err.txt file.


In the above example, the files names out.txt and err.txt were totally arbitrary.
You can use any names there.

## /dev/null

On Unix/Linux system there is a special file called `/dev/null`.
It behaves like a black hole. Whatever is printed to that file will
disappear without any trace. The main use of this is when there is a program
and the user wants to throw away either the regular output or the error messages.

For example, you might have an application, one that you cannot change,
that spit tons of messages to the standard error channel.
If you don't want to see that on the screen you can
redirect it to a file. But if you do that, it can fill your disk quickly.
So instead, you would redirect the standard error to /dev/null and the operating
system will help you disregard all the "garbage".

`perl program.pl 2> /dev/null`

## null on MS Windows

On MS Windows the counterpart of `/dev/null` is just plain `nul`

`perl program.pl > nul` Would redirect the standard output to the nothingness,
and `perl program.pl 2> nul` would redirect standard error.

## Unix/Linux/Windows support?

The separate printing to STDOUT and STDERR inside Perl works on every
operating system, but the actual redirection might not. That depends
on how the operating system, and more specifically the shell (command line)
works.

Most of the above should work on all Unix/Linux systems as well as on MS Windows.
Specifically `/dev/null` is only available on Unix/Linux systems.

<h2 id="buffering">Order of output (buffering)

A slight warning:

Having this code:

```perl
print "before";
print STDERR "Slight problem here.\n";
print "after";
```

The output might look like this:

```
Slight problem here.
beforeafter
```

Please note, that both "before" and "after" both arrived to the screen **after** the error message.
Even though we expected "before" to be, well, before the error message.

The reason is, that by default, Perl buffers the output of STDOUT and does not
buffer STDERR. To turn off buffering use the magic stick called `$|`:

```perl
$| = 1;

print "before";
print STDERR "Slight problem here.\n";
print "after";
```

```
beforeSlight problem here.
after
```

Adding a newline to the string going to STDOUT usually also solves the problem:

```perl
print "before\n";
print STDERR "Slight problem here.\n";
print "after";
```

And the output looks even better:

```
before
Slight problem here.
after
```



## Comments

How to STDOUt to a display device? e.g. on a dual monitor, is it possible?

STDOUT is connected to the cmd or terminal window. It does not itself open or place a new window. So wherever you have your cmd/terminal open that's where STDOUT will be.
