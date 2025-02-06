---
title: "Array references in Perl"
timestamp: 2015-12-09T07:30:01
tags:
  - "@"
  - "\\@"
  - "$#"
  - "$#$"
  - "@{ }"
  - "ARRAY(0x703dcf2)"
  - Data::Dumper
published: true
books:
  - advanced
author: szabgab
archive: true
---


In this part of the [Perl Tutorial](/perl-tutorial)
we are going to learn about <b>array references</b>.


There are two main uses of array references. One is to make it easy
to [pass more than one arrays to a subroutine](/passing-two-arrays-to-a-function),
the other is to build arrays of arrays or other multi-dimensional data structures.

## Creating a reference to a Perl array

If we have an array called `@names`, we can create a reference
to the array using a back-slash `\` in-front of the variable:
`my $names_ref  = \@names;`.

We use the _ref extension so it will stand out for us
that we expect to have a reference in that scalar. This
is not a requirement and Perl does not care,
but it might be useful while learning about them.

If we now call `print $names_ref;` we'll see the following:

```
ARRAY(0x703dcf2)
```

That is the address of the `@names` array in memory
with the clear notion that it is the location of an ARRAY.

The only thing you can do with an array reference, is to get back the original
array.

(If you are a C programmer, don't even think about pointer arithmetic.
You can't do that in Perl.)

Basically, if you see such value printed somewhere, you know that
the code is accessing a reference to an array and that you should probably
change the code to access the content of that array.


## Dereferencing an array

If you have a reference to an array and if you would like to access
the content of the array you need to <b>dereference</b> the <b>array reference</b>.
It is done by placing the `@` symbol (the sigil representing arrays)
in-front of the reference.

This can be written either wrapped in curly braces: `@{$names_ref}`
or without the curly braces: `@$names_ref`.

You could also put spaces around the name and write: `@{ $names_ref }`.
This usually makes things nicer, and more readable.

You can then use this construct to access the array.
For example: `print "@{ $names_ref }";`

A full script might look like this:

{% include file="examples/array_ref.pl" %}

## Individual elements

If we have a reference to an array we can also easily access the individual elements.

If we have the array `@names` we access the first element using `$names[0]`.
That is, we replace the `@`-sign with a `$`-sign and put the index in 
square brackets after the name.

With references we do the same. If we have the array reference
`$names_ref` then the original array is represented by `@{$names_ref}`.
Replace the `@` by the `$` and put the index after the thing in square brackets.
`${$names_ref}[0]` or `$$names_ref[0]` if you like the brace less style.

Unfortunately both of these are a bit hard to read, but luckily Perl provides another, 
much clearer syntax for this: `$names_ref->[0]`.
In this code, on one hand we eliminated the double `$` signs and on the other hand
we represent the dereferencing by a simple arrow.

That's about it learning the basics of array references in Perl.

## Array references cheat sheet

Given an array `@names` and an array reference called `$names_ref`
that was created using `my $names_ref = \@names;` the following table shows
how can we access the whole array, individual elements of an array and the length of
an array in its normal array representation and the corresponding array reference
representation:

```
                    Array                Array Reference
Whole array:        @names               @{ $names_ref }
Element of array:   $names[0]            ${ $names_ref }[0]
                                         $names_ref->[0]
Size of array:      scalar @names        scalar @$names_ref
Largest index:      $#names              $#$names_ref
```

But you really don't want to use `$#$names_ref` among people....

## Data::Dumper for debugging

When you have an array or an array reference, the best way to visualize it
during a debug-by-print session is by using one of the data dumper modules,
for example the built-in [Data::Dumper](https://metacpan.org/pod/Data::Dumper) module.

{% include file="examples/dump_array.pl" %}

And the output is:

```
$VAR1 = [
          'foo',
          'bar',
          'moo
and
moose'
        ];
```

This clearly shows the individual elements even if some of the elements have spaces or newlines embedded in them.

Exactly the same could be done if we already had an array reference in our hand:

{% include file="examples/dump_array_ref.pl" %}


## Passing two arrays to a function

If you want to write a function that gets [two or more arrays](/passing-two-arrays-to-a-function)
you have to use references. Let's say you'd like to write a function that adds the elements of two arrays, pair-wise.

If you call `add(@first, @second)`, on the receiving end the two arrays will be flattened
together into `@_` and you won't be able to tell them apart.

Better to pass two reference like this: `add(\@first, \@second)` and then de-reference
them inside the function:

```perl
sub add {
     my ($first_ref, $second_ref) = @_;
     ...
}
```

## Comments

This also works to get a single value out of an array reference:

print "@{ $names_ref }[0]\n";    # Foo
print "@$names_ref[0]\n";    # Foo

---

It works, but it is not correct.

---

Thank you for your reply. Since it compiles, runs and gives the correct result, what is the danger in using it? Under which circumstance does it go wrong? And since it is syntactically correct, what is it that this statement expresses?

<hr>

Hello,

i'm a beginner with Perl and i'm trying to write a script to

1-read directory files (~ files

2-run external program on each with mutiple arguments (naturally entered on command line). both are running under cygwin.

the perl script reach the program but it comes back with statment, unknown options reun -h (for help menu)

I really appreciate any idea on how to put the arguments for the program in the perl script

use strict;
use warnings;
#the directory path asssigned to a variable
my $directory = '/home/genomes';
#opening the directory or die
opendir ('$mother', "$directory") or die "Could not open 'genomes' for reading \n";
#read different file
my @sequencefiles = readdir '$mother';
foreach my $sequencefiles(@sequencefiles){
#if it is a sequence file
if ($sequencefiles =~ m/.fna/){
#arguments for prodigal
my $name = $sequencefiles =~s/\fna//; # file without extyension
my $input = '-i $sequencefiles';
my $output = '-o $name.gbk';
my $cdna = '-d $name.mrna';
my $trans = '-a $name.faa';
my $start = '-s $name.start';
my @cmd= '/usr/local/bin/prodigal.exe';
push @cmd,'$name';
push @cmd,'$input';
push @cmd,'output';
push @cmd,'cdna';
push @cmd,'start';
system(@cmd) ;

}
}


---

Look for argv in the archive:  https://perlmaven.com/archive

<hr>

is it possible to do this in one line:
my @names = ('foo', 'bar', "moo\nand\nmoose");
my $names_ref = \@names;

Can I do the following?
my $names_ref = \('foo', 'bar', "moo\nand\nmoose");

<hr>

I am trying to write a sub (amelyik) which returns the last element of an array (without pop-ing).

Surely I will pass to the function a reference. But how do I get the $# last index value given the reference? (köszi) (Meanwhile a work-around: I am going pass an other parameter to the function: the size of array.)

---
Sorry, I just saw the answer in your cheat-sheet section.

<hr>

How do we initialize an array reference?


