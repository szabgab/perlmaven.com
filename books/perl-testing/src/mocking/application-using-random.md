# Application using random

We have a simple application that uses the `rand` function to generate a random number between 0 and 1 (0 included, 1 not) and then it return an integer between 1 and n (both included).

{% embed include file="src/examples/mock-random/lib/MyRandomApp.pm" %}

This is a script using it.

{% embed include file="src/examples/mock-random/bin/dice.pl" %}

```
$ perl -Ilib bin/dice.pl
1
3
6
```


