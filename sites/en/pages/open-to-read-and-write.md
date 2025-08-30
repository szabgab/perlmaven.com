---
title: "Open file to read and write in Perl, oh and lock it too"
timestamp: 2017-12-07T07:30:01
tags:
  - open
  - flock
  - seek
  - truncate
  - Fcntl
  - SEEK_END
published: true
author: szabgab
archive: true
---


If you don't have time to read this, just use

```perl
open my $fh, '+<', $filename or die;
```

If you have time, read on.

In most cases when you need to updated a file the best strategy is to read the entire file into memory,
make the changes and then write the whole file back. Well, of course unless the file is too big, which is
a separate story.


In most of these cases it is ok to

1. [open the file for reading](/open-and-read-from-files)
1. [read the whole content](/slurp)
1. make changes in memory
1. open the file again, this time [for writing](/writing-to-files-with-perl)
1. write out the whole content

However, sometimes you need to make this operation "atomic", that is, you need to make sure
no other process will change the file while your are changing it.

OK, so just to clarify, you probably **never** want other process to modify the file
while you do it, but in most cases you don't have to worry about that as no other processes
are dealing with the file.

What happens when there are competing processes? Even if that is the same script?

This script is a counter that for every invocation increases the number in the `counter.txt`
file by one and prints it to the screen:

{% include file="examples/counter_plain.pl" %}

Create a file called `counter.txt` with a single 0 in it and then run:

```
perl counter_plain.pl
```

several times. You'll see the number incremented as expected.

What if several people invoke the script at the same time?

To demonstrate that we will run the script 1000 times in two separate windows.

IF you are using Linux or Mac you can use the following Bash snippet:

```
for x in {1..1000}; do perl counter_plain.pl; done
```

I have not tried this on Windows, and because it has a different file-locking methodology
the results might be totally different.

If you execute the above command in two terminals at more or less the same time, you'll
see the numbers progressing, but they'll not reach 2,000. They might even get reset
to 1 from time-to-time as the file operations of two instances of the script collide.

## Locking

On Unix-like operating systems, such as Linux and OSX, we can use the native file locking mechanism
via the `flock` function of Perl.

For this however we need to open the file for both reading and writing.

{% include file="examples/counter_lock.pl" %}

In this script we

1. Open the file for reading and writing
1. Ask for an exclusive lock on it. (Wait till we get it).
1. Read the file content.
1. Make the changes in memory. (increment by 1)
1. Rewind the filehandle to the beginning using the `seek` function.
1. Remove the content of the file using `truncate`.
1. Write the new content
1. `close` the file (and by that free the lock)

We could not open the file separately once for reading and once for writing,
the closing of the filehandle always frees the lock. So the other instance of our script
might come between the two open calls in our instance.

We needed to rewind the filehandle (using `seek`) so we write the new content at the beginning of the file and not
at the end.

In this case we did not have to `truncate` the file as the new content is never going to be shorter than
the old content (after all the numbers are only incrementing), but in the general case it is a better practice.
It will ensure that we don't have left-over content from the previous version of the file.

If you try to run this script 1,000 each in two separate windows you'll see it reaches 2,000 as expected.

## Comments

Thanks Gabor, I've also use a semaphore methodology to achieve file locking when the file system won't cooperate and my script is the only processing modifying the file - this was a groupware project.

For each run of the script that needs to modify a file, potentially over a long period of time. (this was a CGI script and Mac OS9 wasn't too keen on flock at the time)

For each time through the script
1 - Check for the presence of a semaphore file.
2 - If not present open a new semaphore file with a predetermined name.
3 - Optionally add contents such as current process or user name.
4 - Open data file as outlined above
5 - Let current process run through.
6 - Write contents to data file as outlined above
7 - Delete the semaphore file

2a - If the semaphore file is present, optionally read the process/user and send a message to the requestor.

This works as long as each process that accesses the file agrees to check for the semaphore file. I included a function to delete the semaphore file if the script quit unexpectedly due to a server reboot or something.

Let me know if anyone would like the code for this process or why or why not it should be used.

---
It is a reasonable process, but because 1-2 are not atomic operations that means two process A and B might do in the following order: A1 B1 A2 B2, or if you have multiple cores then even at A1 and B1 can happen at the same time. So there is some risk. Flock (on Linux, Unix) eliminates the risk.

---
Thanks Gabor - those are good points. My app was for a small (less than 10) group of users, so close race conditions weren't an issue (I think) - but if this was used by a larger group, then everything with flock here definitely applies.

---

Hello Gabor,
It was an amazing post, but I need to clarify 1 thing. Can we parse a JSON file instead of TXT file in the above example?
---
For that you are better off using a JSON module:  https://perlmaven.com/json

