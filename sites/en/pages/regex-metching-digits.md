---
title: "Regex matching digits"
timestamp: 2021-03-17T10:30:01
tags:
  - PosixDigit
  - Digit
  - PosixXDigit
  - "[[:digit:]]"
  - "[[:xdigit:]]"
  - digit
  - xdigit
published: true
author: szabgab
archive: true
description: "Regular expressions matching digits in Perl: POSIX, Unicode, ASCII - PosixDigit, Digit, PosixXDigit, [[:digit:]], [[:xdigit:]], digit, xdigit"
show_related: true
---


For many uses only the 10 values between 0-9 are considered digits, but there are quite a few languages that have their own [unicode digits](https://www.fileformat.info/info/unicode/category/Nd/list.htm).

Besides, some would consider A-F also digits. In a hexadecimal number.

So here are some regular expressions matching digits in Perl: POSIX, Unicode, ASCII - PosixDigit, Digit, PosixXDigit, [[:digit:]], [[:xdigit:]], digit, xdigit


{% include file="examples/regex_for_digits.pl" %}
