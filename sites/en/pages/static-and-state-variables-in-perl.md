---
title: "Static and state variables in Perl"
timestamp: 2014-01-15T22:30:01
tags:
  - static
  - state
published: true
books:
  - advanced
author: szabgab
---


In most of the cases we either want a variable to be accessible only from inside a small scope,
inside a function or even inside a loop. These variables get created when we enter the
function (or the scope created by a a block) and destroyed when we leave the scope.

In some cases, especially when we don't want to pay attention to our code, we want variables
to be global, to be accessible from anywhere in our script and be destroyed only when the
script ends. In General having such global variables is not a good practice.

In some cases we want a variable to stay alive between function calls, but still to be private
to that function. We want it to retain its value between calls.


In the C programming language one can designate a variable to be a [static variable](http://en.wikipedia.org/wiki/Static_variable).
This means it gets initialized only once and it sticks around retaining its old value between function calls.

In Perl, the same can be achieved using the [state variable](/what-is-new-in-perl-5.10--say-defined-or-state) which is available starting from version 5.10,
but there is a construct that will work in every version of Perl 5. In a way it is even more powerful.

Let's create a counter as an example:

## state variable

```perl
use strict;
use warnings;
use 5.010;

sub count {
    state $counter = 0;
    $counter++;
    return $counter;
}

say count();
say count();
say count();

#say $counter;
```

In this example, instead of using [my to declare the internal variable](/variable-declaration-in-perl), we used the
`state` keyword.

`$counter` is initialized to 0 only once, the first time we call `counter()`. In subsequent calls, the line `state $counter = 0;`
does not get executed and `$counter` has the same value as it had when we left the function the last time.

Thus the output will be:

```
1
2
3
```

If we removed the `#` from last line, it would generate a
[Global symbol "$counter" requires explicit package name at ... line ...](/global-symbol-requires-explicit-package-name)
error when trying to compile the script. This just shows that the variable `$counter` is not accessible outside the function.

## state is executed in the first call

Check out this strange example:

```perl
use strict;
use warnings;
use 5.010;

sub count {
    state $counter = say "world";
    $counter++;
    return $counter;
}

say "hello";
say count();
say count();
say count();
```

This will print out

```
hello
world
2
3
4
```

showing that the `state $counter = say "world";` line only gets executed once. In the first call to `count()`
`say`, which was also [added in version 5.10](/what-is-new-in-perl-5.10--say-defined-or-state), will return 1 upon success.


## static variables in the "traditional" way


```perl
use strict;
use warnings;
use 5.010;

{
    my $counter = 0;
    sub count {
        $counter++;
        return $counter;
    }
}

say count();
say count();
say count();
```

This provides the same result as the above version using `state`, except that this could work
in older versions of perl as well. (Especially if I did not want to use the `say` keyword,
that was also introduced in 5.10.)

This version works because functions declarations are global in perl - so `count()` is accessible in the
main body of the script even though it was declared inside a block. On the other hand the variable `$counter` is 
not accessible from the outside world because it was declared inside the block.
Lastly, but probably most importantly, it does not get destroyed when we leave the `count()` function (or when
the execution is outside the block), because the existing `count()` function still references it.

Thus `$counter` is effectively a static variable.

## First assignment time

```perl
use strict;
use warnings;
use 5.010;

say "hi";

{
    my $counter = say "world";
    sub count {
        $counter++;
        return $counter;
    }
}

say "hello";
say count();
say count();
say count();
```

```
hi
world
hello
2
3
4
```

This shows that in this case too, the declaration and the initial assignment `my $counter = say "world";`
happens only once, but we can also see that the assignment happens <b>before</b> the first call to
`count()` as if the `my $counter = say "world";` statement was part of the control flow
of the code <b>outside</b> of the block.

## Shared static variable

This "traditional" or "home made" static variable has an extra feature. Because it does not belong to the the `count()`
subroutine, but to the block surrounding it, we can declare more than one functions in that block and we can
share this static variable between two or even more functions.

For example we could add a `reset_counter()` function:

```perl
use strict;
use warnings;
use 5.010;

{
    my $counter = 0;
    sub count {
        $counter++;
        return $counter;
    }

    sub reset_counter {
        $counter = 0;
    }
}


say count();
say count();
say count();

reset_counter();

say count();
say count();
```

```
1
2
3
1
2
```

Now both functions can access the `$counter` variable, but still nothing
outside the enclosing block can access it.

## Static arrays and hashes

As of now, you cannot use the `state` declaration in list context.
This means you cannot write `state @y = (1, 1);`. This limitation could be overcome by
some extra coding. For example in this implementation of the Fibonacci series, we checked if the
array is empty and set the default values:

```perl
use strict;
use warnings;
use 5.010;

sub fib {
   state @y;
   @y = (1, 1) if not @y; # workaround initialization
   push @y, $y[0]+$y[1];
   return shift @y; 
}

say fib();
say fib();
say fib();
say fib();
say fib();
```

Alternatively we could use the "old-style" static variable with the enclosing block.

Here is the example generating the Fibonacci series:

```perl
use strict;
use warnings;
use 5.010;

{
   my @y = (1, 1);
   sub fib {
      push @y, $y[0]+$y[1];
      return shift @y; 
   }
}

say fib();
say fib();
say fib();
say fib();
say fib();
```

