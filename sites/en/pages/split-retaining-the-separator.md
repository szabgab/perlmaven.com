---
title: "Split retaining the separator or parts of it in Perl"
timestamp: 2017-10-30T07:30:01
tags:
  - split
published: true
author: szabgab
archive: true
---


Usually when we use [split](/perl-split), we provide a regex.
Whatever the regex matches is "thrown away" and the pieces between these matches are returned.
In this example we get back the two strings even including the spaces.

{% include file="examples/split_str.pl" %}


```
$VAR1 = [
          'abc ',
          ' def'
        ];
```

If however, the regex contains capturing parentheses, then whatever they captured will be also included
in the list of returned strings. In this case the string of digits '23' is also included.

{% include file="examples/split_str_retain.pl" %}

```
$VAR1 = [
          'abc ',
          '23',
          ' def'
        ];
```

## Only what is captured is retained

Remember, not the separator, the substring that was matched, will be retained, but whatever is in
the capturing parentheses.

{% include file="examples/split_str_multiple.pl" %}

```
$VAR1 = [
          'abc ',
          '2',
          '3',
          ' def '
        ];
```

In this example the `=` sign is not in the resulting list.

## Comments

That should be obvious. But it wasn’t to me. I can recall a few times I would’ve liked to retain the separators. Another tool for the tool box. Thanks!


