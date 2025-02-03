---
title: "Lvalue substr - replace part of a string"
timestamp: 2014-03-18T12:30:01
tags:
  - substr
  - Lvalue
published: true
author: szabgab
---


There are a few strange functions in Perl that can be on the left-hand-side of
an assignment. For example if you would like to change the content of a string you can 
use the [4-parameter version of substr](/string-functions-length-lc-uc-index-substr),
the 4th parameter being the replacement string,
or you can use `substr` as an Lvalue and assign that string to the 3-parameter version of substr.


`substr $text, 14, 7, "jumped from";`

and

`substr($text, 14, 7) = "jumped from";`

make the same changes in `$text`

Try the examples:

## 4-parameter substr

```perl
use strict;
use warnings;
use 5.010;

my $text = "The black cat climbed the green tree.";
substr $text, 14, 7, "jumped from";
say $text;
```

## 3-parameter substr as Lvalue

```perl
use strict;
use warnings;
use 5.010;

my $text = "The black cat climbed the green tree.";
substr($text, 14, 7) = "jumped from";
say $text;
```

They will both print:

```
The black cat jumped from the green tree.
```

## Which one to use?

I think the 4-parameter version is much clearer.
If you want to make sure others in your team don't use the Lvalue version of substr,
you can use [Perl::Critic](/perl-critic-one-policy), and make sure the
[ProhibitLvalueSubstr](https://metacpan.org/pod/Perl::Critic::Policy::BuiltinFunctions::ProhibitLvalueSubstr)
policy is enabled.

## Comments

parameter 4 not taking variable as input in substr function in v5.22.1. any alternate way to do the same?

Could you give an actual example of the problem you face?

thanks for the quick response. I found another bug in my code. substr function works completely fine. thanks once again, inconvenience regretted.
