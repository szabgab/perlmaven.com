---
title: "Writing Command line scripts and accepting command line parameters using Moo"
timestamp: 2015-05-01T10:00:01
tags:
  - Moo
  - MooX::Options
books:
  - moo
published: true
author: szabgab
---


The organic way a Perl script grows usually starts with a few statements, conditionals and loops. Sometimes this
can grow to hundreds or even thousands of lines. Then parts of the script might slowly be turned into functions,
but it is usually very painful.

Moo can help us, even when we write a single script, without modules, to write much cleaner code.

Of course these scripts will also need to accept parameters from the command line. Let's see how can this be done.


## A single-file script using Moo

Let's save the following code as `process.pl`:

{% include file="examples/moo-cli-1/process.pl" %}

We don't create a separate file with a separate module, but we `use Moo` right at the beginning of the script.
(Of course we could have added a sh-bang line like this: `#!/usr/bin/env perl` as the first line of the script,
but that is only needed if we would like to turn the script into executable on Linux/Unix.)

Every perl script already has an implicit package declaration, and the package of script is called `main`.
Probably because programs written in C required a function called `main`. By adding a `use Moo;`
statement at the top of our script we effectively turn our script into a class, with
`use strict;` and `use warnings;` implicitly turned on.

We put our main code in a method, in our case called `run`, and then we create an instance of this
`main` class by calling the `new` constructor. It returns an object and then we call the `run`
method of that object.

We could have written it in two separate statements like this:

```perl
my $object = main->new;
$object->run;
```

but we don't really need the temporary `$object` variable.

When we run this script using `perl process.pl` The output will be `Processing ...`

## Attributes and command line options

We will need variables in our script, but as we try to use the declarative
style that comes with Moo, we declare an object-attribute in the main class.
This is done exactly the same way we declared attributes in a regular
Moo-based class: `has file => (is => 'ro', required => 1);`

The script will require a file to work on.

The name of the file needs to be passed to the constructor.
It might be hard-coded in the script, in which case we would write:
`main->new(file => 'data.txt')->run;`, but most command line scripts
are supposed to get the parameters from the user passed in on the command line.

So instead of hard-coding the name of the file we expect it to be the parameter.
We can the write:

```perl
my $file = shift or die "Usage: $0 FILE\n";

main->new(file => $file)->run;
```

This will get the first element from the `@ARGV` created from the command line,
and pass it to the constructor.

The new version of the script looks like this:

{% include file="examples/moo-cli-2/process.pl" %}

If we run it without any parameters: `perl process.pl` we will get `Usage: process.pl FILE`
and if we provide a parameter `perl process.pl data.txt` it will print `Processing data.txt`.

So far it looks ok, though there is some duplication in our code. Actually we had to mention `file`
3 times in our code. In the `has` statement, in the `shift`, and when passing it to the constructor.

Our code is not [DRY](https://en.wikipedia.org/wiki/Don%27t_Repeat_Yourself).

We'll have to deal with that later, but let's look at another problem:

## Add an optional parameter

In most scripts we will want more than one parameter. For example often we might want to be able to
turn on some debugging or verbose mode to see what our script does. So let's add an optional
attribute (it is not `required`) called `verbose`. We need to declare it:
`has verbose => (is => 'ro');`, we need to receive it from the command line along
with the other parameter: `my ($file, $verbose) = @ARGV;`, and finally
we need to pass it to the constructor:
<h>main->new(file => $file, verbose => $verbose)->run;`.

Again, we had to repeat ourself 3 times, but probably worse than that,
the growing number of command line parameters require us to remember their order.
It won't be easy to add another parameter after the optional one, and it is totally
not obvious what the `1` means on the command line.
(It means [TRUE](/boolean-values-in-perl).)

The new version of the script looks like this:

{% include file="examples/moo-cli-3/process.pl" %}

`perl process.pl` will print `Usage: process.pl FILE [1]`

`perl process.pl data.txt` will be silent.

`perl process.pl data.txt 1` will print `Processing data.txt`.

So will `perl process.pl data.txt 42` by the way.


## Two big problems

We have two major issues:

<ol>
<li>Every new option has to be dealt with in 3 places.</li>
<li>The positional nature of the options does not provide enough flexibility.</li>
</ol>

The latter could be dealt with [Getopt::Long](http://metacpan.org/module/Getopt::Long),
but using Moo we have a better way to handle this.

The generally accepted solution to the problem of the positional arguments is to use named options.
Each option will have a name preceded by a dash. Either a single-character name preceded by a single dash like this:

`perl process.pl -f data.txt`

or a long-name preceded by two dashes like this:

`perl process.pl --file data.txt`

Options that can be either true or false (as in the case of the `$verbose` value, can be set by supplying
a name without any value: `-v` for the single-character version, or `--verbose` for the long version.


## Command line options using MooX::Options

[MooX::Options](https://metacpan.org/pod/MooX::Options) is an extension of [Moo](https://metacpan.org/pod/Moo)
that solves problem 2 above. Let's see the new version of our code. Still not perfect, but a step in the right direction:

{% include file="examples/moo-cli-4/process.pl" %}

After loading the module with `use MooX::Options;`, we replaced the `has` statements by
`option` statements. The `option` statements do everything the `has` statements do,
but they also tell MooX::Options to accept these words as the names of command line options.

In the rest of the code we don't need to deal with `@ARGV` directly, and instead of calling
`new`, we call the `new_with_options` method added by MooX::Options.

The result is, that if we run `perl process.pl` we get the following output:

```
file is missing
USAGE: process.pl [-h] [long options...]
    --file       no doc for file
    --verbose    no doc for verbose
    -h --help    show this help message
```

That looks interesting. Without doing anything further we already
have a skeleton usage page including a `--help` flag!

If we follow the hint in the usage page we'll run
`perl process.pl --file data.txt` that will print nothing. Which is expected of course.
If we also add the `--verbose` flag and run `perl process.pl --file data.txt --verbose`
we get a strange result: `Processing 1`. After referring to the documentation we realize
that we still have to tell MooX::Options that the `--file` option expects a value after it, while
the `--verbose` does not. Actually, the default is that it expects no value, and thus when we
supplied the `--file` flag it set the `file` attribute to the value `1` (meaning TRUE).

Loading MooX::Options adds a few more keywords to the syntax of Moo. Specifically we can
now add ## format => 's' to the declaration of `file` that means we are expecting
a string value after the name.

The full declaration will then look like this:

```perl
option file    => (is => 'ro', required => 1, format => 's');
```

Running `perl process.pl --file data.txt --verbose` will now yield:
`Processing data.txt` as expected.

Unfortunately the output of `perl process.pl` does not change,
even though I think it could have indicated that `--file` expects a value.
(Feature request submitted.)

In addition to `s`, the `format` option can also get the value `i</h>
indicating an integer or `f` indicating a floating point number.
(Thought it seems f also accepts values such as 1.2.3.4.5. Bug reported.)

## Add documentation

As the help output indicates, there is a way to add documentation
to the options. MooX::Options provides the `doc` keyword that allows
us to supply a short description for each option:

```perl
option verbose => (is => 'ro', doc => 'Print details');
option file    => (is => 'ro', required => 1, format => 's',
    doc => 'File name to be processed');
```

Running `perl process.pl --help` will then print:

```
USAGE: process6.pl [-h] [long options...]
    --file       File name to be processed
    --verbose    Print details
    -h --help    show this help message
```

Much nicer, and all the information about the options are in a single place.
Our code is [DRY](https://en.wikipedia.org/wiki/Don%27t_Repeat_Yourself).

## Attributes that are not options

In addition to the two attributes that can provided as command line arguments,
our code might require other attributes that are not filled from the command line.
All those attributes can be still declared using the `has` statement described earlier:

For example: `has counter => (is => 'rw', default => 0);` will add an attribute
to count something but it will not appear in the help output,
and if we supply it on the command
line:  `perl process7.pl --file data.txt --verbose --counter` we will get
an `Unknown option: counter` error and usage explanation.

## Multiple values

It is also possible to tell MooX::Options that our script will accept the same flag multiple times.
For example we would like to get a list of IP addresses. We do that by adding a `@`
character to the `format` like this:

```perl
option ips => (is => 'ro', doc => 'IP addresses', format => 's@');
```

Using Data::Dumper we then print out the content of `ips` attribute:

```perl
use Data::Dumper qw(Dumper);
sub run {
    my ($self) = @_;
    if ($self->verbose) {
        say 'Processing ' . $self->file;
        say Dumper $self->ips;
    }
}
```

Let's see what is the output:

```
$ perl process7.pl --file data.txt --verbose
Processing data.txt
$VAR1 = undef;
```

```
$ perl process7.pl --file data.txt --verbose --ip 1.1.1.1
Processing data.txt
$VAR1 = [
          '1.1.1.1'
        ];
```

```
$ perl process7.pl --file data.txt --verbose --ip 1.1.1.1 --ip 2.2.2.2
Processing data.txt
$VAR1 = [
          '1.1.1.1',
          '2.2.2.2'
        ];
```

The nice part is that we can actually supply a name shorter than the full
name of the attribute: `--ip` instead of `--ips` which looks
much more intuitive in our case.

When we supply `--ip` one or more times, we get an ARRAY ref
with the list of values. On the other hand, when there are no values, the
attribute `ips` will remain `undef`.


This means when we need to write code to processes all the IPs we'll have to write
something like this:

```perl
if ($self->ips) {
    foreach my $ip (@{ $self->ips }) {
        say $ip;
    }
}
```

We have to protect the loop by an `if-statement` so we don't get a
`Can't use an undefined value as an ARRAY reference at ...` error.

In some cases the above `if-statement` is necessary anyway, but sometimes
we really just want to iterate over all the elements. In that case it is
probably better to set i[the default value](/moo-attributes-with-default-values)
of the  `ips` attribute to be an empty array. (Remember, we have to use an anonymous
function to do this.)

```perl
option ips => (is => 'ro', doc => 'IP addresses', format => 's@',
    default => sub { [] } );
```

Then the code handling the IP addresses will be simplified to the loop:

```perl
foreach my $ip (@{ $self->ips }) {
    say $ip;
}
```

## The full example

Let's conclude this article with the full example we have developed:

{% include file="examples/moo-cli-full/process.pl" %}

## Exercise 1

Allow the user to supply the list of IP addresses as a comma separated list with a single
`--ips`.

## perl process.pl --file data.txt --verbose --ips 1.1.1.1,2.2.2.2

Please note, it seems due to a bug we need to use the full name of the attribute here `--ips`
as `--ip` won't work. (The bug was reported against v3.83 of MooX::Options.)

## Exercise 2

Allow the use of the short name for the `verbose` option as `-v`

`perl process8.pl --file data.txt  -v --ips 1.1.1.1,2.2.2.2`

The source code of the most recent version of this script can be found in
[GitHub](https://github.com/PerlMaven/moo-with-moox-options).
You are more than welcome to fork that repository, send your solution as a pull
request and comment on other peoples solution.

## Comments

My complaint with MooX::Options is that so far as I can tell, there is no way to tell it to use a different array for @ARGV. That is, there is no equivalent to GetOptsFromArray($aref, ...). If one is using it to write a Modulino style script (Moodulino?) this can make testing slightly less than ideal in that the test script needs to supply a custom @ARGV without any options, instead passing actual option terms in as params to "new". It also means that one must also use MooX::StrictConstructor to ensure that unwanted options are rejected in submitted in a test bed.

Using Getopt::Long avoids both of those conditions and provides a more true test bed, IMO, because of that, at the price of a slightly more complex init/new/run setup in the moodulino itself.

---

Have you submitted this as a patch or at least a feature request to MooX::Options?

----

o, I haven't. But to be honest, given that it is considered to be poor form to alter @ARGV even with a "local" statement, and given the primary purpose/advantage of writing scripts as modules is to improve testability, it seems like a severe shortcoming to have not included that ability.

I am somewhat surprised that you did not address the underlying reason for adopting the modulino paradigm in the first place. Don't get me wrong, I am a very big fan of Moo and use it extensively at work and for private projects. But there is no advantage to writing scripts as modules other than to have a more reliable test framework.

As an aside, it is imperative that every script that is written like this have "__END__" as the last line to prevent hi-jacking by malicious code adding to it. Clearly that won't prevent all attacks, but it shuts down a rather obvious but often overlooked avenue of attack.


