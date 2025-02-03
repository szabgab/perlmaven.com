---
title: "Hashes in Perl"
timestamp: 2013-03-19T11:12:06
tags:
  - hash
  - keys
  - value
  - associative
  - %
  - =>
  - fat arrow
  - fat comma
published: true
books:
  - beginner
author: szabgab
---


In this article of the [Perl Tutorial](/perl-tutorial)
we are going to learn about <b>hashes</b>, one of the powerful parts of Perl.

Some times called associative arrays, dictionaries, or maps; hashes are one of the data structures available in Perl.


A hash is an un-ordered group of key-value pairs. The keys are unique strings. The values are scalar values.
Each value can be either a number, a string, or a reference. We'll learn about references later.

Hashes, like other Perl variables, are declared using the `my` keyword. The variable name is preceded by the
percentage (`%`) sign.

It's a little mnemonic trick to help you remind about the key-value structure.

Some people think that hashes are like arrays (the old name 'associative array' also indicates this, and in some other
languages, such as PHP, there is no difference between arrays and hashes.), but there are two major differences between arrays
and hashes. Arrays are ordered, and you access an element of an array using its numerical index.
Hashes are un-ordered and you access a value using a key which is a string.

Each hash key is associated with a single <b>value</b> and the keys are all unique inside a single hash structure.
That means no repetitive keys are allowed. (If you really, really want to have more than one values for a key,
you'll will need to wait a bit till we reach the references.)

Let's see some code now:

## Create an empty hash

```perl
my %color_of;
```

## Insert a key-value pair into a hash

In this case 'apple' is the key and 'red' is the associated value.

```perl
$color_of{'apple'} = 'red';
```

You can also use a variable instead of the key and then you don't need to put the
variable in quotes:

```perl
my $fruit = 'apple';
$color_of{$fruit} = 'red';
```

Actually, if the key is a simple string, you could leave out the quotes even when you use the string directly:

```perl
$color_of{apple} = 'red';
```

As you can see above, when accessing a specific key-value pair, we used the `$` sign (and not the % sign)
because we are accessing a single value which is a <b>scalar</b>. The key is placed in curly braces.

## Fetch an element of a hash

Quite similar to the way we inserted an element, we can also fetch the value of an element.

```perl
print $color_of{apple};
```

If the key does not exist, the hash will return an [undef](/undef-and-defined-in-perl),
and if `warnings` are enabled, as they should be, then we'll get a
[warning about uninitialized value](/use-of-uninitialized-value).

```perl
print $color_of{orange};
```

Let's a few more key-value pairs to the hash:

```perl
$color_of{orange} = "orange";
$color_of{grape} = "purple";
```

## Initialize a hash with values

We could have instantiated the variable with the key-value pairs simultaneous passing to the hash a list of key-value pairs:

```perl
my %color_of = (
    "apple"  => "red",
    "orange" => "orange",
    "grape"  => "purple",
);
```

`=>` is called the <b>fat arrow</b> or <b>fat comma</b>, and it is used to indicate pairs of elements.
The first name, fat arrow, will be clear once we see the the other, thinner arrow (->) used in Perl.
The name fat comma comes from the fact that these arrows are basically the same as commas. So we could have written this too:

```perl
my %color_of = (
    "apple",  "red",
    "orange", "orange",
    "grape",  "purple",
);
```

Actually, the fat comma allows you to leave out the quotes on the left-hand side making the code cleaner
and more readable.

```perl
my %color_of = (
    apple  => "red",
    orange => "orange",
    grape  => "purple",
);
```

## Assignment to a hash element

Let's see what happens when we assign another value to an existing key:

```perl
$color_of{apple} = "green";
print $color_of{apple};     # green
```

The assignment changed the value associated with the <b>apple</b> key. Remember, keys are unique and each key has a
single value.

## Iterating over hashes

In order to access a value in a hash you need to know the key.
When the keys of a hash are not pre-defined values you can use the `keys` function
to get the list of keys. Then you can iterate over those keys:

```perl
my @fruits = keys %color_of;
for my $fruit (@fruits) {
    print "The color of '$fruit' is $color_of{$fruit}\n";
}
```

You don't even need to use the temporary variable `@fruits`, you can iterate
over directly the return values of the `keys` function:

```perl
for my $fruit (keys %color_of) {
    print "The color of '$fruit' is $color_of{$fruit}\n";
}
```


## The size of a hash

When we say the size of a hash, usually we mean the number of key-value pairs.
You can get it by placing the `keys` function in scalar context.

```perl
print scalar keys %hash;
```

## Using empty values in a hash

A value cannot be "empty" but it can contain [undef](/undef-and-defined-in-perl)
which what people usually mean when they say "empty".

We can assign `undef` to a key (new or existing):

```perl
$color_of{water} = undef;
```

or when we create the hash:

```perl
my %color_of = (
    apple  => "red",
    orange => "orange",
    water  => undef,
    grape  => "purple",
);
```

Make sure you use the word `undef` and don't put them in quotes as in `"undef"`.
That would insert the string `"undef"` which is not what you want.



## Thanks

The first edition of this article was written by [Felipe da Veiga Leprevost](http://www.leprevost.com.br/) who also makes the
[Portuguese translation](https://br.perlmaven.com/) of the Perl Maven articles.


## Comments

how to declare an empty value ? I have key, but I want to declare the value as empty, how shall I do?

I've updated the article with the answer.

<hr>

$key{$store[0].":".$store[2]} $=" ";
please tell me whats wrong in this?

What did you want to do with this?

Try removing the $ before the =.

<hr>
Hi, please see the following code:

while ($line = <stdin>)
{
while ($line =~ s/(\w+)(.*)/$2/)
{
$word = $1;
$wordHash{$word}++;
#Use a hash to count the occurrences of each word.
}
}

I got this code from CIW syllabus; I don't quite understand why use ++ there and how does it count the occurrences?

---

There are several similar examples on this site. If this explanation does not work for you: https://perlmaven.com/beginner-perl-maven-counting-words-in-a-file look for other in our archive . Something about "counting words" or "counting digits".
---

Thank you. I read your other post and understand the concept now.

<hr>

Is it safe to increase the value of uninitiated hash element by one? Let's say I declare the following hash and increase it's element right away in the following manner:

my %hash;
$hash{'val'}++;

The outcome will be 1 but is it always the case? Is it safe to use it this way? Thank you.

yes

<hr>

read about hash slices https://perlmaven.com/hash-slice

<hr>

Dude, just wanted to say thank you, you don't know how helpful your portal has been to me

<hr>

Please tell me what "When the keys of a hash are not pre-defined values" means.
Thank you for your clear and concise explanations


