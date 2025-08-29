---
title: "Modules in Perl"
timestamp: 2017-01-14T16:00:11
tags:
  - require
types:
  - screencast
books:
  - advanced
published: true
author: szabgab
---


Previously I explained what the [namespaces](/namespaces-and-packages) are in Perl, using the `package` keyword,
but we have not seen the actual solution to the [problem we encountered](/the-problem-with-libraries) earlier.


<slidecast file="advanced-perl/libraries-and-modules/modules" youtube="BwRaMyHiuOc" />

We had our package (namespace) in the same file as our main code, but we could do the same in two separate files:

The main script is in **namespace.pl** and we `require` the other file providing full (or relative) path to it.

```perl
#!/usr/bin/perl
use strict;
use warnings;

require "namespace_lib.pl";

print Calc::add(3, 4), "\n";
```

In the other file which we called **namespace_lib.pl** is everything starting from the `package Calc;`
expression till where we had the `package main;` earlier. This time we don't need the second `package`
statement, but we need to end the file with a true value. `1;` in this case.

```perl
package Calc;
use strict;
use warnings;

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

So basically we took the [previous example](/pro/namespaces), moved the content of the Calc package into a separate file,
and instead of that we put `require "namespace_lib.pl";` to load the new file.

In this version we don't need to use prefixes for the function inside the file where the Calc namespace is defined. On the other hand we
declare our global variables using `my`, because now we have `use strict;` and that forces us to do so. This way the
variable `$base` will be global in the file declaring Calc, but it won't leak out to the file that uses it.

Then we can call the `add` function of the `Calc` namespace in the main script using `Calc::add()`, the fully qualified name 
of the function. We can use the other function of the Calc namespace, including the `validate_parameters` function, but they not part
of the main namespace, and thus there can be no collision with functions from other namespaces, including the main namespace.

So if we have a library with a Calc namespace and another one with the Inventory namespace, then even if both have and `add` function, one will be
called `Calc::add()`, and the other one `Inventory::add()` and then for anyone reading the script, including perl, it
will be clear which `add` function we are calling.

That's how we can put the code of a namespace into a separate file.
But how can we turn this into a **module**?

## Creating a module

A **module** in Perl is just a file in which there is a single namespace (`package`) and where the name of the file is the same as the name of
the package inside with the .pm extension. So in our case if we rename the `namespace_lib.pl` to be `Calc.pm` then suddenly we have a **module**.

(Actually even if there are multiple packages in the same file we can call it a module but that's just creates more confusion so let's just leave that now.)

The script (we call now **module.pl**) has changed a bit. Instead of `require`-ing the external file using a relative or full path to it, 
we write `require Calc;` and perl will find the `Calc.pm` file and load it.

```perl
#!/usr/bin/perl
use strict;
use warnings;

use lib 'examples/modules';

require Calc;

print Calc::add(3, 4), "\n";
```

The `Calc.pm` file, the module itself has exactly the same content as `namespace_lin.pl` had. Just the name of the file has changed.

Seeing the `require Calc;` statement Perl will search for a file called `Calc.pm` in the directories listed in the
`@INC` array. If the Calc.pm can be found in any of the directories listed in the `@INC` by default then perl will find the file.
If the `Calc.pm` is located elsewhere then we need to
[change @INC](/how-to-change-inc-to-find-perl-modules-in-non-standard-locations).
The statement `use lib 'examples/modules';` adds the **examples/modules** directory to `@INC` which was needed when I 
recorded the screencast.


## Comments

I ran above code in my current directory but it showing below error.
Please reply how i can run.
Can't locate Calc.pm in @INC (@INC contains: examples/modules /usr/local/lib64/perl5 /usr/local/share/perl5 /usr/lib64/perl5/vendor_perl /usr/share/perl5/vendor_perl /usr/lib64/perl5 /usr/share/perl5 .) at perl.pl line 7.


Calc.pm needs to be in one of the directories contained in the @INC array. You can put it anywhere but you'll have to add the diretory to @INC using:

use lib 'mydirectory'

Where mydirectory is any valid path.

The example adds examples/modules to the @INC array using the line:

use lib 'examples/modules';

If you create a directory named examples/modules in the same directory as your script and copy Calc.pm there, it should run correctly.
