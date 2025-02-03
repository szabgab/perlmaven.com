---
title: "Moo attributes with default values"
timestamp: 2015-03-16T11:13:10
tags:
  - Moo
  - default
published: true
books:
  - moo
author: szabgab
---


There are cases when you would want to make sure there is a value
for a certain attribute other than undef, but you don't want to
[require](/moo-and-required-attributes) the user to supply it.
If it was supplied, that's good, but if not, you'd like to have a default value.

Moo allows you to define what this default value should be using the `default`
keyword.


Let's see an example:

There is a Person.pm module in which we have an 'age' attribute that defaults to 0.
After all, most us are born at the age of 0.

```perl
has age => (is => 'rw', default => 0);
```

The full Person.pm file would look like this:

```perl
package Person;
use Moo;

has age => (is => 'rw', default => 0);

1;
```

the programming.pl script looks like this:

```perl
use strict;
use warnings;
use 5.010;

use Person;

my $joe = Person->new();
say $joe->age;
my $clara = Person->new( age => 3 );
say $clara->age;
say 'DONE';
```

and the output is what we expected:

```
0
3
DONE
```

## Default timestamp

As you probably know keeping the 'age' value is not really a good idea as the age
changes all the time. It is better to keep the birthdate and if necessary calculate the
age from that and from the current time.

So we replace the 'age' attribute in the Person.pm file by the 'birthdate' attribute and we'll
use the number of seconds from the epoch as to represent the birthdate. Hence the default value
is the number returned by the <b>time</b> function.

```perl
has birthdate => (is => 'rw', default => time);
```

Let's see the code in programming.pl now:

```perl
use Person;

my $joe = Person->new;
say $joe->birthdate;

my $clara = Person->new( birthdate => time - 60*60*24*365*3 );
say $clara->birthdate;

say 'DONE';
```

and the output after running `perl programming.pl`:

```
1371908001
1308836001
DONE
```

Looks good, right?

(Well, except maybe that 60*60*24*365*3  seconds is not exactly the same as "3 years",
but we don't want to deal with that problem now.

At one point, maybe a few seconds later (in run time), you will want to create another Person
object, (we simulate the few seconds of run time with a call to `sleep`:


```perl
use Person;

my $joe = Person->new;
say $joe->birthdate;

sleep 2;

my $pete = Person->new;
say $pete->birthdate;

say 'DONE';
```

The result is

```
1371908295
1371908295
DONE
```

What the #$#$#@?  Why do both objects have the same birthdate?
They were created 2 seconds apart, if you ran this program you even saw it
being "stuck" after the first number was printed.

Has time stopped in the alternate world of Moo?

Indeed that's what happened.

The `time` function was not called at the time when the constructor of Person was called,
but when the Person.pm was loaded into memory. To demonstrate this take a look at this code:

```perl
say time . '  start time';
sleep 3;

my $joe = Person->new;
say $joe->birthdate;
```

Here I print the result of `time()` myself from the script and then, after sleeping 3 seconds
I create the first Person object. They both show the same timestamp.

We need a way to ensure the time function (of the birthdate attribute) is only called at the
time we call the `new` method. This happens because when we declare our attributes, during
the loading and compilation time of the Person class, we had this code:

```perl
has birthdate => (is => 'rw', default => time);
```

This is actually calling the `has` function exported by `Moo` with a few parameters.
Let me rewrite it a bit:

```perl
has('birthdate', 'is', 'rw', 'default', time);
```

As this function is in the body of the Person module, it is called at load time (so the Person class
will know what attributes to create when you create an instance), but this also means the `time()`
function is called at load time.

The above two are exactly the same calls, but the former look much cool, and clearer. So we use that syntax.
Even if at first it does not look like a Perl function call.

So how can we delay the call to `time()`? Moo allows us to pass a code reference
to the `default` key, and it will call that code reference when the default is actually needed.

so if we wrap the call to `time` in an anonymous function, we should be OK.
Let's change the Person.pm file to have this:

```perl
has birthdate => (is => 'rw', default => sub { time });
```


run `perl programming.pl` with the following content of programming.pl:

```perl
use Person;

say time . '  start time';
sleep 3;

my $joe = Person->new;
say $joe->birthdate;
sleep 2;
my $pete = Person->new;
say $pete->birthdate;
say 'DONE';
```

and the output will look like this:

```
1371909556  start time
1371909559
1371909561
DONE
```

So that part is fixed, but let me do another small experiment. Let's change that anonymous
subroutine to be the following:

```perl
has birthdate => (is => 'rw', default => sub {
   say "Creating default";
   time
});
```

Change the programming.pl to contain:

```perl
use strict;
use warnings;
use 5.010;

use Person;

say time . '  start time';
sleep 3;

my $joe = Person->new;
say $joe->birthdate;

my $clara = Person->new( birthdate => time - 60*60*24*365*3 );
say $clara->birthdate;

my $pete = Person->new;
say $pete->birthdate;
say 'DONE';
```

and run `perl programming.pl` again:

(Oh, you might also need to add `use 5.010;` to Person.pm or you'll get a nasty error message about
[String found where operator expected](/scalar-found-where-operator-expected) at Person.pm.)

The output:

```
1371910137  start time
Creating default
1371910140
1277302140
Creating default
1371910140
DONE
```

So "Creating default" was called in two cases (Joe and Pete) but as Clara supplied her birthdate,
the subroutine creating a default value was not called. This might have been obvious to you,
but I wanted to make sure I know that the subroutine is only called when really necessary.

Oh and one more experiment. Instead of a real date, let Clara pass `undef` as her
birthdate:

```perl
my $clara = Person->new( birthdate => time - 60*60*24*365*3 );
```

The result is expected but a bit disappointing:

```
Use of uninitialized value in say at programming.pl line 15.

```

As in the case with the [required](/moo-and-required-attributes) attributes,
you'd probably also need to set up a minimal [type checking](/type-checking-with-moo),
just to make sure the value passed is not `undef`.


## Array reference as attribute

[Moo with array reference as attributes - with or without default values](/moo-with-array-refernce-as-attribute)

## Hash reference as attribute

[Moo with hash reference as attributes - with or without default values](/moo-with-hash-refernce-as-attribute)

## Conclusion

Probably it is better to always use a sub, event if it is not required (as in the constant scalar value case).
The only advantage of having the scalar there is that it might be a bit faster than having an unnecessary subroutine calls.


## Comments

What if I need an unitialized array instead of an empty one?
In my non OOP code I have an

my @aux = undef;

That is required by a subroutine parsing a file to store temporary data. If I use the

has aux => (
is => 'rw',
default => sub { [] },
);

This would break the method, but if I leave 'undef' as default, this is no longer recognized as array

Thanks

---

Then you need to learn Perl better. There is no such thing as uninitialized array in perl. What you wrote my @aux = undef; is an array with a single element which is undef.

---

Thanks for the clarification. I tried to embedd https://github.com/lh3/readfq/blob/master/readfq.pl in an object but I probably need to do some rewriting then...

<hr>

I found this in a file using Moo `with 'Crypt::PBKDF2::Hash';` is with a Moo directive??? if so what does it mean
don't worry found it  https://metacpan.org/pod/Moo#with

