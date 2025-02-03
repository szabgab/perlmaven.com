---
title: "Regex Problem splitting verilog Bit-Blasted pathes"
timestamp: 2019-04-16T17:00:01
tags:
  - regex
published: true
author: szabgab
archive: true
---



I have a list of bits  as below:

```
/ab_c/def/g_hi[1]
/asd/f_gh/qwe/rty[2][3]
/zxc/vbn/nmp_w[4][7][8]
```

I want to split them to path and bit like that:

```
/ab_c/def/g_hi           [1]
/asd/f_gh/qwe/rty      [2][3]
/zxc/vbn/nmp_w        [4][7][8]
```


I tried:

```
while (my $line = <$fh>) {
    my @path_splited =  $line =~ /(.*)(\[.*$)/;

    foreach my $n (@path_splited) {
        print "$n\n";
    }
}
```

got the below capturing format:

```
/ab_c/def/g_hi               [1]      --this is good
/asd/f_gh/qwe/rty[2]      [3]       --this is bad
/zxc/vbn/nmp_w[4][7]    [8]      --this is bad
```

looks like the second () captures only the last match.

Is there a way to tell Perl to catch the maximal match instead of the minimal?


## Solution

Use this regex:

```
/([^\[]*)(\[.*$)/
```

Taking this apart there are two group: `([^\[]*)` and `(\[.*$)`.

The first on captures any character that is not an open square bracket. (This is the `[^\[]` character-class.
We apply the `*` quantifier to it so it will be able to capture 0 or more characters. Effectively capturing
everything up-to but not including the first opening square bracket.

The second expression captures an opening square bracket `\[` and every other character following that `.*`.

Then whatever they captured will be in `$1` and `$2` respectively.



