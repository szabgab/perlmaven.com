---
title: "Numerical operators"
timestamp: 2014-04-24T07:30:01
tags:
  - +
  - -
  - *
  - /
  - %
  - ++
  - --
  - +=
  - *=
  - -=
  - /=
  - %=
published: true
books:
  - beginner
author: szabgab
---


Just as in most of the other programming languages, Perl too has the basic numeric operators:
`+` for addition, `-` for negation, `*` for multiplication, `/` for division:


```perl
use strict;
use warnings;
use 5.010;

say 2 + 3;   # 5
say 2 * 3;   # 6
say 9 - 5;   # 4
say 8 / 2;   # 4

say 8 / 3;   # 2.66666666666667
```

Note that Perl will automatically switch to floating point number when necessary so when we divide 8 by 3 we get a floating point value.

```perl
use strict;
use warnings;
use 5.010;

say 9 % 2;   # 1
say 9 % 5;   # 4
```

The `%` operator is the modulo operator. It returns the value that remains after an integer division.

The same numerical operators can be used on [scalar variables](/scalar-variables) containing numbers as well:

```perl
use strict;
use warnings;
use 5.010;

my $x = 2;
my $y = 3;

say $x + $y;  # 5
say $x / $y;  # 0.666666666666667
```

## Shorthand operators

The expression `$x += 3;` is the shorthand version of `$x = $x + 3;`, they have exactly
the same result:

```perl
use strict;
use warnings;
use 5.010;

my $x = 2;
say $x; # 2

$x = $x + 3;
say $x; # 5

my $y = 2;
say $y;  # 2
$y += 3;
say $y;  # 5
```

In the general case `VARIABLE OP= EXPRESSION` is the same as
`VARIABLE = VARIABLE OP EXPRESSION`, but usually easier to read and less error-prone.
(We don't repeat the name of VARIABLE.)
You can use it with any binary operator:

`+=`, `*=`, `-=`, `/=`, even `%=`


(binary operators work on two values.)

## Auto increment and auto decrement

Perl also provides `++` the auto increment, and `--` auto decrement operators.
They increase and decrease respectively the value of a scalar variable by 1.

```perl
use strict;
use warnings;
use 5.010;

my $x = 2;
say $x; # 2
$x++;
say $x; # 3

$x--;
say $x; # 2
```

Both the postfix versions `$x++`, `$x--` and the prefix versions 
`++$x`, `--$x` and they behave the same way as in other languages.
In case you are not familiar with them, then this is not the time to become deeply
acquainted with them.

They can be used as part of a larger expression when being pre-fix or post-fix really matters,
but in most cases I think the best is to avoid such expressions. They can be fun and a maintenance nightmare.
We'll have an article explaining short-circuit and the pitfalls of auto increment with short-circuit.

In addition the auto-increment operator can also work on a string as explained in the
part about [string operators](/string-operators).


