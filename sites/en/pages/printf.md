---
title: "Formatted printing in Perl using printf and sprintf"
timestamp: 2019-04-20T09:30:01
tags:
  - printf
  - sprintf
published: true
books:
  - beginner
author: szabgab
archive: true
---


`printf` can be used to create a formatted print to the screen.

`sprintf` accepts the same parameters, but it will return the formatted string instead of printing
it so you can collect the string and print them later, or save them to a file or send them in an e-mail.


{% include file="examples/printf.pl" %}

