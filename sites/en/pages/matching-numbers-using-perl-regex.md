---
title: "Matching numbers using Perl regex"
timestamp: 2014-05-19T10:25:56
tags:
  - "^"
  - "+"
  - "[]"
  - "*"
published: true
author: szabgab
---


I have a file with lines looking like this:

```
Usage:524944/1000000 messages
```

How can I match the two numbers and extract them so I can process them later?


Let's see the regex:

The string starts with "Usage:" so the regex will start like this:

```perl
/Usage:/
```

There is no need to escape the : as in the regexes of Perl 5 the colon is
not a special character.

If we know and require that this will be at the beginning of the string we should say that
explicitly by adding a caret `^` at the beginning.

```perl
/^Usage:/
```

Maybe we don't need that, so I'll leave out the caret for now.

That string is followed by a number that, as I assume, can have any number of digits.
`\d` matches a single digit, and the `+` quantifier modifies that to have
**1 or more digits**.

```perl
/Usage:\d+/
```

So far it is good, but we would like to capture and reuse the number so we put the expression
matching it in parentheses:

```perl
/Usage:(\d+)/
```

This will allow code like this:

```perl
my $str = 'Usage:524944/1000000 messages';
if ( $str =~ /Usage:(\d+)/) {
   my $used = $1;
   # here we will have the 524944 in the $used variable
}
```

The next thing is to match the `/`. Because slash is the delimiter of the regular expression
we need to escape that. We write:


```perl
/Usage:(\d+)\//
```

This is not very nice. Luckily we can modify the delimiters of the regexes in Perl 5 by using the
letter `m` (which stand for matching) at the beginning. This way we can use many other characters
instead of the slash. I personally like a pair of curly braces around the regex because that makes
it very readable:

```perl
m{Usage:(\d+)/}
```

The / in the original string is followed by another multi-digit number that we want to capture again:

```perl
m{Usage:(\d+)/(\d+)}
```

That is followed by a space and then the word 'messages'.

```perl
m{Usage:(\d+)/(\d+) messages}
```

If we would like to make sure that nothing follows this string we can add a `$` sign at the end of the regex:

```perl
m{Usage:(\d+)/(\d+) messages$}
```

This will make sure, that a string like this: "Usage:524944/1000000 messages sent" won't match.

If we now go back to the earlier example, we could also use the `^` at the beginning:

```perl
m{^Usage:(\d+)/(\d+) messages$}
```

This would mean we make sure nothing is before the "Usage" and nothing comes after the "messages".

Depending on the situation that might be a good or a bad thing. I'll remove those for the final
example as I think we did not want to enforce that:

```perl
my $str = 'Usage:524944/1000000 messages';
if ( $str =~  m{Usage:(\d+)/(\d+) messages} ) {
   my ($used, $total) = ($1, $2);
   # here we will have the 524944 in the $used variable
   # and 1000000 in $total.
}
```

## Extra flexibility

I am not sure how much flexibility we might need there. Maybe that space after the second number might be
several spaces. Maybe even tabs? To allow for that we would use `\s+` for one or more white-spaces.

```perl
m{^Usage:(\d+)/(\d+)\s+messages$}
```

Maybe there can be spaces and even tabs between the : and the first digit. If we want to allow for that,
we can add `\s*` where the `*` is a quantifier meaning **0 or more**.

```perl
m{^Usage:\s*(\d+)/(\d+)\s+messages$}
```

We could even try to make this more readable by adding the `x` modifier at the end. If we use that,
we can add spaces and comment in the regex to make it look nicer:

```perl
m{^Usage:
  \s*
  (\d+)/(\d+)    # used / total
  \s+messages
 $}x
```


## The data changes

That's great but at some point the input changed. It now looks like this string:

```
Usage:524,944 of 1,000,000 messages
```

Instead of trying to change our regex, let's start it from scratch.

This time we already start with the /x modifier to make more space in the regex:

The beginning is the same and we allow for some spaces after the colon:

```perl
/^Usage:\s*/x
```

Then there is something that contains digits and commas so we create a character class
that can match a single character that is either a digit or a comma: `[\d,]`
and use the `+` quantifier on the character class:

```perl
/^Usage:\s*
   [\d,]+
/x
```

We would like to capture that number so we put it in parentheses and
I also added a comment for clarification.

```perl
/^Usage:\s*
   ([\d,]+)     # used
/x
```

After the number there is a space but because of the /x modifier, perl will disregard
any spaces. We take some liberty here and allow both spaces and tabs using `\s`
instead of a space ` ` on both sides of the "of" word.

```perl
/^Usage:\s*
   ([\d,]+)      # used
   \s+of\s+
/x
```

That is followed by another number with commas:

```perl
/^Usage:\s*
   ([\d,]+)      # used
   \s+of\s+
   ([\d,]+)      # total
/x
```

followed by another (few) spaces and the word "messages":

```perl
/^Usage:\s*
   ([\d,]+)      # used
   \s+of\s+
   ([\d,]+)      # total
   \s+messages
/x
```

This can be used in the `if` statement:

```perl
my $str = 'Usage:524,944 of 1,000,000 messages';
if ($str =~ /^Usage:\s*
            ([\d,]+)      # used
            \s+of\s+
            ([\d,]+)      # total
            \s+messages
           /x) {
  my ($used, $total) = ($1, $2);
  ...
}
```


Finally if we would like to use the numbers as numbers, we can eliminate the commas
with two global substitutes:

```perl
$used =~ s/,//g;
$total =~ s/,//g;
```


## Alternatives

While the above code will work, there are people who like to use regexes in a different way. As the motto of Perl it
TMTOWDI (There's More Than One Way To Do It), let's see these examples:

```perl
if (my ($used, $total) = $str =~ /^Usage:\s*
            ([\d,]+)      # used
            \s+of\s+
            ([\d,]+)      # total
            \s+messages
           /x) {
  ...
}
```

In this snippet of code we use the feature of `=~` that in [LIST context](/scalar-and-list-context-in-perl),
if there are capturing parentheses, it will return the list created from the strings that were captured by these parentheses.
So instead of having the values in `$1` and in `$2` they arrive directly to `$used` and `$total`.

## Named captures

Another alternative for people who can use perl 5.10 or later is to use Named Captures.
An example provided by [Tim Heaney (oylenshpeegul)](http://oylenshpeegul.typepad.com/).

```perl
#!/usr/bin/env perl

use v5.010;
use strict;
use warnings;

my $str = 'Usage:524944/1000000 messages';

# The manual way.
if ( $str =~ m{Usage:(\d+)/(\d+) messages} ) {
    my ($used, $total) = ($1, $2);
    say "$used $total";
}

# The one-line less way:
if (my ($used, $total) = $str =~ m{Usage:(\d+)/(\d+) messages}) {
    say "$used $total";
}

# Named captures:
if ($str =~ m{Usage:(?<used>\d+)/(?<total>\d+) messages} ) {
    say "$+{used} $+{total}";
}
```

## Unicode digits

[Nick Patch](http://nickpatch.net/) thought that it would be important to mention that `\d` may match any Unicode digit.

```perl
# the number 3 in eight different numeral systems
perl -Mutf8 -E 'say "٣३၃៣๓໓᠓௩" =~ /^\d+$/ ? "yes" : "no"'
yes
```

and that [Regexp::Common](http://metacpan.org/pod/Regexp::Common) provides a great out-of-the-box solution for number parsing where
you don't need to worry about Unicode digits or placement of optional commas.

```perl
use Regexp::Common qw( number );

$str =~ / Usage: \s* ( $RE{num}{int}{-sep=>',?'} ) /x;
```


## Source

The [original question](http://mail.pm.org/pipermail/pdx-pm-list/2012-February/006339.html)
was brought up by [Russell Johnson](http://dimstar.net/)
on the mailing list of the [Portland Perl Mongers](http://pdx.pm.org/).

