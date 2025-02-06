---
title: "Processing command line arguments - @ARGV in Perl"
timestamp: 2013-07-07T17:13:10
description: "In Perl @ARGV contains the raw command line arguments as passed by the user running the script"
tags:
  - "@ARGV"
  - "$ARGV[]"
  - "$0"
  - shift
  - argc
published: true
books:
  - beginner
author: szabgab
---


If you wrote a Perl script, for example <b>programming.pl</b>,
your users can run the script on the command line using <b>perl programming.pl</b>.

They can also pass any command line arguments like this <b>perl programming.pl -a --machine remote /etc</b>.
No one will stop the users from doing that, and the script will disregard these values.
The question then how can you, the author of the script, know which values were passed, if any?


## Command line

Perl automatically provides an array called `@ARGV`, that holds all the values from the command line.
You don't have to declare the variable, even if you `use strict`.

This variable always exists and the values from the command line are automatically placed in this variable.

If there are no parameters, the array will be empty. If there is one parameter on the command line, that value will
be the only element in `@ARGV`. In the above example the `@ARGV` will have the following elements:
-a, --machine, remote, /etc

Let's see this in action:

Save this code as <b>programming.pl</b>:

```perl
use strict;
use warnings;
use Data::Dumper qw(Dumper);

print Dumper \@ARGV;
```

Run it like this: `perl programming.pl -a --machine remote /etc` and this is the output:

```
$VAR1 = [
          '-a',
          '--machine',
          'remote',
          '/etc'
        ];
```

As you can see we used the `Dumper` function of `Data::Dumper` to print
out the content of `@ARGV`

If you are coming from another programming language, you might be wondering:
<b>where is the name of the Perl program?</b>

## The name of the script is in $0

The name of the program being executed, in the above case <b>programming.pl</b>, is always in the `$0`
variable of Perl. (Please note, `$1`, `$2`, etc. are unrelated!)

## C programmer

In case you know the <b>C programming language</b>, this is similar to <b>argv</b>, except that the
`@ARGV` of Perl does <b>not</b> contain the name of the program.
It can be found in the `$0` variable. Also a variable such as <b>argc</b> is not necessary,
as you can easily get the [number of elements in the @ARGV array](/scalar-and-list-context-in-perl)
using the `scalar` function or by putting the array in
[scalar context](/scalar-and-list-context-in-perl).

## Unix/Linux Shell programming

In case you arrive from the world of <b>Unix/Linux Shell programming</b> you will recognize `$0`
is being the name of the script there too. In shell however `$1`, `$2`, etc.
hold the rest of the command line parameters. These variables are used by
the regular expressions of Perl. The command line arguments are in `@ARGV`. Similar to `$*`
in the Unix/Linux shell.

## How to extract the command line arguments from @ARGV

`@ARGV` is just a regular [array in Perl](/perl-arrays).
The only difference from arrays that you create, is that it does not
need to be declared and it is populated by Perl when your script starts.

Aside from these issue, you can handle it as a [regular array](/perl-arrays).
You can go over the elements using `foreach`, or access them one by one using an index: `$ARGV[0]`.

You can also use [shift, unshift, pop or push](/manipulating-perl-arrays) on this array.

Indeed, not only can you fetch the content of `@ARGV`, you can also change it.

If you expect a single value on the command line you can check what was it, or if it was provided at all
by looking at `$ARGV[0]`. If you expect two variables you will also check `$ARGV[1]`.

For example, let's create a phone book. If you provide one name, the application will print the corresponding phone
number. If you give a name and a number the program will save that pair in the "database".
(We won't actually handle the "database" part of the code, we just pretend we have something.)

We know that the parameters will arrive in `$ARGV[0]` and maybe also in `$ARGV[1]`, but
those have no meaning besides being the first and second element of an array.
Usually it is better to use your own named variables in your code instead of $ARGV[0] and similar.
So the first thing we'll want is to copy the values to variables with representative names:

This can work:

```perl
my $name   = $ARGV[0];
my $number = $ARGV[1];
```

But this is much nicer:

```perl
my ($name, $number) = @ARGV;
```

Let's now see the full example (well, except of the database part).
Save the following code in <b>programming.pl</b>.

```perl
use strict;
use warnings;

my ($name, $number) = @ARGV;

if (not defined $name) {
  die "Need name\n";
}

if (defined $number) {
  print "Save '$name' and '$number'\n";
  # save name/number in database
  exit;
}

print "Fetch '$name'\n";
# look up the name in the database and print it out
```

After copying the values from `@ARGV`, we check if the name was provided.
If not, we call `die` that will print an error message and exit the script.

If there was a name, then we check for the number. If there was a number we save
it in the database (which is not implemented above) and exit the script.

If there was no number then we try to fetch it from the database. (Again, not implemented here.)

Let's see how it works: (The $ sign only marks the prompt, we don't type that.)

```
$ perl programming.pl Foo 123
Save 'Foo' and '123'

$ perl programming.pl Bar 456
Save 'Bar' and '456'

$ perl programming.pl John Doe 789
Save 'John' and 'Doe'
```

The first two calls were OK, but the last one does not look good.
We wanted to save the phone number of "John Doe" to be 789, but instead of that
our script saved the phone number of "John" as if it was "Doe".

The reason is simple, and it has nothing to do with Perl. This would work the same in any other language.
The shell or command line, where you run the script takes the line apart and passes the values to perl which then
puts them in `@ARGV`. Both the Unix/Linux shell and the Windows Command Line will split the command line
at every space. So when we typed `perl programming.pl John Doe 789`, the shell actually passed 3 parameters to
our script. In order to make it work correctly the user has to put the values that have embedded spaces inside quotes:

```
$ perl a.pl "John Doe" 789
Save 'John Doe' and '789'
```

You, as the programmer cannot do much about this.

## Checking the arguments

Maybe you could check if the number of elements does not exceed the number you expected.
It would stop the user from making the above mistake, but what if the user wants
to fetch the phone number of John Doe and forgets the quotes:

```
perl a.pl John Doe
Save 'John' and 'Doe'
```

In this case there were 2 parameters which is the correct number of arguments.

Here too, you could make a slight improvement and check if the content of the `$number` variable
is in a format you accept as phone number. That would reduce the possibility for mistakes in this case.
That still would not be perfect and certainly not an universal solution:
In other applications there might be several parameters with the same constraints.

Unfortunately there is not a lot we can do when parsing `@ARGV` "manually".
In another article I'll write about `Getopt::Long` and similar libraries
that make life a bit easier, but let's see another simple case now.


## shift a single parameter

A common case is when you expect the user to provide a single filename on the command line.
In that case you could write the following code:

```perl
my $filename = shift or die "Usage: $0 FILENAME\n";
```

Let's break that line into two parts for easier explanation:
`my $filename = shift`

Normally [shift](/manipulating-perl-arrays) would get an array as its parameter,
but in this case we used it without a parameter. In such cases shift defaults to work
on `@ARGV`. So the above code will move the first value of `@ARGV` to the
`$filename` variable. (At least when the code is not in a subroutine.)

Then we basically have the following code:
`$filename or die "Usage: $0 FILENAME\n"`

This is a [boolean](/boolean-values-in-perl) expression.
If the `$filename` contains the name of a file
then it will be [considered True](/boolean-values-in-perl) and the script will go
on running without executing the `or die ...` part.
On the other hand, if the @ARGV was empty, `$filename` was assigned `undef`,
and it will [count as False](/boolean-values-in-perl)
and Perl will execute the right-hand-side of the `or`statement,
printing a message to the screen and exiting the script. 

So effectively, this piece of code would check if a value was provided on the command line. The value
is copied to `$filename`. If there was no value, the script would `die`.

## Minor bug

There is one minor bug in the above code. If the user supplies 0 as the name of the file. It will still
be seen as False and the script will refuse to handle such a file. The question though: Does it matter?
Can we live with the fact that our script might not handle a file called <b>0</b>... ?

## Complex cases

There are a lot of other cases that are much more complex than the above one or two parameter cases.
For those cases you'd probably want to use a tool such as `Getopt::Long` that will be able to analyze
the content of `@ARGV` based on some declaration of what kind of parameters you'd want to accept.


## Comments

Thanks so much.

I haven't written Perl since the dot com boom but now Im using it again for my work in the solar power industry reading data from, and creating 8logs and graphs of solar system performance because the manufacturer software is bad so its an inside job now.

Y'all pop high on google and your info is great!

What, no PayPal link? Think about it.

---

Thanks. You could support the crowdfunding of my Dancer book. See the book cover in the middle of the article.

<hr>

The typic extraction is done with a loop
e.g.
for ( my $i = 0 ; $i <= $#ARGV ; $i++ ) {
$valid = $ARGV[$i];
if ( substr( $ARGV[$i], 0, 1 ) ne '-' ) {
push( @toplevel, $ARGV[$i] );
$valid = '';
}
elsif ( $ARGV[$i] eq '-i' ) {
$map = $ARGV[ ++$i ];
$valid = '';
}
elsif ( $ARGV[$i] eq '-n' ) {
$uvm_reg_file_name = $ARGV[ ++$i ];
$valid = '';
}
elsif ( $ARGV[$i] eq '-o' ) {
$outputdir = $ARGV[ ++$i ];
$valid = '';
}
if ($valid) {
print "Invalid option '$valid'\n";
usage();
exit;
}
}

---

No. The typical extraction is done by one of the Getopt modules.

<hr>

Write a Perl program to create an associative array ("hash") named "last_name"
whose keys are the five first names "Mary", "James", "Thomas", "William", "Elizabeth".
Set the corresponding values for these keys to be "Li", "O'Day", "Miller", "Garcia", "Davis".
Then print out the five full names, each on its own line, sorted primarily by length of last name
and with a secondary sort alphabetically by first name.

<hr>

Using "//" will avoid "0"

```perl
my $name = $ARGV[0] // die "need name. \n";
```

The article is great 😃

<hr>

I have version 5.28.1 of Active State PERL. I have a program that had been working fine, but now for some reason, the @ARGV array no longer holds the command line arguments. I used debug to check the array and $#ARGV = -1 and the array elements were empty. After checking and printing the version # of PERL, and setting the use statements, I do this test.

# Validate command line
if ((!(@ARGV)) || ($#ARGV != 2 )) {
# if command line invalid, print Usage:
print "Syntax: RenameFiles.pl <pathtodir> <oldnamestringfrag> <newnamestringfrag>\n\n Put quotes around path and file names containing spaces\n" ;
die "Need path to target directory, OldStrFrag, ReplacementStringFrag!\n" ;
}

In debug mode, I inserted correct values for the @ARGV array prior to reaching this point in the code and the program executed correctly. Any idea of what is up? I am using Windows 10 Pro.

<hr>

how to take $ARGV[0] as input and open it as a file for reading

<hr>

I am having issues with using the asterisk (*) as a parameter when running Perl from DOS on Windows 10. The asterisk parameter is automatically being expanded into multiple parameters. Each of the parameters received into @ARGV are file names within the current path. To get around this I need to modify all of my Perl programs so that when I run them I must enter '*' rather than just the asterisk. When this is accomplished then the Perl program receives $ARGV of '*'. It is then necessary for me to eliminate the leading and trailing single quote characters in order for my original programs to function properly.

Are you aware of any Windows 10 OS setting that is causing the automated expansion of the asterisk within parameters? I know this is normal for certain DOS commands such as DIR *, but this seems to be new for me running a Perl program. Or, is this a new issue with the version of Perl that I am running? My Perl version is "This is perl 5, version 14, subversion 4 (v5.14.4) built for MSWin32-x86-multi-thread".

<hr>

What about Windows?

The don't working:

perl some_code.pl *

Don't print list of files in directory

---

One needs to understand that * on the command line is handled on Linux/Mac by the shell. Windows ignores it.
Unrelated to the programming language you use.

----

I understand this already. I dont use now @ARGV but use glob(. * *) - its works at Windos and Unix.

