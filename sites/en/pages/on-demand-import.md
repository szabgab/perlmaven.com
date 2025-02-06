---
title: "Import on demand"
timestamp: 2017-02-21T20:00:11
tags:
  - "@EXPORT"
  - "@EXPORT_OK"
types:
  - screencast
books:
  - advanced
published: true
author: szabgab
---


[We saw](/import) that if we have a module and we would like to export some of the functions
we can use the [Exporter](https://metacpan.org/pod/Exporter) module with
the `import` function and we put the list of functions to be exported in the
`@EXPORT` array.


<slidecast file="advanced-perl/libraries-and-modules/on-demand-import" youtube="yvig3dDKmy4" />

As the number of functions we export grows, this soon can get out of hand. Especially
for people who do not
[restrict the import by listing the functions to be imported](/restrict-the-import).
People who just write `use Module::Name;` are going to receive a growing number
of function in their namespace. Many of those functions they will probably never use and they
just pose a risk of colliding with functions from other sources.

For the module author at first it might have seemed to be a good idea to export everything.
After all that makes it much easier to import everything, but later on it turned out that it
would be probably better to export by default only the most commonly used functions and
have a separate list of functions that the users can opt-in to import.

For that the `import` function of the [Exporter](https://metacpan.org/pod/Exporter) module
will look at two arrays. The `@EXPORT` array holds the list of functions that are imported
by default and the `@EXPORT_OK` array holds the list of functions that can also be imported optionally.

So when the use write `use Module::Name;` without providing a list of functions, then everything listed
in `@EXPORT` will be imported but nothing else.

Alternatively, the user can specify which functions to import by listing them after the module name:
`use Module::Name qw(this that);` and then exactly those functions will be imported. Each one of
the requested function names can come from either the `@EXPORT` array or the `@EXPORT_OK` array.

So given the B::Calc module in the <b>B/Calc.pm</b> file:

```perl
package B::Calc;
use strict;
use warnings;

use Exporter qw(import);

our @EXPORT = qw(add);
our @EXPORT_OK = qw(multiply);

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

The user can write

```perl
use B::Calc;
```

and then only the `add` function will be imported.

The user can write:

```perl
use B::Calc qw(multiply);
```

and then only the `multiply` function will be imported but not the `add` function.

So once you start to list the function you'd like to import, you'll have to write down every function
and you'll have to specify the exact list of functions to be imported.


## Conclusion

`@EXPORT` is the list of functions to be imported by default.

`@EXPORT_OK` is the list of function to be imported optionally.

