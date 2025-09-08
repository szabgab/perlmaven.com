# Print a number, use Perl as your calculator

You can execute any perl code that you provide on the command line as the value of the `-e` or the `-E` flag. The difference between the two is that `-E` enables all optional features and builtin functions
that were added since version 5.10 came out in, well a very long time ago.

The first such extra that we get using `-E` is the `say` function.

* `print` will print the value after it
* `say` will also print the value after it, but it will also print a newline. `\n` at the end.


```
perl -e "print 42"


perl -E "say 42"
```

## Forgetting the `-E` flag

What happens if you try to use the `say` function, but mistakenly use the `-e` flag? You get an error:

```
$ perl -e "say 42"
Number found where operator expected (Do you need to predeclare "say"?) at -e line 1, near "say 42"
syntax error at -e line 1, near "say 42"
Execution of -e aborted due to compilation errors.
```

## Calculator

You can use perl on the command line as a calculator:

```
$ perl -E "say 19 * 23"
437

$ perl -E "say 19 + 23"
42
```


---

* -e
* -E
* print
* say


