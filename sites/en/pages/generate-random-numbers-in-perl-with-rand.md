---
title: "Generate random numbers in Perl with the rand() function"
timestamp: 2015-11-25T17:30:01
tags:
  - rand
  - Crypt::Random
  - Data::Entropy
  - Math::Random::Secure
  - Math::TrulyRandom
published: true
author: szabgab
archive: true
---


The built-in `rand()` function of perl returns a random fractional number
between 0 and 1. 0 included but 1 not. Mathematicians would probably represent the range
of possible numbers  with something like this: `[0, 1)` though, because the
numbers in Perl are limited to some 15 digits after the decimal point the actual
numbers rand() will generated don't cover the whole range.

`rand(N)` will generated a random number between 0 and N (not including N):
`[0, N)`.


## Simple use of rand()

```perl
print rand(), "\n";     # 0.242888881432922
print rand(10), "\n";   # 5.320874671411310
```

In general this is enough for you to know, but if you are interested, you can read a bit deeper
explanation. If not, scroll down a bit for more use-cases.

If you run the the above script several times you'll see that the number changes.
If this is your first encounter with random numbers in computers this might not
surprise you, after all we are talking about random numbers.
On the other hand if you come from some other languages this might come to a surprise.

The thing is that in many programming languages, including Perl, the built-in random number
generator do not generate truly random numbers. Instead of that they generate
pseudo-random numbers with something like the 
[Linear congruential generator](http://en.wikipedia.org/wiki/Linear_congruential_generator).

The best to imagine is probably that there is a giant list of pre-defined numbers and every time we
call `rand()` it will just return the next number. In some languages the built-in random generator
starts from the beginning of this list every time a program starts. In order to
let the list start from another place you can call the `srand()` function.
So in other languages you might first need to call `srand()` once and then you can call `rand()`
as many times as you want.

Perl however will call `srand()` for you every time a new script starts so normally you'll
see different numbers every time a script starts.

Just to mess with your mind a bit, if you want to get <b>repeatable random numbers</b>,
you can call `srand()` yourself in your script with some number.

For example, this script, generates 0.744525000061007 on every run. Try it.

```perl
srand(42);
print rand(), "\n";
```

One of the advantages of this is that you can have the same series of random numbers on every run which will
make tests repeatable.

Anyway, let's get back to the daily use of `rand()`

As we saw we can just call `rand()` and it will return a floating-point number between 0 and 1.
(not including 1)

```perl
print rand(), "\n";   # 0.242888881432922
```


If we would like to imitate throwing the dice we can use the following code:

{% include file="examples/rand_6.pl" %}

This will generate a random whole number between 1 and 6 (both inclusive).
In other words, it will pick one of the following numbers randomly: 1, 2, 3, 4, 5, 6.

Why?

`rand(6)` will generate a floating point number between 0 and 6 (6 excluded).

`int rand(6)` will return the integer part of it which can be 0, 1, 2, 3, 4, 5
(but cannot be 6).

`1 + int rand(6)` will return one more. One of the following numbers: 1, 2, 3, 4, 5, 6


## Not cryptographically secure

The [official documentation of rand() in Perl](https://metacpan.org/pod/perlfunc#rand)
warns that
<b>"rand()" is not cryptographically secure.  You should not rely
on it in security-sensitive situations.</b>
It also points to a number
of third-party alternatives from CPAN. Let's have a look at those.

## Crypt::Random

[Crypt::Random](https://metacpan.org/pod/Crypt::Random) calls itself <b>Cryptographically Secure, True Random Number Generator.</b>
it uses `/dev/random` or similar device supplied by the operating system.

The basic usage looks like this:

{% include file="examples/crypt_random.pl" %}

`makerandom` will return a whole number between 0 and 2**N (including 0 and excluding 2**N) where
N is set using the `Size` parameter.  The <b>Strength</b> selects between /dev/random and /dev/urandom.
By default the highest bit of the returned number is always set to 1, which might be useful in some cases,
but I setting `Uniform => 1` will return a value that will have the same randomness on every bit.

In other words if `Uniform => 1` then  `Size` is the number of random bits generated.

```
Size       Range       # possibilities
  1         0-1             2
  2         0-3             4
  3         0-7             8
 ...
 10         0-1023       1024
 ...
```

If `Uniform => 0` which is the default then:


```
Size       Range         # possibilities
  1         1               1
  2         2-3             2
  3         4-7             4
 ...
 10         512-1023      512
 ...
```

Throwing a (6 sided) dice then would look like this:

`int (6 * $r / (2**$N))`

The full script is this:

{% include file="examples/crypt_random_6.pl" %}

An even better solution would be to use the `makerandom_itv` function
that will return whole numbers in a given range: `makerandom_itv(Lower => 1, Upper => 7);`
(Lower inclusive, Upper exclusive)

{% include file="examples/crypt_random_range.pl" %}


## Data::Entropy

[Data::Entropy](https://metacpan.org/pod/Data::Entropy) for entropy (randomness) management.
Looks way too complex for generating random numbers.

## Math::Random::Secure

[Math::Random::Secure](https://metacpan.org/pod/Math::Random::Secure)
is a Cryptographically-secure, cross-platform replacement for rand().

After loading the module and importing the `rand()` function it works just like
the built-in `rand()` function.

{% include file="examples/math_random_secure.pl" %}

## Math::TrulyRandom

[Math::TrulyRandom](https://metacpan.org/release/Math-TrulyRandom) might be still
working well, but it has not been released since 1996 so I'd avoid it.

