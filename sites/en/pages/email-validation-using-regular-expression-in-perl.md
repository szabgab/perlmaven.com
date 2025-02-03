---
title: "Email validation using Regular Expression in Perl"
timestamp: 2016-01-02T20:30:01
tags:
  - regex
  - Email::Valid
  - Email::Address
published: true
books:
  - beginner
author: szabgab
archive: true
---


In various use-cases, but especially at web-based registration forms we need to make sure the value we received is
a valid e-mail address. Another common use-case is when we get a large text-file (a dump, or a log file) and we need
to extract the list of e-mail address from that file.

Many people know that Perl is powerful in text processing and that using regular expressions
can be used to solve difficult text-processing problems with just a few tens of characters in a well-crafted regex.

So the question often arise, how to validate (or extract) an e-mail address using Regular Expressions in Perl? 


Before we try to answer that question, let me point out that there are already, ready-made and high-quality solutions for
these problems.  [Email::Address](https://metacpan.org/pod/Email::Address) can be used to extract a list
of e-mail addresses from a given string. For example:

{% include file="examples/email_address.pl" %}

will print this:

```
foo@bar.com
"Foo Bar" <foobar@example.com>
bar@foo.com
```

[Email::Valid](https://metacpan.org/pod/Email::Valid) can used to validate
if a given string is indeed an e-mail address:

{% include file="examples/email_valid.pl" %}

This will print the following:

```
yes 'foo@bar.com'
yes 'foo@bar.com'
no 'foo at bar.com'
```

It properly verifies if an e-mail is valid, it even removes unnecessary white-spaces from both ends of the e-mail address,
but it cannot really verify if the given e-mail address is really the address of someone, and if that someone is the
same person who typed it in, in a registration form. These can be verified only by actually sending an e-mail to that
address with a code and asking the user there to verify that indeed s/he wanted to subscribe, or do whatever action
triggered the email validation.


## Email validation using Regular Expression in Perl

With that said, there might be cases when you cannot use those modules and you'd like to implement your own solution
using regular expressions. One of the best (and maybe only valid) use-cases is when you would like to teach regexes.

[RFC822](http://www.w3.org/Protocols/rfc822/#z8) specifies how an e-mail address must look like but
we know that e-mail addresses look like this: `username@domain` where the "username" part can
contain letters, numbers, dots; the "domain" part can contain letters, numbers, dashes, dots.

Actually there are a number of additional possibilities and additional limitations, but this is a good start describing an
e-mail address.

I am not really sure if there are length limitation on either of the username or the domain name.


Because we will want to make sure the given string matches exactly our regex, we start with an anchor
matching the beginning of the string `^` and we will end our regex with an anchor matching
the end of the string `$`. For now we have

```
/^
```

The next thing is to  create a [character class](/regex-character-classes) that can catch any character of the username:
`[a-z0-9.]`.

The username needs at least one of these, but there can be more so we attach the [+ quantifier](/regex-quantifiers) that means
"1 or more":

```
/^[a-z0-9.]+
```

Then we want to have an at character `@` that we have to escape:

```
/^[a-z0-9.]+\@
```

The character class matching the domain is quite similar to the one matching the username: `[a-z0-9.-]` and it is also
followed by a `+` quantifier.

At the end we add the `$` end of string anchor:

```perl
/^[a-z0-9.]+\@[a-z0-9.-]+$/
```

We can use all lower-case characters as the e-mail addresses are case sensitive. We just have to make sure that when we
try to validate an e-mail address first we'll convert the string to lower-case letters.

## Verify our regex

In order to verify if we have the correct regex we can write a script that will go over a bunch of
string and check if [Email::Valid](https://metacpan.org/pod/Email::Valid) agrees with our regex:

{% include file="examples/email_regex.pl" %}

The results look satisfying.

## . at the beginning

Then someone might come along, who is less biased than the author of the regex and
suggest a few more test cases. For example let's try `.x@c.com`. That does not look like a proper e-mail
address but our test script prints "regex valid but not Email::Valid". So Email::Valid rejected this, but our
regex thought it is a correct e-mail. The problem is that the username cannot start with a dot. So we
need to change our regex. We add a new character class at the beginning that will only match letter and digits.
We only need one such character, so we don't use any quantifier:

```perl
/^[a-z0-9][a-z0-9.]+\@[a-z0-9.-]+$/
```

Running the test script again, (now already including the new, `.x@c.com` test string we see that we fixed
the problem, but now we get the following error report:

```
f@42.co              Email::Valid but not regex valid
```

That happens because we now require the leading character and then 1 or more from the character class that also includes
the dot. We need to change our quantifier to accept 0 or more characters:

```perl
/^[a-z0-9][a-z0-9.]+\@[a-z0-9.-]+$/
```

That's better. Now all the test cases work.

## . at the end of the username

If we are already at the dot, let's try `x.@c.com`:

The result is similar:

```
x.@c.com             regex valid but not Email::Valid
```

So we need a non-dot character at the end of the username as well. We cannot just add the non-dot character class to the end of
the username part as in this example:

```perl
/^[a-z0-9][a-z0-9.]+[a-z0-9]\@[a-z0-9.-]+$/
```

because that would mean we actually require at least 2 character for every username. Instead we need to require it only if there
are more characters in the username than just 1. So we make part of the username conditional by wrapping that in parentheses
and adding a `?`, a 0-1 quantifier after it.

```perl
/^[a-z0-9]([a-z0-9.]+[a-z0-9])?\@[a-z0-9.-]+$/
```

This satisfies all of the existing test cases.

```perl
my @emails = (
    'foo@bar.com',
    'foo at bar.com',
    'foo.bar42@c.com',
    '42@c.com',
    'f@42.co',
    'foo@4-2.team',
    '.x@c.com',
    'x.@c.com',
);
```


## Regex in variables

It is not huge yet, but the regex is starting to become confusing. Let's separate the username and domain part
and move them to external variables:

```perl
    my $username = qr/[a-z0-9]([a-z0-9.]*[a-z0-9])?/;
    my $domain   = qr/[a-z0-9.-]+/;
    my $regex = $email =~ /^$username\@$domain$/;
```


## Accepting _ in username

Then a new e-mail sample comes along: `foo_bar@bar.com`. After adding it to the test script we get:

```
foo_bar@bar.com      Email::Valid but not regex valid
```

Apparently `_` underscore is also acceptable.

But is underscore acceptable at the beginning and at the end of the username? Let's try
these two as well: `_bar@bar.com` and `foo_@bar.com`.

Apparently underscore can be anywhere in the username part. So we update our regex to be:

```perl
    my $username = qr/[a-z0-9_]([a-z0-9_.]*[a-z0-9_])?/;
```

## Accepting + in username

As it turns out the `+` character is also accepted in the username part. We add 3 more test cases
and change the regex:

```perl
    my $username = qr/[a-z0-9_+]([a-z0-9_+.]*[a-z0-9_+])?/;
```

We could go on trying to find other differences between [Email::Valid](https://metacpan.org/pod/Email::Valid) and our regex,
but I think this is enough for showing how to build a regex and it might be enough to convince you to use
the already well tested Email::Valid module instead of trying to roll your own solution.

Finally, let me include the most recent version of our test script:

{% include file="examples/email_regex_2.pl" %}

## Comments

/^[a-z0-9]([a-z0-9.]+[a-z0-9])?\@[a-z0-9.-]+$/ --- This is wrong . This would fail for email IDs like ab@abc.com
Instead you should use /^[a-z0-9]([a-z0-9.]*[a-z0-9])?\@[a-z0-9.-]+$/

<hr>

This regex is not conformant with email addresses as defined in RFC5322, e.g. the regex does not allow for hyphens, which are regularly used as part of usernames.
---
Thank you for agreeing with what I wrote in the post.

<hr>

if ($email =~ m/^[a-zA-Z0-9][_\-\.a-zA-Z0-9]*[a-zA-Z0-9]\@[a-zA-Z0-9][\-\.a-zA-Z0-9]*[a-zA-Z0-9]\.[a-zA-Z]{2,6}$/) {
print 'The email address is valid.' . "\n";
}
else {
print 'The email address is NOT valid.' . "\n";
}

---

Awesome solution!
