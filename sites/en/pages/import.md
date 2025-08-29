---
title: "Exporting and importing functions easily"
timestamp: 2017-02-03T06:38:11
tags:
  - Exporter
  - "@EXPORT"
  - import
types:
  - screencast
books:
  - advanced
published: true
author: szabgab
---


Previously we talked about the `use` statement includes calling the `import` method of the module
importing the functions of the module.

How does the module author arrange for that to work? How can the module author declare which functions should
the users be able to import? After all there might be helper function or internal functions that should
not be called by an external user of the module.


<slidecast file="advanced-perl/libraries-and-modules/import" youtube="u42upYai4kg" />

Let's see the **cacla.pl** script:

```perl
#!/usr/bin/perl
use strict;
use warnings;

use A::Calc;

print add(2, 3), "\n";
```

Here we have `use A::Calc;` without any list of functions to be imported, yet in the next line
we could use the `add` function imported from that module.

How could the author of the module arrange for that?

Let's see the content of **A/Calc.pm**:

```perl
package A::Calc;
use strict;
use warnings;

use Exporter qw(import);

our @EXPORT = qw(add multiply);

my $base = 10;

sub add {
    validate_parameters(@_);

    my $total = 0;
    $total += $_ for (@_);
    return $total;
}

sub multiply {
}

sub validate_parameters {
    die 'Not all of them are numbers'
        if  grep {/\D/} @_;
    return 1;
}

1;
```

The author had to implement the `import` function that will be called by the
`use` statement, but because this is such a common thing to do, there is already
a module that provides this function. Perl comes with a module called
[Exporter](https://metacpan.org/pod/Exporter) that provides this `import`
function. So we only had to import the `import` function by writing

```perl
use Exporter qw(import);
```

and by that the `A::Calc` module now has an `import` method.

The way that method behaves is that it looks at the array `@EXPORT`
and imports the functions listed in that array.

Please note, the `@EXPORT` array was declared using the `our`
keyword.

So in our case, when the user typed in `use A::Calc;` all the functions
listed in `@EXPORT`, specifically `add` and `multiply` will
be imported into the main script.

As you can see the `A::Calc` module also has a function called `validate_parameters`,
but it is not listed in the `@EXPORT` array and thus it won't be imported into
the namespace of the script.

So this is how the author of a module can **export** certain function and how the user
of such module can **import** those function into another name-space.

