---
title: "Replace character by character (transliterate) using tr of Perl"
timestamp: 2013-11-19T19:30:01
tags:
  - y
  - tr
published: true
author: szabgab
---


I have not needed this frequently, but if you need to replace a set of characters with
another set of characters in a string, there is a better solution than using regexes.

In Perl [tr](/perldoc/tr) is the transliterator tool that can replace characters by other characters pair-wise.


## Simple example

`tr` looks very similar to the substitution operator,
but it behaves in a different way:

```perl
use strict;
use warnings;
use 5.010;

my $text = 'abc bad acdf';
say $text;

$text =~ tr/a/z/;
say $text;
```

Replaces every `a` character by `z`:

```
abc bad acdf
zbc bzd zcdf
```


## More than one character

```perl
use strict;
use warnings;
use 5.010;

my $text = 'abc bad acdf';
say $text;

$text =~ tr/ab/zx/;
say $text;
```

Replaces every `a` character by `z` and every `b` character by `x`:

```
abc bad acdf
zxc xzd zcdf
```

## More about tr

`y` is a synonym of `tr` available for historical reasons.
There are a few modifiers and special cases with tr, that you can
read about in the [documentation of tr](/perldoc/tr).


## When is tr better than a regex?

`tr` replaces character-by-character while a regex substitution will replace a match with a string.
They do different things. So `tr` is only better if you want to do something else.

BTW you can imitate what `tr` does using a regex substitution with the following code:

```perl
use strict;
use warnings;
use 5.010;

my %map = (
    a => 'z',
    b => 'x',
);

my $text = 'abc bad acdf';
say $text;

$text =~ s/([ab])/$map{$1}/g;
say $text;
```

Here we have a hash called `%map` that maps the original string (original character) to the new string (character)
and then uses a single global substitution to replace all the occurrences of every "original character" by the corresponding
"new character".

Note, that in this solution we actually had to write the list of "original characters" both in the `%map` and in the regex.
In order to avoid that we can have a more generic solution:

```perl
use strict;
use warnings;
use 5.010;

my %map = (
    a => 'z',
    b => 'x',
);

my $text = 'abc bad acdf';
say $text;

my $chars = join '', keys %map;
$text =~ s/([$chars])/$map{$1}/g;
say $text;
```

Here we generate the list of characters that we want to replace from the keys
of the `%map` hash.

This will work exactly as the `tr` works, but then again, why not use a `tr` if this is what we would like to do?


## Comments

Gabor...I am very thankful you take the time to teach us. I do not get to use Perl much but every time I do I find myself back reading what you have written to us. Thank you sir!!!

<hr>

Can i use transliterate fom one start point to another last point.

Lets have the string "blablabla (blablah) ablaabla" and i have to transliterate only the contents of the parentheses. Can i use regex and then tr///.

I wrote this :

#!/usr/bin/perl
use strict;
use warnings;
use 5.010;


my $string = 'blablabla (blablah) ablaabla';


if ($string =~ /(\(.*?\))/g) {print $1=~ tr/abcdef/ABCDEF/;}


