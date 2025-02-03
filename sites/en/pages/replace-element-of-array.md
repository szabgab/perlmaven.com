---
title: "How to change an element of an array in Perl"
timestamp: 2020-11-02T08:30:01
tags:
  - @array
  - $array[$i]
published: true
author: szabgab
archive: true
---


```perl
$i = 3;
$array[$i] = $new_value;
```


## Full example

{% include file="examples/replace_element_of_array.pl" %}

Before:

```perl
$VAR1 = [
          'Issac Asimov',
          'Arthor C. Clarke',
          'Ray Bradbury',
          'Foo Bar',
          'Philip K. Dick',
          'H. G. Wells',
          'Frank Herbert'
        ];
```

After:

```perl
$VAR1 = [
          'Issac Asimov',
          'Arthor C. Clarke',
          'Ray Bradbury',
          'Jules Verne',
          'Philip K. Dick',
          'H. G. Wells',
          'Frank Herbert'
        ];
```

Read more about [arrays in Perl](/perl-arrays).

