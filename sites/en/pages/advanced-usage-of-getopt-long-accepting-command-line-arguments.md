---
title: "Advanced usage of Getopt::Long for accepting command line arguments"
timestamp: 2015-01-02T11:20:01
tags:
  - Getopt::Long
published: true
author: szabgab
---


We have already seen [how to use Getopt::Long to process command line arguments](/how-to-process-command-line-arguments-in-perl),
but you can do a lot more with that module.

Let's see how else can we use the [Getopt::Long](https://metacpan.org/pod/Getopt::Long) module:


## Simple boolean (on/off) argument

We would like to enable a boolean flag such as
`--verbose`, `--quiet`, or `--debug` that just by their mere presence make an impact.
Flags that don't need an additional value.


```perl
use strict;
use warnings;
use 5.010;
use Getopt::Long qw(GetOptions);

my $verbose;

GetOption('verbose' => \$verbose);
```

If in the definition of the parameter we only give the name (`'verbose'`), Getopt::Long will treat the option as a boolean
flag. By default `$verbose` is `undef` and thus [false](/boolean-values-in-perl). If the user passes `--verbose` on the
command line, the variable `$verbose` will be set to some [true](/boolean-values-in-perl) value.

Later in the code we'll see snippets like this:

```perl
if ($verbose) {
    say "Some message";
}
```

That is, we'll check if `$verbose` is [true](/boolean-values-in-perl) and if it is, then we print something to the console.
Of course it does not have to be some extra printing. It can be some other change in the behavior of the script.

For example in one script I have an `--all` flag which means, the script needs to process all the files in the the given directory.


## Negatable boolean arguments

Basically they are the same as the boolean arguments except the default is
usually true and the user can turn it off from the command line

This is a special case of the boolean flags as in this case `undef` and `0` have
different meaning:

```perl
use strict;
use warnings;
use 5.010;
use Getopt::Long qw(GetOptions);

my $verbose;

GetOptions(
    'verbose!' => \$verbose,
);

if (defined $verbose) {
    say $verbose;
} else {
    say 'undef';
}
```

We put an exclamation mark `!` at the end of the flag name where we define the flags and we just printed out
the value of `$verbose`.

If we run the script without providing the `--verbose` flag, the variable will remain `undef`.
If we provide the `--verbose` flag, it will be set to be 1, a [true](/boolean-values-in-perl) value.
So far nothing changed. The difference is that now we can supply a `--noverbose` flag that will set the
`$verbose` variable to `0`. In boolean context this is still [false](/boolean-values-in-perl)
just as the `undef`, but now, if we want, we can differentiate in the two cases when the user did not ask for
verboseness, and when the user explicitly ask for no verboseness:

```
$ perl cli.pl
undef
$ perl cli.pl --verbose
1
$ perl cli.pl --noverbose
0
```

In certain situation this might be useful, though I have to admit, I have not encountered any such situation yet.

Just for the curiosity, after reading the next part I came back and wanted to see what happens if we supply both
the `--verbose` and the `--noverbose` flags to the script. The answer is that it depends on their order:

```
$ perl cli.pl --noverbose --verbose
1
$ perl cli.pl --verbose --noverbose
0
```

It would be better to avoid such craziness, but of course, you, as the author of the script
don't have control over what the user supplies on the command line.


## Incremental or counting arguments

Normally Getopt::Long does not care how many times the user supplies
a boolean argument, it only cares if it was supplied at least once, or not
at all. There are cases when we would like to add meaning to the duplication of
the same boolean argument. For example, we have a debugging mechanism
with several levels of verbosity. (For example in the DBI module we can set the
TraceLevel to any number between 0-15). One way to accomplish this is to
allow the user to supply the --trace option multiple times and count how
many times it was supplied. The `+` sign at the end of the definition
will do this for us.

```perl
use strict;
use warnings;
use 5.010;
use Getopt::Long qw(GetOptions);

my $trace;

GetOptions(
    'trace+' => \$trace,
);

if (defined $trace) {
    say $trace;
} else {
    say 'undef';
}
```

The output for various calls:

```
$ perl cli.pl
undef
$ perl cli.pl --trace
1
$ perl cli.pl --trace --trace
2
$ perl cli.pl --trace --trace --trace
3
```

Actually, in this case it might be better to start with 0 as the default value: `my $trace = 0;`
The only difference in the result is that if we set the default to be 0 then if we don't include any `--trace`
on the command line we'll get 0:

```
$ perl cli.pl
0
```

which will probably simplify the code checking the value of `$trace` as won't have to create a special
check to make sure `$trace` is defined.

Then again, we could have get the same effect by accepting an option called "trace" with a numerical value:

## Argument with a value

In the next example we declare two options. Both are optional, but if the user supplies either of those options, the user also has to supply
a value. The `--machine` option is expected to be followed by any string (which of course can be a number as well),
the `--trace` option is expected to be followed by an integer. This is what the `=s` and the `=i` at the end of the
declarations mean.

If the user supplies either of those parameters without a proper value after it, the GetOptions function will print a warning and
return false. That's when the `or die` added to this example, will be executed.

```perl
use strict;
use warnings;
use 5.010;
use Getopt::Long qw(GetOptions);

my $trace = 0;
my $machine;

GetOptions(
    'machine=s' => \$machine,
    'trace=i' => \$trace,
) or die "Usage: $0 [--trace NUMBER] [--machine NAME]\n";

if (defined $machine) {
    say $machine;
} else {
    say 'undef';
}
say $trace;
```


Let's see a couple of examples with various parameters:

```
$ perl cli.pl
undef
0

$ perl cli.pl --trace 1
undef
1

$ perl cli.pl --trace 4
undef
4

$ perl cli.pl --trace 4 --machine big
big
4
```


And two examples with improper invocation:

```
$ perl cli.pl --trace 4 --machine
Option machine requires an argument
Usage: cli.pl [--trace NUMBER] [--machine NAME]

$ perl cli.pl --trace big
Value "big" invalid for option trace (number expected)
Usage: cli.pl [--trace NUMBER] [--machine NAME]
```

I think it is much more simple for the user to supply `--trace 4` that to write
`--trace --trace --trace --trace` on the command line.


## Argument that can get a value (but not required to)

Also known as arguments with an **optional value**

For example we would like to allow the user to turn on/off logging to
a file and we would like to allow the user to set the name of the logfile.
If no logfilename was given, our script will print its log to STDERR.

We can accomplish this in two ways:  One of them is to have two separate
arguments: one of the arguments is to turn logging on/off, and the other one is to supply
the name of the file:

<h3>Two arguments, one depending the other</h3>

```perl
use strict;
use warnings;
use 5.010;
use Getopt::Long qw(GetOptions);

my $log;
my $logfile;
GetOptions(
    'log'        => \$log,
    'logfile=s'  => \$logfile,
) or die "Usage: $0 [--log  [--logfile FILENAME]]\n";
die "--logfile does not do anything when --log is not supplied\n" if $logfile and not $log;

if ($log) {
    if ($logfile) {
        say "logging to file $logfile\n";
        #open ...
    } else {
        say "logging to STDERR\n";
        #print STDERR ...;
    }
}
```

In this case we had to add an extra validation to the code, to notify the user that providing `--logfile FILENAME`
without turning on logging with `--log` does not have any meaning. Other than that we just have two flags,
one with a required `=s` string after it.

Running the above code with different command line parameters look like this:

```
$ perl cli.pl


$ perl cli.pl --log
logging to STDERR

$ perl cli.pl --log --logfile data.log
logging to file data.log
```

We have the extra validation in case the user only supplies the `--logfile FILENAME`:

```
$ perl cli.pl --logfile data.log
--logfile does not do anything when --log is not supplied
```


If the user supplies `--logfile` without an argument the GetOptions will already warn about it and it
will return false that will trigger the first `die` command showing the "Usage" string.

```
$ perl cli.pl --logfile
Option logfile requires an argument
Usage: cli.pl [--log  [--logfile FILENAME]]

$ perl cli.pl --log --logfile
Option logfile requires an argument
Usage: cli.pl [--log  [--logfile FILENAME]]
```

<h3>Argument that can get a value (but not required to)</h3>

The same can be accomplish using an option with an optional value. We declare that by using `:s` at the end of the
option name as in `logfile:s`.

```perl
use strict;
use warnings;
use 5.010;
use Getopt::Long qw(GetOptions);

my $logfile;
GetOptions(
    'logfile:s'        => \$logfile,
) or die "Usage: $0 [--logfile [FILENAME]]\n";

if (defined $logfile) {
    if ($logfile) {
        say "logging to file $logfile\n";
        #open ...
    } else {
        say "logging to STDERR\n";
        #print STDERR ...;
    }
}
```

In this case we don't need the extra parameter checking, though the actual code is quite similar to what we have earlier.
We can run this script in various ways:

```
$ perl cli.pl

$ perl cli.pl --logfile
logging to STDERR

$ perl cli.pl --logfile data.log
logging to file data.log
```

The extra nice part is that because GetOptions allow the user to shorten the name of the options even this will work:

```
$ perl cli.pl

$ perl cli.pl --log
logging to STDERR
```

Where we supplied `--log` instead of `--logfile`.


## Comments

Hi Gabor,

I'm wondering if Getopt provides anything useful to address the following issue:

#!/usr/bin/perl
use Modern::Perl;
use Getopt::Long;

my ($a,$t);

GetOptions( 'tickets=s'     => \$t, 
                    'another_key=s' => \$a );

print "tickets: $t\n";
print "another_key: $a\n";

invoking it like ( given that the script is saved to 'test_getopt.pl'):

$perl -w test_getopt.pl --tickets --another_key asdf

will yield:

tickets: --another_key
Use of uninitialized value $a in concatenation (.) or string at test_getopt.pl line 12.
another_key:

which is obviously not the desired behaviour.
So, my question is, if there is any option to mitigate this, beyond validating each and every parameter?

Thanks!

---

Input validation is usually a good practice.

You could also set a default value for $a and $t if that's correct in your application. You can start your code with
my ($s, $t) = ('', '');
To set both to empty string.

But please don't use $a (or $b) here. See : https://perlmaven.com/dont-use-a-and-b-variables

---

Thanks for the fast reply!
I guess your short answer then is no.
This was an example constructed just to simulate the issue, but it's a good reminder about $a & $b ;)

Thanks again, and please keep up the good work PerlMaven!)

<hr>

Hi Gabor,

Is there any way to limit the number of arguments an option can take like an option can only take a minimum 0 and a maximum of 2 arguments? Say, -logfile or -logfile file1.txt or -logfile file1.txt file2.txt is acceptable; but -logfile file1.txt file2.txt file3.txt must give an error?


