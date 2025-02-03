---
title: "Using the built-in debugger of Perl"
timestamp: 2013-03-07T19:45:56
tags:
  - debugger
  - -d
  - debug
types:
  - screencast
published: true
author: szabgab
---


The new screencast is about [using the built-in debugger of Perl](https://www.youtube.com/watch?v=jiYZcV3khdY).
I gave talks about this at various Perl workshops and conferences and there were always lots of
people who have never used the debugger. I hope this will help more people to start using it.


{% youtube id="jiYZcV3khdY" file="perl_debugger_intro.mp4" %}

Running the debugger:

perl -d yourscript.pl param param

The debugger commands that were mentioned in this video are:

q - to quit

h - to get the help

p - to print

s - step in

n - step over

r - step out

T - stack trace

l - listing code

I also recommend to read the book of Richard Foley and Andy Lester: [Pro Perl Debugging](http://www.apress.com/9781590594544)

