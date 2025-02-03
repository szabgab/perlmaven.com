---
title: "Loop controls: next, last, continue, break"
timestamp: 2021-01-20T12:30:01
tags:
  - next
  - last
  - continue
  - break
published: true
books:
  - beginner
author: szabgab
archive: true
---


In Perl there are 3 loop control keywords. The two commonly used are `next` and `last` and there is a third which is rarely used called `redo`.

In most of the other languages the respective keywords are `continue` and `break`.

`next` of Perl is the same as the `continue` in other languages and the `last` if Perl is the same as the `break` of other languages.

`redo` probably does not have its counterpart.


`next` will jump to the condition and if it is [true](/boolean-values-in-perl) Perl will execute the next iteration.

`last` will quite the loop.

Take a look at this example. This script will count the number of non-empty rows in a file until it encounters `__END__` or the end of file.

{% include file="examples/loop_control.pl" %}

Given this input file:

{% include file="examples/loop_control.txt" %}

the output will be this:

```
Process 'First line'
Process 'Line after empty line'
Process 'Another text line'
Number of non empty rows: 3 out of a total of 6
```

## next

The `next` keyword is usually used when we during our iteration we have an condition inside the loop and if that condition is matched (or faild to match) then we would like to end the current iteration and go to the next one. For example if we are looking for a string that starts with "DNA:" and then has a DNA in it with some complex rule, we might first check if the current row starts with "DNA:". If it does not then there is no point in further investigating the current string and we  can go to the `next` iteration.

## last

On the other hand if we found the DNA we were looking for we might stop the whole search if we are only interested in the first such DNA. In this case calling `last` will break us out from the current loop saving a lot of time by not iterating over the rest of the values.

In this example we were looking for a DNA with a 3-character repetition.

{% include file="examples/find_dna.pl" %}

This is our very limited input file:

{% include file="examples/find_dna.txt" %}

The resulting output looks like this:

<pre>
Checking DNA:ACTGGTATTA
Checking DNA:ACTGTAACTG
First interesting DNA: ACTGTAACTG
</pre>

It skipped all the lines that did not start with DNA: and once it found a match (in the 2nd DNA) it stopped looking skipping all the other lines.

## redo

Calling `redo` will execute the current iteration again without checking the condition. I don't recall using it
so let's not get into it now.

## Comments

I was expecting something on the "continue" keyword, which is actually useful in some cases. There's a good example on the "eof" doc page (https://perldoc.pl/function....

I find "continue" useful when parsing files, and I need to deal with line numbers. Also, when there's some work that needs to be done between iterations, but "next" or "last" is used a lot, "continue" can be more obvious and maintainable.

"redo" is also useful sometimes, when external state changes, or IO is needed.

---
When I wrote this I was more focused on the idea that people new to perl would want to use the "continue" keyword they know from other languages and I wanted to direct them to the "next" keyword.
