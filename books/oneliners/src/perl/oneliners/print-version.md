# Print the version of Perl

Before we get into the more interesting things, let's make sure that we have `perl` installed on the system and we can run it by printing the version number of the installed perl.

Open a terminal or on Windows open a CMD window and type in the following:


```
perl -v
```

The response I got on my Ubuntu Plucky Puffin (aka. 2025.04) is the following:

```
This is perl 5, version 40, subversion 1 (v5.40.1) built for
x86_64-linux-gnu-thread-multi
(with 48 registered patches, see perl -V for more detail)

Copyright 1987-2025, Larry Wall

Perl may be copied only under the terms of either the Artistic License or the
GNU General Public License, which may be found in the Perl 5 source kit.

Complete documentation for Perl, including FAQ lists, should be found on
this system using "man perl" or "perldoc perl".  If you have access to the
Internet, point your browser at https://www.perl.org/, the Perl Home Page.
```

The long flag should give you the same output:

```
perl --version
```


## Detailed version information

Using capital `-V` flag will give you a lot of details about the current version of perl. Most of which is probably not interesting so I won't bore you with explanations now.
However, you are welcome to try in and marvell about the details.

```
perl -V
```


## Latest Perl?

[Perl.org](https://www.perl.org/get.html) indicates that the latest stable version is 5.42.
It is recommended that you use the latest stable version, but for the examples in this book you can probably use much older versions of Perl as well.



