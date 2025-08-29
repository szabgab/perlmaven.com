---
title: "How to get the last character of a string in Perl?"
timestamp: 2013-11-18T18:30:01
tags:
  - substr
  - chop
published: true
author: szabgab
---


Getting the last character of a string is a special case of getting [any substring](/string-functions-length-lc-uc-index-substr).


## substr

`substr` lets us get any [substring](/string-functions-length-lc-uc-index-substr).It gets 3 parameters:
<ol>
<li>The original string</li>
<li>offset - where does the substring start</li>
<li>length - how long is the substring</li>
</ol>

(There is also a 4th parameter, to [replace a substring](/string-functions-length-lc-uc-index-substr), but let's not discuss that now.)

Even the 3rd parameter from the above list, the **length**, is optional. If not given it means "till the end of the string".

The 2nd parameter can be either a positive number, then it is an offset from the left-hand side of the string. (Most people would call it the beginning of the string, but I know places where strings start on the right-hand side, so let's call it "left-hand side".)

If the 2nd parameter is a negative number, then it is an offset from the right-hand side of the string. (Or, as many people would call it, from the end of the string.)


```perl
use strict;
use warnings;
use 5.010;

my $text = 'word';

say substr $text, -1;  # d
say $text;             # word
```


If the `my $text = '';` was an empty string then `substr $text, -1;` will
also return the empty string without giving any warning or error.

If the `my $text;` was [undef](/undef-and-defined-in-perl), we would get
a warning: [Use of uninitialized value $text in substr at ...](/use-of-uninitialized-value).


## chop

Another, solution is to use the `chop` function. It is quite naughty.
I don't recommend this. Actually I think I never had a real world use of the
`chop` function. If I am not mistaken, it is a left over from the era
before chomp was added. 

It removes and returns the last character of a string:

```perl
use strict;
use warnings;
use 5.010;

my $text = 'word';

say chop $text;  # d
say $text;       # wor
```

It could be used to extract, remove and compare the last character of a string,
but I can't think of a real use case when the "remove" part is useful.

If the original text was the empty string `my $text = '';`, chop would return
the empty string as well without giving any warning.

If the original text was [undefined](/undef-and-defined-in-perl) as in
`my $text;` the call to `chop $text;` would give a warning:
[Use of uninitialized value $text in scalar chop at ...](/use-of-uninitialized-value).

## Comments

if(substr $homeBase, -1 eq '/'){
chop $homeBase;
}

<hr>

I actually have what I think is a legitimate use of the `chop`
I need to process a string, but the processing needs to be disabled in between quotes:

my $str = q{this part requires processing "but not THIS part"; Toggle processing on..."but toggle it off for this"};

My solution is to split the string on the double-quote, process the even indices of the array, and join the array through a double-quote...
Works great, except for the double quote on the end, which will get dropped with the simple algorithm.
The solution is to add a space to my string, and chop it afterwards:

my @quoted_str = split qr/"|$/, $str . q{ };
my $i = 0;
while ( $i le $#quoted_str ) {

# Escape any parenthesis in the non-quoted substrings
$quoted_str[$i] =~ <my_processing_stuff>;
$i += 2;
}

# Join the processed substrings back together
$str = join q{"}, @quoted_str;
chop $str; # <====chop gets it done===

Unless there is a more elegant way to process a string, except for the quoted substrings...

