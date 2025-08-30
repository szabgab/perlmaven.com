---
title: "Solution: Hello World part 2 (what is the difference between comment and POD?) - video"
timestamp: 2015-02-15T12:02:29
tags:
  - perldoc
  - pod2html
  - lynx
types:
  - screencast
published: true
books:
  - beginner_video
author: szabgab
---


First exercise, second part


{% youtube id="QpRnR_w8FVk" file="beginner-perl/solution-hello-world-2" %}

## Write a simple script that prints     Hello world

```perl
print "hello world\n";
```

```
$ perl hello.pl
```

```perl
use strict;
use warnings;

print "hello world\n";
```


## Add comments to your code

```perl
use strict;
use warnings;

print "hello world\n";  #comment

# some comment
```


## Add user documentation to your code

```perl
use strict;
use warnings;

print "hello world\n";  #comment

# some comment
=pod
=head1 Title
text
=cut
```

```
$ perl hello.pl
$ perldoc hello.pl
```

But that does not look really good and `perldoc` reported about some error too.

That's because POD requires empty rows around its tags:

```perl
use strict;
use warnings;

print "hello world\n";  #comment

# some comment

=pod

=head1 Title

text

=cut
```


```
$ perldoc hello.pl

$ pod2html hello.pl > hello.html

$ lynx hello.html
```


