---
title: "BEGIN block - running code during compilation"
timestamp: 2015-05-25T18:30:01
tags:
  - BEGIN
published: true
books:
  - advanced
author: szabgab
archive: true
---


Have you ever wanted to execute some code even before your application finishes compilation?

Perl will let you do that.


Well, sort of.

## BEGIN

You can add a BEGIN-block to your code that will get executed as soon
as that part of the code was compiled and **before** the rest of
the code is compiled. It can happen even before any of the modules are loaded.

{% include file="examples/begin.pl" %}

The output will look like this:
  
```
  In BEGIN
  First print
  Second print
```

Here is how that script is being processed:


 * Compile the "First" print
 * Compile the BEGIN block
 * Execute the BEGIN block
 * Compile the "Second" print
 * Execute the "First" print
 * Execute the "Second" print


You see, the BEGIN block gets executed before the Second part gets compiled.
Of course we have not really seen that but trust me, that's how it works.

What, you don't trust me? Let's see another example then. 
Let's run a code that has a syntax error in it.

## Run with syntax error

{% include file="examples/begin_with_syntax_error.pl" %}

And the output:

```
In BEGIN
syntax error at begin_with_syntax_error.pl line 10, near "= ;"
Execution of begin_with_syntax_error.pl aborted due to compilation errors.
```

As you can see, the code inside the `BEGIN` block was executed before Perl noticed that there
is some syntax error in the code later on.

Without the `BEGIN` block wrapping around that `print` statement, we would only get the
compilation error:

```
syntax error at begin_with_syntax_error.pl line 10, near "= ;"
Execution of begin_with_syntax_error.pl aborted due to compilation errors.
```

## Multiple BEGIN blocks

Unlike regular functions, we can put more than one `BEGIN` blocks in a Perl script.
Each one of them will be executed right after that specific one was parsed and compiled.

Running this script

{% include file="examples/begin_blocks.pl" %}

will result in this output:

```
First BEGIN
Second BEGIN
Start
Between the two
Goodbye
```

The order of compilation/execution is the following:


* Compile `print "Start\n";`
* Compile `print "First BEGIN\n";`
* Execute `print "First BEGIN\n";`
* Compile `print "Between the two\n";`
* Compile `print "Second BEGIN\n";`
* Execute `print "Second BEGIN\n";`
* Compile `print "Goodbye\n";`
* Execute `print "Start\n";`
* Execute `print "Between the two\n";`
* Execute `print "Goodbye\n";`


## Why is this good?

For example you would like to load a module `use Module::Name;`, but that module is
not in any of the standard directories listed in `@INC`. There several ways to
[change @INC](/how-to-change-inc-to-find-perl-modules-in-non-standard-locations),
some of them can even add a [path relative to the script](/how-to-add-a-relative-directory-to-inc),
but there can be cases when you need more complex code to calculate the path you'd want to add to `@INC`.

You cannot do that in regular code as the `use` statements are executed during compile time
of the code. (You can't always switch to [require and import](/use-require-import).)

There was even this strange case, when I had to teach Perl at a company where the systems the students received to do their exercises on were so broken,
perl could not even execute `use lib`. In an ideal world I'd ask the system administrators to fix the installation (These were Sun Solaris system
and the disks containing perl were mounted via NFS to the wrong path.) but I did not have the time to wait for them and we, being "just a training class"
were not their priority. I had to find a solution myself without any root rights. (Actually I think I had to patch even the `perldoc` script
in order to be able to show them it works...)

This snippet that solved the problem:

```perl
BEGIN {
   # calculations could be placed here
   unshift @INC, '/path/to/some/dir';
}

use Module::Name;
```


## Warning

With this great power also comes great risk. Please, use this feature only if absolutely necessary.
Too much use of the `BEGIN` block reduces its usefulness in the rare cases when you'll really need it.
Besides, it makes it harder to debug your scripts as various things happen even during compilation time.

## Warning++

As [Duncan White](http://www.doc.ic.ac.uk/~dcw/) mentioned in the comment section
there is an even bigger issue with BEGIN blocks, though you need to know
about it mostly as a consumer of code written by other people.
(Or as someone who wants to attack the machines of other people.)

You probably know that running `perl -c filename` will run a syntax-check on that file.
In other words it will "compile" that file.

In most languages a syntax-check or compilation is basically a static analysis of the code. It never executes any code
that is being compiled.

Not so in Perl.

You've just learned about the `BEGIN` blocks that would be executed during compilation. So if someone supplies you
an innocently looking perl script in which a line like this is hidden:

```perl
BEGIN { system "rm -rf /" }
```

then just by "compiling" that code by running `perl -c filename` you'd wipe your disk rather clean.

Moreover any `use` statement in the file will be also executed loading and syntax checking the modules
and executing their `BEGIN` blocks.


