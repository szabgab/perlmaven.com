---
title: "Solution: display unique rows of a file - video"
timestamp: 2017-05-01T11:30:01
tags:
  - substr
  - ord
published: true
books:
  - beginner_video
author: szabgab
archive: true
---


Solution of the exercise [display unique rows of a file](/beginner-perl-maven-exercise-display-unique-rows-of-a-file).


The input file looks like this:

{% include file="examples/rows_of_file.txt" %}

The expected output looks like this:

```
A 1
B 2
C 3
D 4
```

What we need to notice is that only the first characters count.
The first appearance of each character as the head of each line will determine which line
is included in the final result.

We need to find a way to remember which chracters have been already seen as first-characters
of a line. If this is the first appearance of a given character, inlcude the line in the output
file. If the character was already seen, we skip this line.

It would be easier to do this using a hash, but at this point in the course we have not learned
hashes yet. So we need to settle using an array.

For that we need a mapping from each character that can be the first character of a line to
a unique location in an array. Luckily the `ord` function returns the ASCII code of
each ASCII character. We can use that for the mapping.

The first 32 characterts of the [ASCII table](http://www.asciitable.com/)
are not printable characters, and if we assume we only have letters as the fist character then
many of the numbers between 0 and 127 won't be used. This means if we use the ASCII code as index
in the array, we'll have a sparse array with only some of the fields having a value.

As the total number of potential values is only 128, in most situation we can get away with this waste.

{% include file="examples/unique_rows_with_array.pl" %}

First we expect the name of the input file and the name of the output file on the command line.

Then we open them for reading and writing respectively.

Then we declare an array, cleverly named `@seen` to indicate if a given character has
been already seen as the leading character of a line. It starts out empty as we have not seen
any charcter yet.

As we go over the lines of the input file using a [while loop](/beginner-perl-maven-while-loop)
we extract the first character using [substr](/string-functions-length-lc-uc-index-substr).

Then using the `ord` function we get the ASCII code of that character.

If the corresponding value in the `@seen` array is already [True](/beginner-perl-maven-true-false)
we skip the rest of the block by calling [next](/beginner-perl-maven-loop-controls-next-last).

Otherwise we set that field to `1`. It can be any arbitrary value, we are only interested
in [True-ness](/boolean-values-in-perl) of that value.

Finally we print the current line.

## Comments

Interesting solution, but what is the point of the "ord" function? Can you not compare the value of "$chr"?

Can you explain why just the first character as the title says "display unique rows of a file"? I would think the entire row would be considered in that case. I do realize there are cases where just the first character or "word" is important like a config file where you can override settings.

I'd like to see a file check added to this line as follows:

die "USAGE: $0 INFILE OUTFILE\n" if not $outfile;

die "USAGE: $0 INFILE OUTFILE\n" if not (-s $infile && $outfile);


