# Double-space a file

Given a file

```
One
Two
Three
```

Convert it to

```
One

Two

Three

```

```
perl -i.bak -n -E 'say' src/examples/lines.txt
```


## Don't add the last empty row

```
$ perl  -n -E 'print "\n" if $. > 1; print' src/examples/linex.txt
one

two

three
```

{% embed include file="src/examples/linex.txt" %}
