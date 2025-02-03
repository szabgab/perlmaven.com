---
title: "Epoch - The creation of the world"
timestamp: 2019-11-12T21:30:01
tags:
  - epoch
  - localtime
  - gmtime
  - time
  - DateTime
published: true
author: szabgab
archive: true
---


In case you were wondering what is the `epoch` that sometime we talk about,
it is the "start of the time" - as understood by your Linux/Unix-based computer.

Also know as the "creation of the world".

As you will see, it happened to fall on a Thursday.



{% include file="examples/epoch.pl" %}

In the output first you'll see the epoch in London (or more precisely in
[Greenwich](https://en.wikipedia.org/wiki/Greenwich_Mean_Time)) then the same in any location
that is in the GMT+2 timezone.

Then the same, formatted using the DateTime class.

Finally the value returned by the `time` function which is the current time in seconds since the epoch
and the same in a more readable format. (Yes, you see it well, I wrote this article on a Sunday at 7 am.)

<pre>
Thu Jan  1 00:00:00 1970
Thu Jan  1 02:00:00 1970
1970-01-01T00:00:00

1572757196
Sun Nov  3 07:01:41 2019
</pre>



