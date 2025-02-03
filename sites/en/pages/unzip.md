---
title: "unzip using Archive::Any of Perl"
timestamp: 2021-03-25T15:30:01
tags:
  - unzip
  - zip
  - Archive
  - Archive::Any
published: true
author: szabgab
archive: true
description: "unizp zip files using a Perl module"
show_related: true
---


[Archive::Any](https://metacpan.org/pod/Archive::Any) makes it easy to unzip a file using Perl only.


Start by installing Archive::Any with your favorite method of module installation. e.g.

```
cpanm Archive::Any
```

Then you can use this example program.

{% include file="examples/unzip.pl" %}
