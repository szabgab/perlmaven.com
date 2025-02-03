---
title: "Marpa for building parsers - a first look"
timestamp: 2017-10-13T13:41:01
tags:
  - Marpa
  - parser
published: true
books:
  - marpa
author: grandfather
---


Parsers seem to be esoteric, hard and to lack much day to day application. Marpa
lowers the bar to entry by hiding a lot of the mysterious stuff, adding some fun
and making parsers easy enough to use for solving some common problems.


## The back story

Long ago when Computer Science was still about compilers and data structures I
took a couple of first year CS papers. I learned about recursive decent parsers
and have since used them to do real work. When I picked up Perl I took a look at
[Parse::RecDescent](https://metacpan.org/pod/Parse::RecDescent).

Parse::RecDescent was a lot more work and less fun than I expected. In fact I
[called on the Monks](http://perlmonks.org/?node_id=574311) for help
and was surprised at how many moving parts are buried under the surface of the
iceberg (see ikegami's later replies in particular).

In contrast, playing with [Marpa](https://metacpan.org/pod/Marpa::R2)
recently to answer <a href="http://perlmonks.org/?node_id=1151415">a PerlMonks
question</a> turned out to be a bundle of fun. It still took some playing around
to come to grips with, but at least it had sane error messages! So lets explore
Marpa for the task I struggled with using P::RD. The big picture task doesn't
much matter and I can't remember it anyway. The task I presented to the Monks
was to parse a bunch of assignment statements and generate a hash of name/value
pairs.

## A first look at Marpa
Marpa works with a syntax provided in a BNF
(<a href="https://en.wikipedia.org/wiki/Backus%E2%80%93Naur_Form">WikiPedia:
Backus Naur Form</a>) style definition. A little extra markup hooks up actions
to elements of the syntax and a little boiler plate handles setting up common
parsing options:

```perl
lexeme default = latm => 1

declaration ::= assignment* action => doResult
assignment ::= name '=' number action => doAssign
name ~ [\w]+
number ~ [\d]+

:discard ~ spaces
spaces ~ [\s]+
```

The lexeme line sets the parser for longest token match. The 'spaces' lines at
the end sets up a general rule for discarding white space. The interesting bit
is in the middle where the syntax description lives.

Ignoring the `action => ...` bits for the moment, the first `::=`
line (<b>rule</b>) says that a `declaration` is 0 or more
`assignment`s. The second rule says that an `assignment` is a
`name` followed by the '`=`' character followed by a
`number`.

A `name` is one or more word characters and a `number` is one or
more digits. The `[\w]+` match expression looks kinda weird to Perl eyes,
but it's what Marpa wants so it's what Marpa gets.

So far, so good. The '`action => xxx`' bits hook an action (subroutine
call) up to a rule so that when the rule matches, something happens. The
subroutine gets called with a bunch of parameters passed that depend on the rule
definition and results from processing other rules. Lets see some code:

{% include file="examples/marpa/asHash.pl" %}

The output from running the code is:

```
{ 1 => 1, 42 => 3, wibble => 42, x => 1, y1 => 2, z => 3 }
```

from which you can see that variable names are a rather loose concept in this
parser (numbers are not usually valid variable names!). But, that aside, things
work as desired.

`doAssign` takes the `name` and `number` from the
`assignment` rule and returns a hash ref with the `name` as the
key.

`doResult` takes the list of all the `doAssign` generated hash
refs and turns them into a single hash ref containing all the variables. Note
that it doesn't do anything smart like checking for `name` collisions!

## Extending the parser

So now we have had a first taste. Let's add strings values as well as numbers.
Most of what we have already stays the same. Here's the extra syntax to be
inserted following the assignment rule:

```
    | name '=' string action => doAssignStr

string ::= ['] chars1 ['] action => [values]
    | '"' chars2 '"' action => [values]
    
chars1 ~ [^']*
chars2 ~ [^"]*
```

and the extra handler for the `string` assignment:

```perl
sub doAssignStr     {
    my (@params) = @_;
    
    return {$params[1] => $params[3][1]};
    }
```

The `string` rules don't need any code support. Instead the
`action` creates a list of three values that are returned by the rule.
The string value is the middle value in the list, with the quote characters as
the other two values. `doAssignStr` fishes the string value out of the
third parameter passed in to it - the returned value from the string rule.

The complete script with new test assignments is:

{% include file="examples/marpa/asHashExtended.pl" %}

which prints:

```
{ wibble => 42, wobble => "twenty three", x => 1, y => 2, z => 3 }
```

So, we haven't written a compiler yet, but there is a hint of how such a thing
might be done. An interesting exercise is to write a script to perform the same
task without using helper modules. The simple numeric assignment parsing is
easy, especially if you use a couple of Perlish tricks. Things start getting a
bit more hairy when the string parsing is added. It isn't just a matter of
extending the original code a little as was the case with the Marpa code above.

Note that this is very much a play thing. It doesn't provide any sort of
sensible error handling or allow quoted characters in the strings or even do
very much that is immediately useful. It does provide a starting point and a
playground for exploring Marpa however.

I've written parsers of various sorts in a variety of languages, mostly for
arithmetic expression parsing. Parsers can be fun, and are almost always
frustrating to debug. My (small) experience so far with Marpa is that it
enhances the fun and reduces the frustration.


## Comments

I fail to see why

[\w]+

would look 'weird' to a perl programmer unless they had somehow never used regular expressions?

---
Author: weird in the sense that the [] are not required in Perl regular expressions where we would usually just use \w+

---
Ah! Hadn't thought of it that way since it nearly matches a common pattern I use when matching everything but some character, i,e, [^\{]+ for instance. Probably something I picked up from a fellow monk :)


