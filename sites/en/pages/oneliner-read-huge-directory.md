---
title: "one-liner: read first elements of a huge directory"
timestamp: 2023-01-17T10:55:01
tags:
  - one-liners
published: true
author: szabgab
archive: true
show_related: true
---


At a client we have a networked disk with millions of files. I was trying to list the first few files to see what's going on.

**ls -l | head** takes ages, but here is a Perl one-liner to make it work:


```
perl -E 'opendir(my $dh, "/huge_dir"); my $c = 0; while (my $d = readdir($dh)) { say $d; exit if ++$c > 3 }'
```

In a different layout that could be put in a file

```perl
use feature 'say';
opendir(my $dh, "/huge_dir");
my $c = 0;
while (my $d = readdir($dh)) {
    say $d;
    exit if ++$c > 3
}
```


Explanation:

**perl -E** tells perl that the next string is a piece of perl code that should executed. (as opposed to being a filename) This is what let's us write one-liners in Perl. Using the capital letter **-E** turns on the feature <b>say</b> among other things.

**opendir(my $dh, "/huge_dir");** opens a directory and assigns the directory handle to the new variable called **$dh** that was declared on the spot with <b>my</b>

**my $c = 0;** declares a variable called **$c** and assign 0. We'll use this for  counting the entries.

**while (my $d = readdir($dh))** a while loop that for each iteration will read one entry from the directory and assign it to the newly declared variable **$d**.  We declare this variable inside the loop to make it scoped to the loop.

**{ say $d; exit if ++$c > 3 }** the block of the **while loop**. First statement prints the value of <b>$d</b> followed by a newline. Then we have a conditional statement in what is called <b>statement modifier</b> where the statement comes before the condition. We first increment the counter and then check if it is greater than 3 and if it is then we call <b>exit</b>.

I was even a bit overdoing with declarations. If we are not using **strict** we don't need to declare variables. If a variable does not even have value but is incremented using **++** it will behave as if there was a 0 in it. So we don't need to initialize <b>$c</b>.

```
perl -E 'opendir($dh, "/huge_dir"); while ($d = readdir($dh)) { say $d; exit if ++$c > 3}'
```


And I don't need that **$d** variable either. Instead of that I can use the invisible **$_**:

```
perl -E 'opendir($dh, "/huge_dir"); while (readdir($dh)) { say; exit if ++$c > 3}'
```

## Improvement with for loop

[Aristotle Pagaltzis](http://plasmasturm.org/) posted an improved version as a comment on my [dev.to](https://dev.to/szabgab/one-liner-read-first-elements-of-a-huge-directory-2h8c) post.

This one does not need a named counter variable as we are using a for loop with the invisibele **$_** and we don't need a variable for the filename as we are printing out right away.

```
perl -Mautodie -E 'opendir DH, "/huge_dir"; for ( 1 .. 3 ) { say readdir DH // last }'
```


