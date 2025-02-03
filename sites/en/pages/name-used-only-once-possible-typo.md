---
title: "Name "main::x" used only once: possible typo at ..."
timestamp: 2013-03-05T20:31:10
tags:
  - warnings
  - strict
  - possible typo
published: true
books:
  - beginner
author: szabgab
---


If you see this warning in a Perl script you are in deep trouble.


## Assign to a variable

Assigning to a variable, but then never using it,
or using a variable once without assigning any value to it ever,
are rarely correct in any code.

Probably the only "legitimate" case, is if you made a typo,
and that's how you ended up with a variable that is used only once.

Here is an example of code in which we <b>only assign to a variable</b>:

```perl
use warnings;

$x = 42;
```

It will generate a warning like this:

```
Name "main::x" used only once: possible typo at ...
```

That "main::" part and the lack of $ might be confusing for you.
The "main::" part is there because by default
every variable in Perl is part of the "main" namespace. There are also
a number of things that could be called "main::x" and only one of them
has a $ at the beginning. If this sounds a bit confusing, don't worry.
It is confusing, but hopefully you won't need to deal with this for a long time.

## Fetch value only

If you happen to <b>use a variable only once</b>

```perl
use warnings;

print $x;
```

then you will probably get two warnings:

```
Name "main::x" used only once: possible typo at ...
Use of uninitialized value $x in print at ...
```

One of them we are discussing now, the other one is discussed in
[Use of uninitialized value](/use-of-uninitialized-value).


## What is the typo there?

You might ask.

Just imagine someone using a variable called `$l1`. Then later,
you come and want to use the same variable but you write `$ll`.
Depending on your font they might look very similar.

Or maybe there was a variable called `$color` but you are British
and you automatically type `$colour` when you think about that thing.

Or there was a variable called `$number_of_misstakes` and you don't notice
the typo in the original variable and you write `$number_of_mistakes`.

You got the idea.

If you are lucky, you make this mistake only once, but if you aren't that lucky,
and you use the incorrect variable twice, then this warning won't appear.
After all if you are using the same variable twice you probably have a good reason.

So how can you avoid this?

For one, try to avoid variables with ambiguous letters in it and be very
careful when typing variable names.

If you want to solve this for real, just <b>use strict</b>!

## use strict

As you can see in the above examples, I have not used strict. If I was using it,
then instead of getting a warning about possible typo, I'd get a compile time
error:
[Global symbol requires explicit package name](/global-symbol-requires-explicit-package-name).

That would happen even if you used the incorrect variable more than once.

Then of course there are people who would rush and paste "my" in front of the incorrect
variable, but you are not one of those. are you? You would think about the problem and search till
you find the name of the real variable.

The most common way to see this warning is if you are not using strict.

And then you are in deep trouble.

## Other cases while using strict

As GlitchMr and an Anonymous commenter pointed out, there are a few other cases:

This code, can also generate it

```perl
use strict;
use warnings;

$main::x = 23;
```

The warning is: <b>Name "main::x" used only once: possible typo ...</b>

Here at least it is clear where that 'main' comes from, or in
the next example, where the Mister comes from.
(hint: The 'main' and 'Mister' are both package names.
If you are interested, you can see another
[error message, involving missing package names](/global-symbol-requires-explicit-package-name).)
In the next example, the package name is 'Mister'.

```perl
use strict;
use warnings;

$Mister::x = 23;
```

The warning is <b>Name "Mister::x" used only once: possible typo ...</b>.

The following example too generates the warning. Twice:

```perl
use strict;
use warnings;

use List::Util qw/reduce/;
print reduce { $a * $b } 1..6;
```

```
Name "main::a" used only once: possible typo at ...
Name "main::b" used only once: possible typo at ...
```

This happens because `$a` and `$b` are
special variables used in the built-in sort function so
you don't need to declare them, but you are only
using them once here.
(Actually it is unclear to me why this generates the warnings,
while the same code using <b>sort</b> does not, but the
[Perl Monks](http://www.perlmonks.org/?node_id=1021888) might know.


