---
title: "Avoid (unwanted) bitwise operators"
timestamp: 2015-01-25T11:50:01
tags:
  - bitwise
  - perlcritic
  - Perl::Critic
  - Perl::Critic::Bangs
  - "|="
  - "||="
published: true
author: szabgab
archive: true
---


A while ago I saw this in some code:

```perl
$x |= some_sub();
```

It is syntactically correct but it is almost sure to be a typo.


The recommended way (for lazy programmers) to assign [default to a scalar variable](/how-to-set-default-values-in-perl) is

```perl
$x ||= some_sub();
```


or, if you are using perl 5.10 or newer then the correct way is

```perl
$x //= some_sub();
```

using the defined-or operator.

Actually I think there are very few applications where bitwise operators are needed.
It might be interesting to see which CPAN modules use them.

When I encountered this issue I started to write an e-mail to the developers
of [Perl::Critic](/how-to-set-default-values-in-perl)
asking for their help catching code that uses bitwise operators.
I have not even finished the message when I saw a posting by
[Andy Lester](http://petdance.com/) about exactly the same issue.
Except he already implemented a Perl Critic policy to check for this.
Now, after almost two months finally I had time to try it.
I installed [Perl::Critic::Bangs](https://metacpan.org/pod/Perl::Critic::Bangs).

Created a file called `code.pl` with the following content:

```perl
use strict;
use warnings;

my $x = 3 & 4;
$x |= 42;
```

(I use [strict and warnings](/strict) even when I write simple examples.)

and ran <b>perlcritic code.pl</b>

This was the result

```
Use of bitwise operator at line 12, column 11.  
      Use of bitwise operator "&".  (Severity: 5)
Use of bitwise operator at line 13, column 4.  
      Use of bitwise operator "|".  (Severity: 5)
```

Thank you Andy and thank all the developers of the
[Perl::Critic](http://www.perlcritic.com/) ecosystem.


