---
title: "tell how far have we read a file"
timestamp: 2020-07-03T14:30:01
tags:
  - tell
  - read
published: true
books:
  - beginner
author: szabgab
archive: true
---


In very rare cases you might need very some very fine-tuned file reading operations in which after reading some part of a file you might need to re-read that part,
or you might need to jump over large sections of a file. The two tools for this are `tell` and `seek`.

`tell` can, well, tell you the current position of the filehandle. How far are the reader head from the beginning of the file.

`seek` can move the current position of the filehandle very fast.


## tell

In the first example we expect a filename on the command line. After opening it, first we use the readline operator to read the first line. The we display the content of this line, the size of it and what `tell` thinks of the location of the file reader.

Then we use the `read` function that we saw when we were dealing with [binary files](/reading-and-writing-binary-files) to read in another 20 bytes. This time instead of reading a whole line we read a chunk that might be shorter or longer than a line. Then we print the content again together with the current location of the reader and the size of what we read in.

{% include file="examples/read-and-tell.pl" %}

The easiest might be to feed the script with itself. That is, use the script as the parameter as well. That way we don't need to prepare an additional input file for the example.
So we run this:

```
$  perl examples/read-and-tell.pl examples/read-and-tell.pl
```

The result looks like this:

```
'use strict;
'
12
12
'use warnings;
use 5.'
20
32
```

Here we can see that the readline operator `&lt;$fh&gt;` read in the first line including the trailing newline. It was 12 bytes long and thus the file-reader is at position 12.

Then the instruction to read in 20 bytes read in the next line and a few bytes from the 3rd line as well. The length of what we read is not very surprisingly 20. After all that's the number we asked for. The only way that this will read in a different number of bytes is if the file does not have that many bytes left.

We can then observer that the current position of the reader is 32 bytes from the head of the file. That is 12+20.

