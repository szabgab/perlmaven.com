---
title: "Barewords in Perl"
timestamp: 2013-01-15T10:45:56
tags:
  - bareword
  - strict
published: true
books:
  - beginner
author: szabgab
---


`use strict` has 3 parts. One of them, also called `use strict "subs"`,
disables the inappropriate use of <b>barewords</b>.

What does that mean?

A bareword generally refers to a sequence of characters that is suitable for an identifier (i.e. A-Za-z_A-Za-z_0-9).
The strict pragma bans most uses of barewords by default, but they still live on as the names of global filehandles,
keys that don't require quoting in hashes, and things that are auto-quoted by the fat comma operator. In the latter
two cases the set of allowed characters includes a leading hyphen.


Without this restriction code like this would work and print "hello".

```perl
my $x = hello;
print "$x\n";    # hello
```

That's strange in itself as we are used to put strings in quotes but
Perl by default allows <b>barewords</b> - words without quotes - to behave like strings.

The above code would print "hello".

Well, at least until someone added a subroutine called "hello" to the top of
your script:

```perl
sub hello {
  return "zzz";
}

my $x = hello;
print "$x\n";    # zzz
```

Yes. In this version Perl sees the hello() subroutine, calls it and assigns
its return value to $x.

Then, if someone moves the subroutine to the end of your file,
after the assignment, Perl suddenly does not see the subroutine
at the time of the assignment so we are back, having "hello" in $x.

No, you don't want to get in such a mess by accident. Or probably ever.
Having `use strict` in your code Perl will not allow that bareword
<b>hello</b> in your code, avoiding this type of confusion.

```perl
use strict;

my $x = hello;
print "$x\n";
```

Gives the following error:

```
Bareword "hello" not allowed while "strict subs" in use at script.pl line 3.
Execution of script.pl aborted due to compilation errors.
```

## Good uses of barewords

There are other places where barewords can be used even when `use strict "subs"`
is in effect.

First of all, the names of the subroutines we create are really just barewords.
That's good to have.

Also, when we are referring to an element of a hash we can use barewords within the curly braces
and words on the left hand side of the fat arrow => can also be left without quotes:

```perl
use strict;
use warnings;

my %h = ( name => 'Foo' );

print $h{name}, "\n";
```

In both cases in the above code "name" is a bareword,
but these are allowed even when use strict is in effect.


