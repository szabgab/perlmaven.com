---
title: "The magic unary plus (+)"
timestamp: 2015-01-15T14:30:01
tags:
  - B::Deparse
  - +
published: true
books:
  - beginner
author: szabgab
archive: true
---


In the [article about the size of a file](/how-to-get-the-size-of-a-file-in-perl) I had a code snippet `say (stat $filename)[7];`
that did not work as first expected. One of the solutions was to add a `+` sign in-front of the parentheses: `say +(stat $filename)[7];`

What does that `+` do there? - one reader asked.


The [documentation](https://metacpan.org/pod/distribution/perl/pod/perlfunc.pod#print) explains that the `+` separates
the `print` function from the parentheses `(` and tells perl that these are not the parentheses wrapping the parameters of the print
function.

That might satisfy you, but if you are further intersted you can use the [B::Deparse](https://metacpan.org/pod/B::Deparse) module
to ask perl how does it understand this code-snippet:

```perl
print +(stat $filename)[7];
```

We save that content in the <b>plus.pl</b> file and run `perl -MO=Deparse plus.pl`. The result is:

```perl
print((stat $filename)[7]);
```

and also

```
files/plus.pl syntax OK
```

As you can see the otherwise unnecessary `+` sign has disappeared but, instead of that perl added an extra pair of parentheses.
These are the parens wrapping the parameters of the `print` function.


## How does it work with say?

Now that we saw this with the `print` function, lets make the seemingly obvious change and replace `print` by `say` in
the <b>plus.pl</b> file:

```perl
say +(stat $filename)[7];
```

run `perl -MO=Deparse plus.pl`, and the result is:

```perl
'say' + (stat $filename)[7];
```

<b>What???</b>

That's surprising, and for a few seconds you don't really know what does that mean, but then you remember that `say`
is not part of perl by default. You need to tell somehow that you want the `say` function to be part of your language.
For example by writing `use 5.010;`.

So we change the code to this:

```perl
use 5.010;

say +(stat $filename)[7];
```

run `perl -MO=Deparse files/plus.pl` and get the following result:

```perl
sub BEGIN {
    require 5.01;
}
no feature;
use feature ':5.10';
say((stat $filename)[7]);
```

That a lot of code, but at least we have our extra parens back wrapping the parameters of `say`.

## Conclusion

[B::Deparse](https://metacpan.org/pod/B::Deparse) can be useful when you need to know how perl
understands a code snippet.

Check out the other [articles about B::Deparse](/search/B::Deparse).


