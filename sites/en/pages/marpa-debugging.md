---
title: "Marpa Debugging"
timestamp: 2018-03-01T23:21:01
tags:
  - Marpa
published: true
author: grandfather
---


In my last article (<a href="/marpa-for-building-parsers">Marpa for building
parsers - a first look</a>) we had a first look at the Marpa parsing engine.
This current article was going to be about building a ini file parser, but
trouble along the way has turned it into an article about debugging Marpa
parsing problems!


## What went wrong?

I started implementing a parser for ini files. I wanted to be able to handle
double quoted strings containing double quote characters (") using a backslash
to quote the imbedded quote character. My test cases failed and even with a lot
of fiddling with the grammar I couldn't see why. So it was time to find out
something about debugging Marpa.

## The failing test

After some whitling, here is the failing test case focusing just on the
problematic part of the grammar that parses strings:

{% include file="examples/marpa/debugging/parseFail.pl" %}

which generates the output:

```
Error in SLIF parse: No lexeme found at line 1, column 23
* String before error: "Quoted value with a "
* The error was at line 1, column 23, and at character 0x0020 (non-graphic character), ...
* here:  in the value"\n
Marpa::R2 exception at ...
```

So, after looking at the code for hours and spending hours reading documentation
and chasing my tail, as soon as I started writing this article I saw what the
immediate problem was! \" in the double quoted string was not what I thought it
was (see the source above - did you spot the problem)! However, lets ignore that
break through for the moment and carry on investigating debugging.

## Interpreting the error message

At first glance the error message above looks somewhat intimidating. Jeffrey
Kegler (author of Marpa) doesn't shield us from a much of the parser jargon, but
generally the intent is fairly obvious. Being a bit sloppy for now we can
substitute "token" for "lexeme" and interpret the first line of the message as
"the parser can't find a token at column 23 of line 1".

The next three lines give the context. First the recent text the parser was
happy with, then the character the parser choked on, and finally the unparsed
text following the choke point. In this case it is obvious that the \" wasn't
handled as expected. In fact neither \ nor " show up anywhere in the error
message which should really have caused alarm bells to start ringing.

However, the bells didn't sound, so lets bring in the heavy Marpa debugging
guns. So far we've used Marpa in a "do everything at once" kinda mode. To get
some debugging going we need to break things up a little. For now the parsing
line:

```
my $result = $grammar->parse(\$input, 'main');
```

is replaced with:

```
my $recce = Marpa::R2::Scanless::R->new({grammar => $grammar, semantics_package => 'main'});

eval {$recce->read(\$input)};
print "\n", $recce->show_progress(0, -1);

my $result = $recce->value();

print Data::Dump::dump($$result) if $result;
```

and the output is:

```
P0 @0-0 L0c0 quotedString -> . dQuote quotedCharStr dQuote newLine
P5 @0-0 L0c0 :start -> . quotedString
R0:1 @0-1 L1c1 quotedString -> dQuote . quotedCharStr dQuote newLine
P1 @1-1 L1c1 quotedCharStr -> . quotedCharacter
P2 @1-1 L1c1 quotedCharStr -> . quotedCharacter quotedCharStr
P3 @1-1 L1c1 quotedCharacter -> . nonQuote
P4 @1-1 L1c1 quotedCharacter -> . slash dQuote
R0:2 @0-2 L1c1-21 quotedString -> dQuote quotedCharStr . dQuote newLine
P1 @2-2 L1c2-21 quotedCharStr -> . quotedCharacter
F1 @1-2 L1c1-21 quotedCharStr -> quotedCharacter .
P2 @2-2 L1c2-21 quotedCharStr -> . quotedCharacter quotedCharStr
R2:1 @1-2 L1c1-21 quotedCharStr -> quotedCharacter . quotedCharStr
P3 @2-2 L1c2-21 quotedCharacter -> . nonQuote
F3 @1-2 L1c1-21 quotedCharacter -> nonQuote .
P4 @2-2 L1c2-21 quotedCharacter -> . slash dQuote
R0:3 @0-3 L1c1-22 quotedString -> dQuote quotedCharStr dQuote . newLine
```

which looks worse than the "out of the box" error report. In <a
href="https://metacpan.org/pod/distribution/Marpa-R2/pod/Progress.pod">the Marpa
R2 Progress</a> documentation Jeffrey describes interepreting the debug output
in great detail including a lot of what's going on under the hood. Here I'll
touch on highlights, as I understand them, that are interesting in understanding
the failure.

The first thing to notice is that each line shows a rule with a dot somewhere
after the ->. The letter at the start of the line indicates the matching phase
for the given rule: 'P' is 'predicted' (the rule to try and match), 'R' is a
partially matched rule, and 'F' is a fully matched rule.

Now, looking at the last two lines we can see a failed attempt to match \" and a
successful match to a closing quote. By now it should be pretty hard to escape
the fact that we need to escape the \ in out test string! If we change the test
string to:

```
"Quoted value with a \\" in the value"
```

in the original test script the script runs to completion with the output:

```
"Quoted value with a \" in the value"
```

Yay! Houston, we have lift off!

## Comments

I saw the problem immediately. Most people don't understand that using FOO as a here-string terminator is the same as "FOO", which means the here-string is double-quote interpolated. What you wanted was 'FOO', which would have been effectively single-quoted.
