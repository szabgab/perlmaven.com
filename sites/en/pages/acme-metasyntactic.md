---
title: "Acme::MetaSyntactic or how to get rid of foo and bar?"
timestamp: 2013-08-18T14:30:01
tags:
  - foo
  - bar
published: true
author: szabgab
---


I have to confess: When writing example applications, I almost always use variable names such as <b>foo</b> and <b>bar</b>.
This gets boring, and it easily confuse the reader. Especially when I need to use more variables.

Luckily [Philippe Bruhat (BooK)](http://www.bruhat.net/) has already solved this problem a long time ago. Let's
see how?


If we look up [Foobar](http://en.wikipedia.org/wiki/Foobar) on Wikipedia, we'll see they are
also called <b>place-holder names</b> or
[Metasyntactic variable](http://en.wikipedia.org/wiki/Metasyntactic_variable).

We'll go with that and install [Acme::MetaSyntactic](https://metacpan.org/pod/Acme::MetaSyntactic).

Following its documentation we can write a short example:

```perl
use strict;
use warnings;
use 5.010;

use Acme::MetaSyntactic; # loads the default theme
say metaname();
```

If we run this script it will print out <b>foo</b>. If we run it again it will print <b>bar</b>.
Then if we run it a few more times it will give names such as <b>corge, waldo, quux, fred</b>.

This already provides some useful diversity, but let's go beyond that.

## OOP

[Acme::MetaSyntactic](https://metacpan.org/pod/Acme::MetaSyntactic) provides
an object oriented interface as well, and has a large number of themes. The default being
the <b>foo</b> theme.

The first thing we try is the <b>class method</b> called `themes` that will
return all the available themes:

```perl
use strict;
use warnings;
use 5.010;

use Acme::MetaSyntactic;

foreach my $t (Acme::MetaSyntactic->themes) {
    say $t;
}
```

The list of themes that are supplied with the module.

```
any
contributors
foo
```

## List all the words of a theme

Once we know what themes are available, we can fetch words from the given theme.
For this we first call the constructor `my $ams = Acme::MetaSyntactic->new;`
and on the object itself we can call the `name` method providing to it the
theme, and optionally the number of words we would like to receive.

Thus `say $ams->name('foo');` will return and print out a single word
from the <b>foo</b> theme. `say $ams->name('foo', 1);` would do the same.

Calling the same method with a bigger number: `my @names = $ams->name('foo', 4);`
will return 4 words. For this, we'd better assign the result to an array for later
use or iterate over the returned list. We might even want to sort the words before
printing them out.

As a special case, if we pass `0` as the requested number of words, the method
will return <b>all the words</b> available in the theme:

```perl
use strict;
use warnings;
use 5.010;

use Acme::MetaSyntactic;

my $ams = Acme::MetaSyntactic->new;
foreach my $n (sort $ams->name('foo', 0)) {
    say $n;
}
```

And the result is:

```
bar
baz
corge
foo
foobar
fred
fubar
garply
grault
plugh
quux
qux
thud
waldo
xyzzy
```

A little more diversity, but that's still not enough!

## Contributors

When we listed the existing themes, it also showed `any`, and `contributors`. What are theses
and where are more themes?

If we pass `contributors` to the `name` method, we'll get back the list of all the contributors
of the module. Would you like to use variable names such as `Leon_Brocard` or `Yanick_Champoux`?

## More themes

Of course having only these themes would not be really interesting, so
[Acme::MetaSyntactic](https://metacpan.org/pod/Acme::MetaSyntactic) is extensible.

Install [Acme::MetaSyntactic::Themes](https://metacpan.org/pod/Acme::MetaSyntactic::Themes),
and you will over 130 new themes.

You don't even need to load the extra module the same code we had above, would list all the
<b>installed</b> themes:

```perl
use strict;
use warnings;
use 5.010;

use Acme::MetaSyntactic;

foreach my $t (sort Acme::MetaSyntactic->themes) {
    say $t;
}
```

And you'll get 131 entries.

We can go even further. There are several people who contributed additional themes that have not
been incorporated into this distribution.

Search for [Acme::MetaSyntactic](https://metacpan.org/search?q=Acme%3A%3AMetaSyntactic),
and you'll find a lot more themes. Alternatively, check out all the
[modules that depend on Acme::MetaSyntactic](https://metacpan.org/requires/distribution/Acme-MetaSyntactic).
Most likely they are additional themes.

Well, except of
[Bot-BasicBot-Pluggable-Module-MetaSyntactic](https://metacpan.org/release/Bot-BasicBot-Pluggable-Module-MetaSyntactic) which is an IRC front-end to the module.

[Task-MetaSyntactic](https://metacpan.org/release/Task-MetaSyntactic) list all the related modules
as dependencies, making it super easy to install all of them with one command.

List of modules in the [module:Acme::MetaSyntactic](https://metacpan.org/search?q=module:Acme::MetaSyntactic) namespace.

In the end we have 168 themes.

Of course not everyone will want to install a bunch of Perl modules just to get some good ideas for
metasyntactic names. So I created a web interface to the modules so you, too can go
[Beyond Foo and Bar](/foobar).

