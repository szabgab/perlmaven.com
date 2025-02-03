---
title: "Converting indirect calls"
timestamp: 2016-03-10T19:50:01
tags:
  - Perl::Critic
  - Objects::ProhibitIndirectSyntax
published: true
books:
  - cpan_co_maintainer
author: szabgab
archive: true
---


Earlier we have put some energy into <a href="/eliminating-indirect-method-calls"">eliminating indirect method calls</a>, but
as I started to read the source code again, I found there are lots of other places with indirect calls.

As I found out the [Objects::ProhibitIndirectSyntax](https://metacpan.org/pod/Perl::Critic::Policy::Objects::ProhibitIndirectSyntax) cannot handle them automatically.
[Perl::Critic::Policy::Dynamic::NoIndirect](https://metacpan.org/release/Perl-Critic-Policy-Dynamic-NoIndirect) that looked like an alternative, failed to install and
I am not sure that would do the work.

Instead, I went back to [Objects::ProhibitIndirectSyntax](https://metacpan.org/pod/Perl::Critic::Policy::Objects::ProhibitIndirectSyntax) that
can be configured to look for specific words.


I could have written a new policy that would locate code that looks like those `bareword Bare::Word param param` If there are :: in the second bareword then this is probably an indirect call.
But I did not want to shave that Yak.

Instead of that I started to look over the code looking for indirect calls. Whenever I found one, I would add it to the `.perlcriticrc` file to the
`[Objects::ProhibitIndirectSyntax]` rule.  I've also removed the `severity = 5` entry from that rule as it is not needed any more now that the general
severity level is 4.

I made two separate commits with these changes


[commit](https://github.com/szabgab/Pod-Tree/commit/b3ae3c72482172946ca030d16db47a11885b73fa)

[commit](https://github.com/szabgab/Pod-Tree/commit/e1e00032e4a50596c4422a1e25a7541e86b621ef)

From all the changes let me point out these two lines:

Before:

```perl
           push @text, text Pod::Tree::Node $text if $text;
           push @link, ( text Pod::Tree::Node $link), @$children;
```

After:

```perl
           push @text, Pod::Tree::Node->text($text) if $text;
           push @link, Pod::Tree::Node->text($link), @$children;
```

In the second line of the code before the change, the author had to use parentheses around the construct to make sure
he `text` function receives only two parameters. This kind of disambiguation is not necessary with the direct
method call where we put parentheses around the parameters, as expected by most programmers.


