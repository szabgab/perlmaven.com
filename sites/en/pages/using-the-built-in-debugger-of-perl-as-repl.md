---
title: "Using the built-in debugger of Perl as REPL"
timestamp: 2015-02-10T17:30:56
tags:
  - REPL
  - -d
types:
  - screencast
published: true
author: szabgab
---


This screencast is showing how to use the command line debugger of perl to explore Perl.


{% youtube id="pL_nDlXNqLY" file="perl_debugger_as_repl.mp4" %}

As you might know you can run perl code on the command line without even creating a script using the `-e` flag:
```
$ perl -e "print 42"
```

The same way you can also run the a code that consists of the number 1 only, that of course won't do anything:

```
$ perl -e 1
```

Except that we could include the `-d` flag and that would run that code in the debugger

```
$ perl -d -e 1
```

Because we can combine some of the command line flags, we can also write this:

```
$ perl -de1
```


We can print a number using ther perl function `print`. We can assign a value to a scalar variable.
(There is no need to declare the variables using `my`.) We can then print the content of the variable
using the `print` function of Perl.

If we are lazy, and we should be lazy, we can use the `p` command of the debugger which just does the same
as the `print` function of perl.

```
 DB<1> print 42
42

 DB<2> $x = 42

 DB<3> print $x
42

 DB<4> p $x
42
```

We can also assign values to an array such as `@names`. If we print it out using `print`,
or for that matter using the `p` command of the debugger, the values will be smashed together
and we won't see the separate values.  Not very useful.

We can put the array in double quotes `"@names"` which will get the `print` function to
include spaces between the values, but we still won't know if the array had 3 values, or one value with 2 spaces
in it. A much better way to display an array is the `x` operator of the debugger which is quite similar
to [Data::Dumper](https://metacpan.org/pod/Data::Dumper). It also expects a reference to an array,
hence we added the backslash in-front of the array.

```
 DB<5> @names = qw(Foo Bar Baz)

 DB<6> print @names
FooBarBaz

 DB<7> print "@names"
Foo Bar Baz

 DB<8> x \@names
0 ARRAY(0x1a41c68)
  0  'Foo'
  1  'Bar'
  2  'Baz'
```

We can also create a hash, and we can use the `x` operator on the reference to that hash,
to print it out:

```
 DB<9>  %h = (fname => 'Foo', lname => 'Bar')

 DB<10> x \%h
0 HASH(0x1a41d70)
  'fname'  => 'Foo'
  'lname'  => 'Bar'
```


We can also execute any Perl statement. For example we can use the `push` function on the
array appending a new element to it and then we can check the content of the array again:

```
 DB<11> push @names, 'Moose'

 DB<12> x \@names
0 ARRAY(0x1a41c68)
  0  'Foo'
  1  'Bar'
  2  'Baz'
  3  'Moose'
```


We can also load modules with `use` and the we can call the functions imported by the module.

```
 DB<13> use Cwd

 DB<14> cwd

 DB<15> p cwd
/home/gabor
```


We can also load the `File::Basename` module.

```
 DB<16> use File::Basename

 DB<17> p basename(cwd)
gabor
```

Using the `b` command of the debugger, we can set a breakpoint at the
entrance of any function which is already in memory. Even if it is in a Perl
module written by someone else.
After setting the breakpoint if we run the function again, it will stop just when we enter the function.

```
 DB<18> b File::Basename::basename

 DB<19> p basename(cwd)
File::Basename::basename(/usr/share/perl/5.10/File/Basename.pm:215):
215:      my($path) = shift;
```


Then we can look around. For example we can use the `l` command to list
the next few lines of the source code

```
 DB<<20>> l
215==>b  my($path) = shift;
216
217   # From BSD basename(1)
218   # The basename utility deletes any prefix ending with the last slash '/'
219   # character present in string (after first stripping trailing slashes)
220:  _strip_trailing_sep($path);
221
222:  my($basename, $dirname, $suffix) = fileparse( $path, map("\Q$_\E",@_) );
223
224   # From BSD basename(1)
```

We can also list any section of the code by supplying the line numbers:

```
 DB<<20>> l 200-220
213
214    sub basename {
215==>b  my($path) = shift;
216
217      # From BSD basename(1)
218      # The basename utility deletes any prefix ending with the last slash '/'
219      # character present in string (after first stripping trailing slashes)
220:     _strip_trailing_sep($path);
```

Finally, for this screencasts, we can quite the debugger using `q`:

```

 DB<<21>> q

$
```

## The debugger commands

* p - print scalar
* x - print data structure
* b subname - set breakpoint
* l - list the next few lines of the source code
* l from-to - list source code between given lines
* q - quit the debugger

