---
title: "Introduction to Regexes in Perl 5"
timestamp: 2014-10-21T09:00:01
tags:
  - .
  - //
  - =~
  - !~
published: true
books:
  - beginner
author: szabgab
---


Regular Expressions, or Regexes or regexp as some people like to call, are an integral part of the Perl programming languages.
Other languages and other tools also provide regex support but there are a number of differences.


## Regex dialects and interactions

First of all Regex can be thought of as a separate language that has various dialects and that can be used in various places.

Regexes in Perl are not he same as in Python, Ruby, or PHP, even if some of them call them "Perl 5 compatible Regular Expressions".
Then Regexes used in grep, egrep, vim and emacs are also different from what you can use in Perl.
The general idea is the same, most of the special characters are also the same, but these dialects of regexes differ in various places
and certainly differ in their capabilities.

There is, however, another aspect of difference: The level of integration of the regex language with the host language or host environment.

When you program in some Unix <b>shell</b> and use sed, awk or grep to execute a
regex, the regex is totally separated from the shell language. It is an external tool.

In language such as Python, Ruby, PHP, Java or C#, regexes are another class. You have a constructor and methods and some other syntactic overhead.

In Perl however, Regexes are very closely related to the host-language. They are so integrated that in Perl there is an operator to use regexes.

## =~ the regex operator

There are a number of ways to use regex in Perl, but in most of the cases we use the `=~` operator that connects a string with a regex.
Even among those, various ways the most common looks like this:

```perl
my $str = 'The black cat jumped from the green tree';
if ($str =~ m/cat/) {
    print "There is a cat\n";
}
```

On the left-hand side of the `=~` operator there is a string. On the right-hand side there is a regex. The regex is `cat` while the two
slashes are the delimiters of the regex (just as single-quotes or double-quotes are delimiters of regular strings). The letter <b>m</b> in-front of the
first slash indicates <b>Matching</b>. It can be actually omitted writing just `/cat/` though having it explicitly there might make things clearer.

The above regex checks if the string "cat" appears in the string `$str`. If it appears, then
(in [scalar context](/scalar-and-list-context-in-perl) that was created by the if-statement),
the expression returns [true](/boolean-values-in-perl), otherwise it returns false. Hence the above code
will print "There is a cat", because there is a "cat" in the string `$str`.

## !~ negated regex

Just as the `==` (numeric equal) operator can be negated to become `!=` (numeric not-equal), the `=~` regex operator
can be also negated in a similar way to become `!~`.

So if we would like to check if there is no "dog" in the above string we can write:

```perl
my $str = 'The black cat jumped from the green tree';
if ($str !~ m/dog/) {
    print "There is no dog\n";
}
```

Of course we could have just negated the result of the match by adding the `not` keyword.

```perl
my $str = 'The black cat jumped from the green tree';
if (not $str =~ m/dog/) {
    print "There is no dog\n";
}
```


## Regular characters

A regex is designed to match a series of characters. In the regex most of the characters will match themselves and there are a few characters with special meaning.
For example we can check if the character 'a' can be found in a given string by using the regex `/a/`. If we are interested if the character series 'c', 'a', 't'
can be found in a given string we will use the regex `/cat/`. Regexes in perl match any part of the string so the regex `/cat/` would match any of the following strings:

```
"A cat with a mouse"
"cat"
"caterpillar"
"lolcat"
"LOLcats"
```

But it won't match any of the following:

```
"c a t"
"cut"
"c t"
"c.t"
```

## Special characters

The dot character `.` is one of the special characters. It will match any one(!) character except newline.
So the regex `/c.t/` will match any string with 'c' followed by any character, followed by 't'. Besides all the strings that
`/cat/` matches, this regex will also match

```
"cut"
"c t"
"c.t"
```

There are a number of other special characters `. * + ? ^ $ \ ( ) [ ] | { }` and of course the delimiter `/`.
In addition in some situations `-` is also a special character. We'll see explanation for all this in the following articles.

In case you'd like to use one of the special characters as exact match, for example if you'd like to match a '.' you can "escape" the
special meaning of each character preceding them by a back-slash `\`. So in order to match "c.t" but not match "cat", we can
use the regex `c\.t`.

In the extra special case, when you would like to match an exact back-slash `\`, for example if you'd like to match the string
"a\bc" you can "escape" the back-slash by another back-slash: `/a\\bc/`.

One thing that people learning get nervous about is the compactness of regexes. It is rather hard to read a regex, let me tell you two things.
Please consider that a 20-character long regex can express something that you would need to implement in 50-100 lines of perl code without regexes.
So when you feel it is hard to understand a 20-character regex, compare that to the time an energy needed to understand a 50-100 lines long perl snippet.

The other is that if you follow the Perl Maven articles and do the exercises, <b>you will learn how to read and understand regexes</b> and you won't have
a problem dealing with regexes any more.



