---
title: "$_ the default variable of Perl"
timestamp: 2012-08-14T20:41:51
tags:
  - Perl
  - $_
  - scalar
  - default
  - variable
  - topic
published: true
author: szabgab
---


There is a strange scalar variable called `$_` in Perl, which is the
`default variable`, or in other words the **topic**.

In Perl, several functions and operators use this variable as a default,
in case no parameter is explicitly used. In general, I'd say you should **NOT**
see `$_` in real code. I think the whole point of `$_` is that you don't
have to write it explicitly.

Well, except when you do.


Having a default variable is a very powerful idea, but using it
incorrectly can reduce the readability of your code.

Check out this script:

```perl
use strict;
use warnings;
use v5.10;

while (<STDIN>) {
   chomp;
   if (/MATCH/) {
      say;
   }
}
```

This is exactly the same as:

```perl
use strict;
use warnings;
use v5.10;

while ($_ = <STDIN>) {
   chomp $_;
   if ($_ =~ /MATCH/) {
      say $_;
   }
}
```

I would never write the second one, and I'd probably write the first one only
in a very small script, or in a very tight part of the code.

Maybe not even there.

As you can see, in a `while` loop, when you read from a file handle,
even if that's the standard input, if you don't assign it explicitly
to any variable, the line that was read will be assigned to `$_`.

`chomp()` defaults to work on this variable, if no parameter was given.

Regular expression matching can be written without an explicit string,
and even without the `=~` operator. If written that way, it will work on the
content of `$_`.

Finally `say()`, just as `print()`, would print the content
of `$_`, if no other parameter was given.

## split

The second parameter of `split` is the string to be cut in pieces.
If no second parameter is given, split will cut up the content of `$_`.

```perl
my @fields = split /:/;
```

## foreach

If we don't supply the name of the iterator variable to `foreach`,
it will use `$_`.

```perl
use strict;
use warnings;
use v5.10;

my @names = qw(Foo Bar Baz);
foreach (@names) {   # puts values in $_
    say;
}
```

## Assignment in condition

There are some cases when we implicitly use `$_` by mistake.

Some experts might use this kind of code deliberately,
but when this is written by a newbie, or a mere mortal, it is just a bug.

```perl
if ($line = /regex/) {
}
```

You see, instead of the regex operator: `=~` we used here the plain assignment operator: `=`.
This is, in fact the same as

```perl
if ($line = $_ =~ /regex/) {
}
```

It takes the content of `$_`, executes the pattern matching on it,
and assigns the result to `$line`. Then checks if the content of $line is true or false.

## Explicit $_

I mentioned earlier I recommend **not** using `$_` explicitly. Sometimes I see people writing code like this:

```perl
while (<$fh>) {
  chomp;
  my $prefix = substr $_, 0, 7;
}
```

I think, once you use a statement in perl that forces you to explicitly write out `$_`,
such as `substr` in our case, you should go all the way and use a more meaningful name.
Even if that means more typing:

```perl
while (my $line = <$fh>) {
  chomp $line;
  my $prefix = substr $line, 0, 7;
}
```

Another bad example I often see:

```perl
while (<$fh>) {
   my $line = $_;
   ...
}
```

This probably happens to people who do not understand the interaction between
the `while` statement, the read operator on the file handle and `$_`.

This could be written in a more simple way directly assigning to the `$line`
variable.

```perl
while (my $line = <$fh>) {
   ...
}
```

## List of uses of $_

I've started to put together a list of places that default to **$_**:

* [ord](/ord)

## Exceptions

There are several cases where you can't really avoid, and you have to use `$_`
explicitly. These are the [grep](/filtering-values-with-perl-grep)
and [map](/transforming-a-perl-array-using-map) function, and the
other similar ones, such as [any](/filtering-values-with-perl-grep).

## Comments

short and up to the point description

<hr>

I use `foreach (my $inputLine = <stdin>)` and B::Lint still complains `Implicit use of $_ in foreach`.

That should be while and not foreach.
<hr>

I'm learning Perl slowly from your website, I'm new to scripting
I have this line in one of the script "print "$number\t", $name, "\n" if($number =~ /^[0-9]/) ;" when I run it prints the results on screen all good, but I want to modify it to print the results to a file ( results.csv or results.txt)
I would really appreciated if you can help as this is my first month of scripting

foreach( @numberCsv ){
my $number=$$_[0];
my $name=$names{ $classifier->($number) };
print "$number\t", $name, "\n" if($number =~ /^[0-9]/) ;
}



You need open a file for writing https://perlmaven.com/begin... and then print to the filehandle instead of just print.

You might also want to use a named variable instead of $_
foreach my $row (@numberCsV) {
}





