---
title: "Creating subroutines on the fly using Symbolic references"
timestamp: 2015-04-16T09:40:01
tags:
  - strict
  - symbolic references
published: true
books:
  - advanced
author: szabgab
---


If you read the documentation of  [Log::Dispatch](https://metacpan.org/pod/Log::Dispatch),
you will see you can send a message to the logger by using the `log` method passing both the
"log level" and the "message" like this: `$logger->log( level => 'error', message => 'Blah, blah' );`.
For greater convenience you can also write `$logger->error( 'Blah, blah' );`.

There are 8 log levels, and [David Rolsky](/dave-rolsky), the author of the module, lets you
use a few additional names as well. For example he allows the use of `err` instead of `error`.


All together there are 12 such helper function. They are almost identical. How can you create and maintain them,
without actually having 12 copies in your source code?


## Creating 12 almost identical functions

I'll show you the snippet from an older version of the module (specifically this is from 2.29)
as the newer versions are a bit more complex.

If we have implemented the functions manually we would have written code like this:

```perl
sub warning {
    my $self = shift;
    $self->log( level => 'warning', message => "@_" );
};
```

12 times. In each case replacing the word `warning` (in three places!) with one of the 11 other words.

The code generating the 12 subroutines is going to be longer and more complex than any one of the individual functions,
but it is shorter than the 12 functions together. The big advantage though is that if you want to make
any changes to all the 12 functions, you need to make it in a single location.
Also if you decide to add another name, you just add a single word
to the list at the top and you are done with it.

Here is how the code looks like:

```perl
    foreach my $l (
        qw( debug info notice warn warning err error crit critical alert emerg emergency )
        ) {
        my $sub = sub {
            my $self = shift;
            $self->log( level => $l, message => "@_" );
        };
 
        no strict 'refs';
        *{$l} = $sub;
    }
```

How does this work?

This code snippet creates an anonymous function and assigns it to the `$sub` variable.
The value passed to the `level` parameter is baked into the currently generated function.

```perl
        my $sub = sub {
            my $self = shift;
            $self->log( level => $l, message => "@_" );
        };
```

The following code takes the reference to the subroutine, (in `$sub`) and places it in the current
name-space. 

```perl
        *{$l} = $sub;
```

The `*{$l}` notation might be a strange, but it is quite similar to the case of scalars.
For example in the article about [symbolic references](/symbolic-reference-in-perl)
there was an example `${$name}`. The difference is that for functions we used a `*`.

This is how we add an entry to the symbol table of the current name-space, that holds the
list of all the functions. Because this is a case when we want to use symbolic references
we don't want to have `use strict` stopping us. On the other hand the rest of the code
should work under the restrictions of `use strict`.

Perl allows us to turn strict on/off in a lexical scope - that is within a block enclosed by curly braces.
So we can use `no strict` and it will turn off the influence of `strict` from that point
until the next closing brace.

As `strict` actually has 3 parts, it is enough for us to turn off the part that eliminates symbolic references.
Hence we have in the code `no strict 'refs';`.


## Conclusion

While it is better to avoid accidental use of [symbolic references](/symbolic-reference-in-perl)
and having `use strict;` does this, there are rare cases when an expert like you can gain
extra powers by using them.

For this you'll have to turn off strict, but you will can do it in a very limited scope.

