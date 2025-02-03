---
title: "slurp mode - reading a file in one step"
timestamp: 2013-08-26T16:13:10
tags:
  - $/
  - local
  - $INPUT_RECORD_SEPARATOR
  - $RS
  - slurp
  - File::Slurp
  - Path::Tiny
published: true
books:
  - beginner
author: szabgab
---


While in most of the cases we'd process a [text file](/what-is-a-text-file) [line-by-line](/open-and-read-from-files),
there are cases when it is easier to do the work if all the content of the file is in the memory in a single scalar variable.

For example when we need to replace <b>Java is Hot</b> by <b>Jabba the Hutt</b> in a text file where the original text migh be spread
over more than one lines. For example:

```
... We think that Java
is Hot. ....
```

(Probably this is going to be funny only to programmers who are Star Wars fans and who have a Hungarian accent in
English as I do. Or maybe not even to them.)

In any case you can escape now and read more about [Jabba the Hutt](http://en.wikipedia.org/wiki/Jabba_the_Hutt) or about [Java](https://code-maven.com/java).


Before you go on reading, please note, in this article first you'll see the "manual" way to slurp in a file. You can do
that, but there are more modern and much more readable ways to do that
[using Path::Tiny](/use-path-tiny-to-read-and-write-file).

Let's see an example. This is what we have in the data.txt file:

```
Java is Hot

Java is
Hot
```

{% include file="examples/slurp_in_main.pl" %}

Running the above Perl program we get the following output:

```
Java is Hot

Java is
Hot
------------------------------
Jabba The Hutt

Jabba The Hutt
```

## Explanation

The `$/` variable is the <b>Input Record Separator</b> in Perl. When we put the read-line operator in scalar
context, for example by assigning to a scalar variable `$x = <$fh>`, Perl will read from the file up-to
and including the <b>Input Record Separator</b> which is, by default, the new-line `\n`.

What we did here is we assigned [undef](/undef-and-defined-in-perl) to `$/`. So the read-line operator
will read the file up-till the first time it encounters <b>undef</b> in the file. That never happens so it reads till
the end of the file. This is what is called <b>slurp mode</b>, because of the sound the file makes when we read it.

In case you are wondering about the regex part here is the quick recap provided by [J.L. Bismarck Fuentes](http://jlbfuentes.com/).

* `=~` regex matches `$data`
* `s` substitution, its syntax is `s/regex_to_match/substitution/modifiers`
* `\s+`  One or more whitespaces
* `g` Globally match the pattern repeatedly in the string

The big problem with the above code is that `$/` is a global variable. This mean if we change `$/` in one place
of our code, it will change the behavior of Perl in other places of our code.
It will impact even third-party modules used in our application. That is certainly not good.

So it is better to localize it:

## localize the change

{% include file="examples/slurp_localized.pl" %}


We have 3 changes in this code:
* We put the `local` keyword in front of the assignment to `$/`. This will make sure the value of `$/`
returns to whatever it was when the enclosing block ends.
* For this we needed an enclosing block, so we added a pair of curly braces around
the code-snippet dealing with the file.
* The third change is that we had to declare the `$data` variable outside of the block,
or it would go out of scope when the block ends.


## Creating a slurp function

In the third iteration of the code, we create a separate function called `slurp` that will get
the name of the file and return the content as a single string. This allows us to hide the code-snippet
at the end of the program or even in a separate file. It also makes it reusable, so instead of copying it
to other places where we might need the same functionality we can just call the `slurp` function.

This makes the main body of our code much nicer.

{% include file="examples/slurp_in_function.pl" %}

Of course we could further improve our slurp function by setting the encoding to `utf-8` and by providing better
error message in case one of the system calls fail.

## File::Slurp

In the article [replacing a string in a file](/how-to-replace-a-string-in-a-file-with-perl) we had a similar example,
except that there we used the `read_file` function of the [File::Slurp](https://metacpan.org/pod/File::Slurp) module.

## Path::Tiny

An even better solution is to use the [Path::Tiny](https://metacpan.org/pod/Path::Tiny)
module. It exports the `path` function that gets a path to a file as a parameter and returns
an object. We can then call the `slurp` or `slurp_utf8` methods on that object:

{% include file="examples/slurp_path_tiny.pl" %}

## Installing the modules

Neither of these modules come with the standard Perl distribution so you will need to install them first.
There are a number of ways to [install a Perl module from CPAN](/how-to-install-a-perl-module-from-cpan).

## Comments

As so far, it is not explained how this works:
$data =~ s/Java\s+is\s+Hot/Jabba The Hutt/g;

=~ -> regex matches $data
s -> substitution, its syntax is s/<regex_to_match>/<substitution>/<modifiers>
\s+ -> One or more whitespaces
g -> Globally match the pattern repeatedly in the string
See the perl documentation for more info https://perldoc.perl.org/perlre

<hr>

Once the file is slurped into $data is it possible to read line by line from $data?

You can split it by newline and do that, but I wonder, if you'd like to process it line-by-line then why read the whole file in memory?

Good point. I can explain why I wanted to do this in this way: I'm not a "real" programmer and I use mainly R (and SQL) where I usually read files into a so called dataframe (=table). From there I can work on this table, for example, selecting only rows which fullfills some criteria. So, now I learned that I have reconsider my habits. I will read line-by-line and create arrays or hashes according to the row criteria. By the way thank you very much for your blog.


<hr>

Please do not recommend File::Slurp. Use File::Slurper instead.

<hr>

In examples 2 and 3 the close $fh isn't needed. Perl will close the $fh when it reaches end of the scope.

<hr>

I prefer Path::Class slurp


use Path::Class qw{file};
my $content = file("filename")->slurp();
my @lines = file("filename")->slurp(chomp=>1);



