# Use module to add numbers in a file


{% embed include file="src/examples/numbers_in_line.txt" %}

```
$ perl -n -E 'use List::Util qw(sum); say sum(split)' src/examples/numbers_in_line.txt
16
```

