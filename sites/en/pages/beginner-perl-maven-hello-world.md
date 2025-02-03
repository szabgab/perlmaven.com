---
title: "Your first script: Hello world - video"
timestamp: 2015-01-26T09:01:47
tags:
  - print
  - ;
  - \n
types:
  - screencast
published: true
books:
  - beginner_video
author: szabgab
---


The first script you write: printing Hello World to the screen. Separate statements with semi-colons `;`.
Separate parameters with comma: `,`. Print newlines using `\n`.


<slidecast file="beginner-perl/hello-world" youtube="h0VHYdESJWM" />

```perl
#!/usr/bin/env perl
use strict;
use warnings;

print "Hello world\n";
print 42, "\n";
```

<b>chmod u+x hello_world.pl</b>

See also the [getting started article](/installing-perl-and-getting-started)
and the one about the [sh-bang, she-bang or hashbang](/hashbang).


