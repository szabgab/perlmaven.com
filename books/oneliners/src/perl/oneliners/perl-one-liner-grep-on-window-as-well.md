# Using `grep` on Windows as well

How can you search for all the occurrences of the 'secret' in your xml files?

On Linux and macOS you would probably use `grep` or `egrep`. You can also install some kind of `grep` on MS Windows as well, but if you already have Perl installed then you can use it as well.

## In a single file

```
perl -ne "print if /secret/" main.xml
```

* `-e` tells perl to use the parameter as perl code
* `-n` tells perl to execute that code on every line of the input file and on each iteration put the current line in the default variable called `$_`.
* `print` without parameters will print the content of `$_`.
* `/secret/` is regex (the slashes are the delimiters). If no `=~` is provided then it works in the content of the default variable called `$_`.

The above line is the same as the one below:

```
perl -n -e "print $_ if $_ =~ /secret/" main.xml
```

Use Deparse to convert the oneliner into full script to make it more readeble.

```
$ perl -MO=Deparse -ne "print if /secret/" main.xml

LINE: while (defined($_ = readline ARGV)) {
    print $_ if /secret/;
}
-e syntax OK
```



## In multiple files

As Windows does not handle wildcards on the command line, we cannot supply `*.xml` and expect it to handle all the xml files.
We help it with a small `BEGIN` block. `$ARGV` holds the name of the current file

```
perl -ne "BEGIN{ @ARGV = glob '*.xml'} print qq{$ARGV:$_} if /secret/"
```

* The `BEGIN {}` construct will be executed once, before we start looping over the lines
* `glob '*.xml'` is an expression in perl returning the list of all the files in the current folder with `xml` extension.
* `@ARGV` is the global variable that holds the command line parameters. Usually it is filled by perl when a script starts. Here we fill it ourselves from inside the perl code.
* The `-n` flag tells perl to iterate over every line in every file listed in `@ARGV`. On every iteration the name of the current file is in the `$ARGV` variable and the current line is in the `$_` variable.
* In this example we use the reversed `if`-statement (do something if some condition).
* `/secret/` is a regex checking if the current content of `$_` matches the series of characters: `secret`.


We can use the [B::Deparse](https://metacpan.org/pod/B::Deparse) library to ask perl to show how it understands our code:

```
$ perl  -MO=Deparse -ne "BEGIN{ @ARGV = glob '*.xml'} print qq{$ARGV:$_} if /secret/"
LINE: while (defined($_ = readline ARGV)) {
    sub BEGIN {
        use File::Glob ();
        @ARGV = glob('*.xml');
    }
    print ':main.xml' if /secret/;
}
-e syntax OK
```

