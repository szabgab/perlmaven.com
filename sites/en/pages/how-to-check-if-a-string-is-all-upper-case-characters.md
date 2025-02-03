---
title: "How to check if a string is all upper case (lower case) characters?"
timestamp: 2013-11-17T17:30:01
tags:
  - open
  - UTF-8
  - \p{Uppercase}
  - uc
published: true
author: szabgab
---


There is function `is_upper` in Perl, so how can we check if a string contains
only upper case characters?

The simple thing is to compare it to the upper-case version of itself:

```perl
if ($str eq uc $str) {
    print "All the characters are upper case\n";
}
```

but this will also say that "123" us all upper case.

Sometimes this is not what you need.



## At least one upper case letter

In addition to checking if the upper case version of the string equals to itself,
we might want to make sure that there is at least one upper case letter.
We can use a regex:

```perl
if ($str =~ /[A-Z]/) {
    print "There is an upper case letter\n";
}
```

This will work with the Latin ABC, but won't match characters like
ÁÉÍÓÖŐÚÜŰ (the upper case versions of áéíóöőúüű)  from the Hungarian ABC,
nor other strange characters like a [Umlaut Ä](http://en.wikipedia.org/wiki/%C3%84) (the upper case version of ä).

## At least one upper case Unicode letter

For that there is `\p{Uppercase}` that will match exactly one upper case
Unicode character. So it will match any of these:
ÄAÁBCDEÉFGHIÍJKLMNOÓÖŐPQRSTUÚÜŰVWXYZ

```perl
if ($str =~ /\p{Uppercase}/) {
    print "There is an upper case Unicode letter\n";
}
```

## All the characters are upper case Unicode letters

It might not be enough to have one upper case letter.
You might require to have all of them:
In that case we can use the `^` and `$` regex anchors
to match the beginning and the end of the string respectively.

We also apply the `+` quantifier that means 1 or more of the
preceding thing. In our case one or more of the preceding upper case character.

```perl
if ($str =~ /^\p{Uppercase}+$/) {
    print "There is an upper case Unicode letter\n";
}
```


## All the characters are upper case Unicode letters or space

Of course it is rare that a string would only consist of upper case letters.
sometime we also want to allow other characters. For example we would like to allow
spaces as well. In this case we create a character class (in square brackets)
that is built up from a space and the character class representing all the upper
case letters in the world: `[ \p{Uppercase}]`.

```perl
if ($str =~ /^[ \p{Uppercase}]+$/) {
    print "There is an upper case Unicode letter\n";
}
```


## Trying the examples

When trying the example we can either read the strings from a file.
In that case we will probably want to
[open the file](/open-and-read-from-files) using the 
UTF-8 flag enabled:

```perl
open(my $fh, '<:encoding(UTF-8)', $filename)
```


On the other hand, if the strings to be compared are in the code,
one needs to add `use utf8;` to the beginning of the script.

In either case it is recommended to change the standard output channels
to use utf-8 with the following:

```perl
use open ':std', ':encoding(utf8)';
```

Try this example:

```perl
use strict;
use warnings;
use 5.010;
use utf8;
use open ':std', ':encoding(utf8)';

foreach my $str ("1", "ä", "äÄ", " Ä", "X", "Á", "É", "Í", "Ö", "Ő", "Ú", "Ü") {
   if ($str =~ /^[ \p{Uppercase}]+$/) {
      say $str;
   } else {
      say "no $str";
   }
} 
```

