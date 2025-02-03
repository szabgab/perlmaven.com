---
title: "EOF - End of file in Perl"
timestamp: 2014-01-22T05:49:01
tags:
  - eof
published: true
books:
  - beginner
author: szabgab
---


As the [documentation of eof](/perldoc/eof) also points out, you almost never need to call `eof()` in Perl.
In most cases operations that read from file-handles will return [undef](/undef-and-defined-in-perl)
when they reach the end of the file or when they reach the end of the data available.


## Reading text file in while loop

`<$fh>`, the "readline" operator in Perl returns `undef` when there is no more to read from the file-handle:

```perl
open my $fh, '<', 'data.txt' or die;
while (my $line = <$fh>) {
}
```

The same is true for the diamond operator, which is just a special case of the "readline" operator:

```perl
while (<>) {
}
```

## Reading file in list context


```perl
open my $fh, '<', 'data.txt' or die;
my @lines = <$fh>;
```

In this case even checking for `undef` is unnecessary as Perl will just end the operation when the
input is exhausted.

## Reading binary file

Even when reading binary files using `read` we don't need to check for end of file manually
as `read` will return 0 at the end of file. So we can write:

```perl
open my $fh, '<:raw', $file or die;
my $buf;
while (read $fh, $buf, 1000) {
}
```


