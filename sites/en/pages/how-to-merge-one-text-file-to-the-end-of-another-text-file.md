---
title: "How to merge one text file to the end of another text file?"
timestamp: 2015-03-15T07:30:01
tags:
  - cat
  - append
  - open
  - ">>"
published: true
books:
  - beginner
author: szabgab
---


Given one or more files, (e.g. `1.txt`, `2.txt`, `3.txt`, how can we merge them into another
file, let's say called `target.txt`?


## Unix/Linux specific non-Perl solution

If you are using Linux or Unix the `cat` command can be used together with the `&gt;&gt;` redirection:

```
cat 1.txt 2.txt 3.txt >> target.txt
```

This will work regardless if `target.txt` existed before or not.

## Platform independent solution with Perl

If you need to <b>combine several files</b>, and you want to make sure this will work on other platforms as well
(most importantly MS Windows), then you can read the files in memory and then write them out 
[appending](/appending-to-files) to the target file.

Even that we should probably do line-by-line, in order to preserve memory. Instead of reading the
input files in memory at once, we will read one line, the print it out to the target file.
Then we read in another file and print it out. This will work even with huge file. File way
bigger than the available memory in the computer.

{% include file="examples/merge_files.pl" %}

If we run this script using `perl merge_files.pl` it will print out:
`Usage: merge_files.pl in in ... in  out`

Maybe not the best way to indicate, but the idea is that the user has to provide on the command-line
a list of input files and as the last element, the name of the output file.

so let's run `perl merge_files.pl 1.txt 2.txt 3.txt target.txt` (Note, we don't need the `&gt;&ht;`
on the command-line here.)

This will do the job.

In the script, after adding the [safety net](/beginner-perl-maven-safety-net) the first thing we do is
[pop](/manipulating-perl-arrays) the last element of the
[@ARGV array](/argv-in-perl) that holds the content of the command-line.
This is the name of the `$target` file.
Then we copy all the other values to the `@sources` array. We don't have to do this,
we could have used `@ARGV` directly, but I thought it is clearer if we have our data in descriptive
variable names.

`die ...` checks if there is at least one element in the `@sources` array. If there is non,
it will print out the `usage` message and quit. We don't need to check separately if `$target`
has a value, because if `$target` was empty then surely `@sources` will be empty too.

The next step is to open the target (or output file) for [appending](/appending-to-files).
We use the `&gt;&gt;` here.

Then we iterate over the elements of the `@sources` array, each file we
[open for reading](/open-and-read-from-files), read the lines one-by-one,
from the `$in` file-handle, and write them out one-by-one to the `$out`
file-handle.

Calling `close` is not really required, but at least the `close $out` is strongly recommended.
Even without that Perl will write out everything to the disk, but only when it feels like it.
If you want to make sure everything is written to the disk before you reach the `print "done\n";`
statement, then you have to call `close $out;`.

## Why the different error handling?

You might have noticed that in the first call to `open` I used the `open ... or die ...`
construct and it the second call to `open`, that will be executed multiple times, I used
`if (open ...) { } else { warn ... }` construct.

The reason for this difference is that if we cannot open the target file, we don't have any more business
running this code, so I through an exception using `die`. This will end the program right there.

On the other hand, if one of the input files is missing, or not readable that should probably not
terminate the whole process. Therefore if one of those calls to `open` failed then we should
just report about it calling [warn](/warn), and we should start working on the next file.

Of course, what exactly should happen in such case will be dependent on your requirements, this is just
an example that fits one use-case.


## Extra safety - error checking

If you want to be cautious, you could, and probably should check if every write operation and if
every `close` was successful by writing `print $out $line or die ...` and
`close $out or die ...`, or by using [autodie](https://metacpan.org/pod/autodie).

This will help you catch the cases when the disk got full or when someone removed the external hard-disk
or pen-drive while you were trying to write to it.


