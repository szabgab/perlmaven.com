---
title: "Get absolute path (aka. canonical path) using abs_path or canonpath"
timestamp: 2020-07-07T08:30:01
tags:
  - Cwd
  - abs_path
  - File::Spec
  - canonpath
published: true
author: szabgab
archive: true
description: "Convert a relative file or directory path to an absolute or canonical path."
show_related: true
---


It is often a good idea to have your configuration files or your code contain <b>relative pathes</b> to
various locations as that makes it easy to install your application in different places.

It also makes it a lot  easier to run two totally separate copies of the same program on the same machine.

However, when accessing the files it is often better to use the absolute path-es.

So the question arises: <b>How can you convert a relative path to an absolute path?</b>


There are are several way you can do even with standard Perl modules:

{% include file="examples/absolute_path.pl" %}

```
perl examples/absolute_path.pl
```

{% include file="examples/absolute_path.out" %}

