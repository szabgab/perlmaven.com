---
title: "qw - quote word"
timestamp: 2015-03-27T16:30:01
tags:
  - qw
published: true
books:
  - beginner
author: szabgab
archive: true
---


What is this `qw` I often see in Perl code?

`qw` stands for <b>quote word</b>. It looks like some other operators such as
<a href="/quoted-interpolated-and-escaped-strings-in-perl">`q` and `qq`</a>, or 
<a href="/search/qr">`qr`</a>, but actually it works more like
[split](/perl-split).


If you want to include a list of strings in your code, this is one way:

```perl
my @name = ('foo', 'bar', 'zorg');
```

Instead of that you can use the `qw` operator:

```perl
my @name = qw(foo bar zorg);
```

Which is the same as:

```perl
my @name = qw(foo bar    zorg);
```

or even

```perl
my @name = qw(
    foo
    bar
    zorg
);
```

`qw` will take the values provided in the parentheses and split them up where it finds one or more spaces.

So it has the same result as this code:

```perl
my @name = split /\s+/,  q(foo bar      zorg);
```

Of course, there is no point in using `split` where we can use a `qw`.
(And the split version would give different result if there was a whitespace or newline before the first word.)

## Why is it called quote word?

Qw is slightly limited. Since it splits strings via spaces, no string in the created array can contain
spaces. For example, this creates a 3-element array:

```perl
my @name = ('foo', 'bar', 'zorg morg');
```

On the other hand, this would make a 4-element array:

```perl
my @name = qw(foo bar zorg morg);
```

So `qw` does not allow spaces in the string as it looks for space-delimited "words".

On the other hand the "letters" can be any other character.

For example:

```perl
my @name = qw(#foo $bar      @zorg);
```

Is the same as this:

```perl
my @name = ('#foo',  '$bar', '@zorg');
```

So you can use any other characters as part of the "words".

## qw is not a function

Although at first the parentheses after qw make it look like a function, it is not. We can use other delimiters as well.

Slashes seem to be popular:

```perl
my @name = qw/foo bar zorg/;
```

Brackets or braces also work:

```perl
my @name = qw{foo bar zorg};
my @name = qw[foo bar zorg];
```

So do quotes:

```perl
my @name = qw'foo bar zorg';
my @name = qw"foo bar zorg";
```

Even some other characters can be used:

```perl
my @name = qw!foo bar zorg!;
my @name = qw@foo bar zorg@;
```

Though I like to stick to parentheses and I'd recommend you do that too.

## Possible attempt to separate words with commas

A common mistake when switching from a list of words to a `qw` construct
is forgetting to remove the separating commas between the elements:

```perl
my @name = qw(foo, bar, zorg);
```

If your code has [use warnings](/always-use-strict-and-use-warnings) turned on, as it should, then you'll get
a warning about `Possible attempt to separate words with commas`.


## Importing functions selectively

One of the places where you'll often see the use of `qw` is where modules are loaded.
You might see something like this:

```perl
use Module::Name qw/foo $bar/;
```

From the above explanation you'll know that this is the same as

```perl
use Module::Name ('foo', '$bar');
```

This basically means we pass this list as parameters to the
[import](/use-require-import) function of `Module::Name`
which will import the 'foo' function and the '$bar' scalar variable into our code.

See also [on-demand import](/on-demand-import), for further explanation.

