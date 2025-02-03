---
title: "Argument ... isn't numeric in numeric ..."
timestamp: 2014-10-14T09:30:01
tags:
  - warnings
published: true
books:
  - beginner
author: szabgab
---


If we have variables that were assigned values that contain numbers, even if they were assigned as strings
(inside quotes), for any numerical operation, Perl will automatically convert them to the appropriate number:


```perl
use strict;
use warnings;
use 5.010;

my $x = '23';
my $y = '17';

say $x > $y;   # 1
say $x >= $y;  # 1
say $x + $y;   # 40
```

Even if the numbers contain a decimal point or an exponential part:

```perl
use strict;
use warnings;
use 5.010;

my $x = '23.2e2';
my $y = '17.1';

say $x > $y;   # 1
say $x >= $y;  # 1
say $x + $y;   # 2337.1
```

Perl [automatically converts](/automatic-value-conversion-or-casting-in-perl) the strings into
numbers that are exactly the same as what we had in the string.  No warnings were emitted.
(Think about writing numbers on a paper.  Are those strings or numbers? Who cares. They look like numbers.)


## Not numbers

On the other hand if one of the values cannot 
[be converted](/automatic-value-conversion-or-casting-in-perl) without disregarding some
part of it then Perl will emit a warning. (Of course only if `use warnings` is effect.)

```perl
use strict;
use warnings;
use 5.010;

my $x = '23';
my $y = '17x';

say $x > $y;   # 1
say $x >= $y;  # 1
say $x + $y;   # 40
```

Even before the normal output of the script there is a warning:

```
Argument "17x" isn't numeric in numeric gt (>) at ... line 8.
1
1
40
```

'17x' was converted to the number 17, at the first comparison. Please note, there is only one warning.
Once the string was converted to its numerical representation Perl stores this numerical value along the
original string value and so in the next expression it does not need to make an imperfect conversion again.
Therefore no further warnings are emitted. If we remove the first comparison:

```perl
use strict;
use warnings;
use 5.010;

my $x = '23';
my $y = '17x';

say $x >= $y;  # 1
say $x + $y;   # 40
```

The warning would be now on the greater-than-or-equal comparison.

```
Argument "17x" isn't numeric in numeric ge (>=) at ... line 8.
1
40
```


If we removed even that, then the warning is on the addition operation.

```perl
use strict;
use warnings;
use 5.010;

my $x = '23';
my $y = '17x';

say $x + $y;   # 40
```

```
Argument "17x" isn't numeric in addition (+) at ... line 8.
40
```

Each warning has a slightly different wording, but they have the same general layout.

If both arguments are 'dirty' and cannot be converted to numbers flawlessly, then each one of them
will generate a warning:

```perl
use strict;
use warnings;
use 5.010;

my $x = '23y';
my $y = '17x';

say $x + $y;   # 40
```

```
Argument "17x" isn't numeric in addition (+) at ... line 8.
Argument "23y" isn't numeric in addition (+) at ... line 8.
40
```


## Solution

The solution of course is that we need to make sure values that cannot be fully converted to numbers
are not used in numeric operations. If you encounter the above problem, add a print-statement in front
of the line emitting the warning to display the variables involved in the operation. That will help you track down
the source of the problem.

Alternatively you can use the [looks_like_number](/automatic-value-conversion-or-casting-in-perl)
function from [Scalar::Util](https://metacpan.org/pod/Scalar::Util) to check if a variable can be
used as a number.

