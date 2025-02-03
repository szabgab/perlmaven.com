---
title: "How to process command line arguments in Perl using Getopt::Long"
timestamp: 2014-10-30T18:56:14
tags:
  - @ARGV
  - Getopt::Long
  - GetOptions
published: true
author: szabgab
---


When a Perl script is executed the user can pass arguments on the command line in various ways.
For example `perl program.pl file1.txt file2.txt` or
`perl program.pl from-address to-address file1.txt file2.txt` or, the most common and most useful
way:

`perl program.pl -vd --from from-address --to to-address file1.txt file2.txt`

How can we deal with this information?


When the scripts starts to run, Perl will automatically create an array called `@ARGV` and put all the values
on the command line separated by spaces in that variable. It won't include `perl` and it won't include the name of our script
(`program.pl` in our case), that will be placed in the `$0` variable. `@ARGV` will only
include the values located after the name of the script.

In the above case `@ARGV` will contain:
`('-vd', '--from', 'from-address', '--to', 'to-address', 'file1.txt', 'file2.txt')`

We can access `@ARGV` manually as described in the [article about @ARGV](/argv-in-perl), but there are
a number of modules that will handle most of the work for you. In this article we'll see [Getopt::Long](https://metacpan.org/pod/Getopt::Long)
a module that also comes with the standard installation of Perl.

## Explain the command line

Just before doing that, let's see what is really our expectation from the command line processing.

* Long names with values: we would like to be able to accept parameters with long names followed by a value. For example `--to VALUE`.
    ("Long" is relative here, it just means more than 1 character.)
* Long names without value: We would like to accept flags that by their mere existence will turn some flag on. For example `--verbose`.
* Short names (or single-character names) with or without values. The above two just written `-t VALUE` and `-v`.
* Combining short names: `-vd` should be understood as `-v -d`. So we want to be able to differentiate between "long names" and "multiple short names combined".
     The difference here is that "long names" start with double-dash `--` while short names, even if several of them were combined together start with a single dash `-`.
     
* Non-affiliated values, values that don't have any name starting with a dash in front of them. For example `file1.txt file2.txt`.

There can be lots of other requirements and Getopt::Long can handle quite a few of them, but we'll focus on the basics.

## Getopt::Long

[Getopt::Long](https://metacpan.org/pod/Getopt::Long) exports a function called `GetOptions`, that can process
the content of `@ARGV` based on the configuration we give to it. It returns [true or false](/boolean-values-in-perl)
indicating if the processing was successful or not. During processing it removes the items from `@ARGV` that have been successfully
recognized.  We'll take a look at possible errors later on. For now, let' see a small example we save in `cli.pl`:

```perl
use strict;
use warnings;
use 5.010;
use Getopt::Long qw(GetOptions);

my $source_address;
GetOptions('from=s' => \$source_address) or die "Usage: $0 --from NAME\n";
if ($source_address) {
    say $source_address;
}

```

After loading the module we declare a variable called `$source_address` where the value of the `--from` command line
flag will be stored. We call `GetOptions` with key-value pairs. The keys (in this case one key) is the description
of the flag. In this case the `from=s` declares that we are expecting a command line parameter called `--from`
with a <b>string</b> after it. Because in Perl numbers can also be seen as strings, this basically means "pass me any value".
This declaration is then mapped to the variable we declared earlier. In case the syntax is unclear `=>` is a "fat arrow"
you might be familiar from [hashes](/perl-hashes) and the back-slash `\` in-front of the variable indicates
that we are passing a reference to the variable. You don't need to understand references in order understand this code. Just remember
that the variables on the right hand side of the "fat comma" operators need to have a back-slash when calling `GetOptions`.

We can run this program in several ways: `perl cli.pl --from Foo` will print "Foo". The value passed after the `-from`
flag is assigned to the `$source_address` variable. On the other hand running `perl cli.pl` will not print anything as we have no
passed any value.

If we run it `perl cli.pl Foo`  it won't print anything either, as GetOptions only deals with options that start with a dash (`-`).
(This is actually configurable, but let's not get there now.)

## Failures

So when will the [short circuit](/short-circuit) `or die` kick-in?

<h3>Unknown option</h3>

If we run the script passing something that looks like a parameter name, but which has not been declared
when calling `GetOptions`. Something that starts with a dash `-`. For example:

`perl cli.pl --to Bar`

```
Unknown option: to
Usage: cli.pl --from NAME
```

The first line is a warning printed by `GetOptions`, the second line is the string we generated using `die`.

<h3>Option requires an argument</h3>

Another case is when we run the script, pass `--from`, but without passing any value after it:

`perl cli.pl --from`

In that case the output will look like this:

```
Option from requires an argument
Usage: cli.pl --from NAME
```

Here too, the first line was from GetOptions and the second line from our call to `die`.
When we called `GetOptions` we explicitly said `=s` that we are expecting a string after the `--from`.

## Default values

Often we would like to give a default value to one of the options. For example in the case of the `--from` field we
might want it to default to the word 'Maven'. We can do it by assigning this value to the `$source_address` variable
before calling `GetOptions`. For example, at the time we declare it using `my`.

```perl
my $source_address = 'Maven';
GetOptions('from=s' => \$source_address) or die "Usage: $0 --from NAME\n";
if ($source_address) {
    say $source_address;
}
```

If the user does not pass the `--from` flag then GetOptions will not modify the value in the `$source_address`
variable. Running `perl cli.pl` will result in "Maven".

## Flags without value

In addition to parameters that require a value, we also would like to allow flags. Names, that by their presence make a difference.
These things are used when we want to allow the users to turn on debugging, or to set the verbosity of the script. 

```perl
use strict;
use warnings;
use 5.010;
use Getopt::Long qw(GetOptions);

my $debug;
GetOptions('debug' => \$debug) or die "Usage: $0 --debug\n";
say $debug ? 'debug' : 'no debug';
```

Originally the `$debug` variable contained <a href="/undef-and-defined-in-perl">undef` which is
considered to be [false](/boolean-values-in-perl) in Perl. If the user passes the `--debug` flag,
the corresponding variable will be set to some [true](/boolean-values-in-perl) value.
(I think it is the number one, but we should only rely on the fact that it evaluates to true.)
We then use the [ternary operator](/the-ternary-operator-in-perl) to decide what to print.

The various ways we call it and the output they produce:

```
$ perl cli.pl 
no debug

$ perl cli.pl --debug
debug

$ perl cli.pl --debug hello
debug
```

The last example shows that values placed after such name are disregarded.


## Multiple flags

Obviously, in most of the scripts you will need to handle more than one flag. In those cases we still call GetOptions <b>once</b> and provide it with
all the parameters:

Combining the above two cases together we can have a larger example:

```perl
use strict;
use warnings;
use 5.010;
use Getopt::Long qw(GetOptions);

my $debug;
my $source_address = 'Maven';
GetOptions(
    'from=s' => \$source_address,
    'debug' => \$debug,
) or die "Usage: $0 --debug  --from NAME\n";

say $debug ? 'debug' : 'no debug';
if ($source_address) {
    say $source_address;
}
```

Running without any parameter will leave `$debug` as `undef` and the `$source_address` as 'Maven':
```
$ perl cli.pl 
no debug
Maven
```

Passing `--debug` will set `$debug` to true, but will leave `$source_address` as 'Maven':

```
$ perl cli.pl --debug
debug
Maven
```

Passing `--from Foo` will set the `$source_address`  but leave `$debug` as `undef`:

```
$ perl cli.pl  --from Foo
no debug
Foo
```

If we provide parameters, they will both set the respective variables:

```
$ perl cli.pl --debug --from Foo
debug
Foo
```

The order of the parameters on the command line does not matter:

```
$ perl cli.pl  --from Foo --debug
debug
Foo
```

## Short names

[Getopt::Long](http://metacpan.org/pod/Getopt::Long) automatically handles shortening of the option names up to ambiguity.
We can run the above script in the following manner:

```
$ perl cli.pl --fr Foo --deb
debug
Foo
```

We can even shorten the names to a single character:

```
$ perl cli.pl --f Foo --d
debug
Foo
```

and in that case we can even use single-dash `-` prefixes:

```
$ perl files/cli.pl -f Foo -d
debug
Foo
```

These however are not really single-character options, and as they are they cannot be combined:

```
$ perl cli.pl -df Foo
Unknown option: df
Usage: cli.pl --debug  --from NAME
```

## Single-character options

In order to combine them we need two do two things. First, we need to declare the options as real single-character options.
We can do this by providing alternate, single-character names in the definition of the options:

```perl
GetOptions(
    'from|f=s' => \$source_address,
    'debug|d' => \$debug,
) or die "Usage: $0 --debug  --from NAME\n";
```

The second thing is that we need to enable the `gnu_getopt` configuration option of Getopt::Long by calling
`Getopt::Long::Configure qw(gnu_getopt);`

```perl
use Getopt::Long qw(GetOptions);
Getopt::Long::Configure qw(gnu_getopt);
```

After doing that we can now run

```
$ perl cli.pl -df Foo
debug
Foo
```

The full version of the script with the above changes looks like this:

```perl
use strict;
use warnings;
use 5.010;
use Getopt::Long qw(GetOptions);
Getopt::Long::Configure qw(gnu_getopt);
use Data::Dumper;

my $debug;
my $source_address = 'Maven';
GetOptions(
    'from|f=s' => \$source_address,
    'debug|d' => \$debug,
) or die "Usage: $0 --debug  --from NAME\n";

say $debug ? 'debug' : 'no debug';
if ($source_address) {
    say $source_address;
}
```


## Non-affiliated values

The GetOptions function only handles the parameters that start with a dash and their corresponding values, when they are relevant.
Once it processed the options it will remove them from `@ARGV`. (Both the option name and the option value will be removed.)
Any other, non-affiliated values on the command line will
stay in `@ARGV`. Hence if we add [Data::Dumper](https://metacpan.org/pod/Data::Dumper) to our script and
use that to print the content of `@ARGV` at the end (`print Dumper \@ARGV`) as in this script:

```perl
use strict;
use warnings;
use 5.010;
use Getopt::Long qw(GetOptions);
use Data::Dumper;

my $debug;
my $source_address = 'Maven';
GetOptions(
    'from=s' => \$source_address,
    'debug' => \$debug,
) or die "Usage: $0 --debug  --from NAME\n";

say $debug ? 'debug' : 'no debug';
if ($source_address) {
    say $source_address;
}
print Dumper \@ARGV;
```

We get the following results:

```
$ perl files/cli.pl  -f Foo -d file1.txt file2.txt
debug
Foo
$VAR1 = [
          'file1.txt',
          'file2.txt'
        ];
```

After processing the options, `file1.txt` and `file2.txt` were left in `@ARGV`. We can now do whatever we want
with them, for example we can iterate over the `@ARGV` array using `foreach`.


## Advanced

[Getopt::Long](https://metacpan.org/pod/Getopt::Long) has tons of other options. You might want to check out the documentation.

There are also other solutions, for example if you are using [Moo](/moo) for light-weight object oriented programming,
you could take a look at [MooX::Options](https://metacpan.org/pod/MooX::Options)  explained in a number of advanced articles: for example
[Switching to Moo - adding command line parameters](/switching-to-moo-adding-command-line-parameters)
and 
[Writing Command line scripts and accepting command line parameters using Moo](/command-line-scripts-with-moo).

## Comments

What happens if I have the following code:

use strict;
use warnings;
use 5.010;
use Getopt::Long qw(GetOptions);

my $source_address;
my $dest_address;

GetOptions('from=s' => \$source_address,
'to=s' => \$dest_address) or die "Usage: $0 --from NAME --to NAME\n";
if ($source_address) {
say $source_address;
}

if ($dest_address) {
say $dest_address;
}
And I use a command like (where I forgot to enter the second option:

perl sample-perl.pl --from nyc lon
Output will be: nyc

How can I enforce that when there is an additional string at the end, it is detected and an error is displayed.

---

Check if there is any leftover values in @ARGV after you called GetOptions.

---

Yes. That did the trick. Thanks.

<hr>

my $res = GetOptions ("change-directory | cd! " => \$changedir)

what does the above key indicates??


