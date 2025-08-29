---
title: "ANSI command line colors with Perl"
timestamp: 2022-09-05T07:30:01
tags:
  - ANSI
  - cat
  - color
  - more
  - less
published: true
author: szabgab
archive: true
show_related: true
---


Many command on the Unix/Linux command line will print out text in various colors. For example the `ls` command accepts a `--color`
flag and then it adds color to the file-system listings. You can convince your prompt to change color based on some condition.
e.g. the weather outside.

How can you create such colorful output with Perl and how could you do it manually?


The key to this is the [ANSI escape code tabel](https://en.wikipedia.org/wiki/ANSI_escape_code)
where you can find how to give instructions to the screen of a command-line window. Some of these instructions are related to color.

Here is an example script:

{% include file="examples/colors.pl" %}

Here I selected a few colors from the ANSI escape code table and put them in plain scalar variables. Then I only needed to print them to the screeen.

Running this script:

```
perl colors.pl
```

resulted in the following output on my computer:

<img src="/img/ansi-colors.png" alt="ansi colored output text">


## Color file content manually

If I run the same script and redirect the output to a file

```
perl color.pl > colors.txt
```

I'll get a "regular" text file that looks like this if I open it with any regular editor. e.g. vim.

{% include file="examples/colors.txt" %}

However using `cat` to display the file will evaluate the ANSI escape codes

```
cat colors.txt
```

and you will see the same as previously when we ran the Perl script.

<img src="/img/ansi-colors.png" alt="ansi colored output text">

However you don't need a Perl script to create the file. You can edit it manually as well.

The `more` command gives you the same colorful result:

```
more colors.txt
```

However, these ANSI escape codes confuse the `less` command:

```
less colors.txt
"colors.txt" may be a binary file.  See it anyway?
```


## less -rf and [Term::ANSIColor](https://metacpan.org/pod/Term::ANSIColor)

After posting this article I received a comment from Thomas Köhler telling me that `less -r`
would show the color. That helped me overcome my lazyness and checked the manual page of `less`.
I found that the `-f` flag would suppress the **may be a binary file.  See it anyway?** warning.
So you can use

```
less -rf colors.txt
```

He also showed two other ways to [use ANSI colors in Perl](http://gott-gehabt.de/800_wer_wir_sind/thomas/Homepage/Computer/perl/ansi-colors.html).

