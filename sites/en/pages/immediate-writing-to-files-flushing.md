---
title: "Immediate writing to file - flushing in Perl without buffering"
timestamp: 2021-10-04T12:11:11
tags:
  - flush
  - autoflush
published: true
author: szabgab
archive: true
---


When we say we read from a file or write to a file in Perl (or any other language for that matter), we don't actually access the file directly and immediately. Instead of that we what we really do is that we ask the operating system to read from the file or write to the file using a "system call". The Operating system (Linux, OSX, Windows, etc.) will do the work on our behalf, but it will try to optimize.

So it won't go and write to the disk immediately when we ask it to write a few characters. Instead of that it will keep the request in memory in a "buffer" and will write it to the disk later, when the buffer is full or when the file is closed.


Look at this example:

{% include file="examples/buffered_write.pl" %}

Here we opened a file for writing, wrote a few characters, even waited a second and then checked the size of the file.
It was 0.

Then we closed the file and checked the size again. It became 12.

In the general case this behaviour is good as this uses the optimization of the file-system so extensive disk-access won't bog down the whole system.

Sometime however you'd want to make sure the content is written to the disk immediately.

For example your application writes to some log file and you'd like to be able to track what's going on in "real time" without waiting for the system to empty its buffer.

## Append and close

One solution might be to create a funnction that will do all the writing to the file.
That function can open the file every time in **append** mode and then close the filehandle once it is done:

{% include file="examples/write_and_close.pl" %}

This solution is simple, but it incures the overhead of opening the file every time you would like to write to it.
It might not be the ideal solution.


## Flushing

Another solution migh be calling the `flush` method of the filehandle object every time you want to make sure the content was written to the disk. This will "flush" the content of the buffer to the disk.

{% include file="examples/flush.pl" %}

This however requires that you keep calling `flush` after every `print` or `say` statement.

## Autoflush

There is a better alternative. When you open the file you can turn on `autoflush` mode that will make sure
everything is written to the disk as soon as possible.

{% include file="examples/autoflush.pl" %}

You might wonder why not turn this always on.  Remember this will circumvent the disk access oprimizatins of your operating system
so the whole system will work much harder. Only do this if it is really importan that data is written immediately to the disk.


## IO::Handle

For older versions of Perl, you might need to include the following in your code for flush and autoflush to work:

```
use IO::Handle;
```

