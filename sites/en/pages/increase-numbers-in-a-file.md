---
title: "Increase numbers in a file"
timestamp: 2018-08-25T23:30:01
tags:
  - e
  - ee
  - Path::Tiny
  - slurp_utf8
  - lines_utf8
  - split
published: true
author: szabgab
archive: true
---


There are already a number of solution in the [counter example](https://code-maven.com/counter)
series, but this one is quite different. It is actually based on a question I got from one of my former students
at one of the big hi-tech companies.

Here we have a file with lots of content, including some numbers in more or less arbitrary places.
We would like to increase these numbers.

{% include file="examples/counter_template/counter.txt" %}

In the basic version we would like to increase each number by one. In the extended version we will want
to supply a file with "rules" how to change each number.


## The helpers: Path::Tiny

In each one of the solutions below we used [Path::Tiny](https://metacpan.org/pod/Path::Tiny)
to read the content of the 'counter.txt' file and later also the 'rules.txt' file. In the case of the
former we have used the `slurp_utf8` method which
[reads the whole file as a single string](/slurp).

In the case of 'rules.txt' in one of the examples below, we used the `lines_utf8` method that
[reads the file in LIST context](/reading-from-a-file-in-scalar-and-list-context) making
each line an element in the resulting array.

For writing the file we use the `spew_utf8` method that takes one or more strings (or an array)
and writes them to the given file.

## Split and increment numbers

In the first solution, after reading the content of the 'counter.txt' file into the cleverly
named `$data` variable we [split](/perl-split) the content at every place where there was
a number. As we wrapped our splitting regex in parentheses `(\d+)`, the resulting array will contain
both the pieces between the numbers and the numbers themselves. (See below.)

Basically this means that some of the `@pieces` will be the numbers we wanted to increase.

Then we go over the `@pieces` array which contains strings without any digits in them and strings that include only digits.
The ones that are digits only are then increased by 1 using [++](/numerical-operators).

Finally we save all the strings and numbers back to the same file.

{% include file="examples/counter_template/counter_one.pl" %}

The ouput will look like this:

<pre>
9
4
24
16
41
</pre>

And the 'counter.txt' file will be updated with these numbers to become this:

{% include file="examples/counter_template/counter_one.txt" %}

Let's see a bit more detailed explanation:

## Split retaining the separator or parts of it

In our example, you can see that the `@pieces` array
contains all the content of the original file including the newlines
and the numbers we used to split up the string.
If we printed this array into a file we would get back the original content.

Instead of that we have increased the numbers and saved them
to the 'counter.txt' file only after that.

Here you can see what the `@pieces` array contains after we called `split`.

{% include file="examples/counter_template/counter_explain.pl" %}

```
$VAR1 = [
          'This is a file with several number For example ',
          '8',
          '
In the second row there are two number ',
          '3',
          ' and ',
          '23',
          '
There are also numbers between other characters: #',
          '15',
          '# and =',
          '40',
          '=
'
        ];
```

For an explanation see how [split retains the separator](/split-retaining-the-separator).

## Change the numbers by any number

As a generalization to our solution we could accept a number on the command line (and default to 1)
and increment each number in the file using the number we received from the command line. We did not need to make a
lot of changes, we just had to accept a number on the command line with
`my $inc = $ARGV[0] || 1;` setting the [default value](/how-to-set-default-values-in-perl) to 1.
We also had to replace the [auto increment](/numerical-operators)  `$p++` by
`$p += $inc;`.

{% include file="examples/counter_template/counter_any.pl" %}

This will allow us to increase the counter by any number.

For example after restoring the original counter.txt running `perl counter_any.pl` will print out the following:

```
10
5
25
17
42
```

and result in the following file:

{% include file="examples/counter_template/counter_any_2.txt" %}

It will also allow us to use a negative number or
a non-whole number.

`$ perl counter_any.pl -2`

```
6
1
21
13
38
```

and result in this file:

{% include file="examples/counter_template/counter_any_minus_2.txt" %}

## Does the negative counter really work?

(This is far from perfect. If we run `$ perl counter_any.pl -2` again we'll get

```
4
-1
19
11
36
```

and this file:

{% include file="examples/counter_template/counter_any_minus_4.txt" %}


Which is still ok, but if we run it a 3rd time we get this:

```
2
-1
17
9
34
```

and this file:

{% include file="examples/counter_template/counter_any_minus_6.txt" %}

the -1 has not changed. Worse than that, now the 'counter.txt' file contains '--1' in that place.

So this solution does not properly handle negative numbers in the counter.txt file.

## Replace numbers using regex substitute

As an alternative solution, one that is more in line with the original request we could use
a [regex substitution](/regex-cheat-sheet) instead of the split.

{% include file="examples/counter_template/counter_substitute.pl" %}

In this solution we have the following substitution:

`$data =~ s/(\d+)/ $1 + $inc /ge;`

The `g` modifier is probably familiar to you. It means `globally`.
It tells Perl to execute the substitution as many time as it can. The `e`
might not be familiar though. It stand for `eval`.

You can see an explanation of it in the [regex superpower article](/regex-superpowers-execute-code-in-substitution).

Having that modifier means that instead of using the string "$1 + $inc" as the replacement
we use the result of `eval "$1 + $inc"` as a replacement. Without the `e`
at the end of the regex the results in the file would look like
`8 + 1`.


## Replace numbers using rules

As another generalization and one that is the closest to the original problem we
would like to supply a file called 'rules.txt' that contains rules on how to change
each number.

In the 'rules.txt' file every odd line is a regex that is supposed to match one or more of
the numbers. Every even line is the substitution part of the `s///` expression.

In our example the first pair will match the numbers that are surrounded by `#` characters
and increment them by 1. The second rule will match numbers that are surrounded by `=` characters
and increment the numbers by 2.

{% include file="examples/counter_template/rules.txt" %}

In the implementation first we read in the rules and create a hash in which the keys are the rules (the odd lines)
and the values are the replacement expressions (the even lines).

Then we go over the rules and for each rule we execute the following substitution:

`$data =~ s/$rule/ $rules{$rule} /gee;`

In which the regex has the `ee` modifier. It tells perl to eval the expression and then
eval the results and use the result of that as the substitution.
This is required in this case otherwise we would get the templates from the even rows.

{% include file="examples/counter_template/counter_substitute_rules.pl" %}

`$ perl counter_substitute_rules.pl` will result in the following output
where only the last two numbers are changed, and the 'counter.txt' file is updated properly.

```
8
3
23
16
42
```


If we remove one of the `e`-s from the regex the output would look like this:


```
8
3
23
1
1
1
2
```

and 'counter.txt' would look like this:

```
This is a file with several number For example 8
In the second row there are two number 3 and 23
There are also numbers between other characters: '#' . ($1+1) . '#' and '=' . ($1+2) . '='
```

clearly not what we wanted.


## !!! Security warning !!!

If you use `e` or `ee` you are using string `eval`, aka. evil eval.
If combined with input from an untrusted source you open your system for arbitraty code execution
by that untrusted source. So if they supply `system "rm -rf /"` or some similar well-crafted
input, your system is toast.

## Caveat

These solutions only handle positive integers. Neither negative numbers nor floating point numbers will work properly.
See above.

Read the security warning again!

