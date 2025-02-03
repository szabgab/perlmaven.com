---
title: "How to break lines with max width? (wrap)"
timestamp: 2014-08-24T08:30:01
tags:
  - substr
  - rindex
  - Text::Wrap
  - wrap
types:
  - screencast
published: true
author: szabgab
---


The other day someone asked me:
"How can I split $var after max. 100 characters, where the delimiter is a space, so it will not cut the words in the middle?"
or in other words, she has some long text and she wants to make sure every row is less than 100 characters long, but words
(separated by space) are kept in one piece.


{% youtube id="u7G5wij_tFQ" file="break-lines-with-max-width" %}

Using [split](/perl-split) might work, but we are not really looking for
splitting up the the text along every space. We are looking for the right-most space in the first 100 characters.

In Python there is an [rindex](https://code-maven.com/slides/python-programming/rindex-in-string-range) function that will
accept a range. So we could easily find the right-most white-space within the first 100 characters using `text.rindex(' ', 0, 100)`
and then we can get the appropriate prefix of the original text using the [string slice notation](https://code-maven.com/slides/python-programming/string-slice).

In Perl there is also an [rindex](/string-functions-length-lc-uc-index-substr) function to return the right-most location
of a substring, but it only accepts a starting position. In order to limit the search to only a part of the original string we can use
the [substr](/string-functions-length-lc-uc-index-substr) function.

In order to have some text that we can work on, we can copy part of the [Lorem Ipsum](http://www.lipsum.com/) text and put it in a variable called
`$text`. (In a real application this variable would be probably filled by the content of a file.)
In our solution we are going to cut up this string (split it up, if you prefer that word) into pieces where each piece will be shorter than some
`$max` characters, but making sure we don't cut words into pieces. (It is more generic than just to solve this for $max=100.)

We have a [while-loop](/while-loop) running as long as there is something in the `$text` variable.
The first thing in the while loop is to check if the the content is already smaller than the `$max` length. We print that and finish the loop.

If it is longer than the `$max`, then we need take the first `$max` character, and locate the right-most space using `rindex`.
It will return -1 in case there was no space. I don't really know what to do if there is a word which is more than 100 (or in our case 40) characters long.
So for now I just threw an exception calling [die](/die).

Once we have the location of the right-most space before the `$max` limit, we can now use the [4-parameter version of substr](/lvalue-substr),
that will return the first `$loc` character and also replace them with the content of the 4th parameter which, in this case, is the empty string.

We can print this string but at the end we have to remove an additional character from the beginning of `$text`. This is the space we located, but have not
included in the string we print.

```perl
use strict;
use warnings;
use 5.010;

my $text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
my $max = 40;

while ($text) {
    if (length $text <= $max) {
        say $text;
        last;
    }
    my $prefix = substr $text, 0, $max;
    my $loc = rindex $prefix, ' ';

    if ($loc == -1) {
        die "We found a word which is longer than $max\n";
    }
    my $str = substr $text, 0, $loc, '';
    say $str;
    substr $text, 0, 1, '';
}
```

## use Text::Wrap

I think this is not the first time I forget about [Text::Wrap](https://metacpan.org/pod/Text::Wrap), when solving this problem,
I know I even found it in some of my notes, but this time, as Ralf Peine pointed to it, I am going to include the solution with this module:

```perl
use strict;
use warnings;
use 5.010;

my $text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

use Text::Wrap qw(wrap);
local $Text::Wrap::columns = $max;
say wrap('', '', $text);
```

The call to `local` is not strictly required there, but it is a good practice especially if we wrap the whole code in a block to limit the impact of the assignment.
Once the block is over, the value of `columns` will go back to the default, or whatever was set earlier.

```perl
{
    local $Text::Wrap::columns = $max;
    say wrap('', '', $text);
}
```

The two empty string provided as the first two parameters of the `wrap` function set the indentation of the first row, and all the subsequent
rows. We wanted both to be the empty string.


