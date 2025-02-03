---
title: "Switch-Case statement in Perl 5"
timestamp: 2016-10-16T07:30:01
tags:
  - switch
  - case
  - if
  - elsif
  - else
  - given
  - when
  - ~~
published: true
author: szabgab
archive: true
---


People coming from other languages often ask how to use the `switch` `case` statements in Perl 5.

In a nutshell, you always use `if`, `elsif`, and `else`.

The longer answer is as follows:


## Switch Case

Perl 5, the language itself does not have any statement similar to the `switch` and `case` statement of some other languages. (Neither does Python by the way.)

There is, or rather used to be, a standard module called [Switch](https://metacpan.org/pod/Switch) that could provide similar functionality,
but reportedly it was buggy and it was removed from the core. That means recent version of Perl won't have it. If you read its documentation you'll see
it recommends given/when.

## Given When

In version 5.10 the keywords [given and when](/switching-in-perl-5.10) were introduced trying to provide functionality
similar to what `case` and `switch` are expected to do, but the design was copied from the design of Perl 6.

Unfortunately due to some misunderstandings the implementation had various issues and thus in a later version this functionality was marked as <b>experimental</b>
which means if you use it, perl will give you warnings such as `given is experimental` and `when is experimental`.
It also means its behaviour might change in the future or that it will be removed.

You can avoid those warnings if you add `no warnings 'experimental';` to your code.

With that said, as far I as I know, the problems of the `given/when` statement are actually rooted in the `~~` operator which
was called `Smart Match`, but which turned out to be not so smart. If you don't rely on the "magic" in that operator then you will be ok.
So for example the following script should work without any issues:

{% include file="examples/given_when.pl" %}

## if elsif else

Probably the safest solution however is to go back to good old `if`, `elsif`, `else` statement as in the following example:

{% include file="examples/if_elsif_else.pl" %}

## Comments

I have a script which has a 7 level if-elsif-else statement. Perlcritic complains about that. So I created an equivalent given/when statement and put in the "no warnings 'experimental'". Of course that brings up the issue of using a feature that may go away. Personally I like the SmartMatch "~~" operator's ability to check if there is an existing element in an array with the simple "if ($var ~~ @array)". But experimental is experimental. I decided to stick with my original if-elsif-else statement and insert "## no critic (ProhibitCascadingIfElse)" to ignore it.

The irony is I find myself doing more Node.js now as the Perl audience has become very limited. The bulk of my Perl coding is simply updating old scripts I have lying around.


<hr>

Well the original c switch statement only takes constants. And also, most C compilers convert switch statements to hashes and do hash lookups.

So an equivalent to the case statement could be :

my %CASE= (
'x1' => sub { print 'y1' },
'x2' => sub { print 'y2' }
);

Then you can call :

$CASE{'x1'}->()

to execute the specified sub.

This is also the fastest and most efficient way to code this.

Also see : https://en.wikipedia.org/wiki/Conditional_(computer_programming)#Hash-based_conditionals

<hr>

Nice. And when formatted so cleanly, makes one wonder Why the need fore "case".




