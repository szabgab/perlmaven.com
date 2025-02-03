---
title: "What's new in Perl 5.10? say, //, state"
timestamp: 2012-07-06T05:45:56
tags:
  - v5.10
  - 5.010
  - say
  - //
  - defined or
  - state
  - ||=
  - //=
published: true
author: szabgab
---


It is not news any more, Perl 5.10 has been released on 18th December, 2007,
the 20th birthday of Perl. Many people have written articles about it.
There are several presentations on-line available. For example see
the discussion on [PerlMonks](http://perlmonks.org/?node_id=654042).
It has several good links.

I am writing about it as many companies are very late adopters and they will want
to see how can Perl 5.10 or some later version improve their life.

(This article was originally published on 2007 Dec 24 on szabgab.com)


There are many new features, let's start with some of the simple ones:

## say

There is a new function called `say`. It is the same as <b>print</b>
but it automatically adds a new line <b>\n</b> to every call.
This does not sound like a big issue and it is indeed not a huge one, but
nevertheless it saves a lot of typing, especially in debugging code.
There are just so many times we type

```perl
print "$var\n";
```

Now we'll be able to say this:

```perl
say $var;
```

If you are worried of new functions popping up in old code,
you should not. The new function is only available if
you explicitly ask for it by writing

```perl
use feature qw(say);
```

or if you require 5.10 to be the minimal version where your code can run:

```perl
use 5.010;
```

## defined or

Another cute help is the <b>//</b> defined-or operator. It is nearly the
same as the good old <b>||</b> but without the
<i>"0 is not a real value"</i> bug:

Earlier when we wanted to give a <b>default value</b> to a scalar we could write
either

```perl
$x = defined $x ? $x : $DEFAULT;
```

which is quite long, or we could write

```perl
$x ||= $DEFAULT;
```

but then 0 or "0" or the empty string were not accepted as valid
values. They were replaced by the $DEFAULT value. While in some
cases this is ok, in other cases this created a bug.

The new defined-or operator can solve this problem as it will return
the right hand side only if the left hand value is `undef`. So now
we are going to have <b>short AND correct</b> form:

```perl
$x //= $DEFAULT;
```

## state

Third thing I look at in this article is the new <b>state</b>
keyword. This too is optional and is only included if you ask for it
by saying

```perl
use feature qw(state);
```

or by

```perl
use 5.010;
```

When used it is similar to <b>my</b> but it creates and initializes the
variable only once. It is the same as the <b>static</b> variable in C.
Earlier we had to write something like this:

```perl
{
   my $counter = 0;
   sub next_counter {
      $counter++;
      return $counter;
   }
}
```

Which always needed lots of explanations why $counter is set to 0 only once
and how can it always get you a higher number. The anonymous block is also
unclear at first glance.

Now you can write this:

```perl
sub next_counter {
   state $counter = 0;
   $counter++;
   return $counter;
}
```

Which is much clearer.

For another use case of the `state` keyword check out
[how to hide multiple warnings of Perl?](/how-to-capture-and-save-warnings-in-perl).


