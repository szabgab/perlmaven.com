---
title: "Understanding regular expressions"
timestamp: 2016-01-23T08:30:01
tags:
  - regex
published: true
books:
  - beginner
author: szabgab
archive: true
---


The other day one of the readers of the [Perl Maven tutorial](/perl-tutorial)
asked me about regular expressions.

She asked if the regular expressions work on words or on strings.

This made me think about this a bit.


## Regular expressions per character

In general, regular expressions work per character so

* `z` matches one single 'z' character
* `.` (the dot) matches one single character - any character except newline
* `[abc]` (a [character class](/regex-character-classes)) matches one single character, a or b or c
* `\s` matches a single "white space" character
* `\p{...}` matches a single character in the appropriate [Unicode character class](/regex-special-character-classes)
* etc.

*, +, ? and {} are [quantifiers](/regex-quantifiers) that tell how many times
the character that is on the left hand site can match:

* `z*`  means 0 or more 'z' characters
* `z+` means 1 or more 'z' characters
* `z?` means 0 or 1 'z' character.
* `z{2, 4}` means 2, 3 or 4 'z' characters.
* `[abc]+` means matching a, b or c one or more times.

Then we can have sub-expressins enclosed in parentheses, and we can apply quantifiers to these subexpressions.
So we can have a subexpression like `#\d{2,4}-\d{4,7}\s+` and if we would like to have more of these
matching one after the other, we can enclose it in `()` parentheses and put a quantifier (e.g. `{3,}`) after it:
`(#\d{2,4}-\d{4,7}\s+){3,}` That quantifier will be applied to the whole subexpression, meaning that subexpression has
to match 3 or more times.

This seems to match "words" or "strings", but in reality those "words" or "strings" are matched on the
individual character level.


## Regex cheat sheet

There are a number of articles about regexes you might want to read. The
central one might be the [regex cheat sheet](/regex-cheat-sheet)
that has links to all the other articles.


## Comments

i don't understand meaning of [^a-z0-9]*[ \t\n\r][^a-z0-9]* .

---
What do you understand from this?

