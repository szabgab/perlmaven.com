---
title: "Bare Here documents are deprecated - How to find offending code?"
timestamp: 2013-07-11T11:01:01
tags:
  - <<
  - Perl::Critic
  - perlcritic
published: true
author: szabgab
---


## Update

Apparently I misunderstood the change in perl 5.20, so this article has been fixed accordingly.

Thanks again to [Jon Jensen](https://twitter.com/jonjensen0) to pointing to
[the comment](https://rt.perl.org/rt3/Public/Bug/Display.html?id=118511#txn-1228753)
that clarifies this. And thanks to Joel Berger who made that point as well in his comment.


There is a way to write here documents with an empty end-tag:

```perl
my $str = <<"";
text

print $str
```

If you run the above code you will get:

```
text
```

I don't think I've ever seen this, and I don't think I like it. I think I prefer when
it is obvious where something ends, and I think I don't like having significant white-space.

Anyway, there is (or rather was) an even stranger version of this,
when you don't even put the quotes at the not-existing end at the beginning of the
here-document:

```perl
my $str = <<;
text

print $str
```

<b>This is the case that has been deprecated</b> and that will be removed in perl 5.20.

If you run the above code you will get:

```
Use of bare << to mean <<"" is deprecated at program.pl line 2.
text
```

So even without `use warnings` this generates a warning.

Now I understand more why do the Perl Porters think this is a rare case, as people
would get a warning every the time they use this code.

So I'd say false alarm.

Sorry if the article got you worked up on the changes.

<hr>

Anyway, I'll leave the original text here: You might still want to track down the other
cases, even if they are not going to be removed from Perl, you might want to clarify
the way the here-documents are written to make interpolation more obvious to the reader.

## The original article

When describing the [here documents](/here-documents) in Perl I mentioned that you
might see cases of here-documents where the end-mark is not quoted at the declaration.

It [turns out](http://byte-me.org/perl-5-porters-weekly-july-1-7-2013/) that feature has been
deprecated a long time ago and it will be removed from perl version 5.20.

You might be a long way from upgrading to that version of Perl, and you don't know if you have such code at all.
You might think "I won't be around when that happens".

Or you could use the following steps to find any place where you have here-document using the deprecated
feature and you can fix it now easily.

That way you can make sure this issue won't break the code when that upgrade happens, and if you are not
there people won't want to hunt you down!


## Perl::Critic to the rescue

The [Perl::Critic](http://www.perlcritic.com/) has a policy called
[ValuesAndExpressions::RequireQuotedHeredocTerminator](https://metacpan.org/pod/Perl::Critic::Policy::ValuesAndExpressions::RequireQuotedHeredocTerminator)
that check exactly this situation.

As explained in the [article about improving your code](/perl-critic-one-policy),
you can use the `perlcritic` command to look for violations of a specific policy.

Let's say we have a file called programming.pl with the following code:

```perl
my $what = 'quote';

print <<"END2";
double $what
END2

print <<'END1';
single $what
END1

print <<END0;
no $what
END0
```

If we run this using <b>perl programming.pl</b> the output will look like this:

```
double quote
single $what
no quote
```

Which, I assume, is the expected output.

If we run the perlcritic command:

`perlcritic --single-policy  ValuesAndExpressions::RequireQuotedHeredocTerminator programming.pl`

we get the following report:

```
Heredoc terminator must be quoted at line 11, column 7.  See page 64 of PBP.  (Severity: 3)
```

There you are. It found the code that violates the policy, that will stop working on perl 5.20.

Fix it by putting double quotes around the name: `print <<"END0";` and run the script again
to make sure the output stayed the same.

You can also run the perlcritic policy checker to see the success report:

```
$ perlcritic --single-policy  ValuesAndExpressions::RequireQuotedHeredocTerminator p.pl
p.pl source OK
```

Now do it on all the files you have.

## RT Ticket

I did not even think to search for this, but thanks to
[Jon Jensen](https://twitter.com/jonjensen0) here is the link
to [the RT ticket](https://rt.perl.org/rt3//Public/Bug/Display.html?id=118511) discussing
this specific change in perl.


