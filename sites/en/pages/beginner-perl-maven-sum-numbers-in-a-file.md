---
title: "Sum numbers in a file - video"
timestamp: 2015-03-28T17:03:11
tags:
  - sum
types:
  - screencast
published: true
books:
  - beginner_video
author: szabgab
---


Sum numbers in a file


<slidecast file="beginner-perl/sum-numbers-in-a-file" youtube="77MUdZp4FBc" />

Let's do now something slightly useful with our knowledge.
In this example we have a file called `numbers.txt` that has numbers in it. Each line is a number:

{% include file="examples/files/numbers.txt" %}

Let's add these numbers together and print out their sum:
In order to accomplish this we need to have a variable to hold the sum of numbers so far that will start from 0, then go over
the file line-by-line and add the content of each line to the variable holding the sum.

{% include file="examples/files/count_sum.pl" %}

After including the standard beginning of almost every Perl program we declare a variable called `$sum` where we are going to collect the sum
of the numbers. We initialize it to 0.

Then we have the name of the file hard-coded in a variable called `$filename`

The we call `open` to open the file `or die` to throw an exception of the `open` failed. Regular thing
we have seen in the article [open and read from files](/open-and-read-from-files).

Then we go over it line-by-line using a `while` loop.

This code will read in one line on every iteration. So `$line` will always contain the a line which is a number and trailing newline.
Then we add that line to the `$sum` variable using `+=`. Because Perl is nice to us, it disregards the newline, and automatically converts
the string to a numeric value so we don't need to use any special expression for casting the string to a number.

When we finish the loop we have all the numbers in the `$sum` variable that we can print.


## Using List::Util

We have not learned it yet, and it is <b>not in the video</b>, but let me add two more solutions. In the first
one we use the `sum` function of the standard [List::Util](https://metacpan.org/pod/List::Util) module.

{% include file="examples/files/sum.pl" %}

We open the file exactly the same way as we did in the previous example, but this pass the result of the read-file operator to the
`sum` function. In this case we are actually [reading from the file in list context](/reading-from-a-file-in-scalar-and-list-context)
which means all the lines are read into memory at once and they are passed to the `sum` function as individual elements. (Each line is one element.)
The `sum` function then adds them together and returns the result.


## Using Path::Tiny as well

In the third example we also use the `path` function of the [Path::Tiny](https://metacpan.org/pod/Path::Tiny) module
that opens a file and returns an object on which we can call the `lines` method. This will return the lines of the file.

{% include file="examples/files/sum_short.pl" %}



