---
title: "shift in Perl"
timestamp: 2015-12-17T18:55:56
tags:
  - shift
  - @ARGV
  - @_
published: true
books:
  - beginner
author: szabgab
---


The `shift` function in Perl will remove the first value of the array passed to it and return it.


```perl
my @names = ('Foo', 'Bar', 'Moo');
my $first = shift @names;
print "$first\n";     # Foo
print "@names\n";     # Bar Moo
```

Note, the array itself got shorter. The first element was removed from it!

## shift without parameters

In case no array is passed to it, `shift` has two defaults  depending on the location of `shift`.

If `shift` is outside any function it takes the first element of `@ARGV` (the parameter list of the program).

{% include file="examples/shift_argv.pl" %}

```
$ perl examples/shift_argv.pl one two
one
```

If shift is inside a function it takes the first element of `@_` (the parameter list of the function).


{% include file="examples/shift_in_sub.pl" %}

```
$ perl examples/shift_in_sub.pl one two
hello
```

Here `shift` disregarded the content of `@ARGV` and took the first element of `@_`, the array
holding the parameters passed to the function.

## Shift on empty array

If the array `shift` works on is empty, then `shift` will return `undef`.

Regardless if the array was explicitely given to it or implicely selected based on the location of `shift`.

See [video explaining shift and unshift](https://perlmaven.com/beginner-perl-maven-shift-and-unshift)
or the example [using shift to get first parameter of a script](https://perlmaven.com/beginner-perl-maven-shift).

## Comments

use strict;

use warnings;

sub something {

my $first = shift;

print "$first\n";

}

something($ARGV[0], $ARGV[1]);
What about this?

<hr>

Hi Gabor,
As a beginner of Perl scripting, I have been reading your tutorials for sometime now. I am always amazed by your simple and to the point explanation of complex concepts. I am not even a real coder- just a grad student making some boring tasks interesting by learning new and appropriate languages. Thanks for being supper clear and your dedication to help others. - Ze

I am glad I can help!

<hr>

What about shift with a hash reference?

if ( !checkusage(\%opts) ) {
usage();
}
sub checkusage {
my $opts_ref = shift;
...do something with $opts_ref
}

<hr>

Please I need your help:
I han been create the next variable:
my @dias=('2023-01-01','2023-01-02','2023-01-03');
my $cadena_promedio= "obtener_promedios(\\%HoH,";
foreach my $d (@dias){
$cadena_promedio.="\'$d\', ";
}
$cadena_promedio.=");";

&obtener_promedios(\\%HoH, '2023-01-01','2su023-01-02','2023-01-03',);

sub obtener_promedio{
my $HoH= shift;
my @dates= @_;
}

Please, what will be the value for the variables $HoH and @dates:

THANKS A LOT.
REGARDS


