---
title: "Passing multiple parameters to a function in Perl"
timestamp: 2020-10-24T08:30:01
tags:
  - "@_"
published: true
books:
  - beginner
author: szabgab
archive: true
---


How can you implement a function that will accept several variables? After all in Perl all the parameters passed
to a function are shoved into the `@_` array of the function.

For example, what if you are creating a function to send emails.
You would like the user to pass in a parameter for the "from" field, one for the "to" field, one for the "subject",
one for the "plain text" version of the email, one for the "html" version of the email. Maybe even a parameter for the "cc"
and the "bcc" fields.


## Positional parameter in Perl function call

We can expect the parameters to be passed one after the other as in this implementation:

```perl
sub sendmail {
    my ($from, $to, $subject, $text, $html, $cc, $bcc) = @_;
    ...
}
```

This allows the user of this function (who might be you on another day) to call it this way:
leaving out the last two parameters that were considered optional. We only have to make
sure inside the function that even if no value was passed for `$cc` or `$bcc`
we won't attempt to use the [undef](/undef) that is assigned to these variables.

```perl
sendmail(
   'foo@sender.com',
   'bar@receiver.com',
   'Welcome to Company',
   q{Dear Bar,
This is some long message
...
},
  q{## Dear Bar
This is a long HTML message
...
},
);
```

The problem with this way of expecting parameters is that both the person who calls the function
and the person who reads the code later, will have to remember (or look up) the order of the parameters.

Is the first e-mail the "from" and the second the "to" or the other way around?

This is time consuming and error prone.

In addition, if you would like to skip some of the parameters in the middles, you still need to pass `undef` explicitly.
For example what if we wanted to supply a value for the `bcc` field but not the `cc` field?
What if you'd like to skip the "text" parameter and send only HTML mail?
You'd have to call it like this:

```perl
sendmail($from, $to, $subject, undef, $html, undef, $bcc);
```

That's not very nice.

## Named parameters for Perl functions - Expecting key-value pairs

A different approach is to expect parameters as key-value pairs.
The user will then be able to call the function like this:

```perl
sendmail(
   subject => 'Welcome to Company',
   to      => 'bar@receiver.com',
   from    => 'foo@sender.com',
   text    => q{Dear Bar,
This is some long message
...
},
   html => q{## Dear Bar
This is a long HTML message
...
},
);
```

```perl
sendmail(
    from    => $from,
    to      => $to,
    subject => $subject,
    html    => $html,
    bcc     => $bcc
);
```

This requires the person calling the function to write a bit more, it required them to know the exact spelling
of the names of the fields, but it is a lot more readable for the next person who will have to maintain the
program and it makes it easy to not supply some of the parameters.

In the implementation of the function we assume that the user passes key-value pairs and we build a hash from
the values arriving in the `@_` array:

```perl
sub sendmail {
    my %params = @_;
    ...
}
```

We can then go one and include some extra protection. (Something we could have done earlier as well, but neglected to implement.)

<ol>
   <li>Verification that all the required parameters were passed.</li>
   <li>Set default values to the optional parameter.</li>
   <li>Verification that all the parameters passed were expected. This can help avoiding typos in the parameter names.</li>
</ol>


```perl
sub sendmail {
    my %params = @_;

    die "Parameter 'to' is required" if not $params{to};

    $params{text} //= '';
    $params{cc} //= '';
    $params{bcc} //= '';

    my %valid = map { $_ => 1 } qw(from to subject text html cc bcc);
    for my $param (sort keys %params) {
        die "Invalid field '$param'" if not $valid{$param};
    }

    ...
}
```


