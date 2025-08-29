---
title: "Perl 5 Regex Cheat sheet"
timestamp: 2015-08-19T07:30:01
tags:
  - "?"
  - "+"
  - "*"
  - "{}"
  - "."
  - "[]"
  - "|"
  - "$1"
  - "$2"
  - "$3"
  - "$4"
published: true
books:
  - beginner
author: szabgab
---


When learning regexes, or when you need to use a feature you have not used yet or don't use often, it
can be quite useful to have a place for quick look-up. I hope this Regex Cheat-sheet will provide such aid for you.


[Introduction to regexes in Perl](/introduction-to-regexes-in-perl)

```
   a           Just an 'a' character
   .           Any character except new-line
```

## Character Classes

[Regex Character Classes](/regex-character-classes) and [Special Character classes](/regex-special-character-classes).

```
   [bgh.]      One of the characters listed in the character class b,g,h or . in this case.
   [b-h]       The same as [bcdefgh].
   [a-z]       Lower case Latin letters.
   [bc-]       The characters b, c or - (dash).
   [^bx]       Complementary character class. Anything except b or x.
   \w          Word characters: [a-zA-Z0-9_].
   \d          Digits: [0-9]
   \s          [\f\t\n\r ] form-feed, tab, newline, carriage return and SPACE
   \W          The complementary of \w: [^\w]
   \D          [^\d]
   \S          [^\s]
   [:class:]   POSIX character classes (alpha, alnum...)
   \p{...}     Unicode definitions (IsAlpha, IsLower, IsHebrew, ...)
   \P{...}     Complementary Unicode character classes.
```

TODO: add examples \w and \d matching unicode letters and numebers.

## Quantifiers

[Regex Quantifiers](/regex-quantifiers)

```
   a?          0-1         'a' characters
   a+          1-infinite  'a' characters
   a*          0-infinite  'a' characters
   a{n,m}      n-m         'a' characters
   a{n,}       n-infinite  'a' characters
   a{n}        n           'a' characters
```

## "Quantifier-modifier" aka. Minimal Matching

```
   a+?
   a*?
   a{n,m}?
   a{n,}?

   a??
   a{n}?
```

## Other

```
   |           Alternation
```

## Grouping and capturing

```
   (...)                Grouping and capturing
   \1, \2, \3, \4 ...   Capture buffers during regex matching
   $1, $2, $3, $4 ...   Capture variables after successful matching

   (?:...)              Group without capturing (don't set \1 nor $1)
```


## Anchors

```
   ^           Beginning of string (or beginning of line if /m enabled)
   $           End of string (or end of line if /m enabled)
   \A          Beginning of string
   \Z          End of string (or before new-line)
   \z          End of string
   \b          Word boundary (start-of-word or end-of-word)
   \G          Match only at pos():  at the end-of-match position of prior m//g
```

## Modifiers

```
  /m           Change ^ and $ to match beginning and end of line respectively
  /s           Change . to match new-line as well
  /i           Case insensitive pattern matching
  /x           Extended pattern (disregard white-space, allow comments starting with #)
```


## Extended</h2

```
  (?#text)             Embedded comment
  (?adlupimsx-imsx)    One or more embedded pattern-match modifiers, to be turned on or off.
  (?:pattern)          Non-capturing group.
  (?|pattern)          Branch test.
  (?=pattern)          A zero-width positive look-ahead assertion.
  (?!pattern)          A zero-width negative look-ahead assertion.
  (?<=pattern)         A zero-width positive look-behind assertion.
  (?<!pattern)         A zero-width negative look-behind assertion.
```

```
  (?'NAME'pattern)
  (?<NAME>pattern)     A named capture group.
  \k<NAME>
  \k'NAME'             Named backreference.
```

```
  (?{ code })          Zero-width assertion with code execution.
  (??{ code })         A "postponed" regular subexpression with code execution.
```

## Other Regex related articles

* [Parsing dates using regular expressions](/understanding-dates-using-regexes)
* [Check several regexes on many strings](/check-several-regexes-on-many-strings)
* [Matching numbers using Perl regex](/matching-numbers-using-perl-regex)
* [Understanding Regular Expressions found in Getopt::Std](/understanding-regular-expressions-found-in-getopt-std)
* [Email validation using Regular Expression in Perl](/email-validation-using-regular-expression-in-perl)

## Official documentation

* [perlre](https://metacpan.org/pod/perlre)
* [perlretut](https://metacpan.org/pod/perlretut)

## Comments

You didn't mention \R character class which matches familiar end of line sequences.


