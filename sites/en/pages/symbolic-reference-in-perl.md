---
title: "Symbolic references in Perl"
timestamp: 2013-07-18T00:30:01
tags:
  - strict
  - symbolic references
published: true
books:
  - advanced
author: szabgab
---


One of the 3 things `use strict` disables is the use of <b>symbolic references</b>.

Let's see how can that save you time and avoid embarrassment!

Let's see why avoiding symbolic references is a good thing!

At another time we'll see a useful example of symbolic references.


In general, symbolic references are a very powerful tool in Perl, but if used by accident, it can cause a lot of
head scratching. Best to disable them in every script, and enable them only when we know exactly why we need them.

## The danger

A long time ago, in a Perl training session, we had some discussion that led me mention that you can
use the same name for both scalar variables and arrays and hashes. It is not a recommended practice
but technically it is possible. I got carried away a bit and wanted to show the students that it works.
So I wrote the following code:


```perl
my $person = "Foo";
my %person;
$person->{name} = 'Bar';
```

...and explained that I declared the `$person` scalar, assigned "Foo" to it.
Then created a hash with the same name, and put a key and a value in it.
To further show it works I printed out the content of the hash:

```perl
use Data::Dumper;
print Dumper \%person;
```

To my great surprise the following was printed:

```
$VAR1 = {};
```

I was quite baffled. Where did the new key/value pair go?

I had really no idea what happened.

The situation was quite embarrassing.

Luckily we had lunch break, and just after I finished the soup it occurred to me
that I have not used <b>strict</b> in my code.

## The understanding

Returning to the class-room I added `use strict` and <b>ran</b> the code again:

```perl
use strict;
use Data::Dumper;

my $person = "Foo";
my %person;
$person->{name} = 'Bar';
```

I got the following error message:

```
Can't use string ("Foo") as a HASH ref while "strict refs" in use at ...
```

See another case of [Can't use string (...) as an HASH ref while "strict refs" in use at ...](/cant-use-string-as-a-hash-ref-while-strict-refs-in-use).

Apparently I was using a <b>symbolic HASH reference</b>, by accident.

In fact, I never touched the `%person` hash. In the second assignment
I used the `$person` scalar as a reference to a hash. This would be OK
if the variable `$person` was undef, it would [autovivify](/autovivification) (pro page)
to be a reference to a hash. As it already contained a string Perl was trying to use that name, the content of the
variable, as the name of a hash. Effectively I assigned 'Bar' to the 'name' key of the `%Foo` hash.

This is how you can check it too:

```perl
use Data::Dumper;

my $person = "Foo";
my %person;
$person->{name} = 'Bar';

print Dumper \%person;
print Dumper \%Foo;
```

And the output is:

```
$VAR1 = {};
$VAR1 = {
        'name' => 'Bar'
      };
```

As you can see, the first print of the `%person` hash is empty,
but the `%Foo` hash sprang to existence and has a 'name' key with 'Bar'
as the value.

Certainly <b>not</b> what I wanted.

Since Perl has real references, you almost never need this capability,
and if such thing happens by mistake then it is way better to get
an error than to silently do the wrong thing.

So <b>always use strict</b>.


## Symbolic references of scalar variables

```perl
print "Hello World\n";
my $name = 'person';
${$name} = 'Foo';
print "$name\n";
print "$person\n";
```

Save this code in a file called `programming.pl`
and run it as `perl programming.pl`.

The output will be this:

```
Hello World
person
Foo
```

The variable `$name` still has the value 'person' in it as expected, but now we also have
a variable called `$person`, that holds the value 'Foo'. Even though we don't have
a clearly visible assignment to `$person`, such as `$person = 'Foo';` would be.

This is in the expression `${$name} = 'Foo';`, perl replaced the variable `$name`
with its value 'person' so effectively perl saw `$person = 'Foo';`. There. Now we can
see what perl saw.

Let's see how can using strict stop us from such mistake?
Add `use strict;` to the beginning of the script and run it again!
You will get:

```
Global symbol "$person" requires explicit package name at programming.pl line 10.
Execution of programming.pl aborted due to compilation errors.
```

Interesting, this is not the same error as we saw above. This complains about the fact
that we have not declared the `$person` variable. Not only that but this is a
compile-time error. How do I know it, you ask?

Try `perl -c programming.pl`, it will give you the same error message and will
tell you there was a compilation error:

```
Global symbol "$person" requires explicit package name at programming.pl line 10.
programming.pl had compilation errors.
```

The `-c` flag of perl tells it to compile the script and exit.

In order to further experiment, let's add `my $person;` at the top of the script
and try to compile it again using `perl -c programming.pl`.

The output will be:

```
programming.pl syntax OK
```

So we can see the code now compiles. What if we try to run it with `perl programming.pl`?

We get:

```
Hello World
Can't use string ("person") as a SCALAR ref while "strict refs" in use at programming.pl line 8.
```

Note, it runs. I know it as it printed 'Hello World', but then it stops running with an error
similar to what we saw at the beginning of the article.

In general this is a good thing. In most cases we don't want to write code that will
act as symbolic references <b>by mistake</b>.

The only unfortunate part is that perl can only notice this during run-time, so if this
code is a part of the code that rarely executes (eg. within an if statement), then
the problem might only surface when it is running in production.

<h1>Can symbolic references be useful?</h1>

Sometimes it might feel useful to use symbolic references.

## Accessing a variable when its name is in another variable

For example, sometimes I see code similar to this:

```perl
$machineA = '10.3.7.5';
$machineB = '11.3.5.6';

foreach $name ('machineA', 'machineB') {
    print "${$name}\n";
}
```

or maybe:

```perl
foreach $name ('A', 'B') {
    $key = 'machine' . $name;
    print "${$key}\n";
}
```

The programmer has a bunch of variables holding IP addresses of computers, she wants to
go over all the names and do something with each machine. (In this case, just printing
the value.)

This won't work under `use strict;`, and in general this practice should be avoided.

This is a typical example, when one should use a hash instead of several scalar variables.
Like this:

```perl
use strict;
use warnings;

my %machine;
$machine{A} = '10.3.7.5';
$machine{B} = '11.3.5.6';

foreach my $name ('A', 'B') {
    print "$machine{$name}\n";
}
```

## Several numbered variables

Another case I saw a couple of times:

```perl
$machine1 = '10.3.7.5';
$machine2 = '11.3.5.6';
$machine3 = '12.4.5.6';

foreach $number (1 .. 3) {
    $name = 'machine' . $number;
    print "${$name}\n";
}
```

Here we have several machines numbered and then we iterate over them.

This is better written as a hash, similar to the previous example, or
as an array:

```perl
use strict;
use warnings;

my @machine = (
    '10.3.7.5',
    '11.3.5.6',
    '12.4.5.6',
);

foreach my $number (0 .. 2) {
    print "$machine[$number]\n";
}
```

## Conclusion

Always use strict!


