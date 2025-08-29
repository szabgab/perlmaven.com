---
title: "Buffering or autoflush?"
timestamp: 2021-04-10T11:35:01
tags:
  - autoflush
published: true
author: szabgab
archive: true
show_related: true
---


By default every filehandle opened for writing is buffered. We can turn of buffering (or in other words turn on autoflush)
by calling the **autoflush** method of the filehandle.

Alternatively we can use **select** and set [$|, $OUTPUT_AUTOFLUSH to 1](/outout-autoflush) to enable autoflush.

The recommended solution is the one in this article as it makes the code more readable.


{% include file="examples/autoflush.pl" %}

By default a filehandle is buffered. In this example we use the **autoflush** method of the filehandle object to make it flush to the file automatically.

```
$ perl examples/autoflush.pl
0
0
0
23

$ perl examples/autoflush.pl 1
0
12
23
23
```

First time we run it without **autoflush** being on and as you can see the file does not grow while we write to it only after we explicitely close the filehandle the content is written to the disk. The output channel is being buffered,

The second time we turn **autoflush** on the filehandle and thus after every **print** statement we see the file growing.
