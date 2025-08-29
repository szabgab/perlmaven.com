---
title: "Perl 5 Regex Quantifiers"
timestamp: 2014-12-02T13:30:01
tags:
  - "?"
  - "+"
  - "*"
  - "{}"
published: true
books:
  - beginner
author: szabgab
---


In pattern matching using regular expressions, or regexes, every character matches exactly one character. Even the special characters
such as the dot `.` and a [character class](/regex-character-classes), matches exactly one character.
(Well, except of the anchors, but we'll talk about them later.)

In order to provide more flexibility there are a number of special characters called **quantifiers**,
that will change the number of times each character can match.


There are 3 main quantifiers:

* `?` matching 0 or 1 occurrence.
* `+` matching 1 or more occurrence.
* `*` matching 0 or more occurrence.

In addition, using a pair or curly braces `{}` we can have even more flexible quantifiers.

Each quantifier impact the character, or sub-expression in-front of it. In other words a quantifier never stands alone.
It is always on the right hand side of some character or some sub-expression and it always changes the quantity of that sub-expression only.

Let's see a few examples:

## color or colour? - optional characters

Given a string we need to know if the word "color", or the British spelling "colour" can be found in it. We could write

```perl
if ($str =~ /color/ or $str =~ /colour/) {
   # match
}
```

and it would be quite right, but if this is part of a bigger expression we would not want to repeat the whole expression.
Instead of that we would write:

```perl
if ($str =~ /colou?r/) {
   # match
}
```

Here the question-mark `?` is a quantifier that says, the letter 'u' can appear 0 or 1 times. That is, it might be there, or it might not be there.
Exactly the two cases we wanted.

## * Any number of characters

The star `*` means the character in-front of it can appear any number of times. Including 0 times. So an expression like
`/-.*-/` means a dash (`-`) followed by any character any number of times (`.*`), followed by another dash.
A few sample strings that would match:

```
-hello-
word - other text - more text - and even more
prefix -- postfix
---
--
```

Basically any string that has at least two dashes in it with anything between them except newlines.

## + One or more characters

The third common quantifier is the plus character `+` which means 1 or more occurrence.

The regex `/-.+-/` then would match the same things as `/-.*-/` matched above,
but it will **not** match the `--` and the 
`prefix -- postfix` strings.


## {} curly braces

Using curly braces we can express a lot of different amounts. Normally it is used to express a range so
`x{2, 4}` would mean 2, 3 or 4 x-es.

We can leave out the second number thereby removing the upper limit. `x{2,}` means 2 or more x-es.
If we also remove the comma the `x{2}` means exactly 2 x-es.
So in order to express the 3 common quantifiers we could use the curly braces:

```
?  =  {0,1}
+  =  {1,}
*  =  {0,}
```

Of course in these cases it is much shorter and clearer to use the 3 common quantifiers than the curly braces.


## Quantifier table

```
Regex       # examples it would match

/ax*a/      # aa, axa, axxa, axxxa, ...
/ax+a/      #     axa, axxa, axxxa, ...
/ax?a/      # aa, axa
/ax{2,4}a/  #          axxa, axxxa, axxxxa
/ax{3,}a/   #                axxxa, axxxxa, ...
/ax{17}a/   #                                 axxxxxxxxxxxxxxxxxa
```

## Warning

While `x{5}` means "match exactly 5 x-es, the expression /x{5}/ would also match the string
"xxxxxx" where we have 6 x-es. The reason is that normally regexes don't care what else is in the string beyond the
area they match. So x{5} will match the first 5 x-es and the whole expression will disregard the 6th x.
This was not the case in the earlier examples as in ever example we had some other characters in the regex on both sides
of the quantified character. For example `/ax{17}a/` means: "match a, match 17 x-es, match a". It does not let
additional x-es to be located between the 17 x-es and the trailing a. Nor does it let an x-es appear between
the leading 'a' and the 17 x-es.


## Quantifiers on character classes

Just as we can put quantifiers on individual character such as 'a', or 'x', we can also put them on the special character `.`, and even on
character classes. So we can write `/[0-9]+/` which means 1 or more digits, `/[0-9]{2,4}/` meaning 2-4 digits, or `/-[abc]+-/`
meaning 1 or more occurrences of any of a,b or c between two dashes. (Please note, those dashes are outside of the character class
and therefore they are totally regular characters. No special meaning at all.)

The character class without the quantifier `/-[abc]-/` will match the following:

```
-a-
-b-
```

but it won't match any of these:

```
-aa-
-ab-
--
-x-
```


On the other hand if we add a `+` quantifier after the character class: `/-[abc]+-/` it will match

```
-a-
-b-
-aa-
-ab-
```

but will still not match:

```
--
-x-
```

If we replace the `+` by a `*` it will also match the

```
--
```

but still won't match:

```
-x-
```





