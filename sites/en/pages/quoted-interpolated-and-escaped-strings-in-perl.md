---
title: "Strings in Perl: quoted, interpolated and escaped"
timestamp: 2013-05-15T11:45:03
tags:
  - strings
  - "'"
  - escape character
  - interpolation
  - quote
  - embedded characters
  - q
  - qq
published: true
books:
  - beginner
author: szabgab
---


Understanding how strings work is important in every programming language, but in Perl they are
part of the essence of the language. Especially if you consider that one of the acronyms of Perl
is <b>Practical Extraction and Reporting Language</b> and for that you need to use lots of strings.


Strings can be placed either between single quotes `'` or double quotes `"` and they have slightly different behavior.

## Single quoted strings

If you put characters between single quotes `'`, then almost all the characters,
except the single-quote itself `'`,
are interpreted as they are written in the code.

```perl
my $name = 'Foo';
print 'Hello $name, how are you?\n';
```

The output will be:

```
Hello $name, how are you?\n
```

## Double quoted strings

Strings placed between double quotes `"` provide interpolation
(other variables embedded in the string will be replaced by their content),
and they also replace the special escape sequences such as `\n` by a real newline
and `\t` by a real tab.

```perl
my $name = 'Foo';
my $time  = "today";
print "Hello $name,\nhow are you $time?\n";
```

The output will be

```
Hello Foo,
how are you today?

```

Note, there is a `\n` right after the comma in the string and another one at the end of the string.

For simple strings such as 'Foo' and "today" that have no `$`, `@`, and `\` characters
in them, it does not matter how they are quoted.

The next two lines have the exact same result:

```perl
$name = 'Foo';
$name = "Foo";
```

## Interpolating variables followed by other letters

In the following example we would like to print "Mb" immediately after the value that is in the variable.

{% include file="examples/interpolation_speed.pl" %}

We expected:

```
The download speed is 100Mb
```

but we get:

```
The download speed is
```

because Perl looks for the variable called `$speedMb`


If we have [use strict](/always-use-strict-and-use-warnings) enabled, as should always:

{% include file="examples/interpolation_speed_strict.pl" %}

then we would get a compilation error:

```
Global symbol "$speedMb" requires explicit package name (did you forget to declare "my $speedMb"?) at interpolation_speed_strict.pl line 6.
Execution of interpolation_speed_strict.pl aborted due to compilation errors.
```

The way to handle this case is to wrap the real variable name in curly braces:

{% include file="examples/interpolation_speed_strict_fixed.pl" %}


## E-mail addresses

As `@` also interpolates in double quoted strings, writing e-mail addresses
needs a little more attention.

In single quotes `@` does not interpolate.

In double quotes this code will generate an error:
[Global symbol "@bar" requires explicit package name at ... line ...](/global-symbol-requires-explicit-package-name)
and a warning:
<b>Possible unintended interpolation of @bar in string at ... line ...</b>

The latter might be the one that provides the better clue what is really the problem.

```perl
use strict;
use warnings;
my $broken_email  = "foo@bar.com";
```

This code, on the other hand, having the e-mail address in single quotes, will work.

```perl
use strict;
use warnings;
my $good_email  = 'foo@bar.com';
```

What if you need both the interpolation of scalar variables but you want to include at marks `@` in the string?

```perl
use strict;
use warnings;
my $name = 'foo';
my $good_email  = "$name\@bar.com";

print $good_email; # foo@bar.com
```

You can always <b>escape</b> the special characters, in this case the at-mark `@` by using the so-called <b>escape character</b>
which is the back-slash `\` character.

## Embedding dollar $ sign in double quoted strings

In a similar way if you'd like to include a `$` sign in an otherwise double-quoted string you can escape that too:

```perl
use strict;
use warnings;
my $name = 'foo';
print "\$name = $name\n";
```

Will print:

```
$name = foo
```

## Escaping the escape character

There are rare cases when you'd like to include a back-slash character in a string.
If you put a back-slash `\` in a double-quoted string,
Perl will think you want to escape the next character and do its magic.

Don't worry though. You can tell Perl to stop that by escaping the escape character:

You just put another back-slash in front of it:

```perl
use strict;
use warnings;
my $name = 'foo';
print "\\$name\n";
```

```
\foo
```

I know this escaping the escape character is a bit strange, but this is basically how it works in every other language as well.


If you'd like to understand this whole escaping business, try something like this:

```perl
print "\\\\n\n\\n\n";
```

see what does that print:

```
\\n
\n
```

and try to explain it to yourself.

## Escaping double quotes

We saw that you can put scalar variables in double-quoted strings but you can also escape the `$` sign.

We saw how you can use the escape character `\` and how you can escape that too.

What if you'd like to print a double quote in a double-quoted string?


This code has a syntax error:

```perl
use strict;
use warnings;
my $name = 'foo';
print "The "name" is "$name"\n";
```

when Perl sees the double-quote just before the word "name" it thinks that was the end of the string
and then it complains about the word <b>name</b> being a [bareword](/barewords-in-perl).

You might have already guessed, we need to escape the embedded `"` character:

```perl
use strict;
use warnings;
my $name = 'foo';
print "The \"name\" is \"$name\"\n";
```

This will print:

```
The "name" is "foo"
```

This works, but it is quite hard to read.


## qq, the double-q operator

That's where you can use `qq` or the double-q operator:

```perl
use strict;
use warnings;
my $name = 'foo';
print qq(The "name" is "$name"\n);
```

For the untrained eyes, the qq() might look like a function call, but it is not. `qq` is an operator
and you'll see in a second what else it can do, but first let me explain this.

We replace the double-quotes `"` that used to surround the string by the parentheses of the `qq`
operator. This means the double-quotes are not special any more in this string, so we don't need to escape them.
That makes the code a lot more readable.
I'd even call it beautiful, if I did not fear the wrath of the Python programmers.

But what if you would like to include parentheses in your string?

```perl
use strict;
use warnings;
my $name = 'foo';
print qq(The (name) is "$name"\n);
```

No problem. As long as they are balanced
(that is, having the same number of opening `(`, and closing `)` parentheses,
and always having the opening parentheses before the corresponding closing parentheses) Perl can
understand it.

I know. You'll want to break it now, by putting a closing before the opening:

```perl
use strict;
use warnings;
my $name = 'foo';
print qq(The )name( is "$name"\n);
```

Indeed, Perl will give you a syntax error about "name" being a [bareword](/barewords-in-perl).
Perl can't understand everything, can it?

You could, of course, escape the parentheses in the string`\)` and `\(`, but we were down that rabbit hole already.
No thank you!

There must be a better way!

Do you remember, I wrote `qq` is an operator and not a function? So it can do tricks, right?

What if we replaced the parentheses around our string by curly braces? `{}`:

```perl
use strict;
use warnings;
my $name = 'foo';
print qq{The )name( is "$name"\n};
```

That works and prints the string as we meant:

```
The )name( is "foo"
```

(even though I have not idea why would I want to print something like that...)

Then [the guy from the second row](http://perl.plover.com/yak/presentation/samples/slide027.html) raises his hand,
and asks what if you want both parentheses and curly braces in your string, <b>and</b> you want them imbalanced?

You mean like this, right?

```perl
use strict;
use warnings;
my $name = 'foo';
print qq[The )name} is "$name"\n];
```

printing this:

```
The )name} is "foo"
```


... there must be a use for the square brackets too, right?


## q, the single-q operator

Similar to `qq` there is also an operator called `q`.
That too allows you select the delimiters of your string, but it works
as a single quote `'` works: It does <b>NOT</b> interpolate variables.

```perl
use strict;
use warnings;
print q[The )name} is "$name"\n];
```

prints:

```
The )name} is "$name"\n
```

## Comments

Is there a way to print "test0A, test1A, test2A" using a loop, by something like print "test$iA\n"; and not print
"test" . $i . "A\n";?


print "test${i}A\n"


Ahhh, would've saved me hours during the past seven years had I learnt it back then. Thanks so much! Last question, do you know of any way to do, for example,

"test1A, test3A, test5A" similarly using "test${i*2+1}A\n" of some sort? Doing calculations inline... Am I reaching? Kosz szepen!


Well, you can, but I'd probably advise against it as that might make your code harder to read and maintain.
See this:

print "@{[$x++]}\n"


<hr>

I don't understand why I get "Unmatched ( in regex" in the example below. Can you explain it ?

  my $pat='(\\)';
  '\\'=~/^(\\)/  ? print "OK" : print "NO MATCH!\n";   # OK
  '\\'=~/^$pat/  ? print "OK" : print "NO MATCH!\n";   # Unmatched ( in regex


What I understand m// interpolates as a double quoted string. That should expand $pat, which contains (\\), If I add an extra backslash, e.g. $pat='(\\\)' then it prints OK. Dont understand that at all. Using Perl 5.16.


I wrote you an answer in this example: https://perlmaven.com/escaping-regexes I hope that helps

Thanks for your answer. Was not aware of the qr// quoting operator. However I can still not avoid modifying an arbitrary regex in qr//, since I must quote the end-delimiter. On stackoverflow I found this suggestion:
$pat = <<'EOF';
(\\)/'
EOF

Why do you need to quote the end-delimiter? Show me the code that did not work.

I want to enter regexps from puzzles like this one https://regexcrossword.com/playerpuzzles/58a687880d4d8 to debug my entries. As the regexps can be tricky I want to avoid changing them.

Show me one specific that does not work with qr//

E.g. this regexp /;.* would require change if inserted in qr//

then use qr{} or qr!!

<hr>

how to escape special characters like a single inverted quote (’ ) in Perl. Example: Patient’s Phone

backslash


