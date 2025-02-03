---
title: "Count digits - video"
timestamp: 2015-07-02T13:01:13
tags:
  - $count[$c]++
types:
  - screencast
published: true
books:
  - beginner_video
author: szabgab
---


Count digits


<slidecast file="beginner-perl/count-digits" youtube="fvYS6kCzSAs" />

Given a file like this, that has line, and each line has numbers separated by a space.
Our task is to count digits. Not numbers, but digits.

{% include file="examples/arrays/count_digits.txt" %}

So basically we need to have 10 counters. One for counting 0-s, one for counting 1-s etc. up till the counter of 9-s.
The natural way to hold such counters is to use an array. An array of counters.

So that's what we have here. We have an array called `@count` which is empty at the beginning.
* At the index 0 we are going to count how many times 0 has appeared in the file.
* At the index 1 we are going to count how many times 1 has appeared in the file.
* ...
* At the index 9 we are going to count how many times 9 has appeared in the file.


The first thing we do is we get the filename from the command line using [shift](/beginner-perl-maven-shift) so we will run this
script as `perl count_digits.pl count_digits.txt`, [or die](/beginner-perl-maven-open-or-die), so if the user does
not provide a filename we explain how the program should be used, and exit.

Then we [open the file or die](/beginner-perl-maven-open-or-die), this is just a standard thing we have been doing earlier,
and then we loop over the file line-by-line using a `while` loop. Inside we deal with just one line.

First we [chomp](/chomp) of the newline at the end of the line as we don't want to count that. The we use
[split](/perl-split) with `//`, the empty regex to cut up the string into characters. We could have done a number of
different things to go over the string character-by-character, this is juts one of the possibilities. Using split with an empty regex
is thought as sepcial form of split, though it is just splitting the string every place where there is an empty string, meaning along
each character. What we get back and assign to `@chars` is a list of characters.

Based on the input file each character is going to be either  a digit, or a space.

Then we use a `foreach` loop to go over the characters one-by-one. On every iteration `$c` will hold one of
the characters which is either a digit or a space. Inside the foreach loop we check if `$c` is not equal (`ne`)
to an empty space, which means it is a digit.

In that case we increase the counter at that index using `$count[$c]++`.

After iterating over all the lines and all the characters in every line we have a full count.

{% include file="examples/arrays/count_digits.pl" %}

## Automatically converting strings to numbers

However you might be wondering how this `$count[$c]++` really works. First of all, unlike in many other programming languages
perl will automatically convert a string to a number when it is needed. So although `$c` is a string holding a digit in it,
when it is used as an index of an array, perl will automatically convert it to the corresponding number.

## Autovivification

The other thing that might be strange is that when we first encounter a digit, its place in the `@count` array does not exists yet.
So how could we access it as a number and increment it with `++`?

When we start the iteration the `@count` array is empty. Using our input file the first digit we are going to encounter will be `2`.
When executing `$count[$c]++`, perl is actually executing `$count[2]++`. Perl will try to look up the value of `$count[$c]`
It does not exist hence, because we are attempting a numeric operation on a value that does not exist, Perl will default to act as if there was a number 0.
Incerementing it with `++` it will turn into a `1` and will be assigned back to `$count[2]`.

In oreder to be able to store 1 in `$count[2]` perl will allocate space for 3 elements of the array `@count`: indexes 0, 1, and 2.
Index 2 will get the value 1, and indexes 0, and 1, will have [undef](/undef-and-defined-in-perl) in them. Creating:

`@count = (undef, undef, 1)`

This is one form of [autovivification](/autovivification).

The next digit is 3. After that iteration the array will look like this:

`@count = (undef, undef, 1, 1)`

Then comes a space which will not be counted.

Another 3 will get us to this: `@count = (undef, undef, 1, 2)`
The 4 after that will get us here: `@count = (undef, undef, 1, 2, 1)`,
and then the 9, will cause the array to be further enlarged to this:
`@count = (undef, undef, 1, 2, 1, undef, undef, undef, undef, 1)`.


## Display the results

The last 3 lines in the program will show the results. We have a `foreach` loop there that iterates over the digits from 0 to 9.
On each iteration it will print out the content of `$i`, the current digit, and then we use the
[ternary operator](/the-ternary-operator-in-perl) to print out the content of the `@count` array in that place.
In the ternary operator, we check if `$c[$i]`, the counter containing the number of occurances of the digit currently in `$i`,
has any value. If it has, it means we have encountered that digit at least once, so we print `$count[$i]`. Otherwise, if we
have not encountered this digit we print out 0.

If we did not have this ternary operator, and if just printed the content of `$count[$i]` we might encounter some issues in case
one of digit did not appear in our file. In that case `$count[$i]` would be still [undef](/undef-and-defined-in-perl)
which if printed will do two things: It will act as en empty stirng and will print nothing, but becasue we have
[use warnings](/always-use-strict-and-use-warnings) we are also going to get a 
[Use of uninitialized value](/use-of-uninitialized-value) warning.

That warning will certainly alarm any viewer of the results.

Even if we turn off warnings, which I don't recommend, we'd get an output in which we have holes. Rows that show the
digit, but no number showing the frequency of that digit. Any casual viewer will immediately think that it is a bug.
So it is better that we put a 0 in there.


## The result:

```
0 1
1 5
2 9
3 11
4 9
5 8
6 4
7 2
8 0
9 1
```



