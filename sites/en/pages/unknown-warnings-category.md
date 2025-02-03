---
title: "Unknown warnings category"
timestamp: 2013-02-22T10:45:56
tags:
  - ;
  - warnings
  - unknown warnings
published: true
books:
  - beginner
author: szabgab
---


I don't think this is a very commonly encountered error message in Perl.
At least I don't remember seeing it earlier, but recently this tripped
me during a Perl training class.


## Unknown warnings category '1'

The full error message looked like this:

```
Unknown warnings category '1' at hello_world.pl line 4
BEGIN failed--compilation aborted at hello_world.pl line 4.
Hello World
```

This was very disturbing, especially as the code was really simple:

```
use strict;
use warnings

print "Hello World";
```

I stared at the code quite a lot and have not seen any problem with it.
As you can also see, it already printed the "Hello World" string.

It baffled me and it took me quite some time to notice,
what you probably have already noticed:

The problem is the missing semicolon after the `use warnings`
statement. Perl is executing the print statement,
it prints out the string and the `print` function returns 1
indicating that it was successful.

Perl thinks I wrote `use warnings 1`.

There are many warning categories, but none of the categories is called "1".

## Unknown warnings category 'Foo'

This is another case of the same problem.

The error message looks like this:

```
Unknown warnings category 'Foo' at hello.pl line 4
BEGIN failed--compilation aborted at hello.pl line 4.
```

and the example code is showing how string interpolation works.
This is about the second example I teach, right after "Hello World".

```perl
use strict;
use warnings

my $name = "Foo";
print "Hi $name\n";
```

## Missing semicolon

Of course these are all just special cases of the generic
problem of leaving out a semicolon. Perl can notice it only
at the next statement.

It is generally a good idea to check the line just before
the location indicated in the error message.
Maybe it is missing the semicolon.

