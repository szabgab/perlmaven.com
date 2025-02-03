---
title: "How to get the size of a file in Perl"
timestamp: 2015-01-07T10:30:01
tags:
  - -s
  - stat
  - File::stat
published: true
author: szabgab
---


Given a path to e file in a variable `my $filename = "path/to/file.png";`  the easiest thing is to use the
`-s` operator to retrieve the size of the file: `my $size = -s $filename;`


```perl
use strict;
use warnings;
use 5.010;

my $filename = "/etc/passwd";
my $size = -s $filename;
say $size;
```


## stat function

Alternatively the `stat` built-in function of perl returns a 13-element list providing information about the
status of the file. The 8th element (index 7) is the size of the file.


```perl
use strict;
use warnings;
use 5.010;

my $filename = "/etc/passwd";
my @stat = stat $filename;
say $stat[7];
```

## Fetch list element on-the-fly

Of course you don't have to assign the return value of the `stat` function to an array.
We can fetch the element on-the-fly by putting parentheses around the whole expression and then putting
the element index after that in square bracket: `(stat $filename)[7];`

```perl
use strict;
use warnings;
use 5.010;

my $filename = "/etc/passwd";
my $size = (stat $filename)[7];
say $size;
```

We don't even need the `$size` variable for that, but we cannot simply write 
`say (stat $filename)[7];` or `print (stat $filename)[7];`.

The reason is that in this case perl will think the parentheses are part of the `say`
or `print` function and the `[7]` is an index on the return value of `say`
or `print`.

We can solve this by either adding the real parentheses of the `say/print` functions, or
by adding a `+` sign in-front of the parentheses:

```perl
use strict;
use warnings;
use 5.010;

my $filename = "/etc/passwd";
say ((stat $filename)[7]);
say +(stat $filename)[7];
```


## Object Oriented

Probably the most readable of all the solutions is the one using the [File::stat](https://metacpan.org/pod/File::stat) module.
It provides a replacement for the `stat` function of perl that will return an object which has, among several others, a method
called `size` that will return the size of the file.

Here too, the first version assigns the object to a variable called `$stat`, and the second method calls the `size` method
on-the-fly, without the need of the extra variable.

```perl
use strict;
use warnings;
use 5.010;

my $filename = "/etc/passwd";

use File::stat;
my $stat = stat($filename);
say $stat->size;

say stat($filename)->size;
```

## Comments

Dear Gabor,

I have many large files which need to verify the lines. I can use

 

system("wc -l < $filename");

 

or I can use

 

open (FILE,"$file");

 

while<file>;

 

my $size=$.;

 

Either way took almost 12s to get the solution. Is there any faster way to do so? Any further suggestion would be highly appreciated.

---


Have you tried writing wc -l $filename (without the redirection) ?

---

It makes no difference whether wc opens the file or the shell opens it on stdin and wc reads that.

---

Counting the number of lines in a file is inherently slow. You should reconsider whether you actually need to do this ... it's hard to imagine a situation in which you need to verify the number of lines in a file and a byte count wouldn't work just as well.

If you really really need this, then gnu's wc -l will be a lot faster than perl ... other implementations of wc may not be.


