# Print a string

Strings in perl are either inside single-quotes (`''`) or double-quotes (`""`).


```
perl -E "say 'hello world'"
```

As in most other programming languages if you would like to use a quote character inside a string you will need to escape it by putting a backslash `\` in front of it.

```
perl -e "print 'hello \'nice\' world'"
```

This is doubly true for oneliners as the whole perl expression is also inside some kind of quotes.

```
$ perl -E "say 'hello \"nice\" world'"
hello "nice" world
```

However, perl allows you to use `q()` instead of single-quote and `qq()` instead of double quotes. That means we can rewrite the earlier example using either of them

```
perl -E "say q(hello 'nice' world)"
hello 'nice' world
```


```
$ perl -E "say qq(hello 'nice' world)"
hello 'nice' world
```

The difference betweem single- and doble-quotes is that in double-quotes variables are interpolated. We'll see that in later examples. In our current examples that did not matter.

