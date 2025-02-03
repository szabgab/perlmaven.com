---
title: "String functions: length, lc, uc, index, substr"
timestamp: 2013-02-20T14:45:56
description: "perl substr(STRING, OFFSET, LENGTH, REPLACEMENT) - extract any part of a string; index(STRING, STR, OFFSET) - return location of substring"
tags:
  - length
  - lc
  - uc
  - index
  - substr
  - scalar
types:
  - screencast
published: true
books:
  - beginner
author: szabgab
---


In this part of the [Perl Tutorial](/perl-tutorial) we are going to learn
about some of the functions Perl provides for manipulating strings.


{% youtube id="U2B5ZD59L7g" file="modern-perl-tutorial-part-04-string-functions-1." %}

## lc, uc, length

There are a number of simple functions such as <b>lc</b> and <b>uc</b>
to return the lower case and upper case versions of the original string respectively.
Then there is <b>length</b> to return the number of characters in the given string.

See the following example:

{% include file="examples/uc_lc_length.pl" %}

Please note, in order to get the [length of an array](/length-of-an-array) you don't use the <b>length</b> function.
Instead, you put it in [scalar context](/scalar-and-list-context-in-perl) using the <b>scalar</b> function.


## index

Then there is the <b>index</b> function. This function will get two strings and return
the location of the second string within the first string.

{% include file="examples/index.pl" %}

The first call to `index` returned 10, because the string "cat" starts on the 10th character.
The second call to `index` returned -1 indicating there is no "dog" in that sentence.

The 3rd call shows that `index` returns 0
when the second string is a prefix of the first string.

The 4th example shows that `index` is looking for exact matches so case also matters.
Hence "the" and "The" are different.

`index()` looks for strings and not just for words, so even the string "e " can be looked up:

```perl
my $str = "The black cat climbed the green tree";
say index $str, "e ";              # 2
```

`index()` can also have a 3rd parameter that indicates the location where
to start searching. So as we found "e " to start at the 2nd character of the first string,
we could try to search starting from the 3rd place to see if there is another occurrence of "e ":

{% include file="examples/index_more.pl" %}

Looking for "e" without a space will yield a different result.

Lastly, there is another function called <b>rindex</b> (right index)
that will start searching from the right hand side of the string:

{% include file="examples/rindex.pl" %}

## substr

I think the most interesting function in this article is `substr`.
It is basically the opposite of index(). While index() will tell you
<b>where is a given string</b>, substr will give you the <b>substring at a given locations</b>.
Normally `substr` gets 3 parameters. The first one is the string. The second is a
0-based location, also called the <b>offset</b>, and the third is the <b>length</b> of the
substring we would like to get.

{% include file="examples/substr.pl" %}

substr is 0 based so the character at the offset 4 is the letter b.

```perl
my $str = "The black cat climbed the green tree";
say substr $str, 4, -11;                    # black cat climbed the
```

The 3rd parameter (the length) can also be a negative number. In that case it tells us
the number of characters from the right hand side of the original string that
should NOT be included. So the above means: count 4 from the left, 11 from the
right, return what is between.

```perl
my $str = "The black cat climbed the green tree";
say substr $str, 14;                        # climbed the green tree
```

You can also leave out the 3rd (length) parameter which will mean:
return all the characters starting from the 14th place till the end of the string.

```perl
my $str = "The black cat climbed the green tree";
say substr $str, -4;                        # tree
say substr $str, -4, 2;                     # tr
```

We can also use a negative number in the offset, which will mean:
count 4 from the right and start from there. It is the same as having
`length($str)-4` in the offset.

## Replacing part of a string

The last example is a bit funky.
So far in every case `substr` returned the substring
and left the original string intact. In this example, the return value
of substr will still behave the same way, but substr will also change the
content of the original string!

The return value of `substr()` is always determined by the first 3 parameters,
but in this case substr has a 4th parameter. That is a string that will
replace the selected substring in the original string.

```perl
my $str = "The black cat climbed the green tree";
my $z = substr $str, 14, 7, "jumped from";
say $z;                                                     # climbed
say $str;                  # The black cat jumped from the green tree
```

So `substr $str, 14, 7, "jumped from"` returns the word <b>climbed</b>,
but because of the 4th parameter, the original string was changed.

There is also an [lvalue](/lvalue-substr) version of this example, but
only look there if you are brave.

## Comments

Hello:

I am new to perl and index function.
For some reason, I cannot find the right location/index for a tab character.

Can you please review my code and result below and tell me what I incorrectly coded?

My Code:

{% include file="examples/some_example_with_tabs.pl" %}

Result:
D. Test
Length of the string is 55
 My string has a tab at 5; = chr(9)
 My string has a tab at 5; = <  >
1st Location of a Tab is 130
2nd Location of a Tab is 1315
3rd Location of a Tab is 1334
1st Location of a Tab is 130
2nd Location of a Tab is 1315
3rd Location of a Tab is 1334
1st Location of a Tab is -10
2nd Location of a Tab is -115
3rd Location of a Tab is -134
1st Location of a Tab is -10
2nd Location of a Tab is -115
3rd Location of a Tab is -134
1st Location of a Tab is -10
2nd Location of a Tab is -115
3rd Location of a Tab is -134

Thank you.
Bobby


---
A tab is "\t" in double quotes. and you put the 3rd parameter outside of the parentheses. eg. you wrote:

index ($Tmp, chr(9)), 15

instead of

index($Tmp, chr(9), 15)

---

Thank you Gabor.


