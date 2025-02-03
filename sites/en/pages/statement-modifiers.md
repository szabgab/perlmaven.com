---
title: "Statement modifiers: reversed if statements"
timestamp: 2015-06-04T09:00:01
tags:
  - if
  - unless
published: true
author: szabgab
---


You'll become an expert, if you use Perl a lot.

If you use Perl a lot, you'll become an expert. 

These two sentences mean the same and if we are told either of those we'll understand the same thing.
Maybe there is a slight difference in the focus of the sentence, but the real meaning is the same.

Just as in English and in any other spoken language you can do the same reversal in Perl as well.


## if-statement in Perl

These two examples do the same in Perl:

```perl
if (-e $file) {
    die "File '$file' already exists";
}
```

```perl
die "File '$file' already exist" if -e $file;
```

In both cases Perl first checks the condition (does the file `$file` exist?),
and in both cases it executes the `die` statement only if the condition was met.

You are already familiar with the first, the direct way of writing an if-statement
and the block that belongs to it. In the second example we reversed the order of the two parts.
We could also leave out the curly-braces of the block `{}`, and the parentheses `()`
of the condition. That's the big advantage of writing this way.

The disadvantage is that in this syntax there can be only one statement in the (not existing) block.
There can be only one statement executed if the condition was met and there is no `else` part at all.


This kind of statement is often used together with flow-control statements such as `die`, `next`, and `last`,
to name a few.


## unless-statement in Perl

Just as `if` can be used as a statement modifier, we can also use `unless` as a statement modifier.

```perl
if (not -e $file) {
    die "File '$file' does not exist";
}
```

Is the same as

```perl
unless (-e $file) {
    die "File '$file' does not exist";
}
```

Which is the same as

```perl
die "File '$file' does not exist" if not -e $file;
```

which is the same as:

```perl
die "File '$file' does not exist" unless -e $file;
```


## Comments

The use of "if" as a statement modifier is a favorite of mine. It was a feature of Digital Equipment Corporation's Basic-Plus language dating back to the 1970's as was using "for" as well:

print i% for i% = 0% to 10%

Unfortunately the "for" syntax was not carried into Perl.


Perl has very similar "for" statement modifier.

say "$_%" for (0..10) # will evaluate say for each list element

https://perldoc.perl.org/perlsyn#Statement-Modifiers


Sure enough. You learn something new every day. I didn't realize Perl carried that little gem from Basic-Plus as well. BTW, the "%" I used was how you indicated an integer value in BP. 10 by itself was a real value but 10% was an integer value. Hard for me to believe I still remember that from the late 70's when I was in high school LOL.


