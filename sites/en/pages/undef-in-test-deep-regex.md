---
title: "Use of uninitialized value $got in pattern match (m//) at Test/Deep/Regexp.pm line 57."
timestamp: 2016-06-03T07:30:01
tags:
  - Test::Deep
  - array_each
  - re
published: true
author: szabgab
archive: true
---


[Test::Deep](https://metacpan.org/pod/Test::Deep) is a great module if you need to test deep and/or fuzzy data structures,
but sometimes it does not give the correct error messages. Recently I've encountered such a case when I got tons of warnings like this:

<b>Use of uninitialized value $got in pattern match (m//) at Test/Deep/Regexp.pm line 57.</b>

Unfortunately the warning did not say what really caused it, but after patching the Test::Deep::Regexp I could solve the riddle.


The problem was that in my test I had something like this:


```perl
cmp_deeply \@data, array_each({
    fname => re('^.*$'),
    lname => re('^.*$'),
    ...
    email => re('^.*$'),
    address => re('^.*$')
});
```

with about 25 fields, each one with its own regex.

Getting a warning that one of them is undef was not really useful.

The source code of Test/Deep/Regexp.pm looked like this:

```perl
sub descend
{
        my $self = shift;
        my $got = shift;

        my $re = $self->{val};
        if (my $match_exp = $self->{matches})
        {
                my $flags = $self->{flags};
                my @match_got;
                if ($flags eq "g")
                {
                        @match_got = $got =~ /$re/g;
                }
                else
                {
                        @match_got = $got =~ /$re/;
                }
 
                if (@match_got)
                {
                        return Test::Deep::descend(\@match_got, $match_exp);
                }
                else
                {
                        return 0;
                }
        }
        else
        {
                return ($got =~ $re) ? 1 : 0;
        }
}
```

Line 57 in the original code, that generated the warning was this line: `return ($got =~ $re) ? 1 : 0;`.

A quick glance at the return value gave me the impression that this would indicate the success or failure of the regex.

So I changed the code and added

`return 0 if not defined $got;` right after copying the second parameter to the `$got` variable on the 2nd row of the function.
So I had


```perl
sub descend
{
        my $self = shift;
        my $got = shift;
        return 0 if not defined $got;
...
```

Then I ran my tests again. This time the test failed and told me exactly which key in my hash was `undef`.

At this point I had two choices:

If having and `undef` there was incorrect then I'd need to fix my code, or if the `undef` was acceptable
I could change my test to be:

```perl
     field => any(undef, re('...')),
```

with the appropriate regex. This expression will only try to run the regex if the value is not `undef`.

## A full example of the problem

The following script can demonstrate the issue:

{% include file="examples/undef_in_test_deep_regex.pl" %}

I have even opened a [ticket](https://github.com/rjbs/Test-Deep/issues/39) with this issue, but I am not sure if
my recommended solution is acceptable at all. In any case this little change helped me figuring out the source of the warnings.


## Screenshots

<img src="/img/shots/undef-in-test-deep-regex.png" alt="Test::Deep example">


