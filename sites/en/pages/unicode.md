---
title: "What is Unicode"
timestamp: 2013-08-08T08:22:13
tags:
  - Unicode
  - UTF-8
published: true
books:
  - beginner
author: mguttman
---


In this part of the [Perl Tutorial](/perl-tutorial) we are going to
talk about **Unicode issues in Perl**.

Unicode aspires to cover all known human, and even fictional scripts, from the Egyptian hieroglyphs
all the way to all modern languages. Even non-human languages like the fictional language of the
Star-Trek ["Klingon"](http://en.wikipedia.org/wiki/Klingon_alphabets) empire are represented,
although this one not officially.

This article is an introduction, presenting a few important facts about Unicode, including the issue of <i>encoding</i>.

Further parts will show how you can have Unicode strings in expressions,
how to deal with Unicode in regular expressions,
and how to collate, search and compare Unicode text.


## A few facts about Unicode

Remember ASCII? One page and you knew all about it! But all it could represent was the English alphabet.
Then every country standardized its own script, usually taking advantage
of the numerical range of 128 to 255. All these were in general mutually exclusive.
One could not have unique-to-Spanish and unique-to-German characters in the same document.

Enter Unicode!

We have binary codes for each and every conceivable character in each
and every conceivable language on earth (and beyond...)

It should be noted that Unicode Specifies "Scripts", as opposed to "Languages".
For example, Chinese, Japanese and Korean share the same script.
There are 100 scripts as of v. 6.2 (Sep. 2012).

Numbers, punctuation, graphical symbols, mathematical symbols,
musical symbols, technical symbols, dingbats, arrows,
braille patterns and more are also assigned codes.

Binary representations of Unicode characters and other text entities
are referred to as "Code-Points". Code-points range from U+00’0000
to U+10’FFFF, please note the designation format.

## Diacritics

A big Unicode issue, one that might not be familiar to native English speakers,
is [diacritics](http://en.wikipedia.org/wiki/Diacritics).
In addition to "naked" characters such as the Latin alphabet,
Unicode code-points also represent all those pesky signs such as
the French "acute", the German "umlaut", as well as the Hebrew punctuation and
the vocalization of the Bible signs. Diacritics are superimposed "on top" of
the base character after which they appear. They can be rendered above, below, 
to the left or to the right of it. Some can even overlay it, see for example
[Unicode's Combining Diacritical Marks](http://www.unicode.org/charts/PDF/U20D0.pdf).
Multiple diacritics to the same direction are stacked in the order of appearance.
Arabic and Hebrew are replete with such.

In order to be backward compatible as much as possible, Unicode also supports "equivalents",
such as an equivalents combination of a "naked" character and a diacritic that looks like
and can be replaced in some circumstances, by a fully-formed character. For example,
the ANGSTROM SIGN which is a common Nordic character, has a fully-formed `Å`,
code-point U+00C5 (but also another fully-formed one, code-point U+212B).
It can be represented also as a two code-points composite:
a bare Latin `A` (code-point U+0041) plus a `̊` diacritic, code-point U+030A.

## Ligatures

[Ligatures](http://en.wikipedia.org/wiki/Typographical_ligature) are
also [supported](http://www.unicode.org/charts/PDF/UFB00.pdf),
as well as their equivalents. As an example, `ﬃ ` code point U+FB03,
can for some application such as "collating"
(kind of sorting, explained in further parts) be replaced by a string of simple characters,
in this case the three characters `'ffi'`.

Unicode supports the notion of a "paragraph".
Paragraph breaking, line-breaking (i.e. one that does break a line but doesn’t terminate a logical paragraph),
special non-characters such as
[zero-width non-breaking space](http://en.wikipedia.org/wiki/Non-breaking_space)
and others are also defined.


## Bi-directional text

But it is not only characters, symbols, diacritics and paragraphs. Unicode also
specifies **rendering**, namely providing composing rules to render a string of
base characters and their added diacritics as mentioned above on a two-dimensional
medium in its proper reading direction.

An example of reading direction support is for Bi-Directional (Bi-Di) text.
In Arabic and Hebrew text (which are Right-to-Left), one often encounters
embedded numerals, Latin text and other opposite reading direction scripts. The
support includes code-points that explicitly marks Left-to-Right (LTR) and
Right-to-Left (RTL) strings, and where one is embedded within the other. But it also
classifies some character code-points as either "inherently RTL" e.g. Arabic,
"inherently LTR" e.g. Latin, or "neutral", e.g. numerals, hyphens and asterisks. Then
the Bi-Di algorithm specifies rules as to how to compose a string of text, <i>even in
the absence</i> of explicit LTR/RTL marks.

## Columns

Unicode also supports other kinds of text reading directions marks: columns of
text going from Top-to-bottom or bottom-up where the columns may go either
from left-to-right or right-to-left. It even supports "Boustrophedon"
(literally, Greek for "ox turning") reading. In this reading sequence,
when in one row the reading direction is LTR, in the next row it is RTL.
Early Greek and Egyptian hieroglyphs used it.

## Encodings

"Encoding" means how are Unicode "code-points" represented as binary
strings in files and I/O: text files, Internet pages, software source
code (hence variables storing strings in it), text streams coming from or going to
OS "pipes", etc. It **does not**, repeat, does not necessarily
apply to an internal representation in memory such as in Perl!

Current encodings are only [UTF-8](http://en.wikipedia.org/wiki/UTF-8),
[UTF-16](http://en.wikipedia.org/wiki/UTF-16) and
[UTF-32](http://en.wikipedia.org/wiki/UTF-16).
Older, deprecated encodings are UCS-2, UCS-4, UTF-1 and UTF-7.
Nowadays however you will seldom encounter anything other then
UTF-8 encoded files and HTML pages where Unicode is used.

