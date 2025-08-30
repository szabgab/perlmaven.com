---
title: "Solution: number guessing game - video"
timestamp: 2015-03-14T09:02:37
tags:
  - solution
types:
  - screencast
published: true
books:
  - beginner_video
author: szabgab
---


Solution: [Number guessing game](https://code-maven.com/exercise-number-guessing-game).

This [exercise](/beginner-perl-maven-exercise-number-guessing-game) is also part of the
[Code Maven exercises](https://code-maven.com/exercises) where you can find a
number of solutions in other languages as well.


{% youtube id="CPUf6xom31Q" file="beginner-perl/solution-number-guessing-game" %}


{% include file="examples/number_guessing.pl" %}

We start with the usual boiler-plate lines, but we also require Perl version 5.10 or higher so we can
use the `say` function.

```
#!/usr/bin/perl
use strict;
use warnings;
use v5.10;
```

The `rand` function of perl will generate a random floating point number between 0 and 1. (1 not included.)
If we call `rand 200` the generated floating point number will be between 0 and 200. (200 not included.)

The `int` function will return the integer part of the number. So `int rand 200` will a whole number
between 0 and 200 (0 included, 200 not included).

The 200 in the code is just a "magic number", it could be anything. It is usually better to put these numbers in variables
at the top of the program so they stand out more. That's why in our code we used `$N` for the number.
Actually this also means that we don't have to repeat the number later when we give a hint to the users about the
range where they should guess.

As we would like the values to be 1 and 200 including both ends, we can just add 1 to the previous result. That
will give a number between 1 and 201 (with 201 excluded) which is just what we wanted.

Then we use the regular `print` function to ask the user something. We don't put a newline at the end
as we would like to let the user type the answer on the same line where the question appeared.

We use the `&lt;STDIN&gt;` operator to read in from the standard input.
In Perl this input will include the trailing newline added when the user pressed ENTER.
Although in this case we don't need to do this we use the [chomp](/chomp) function to remove that trailing newline.

Then we can check which one of the 3 cases is true and provide feedback to the user.


