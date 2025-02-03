---
title: "$| or $OUTPUT_AUTOFLUSH - Buffering or autoflush?"
timestamp: 2021-04-10T11:30:01
tags:
  - $|
  - $OUTPUT_AUTOFLUSH
published: true
author: szabgab
archive: true
show_related: true
---


If set to nonzero, forces a flush right away and after every write or print on the currently selected output channel.

By default STDOUT - the standard output is the selected channel and the default value of the <b>$|</b> variable is 0.
That means it is buffered.

<b>$OUTPUT_AUTOFLUSH</b> is the name of the variable when the [English](/english) module is used.


## Autoflush or buffering STDOUT

In this example the <b>$|</b> variable is set from the command line.

{% include file="examples/autoflush_stdout.pl" %}

```perl
$ perl examples/autoflush_stdout.pl
STDERR First STDERR Second STDOUT First STDOUT Second

$ perl examples/autoflush_stdout.pl 0
STDERR First STDERR Second STDOUT First STDOUT Second

$ perl examples/autoflush_stdout.pl 1
STDOUT First STDERR First STDOUT Second STDERR Second
```

In the first two cases, when we keep the default or explicitely set it to 0, you can see thet the 2 prints to STDERR are displayed before the 2 prints to STDOUT.
That happens because STDOUT is buffered by default but STDERR is not.

In the 3rd example we set <b>$| = 1</b> thereby truning the autoflush on (the buffering off). In this case every print to STDOUT immediatly shows up on the screen
so the text arrives in the same order as it was sent in.


## Autoflush to a file

In this example you will see how to use <b>$|</b> to set autoflush on a filehandle, but a better, and more modern way is to use the <a href="/autoflush</a> method of the filehandle.

{% include file="examples/autoflush_select.pl" %}

By default a filehandle is buffered. In this example we use the <b>select</b> keyword to change the "current default output channel",
then set <b>$|</b> that now works on the filehandle, finally we change the "current default output channel" back to what was earlier
which normally is the STDOUT.

```
$ perl examples/autoflush_select.pl
0
0
0
23

$ perl examples/autoflush_select.pl 1
0
12
23
23
```

First time we run it without <b>autoflush</b> being on and as you can see the file does not grow while we write to it only after we explicitely close the filehandle the content is written to the disk. The output channel is being buffered,

The second time we turn <b>buffering</b> off on the filehandle using <b>select</b> and <b>$|</a> and thus after every <b>print</b> statement we see the file growing.

[documentation](https://metacpan.org/pod/perlvar#OUTPUT_AUTOFLUSH)

