# Sum numbers in a file

{% embed include file="src/examples/numbers.txt" %}

```
$ perl -n -E 'END { say $c } $c += $_' src/examples/numbers.txt
21
```
