---
title: "Packaging a Perl script and a Perl module"
timestamp: 2017-03-28T20:00:11
tags:
  - SYNOPSIS
  - DESCRIPTION
types:
  - screencast
books:
  - advanced
published: true
author: szabgab
---


What we are packaging is a script and a module.


{% youtube id="PEwkiG1tb5U" file="advanced-perl/libraries-and-modules/file-and-module" %}

The script is placed in the `script/` directory and it is just a regular script.
You don't have to tell it where to load the modules from, you just load the module.

```perl
#!/usr/bin/perl
use strict;
use warnings;

use App qw(run);

run();

# If there is a script in the application
# or if the whole application is one or more scripts
# then this is an example of such a script.
```


The module itself includes the `package` keyword. We have a `$VERSION` variable with the version number.
It is declared using `our` as this variable needs to be access from the outside world as well, not just by the
code in the module itself. It is important to have this version number in every module. The Makefile.PL or Build.PL
will take the version number of the main module of your distribution and use that as the version number of the distribution.
In addition the CPAN clients will use the version number inside each individual module to determine if that module is "new enough"
which is especially interesting if the particular module is mentioned as a dependency of some other distribution.

The module also has a POD section. The POD has a `NAME` part that contains the name of the module and a one-line description
of what does the module do.

Then the `SYNOPSIS` usually contains a simple code example for the people who really don't want to read any documentation.

Then the `DESCRIPTION` section will contain detailed description of every function and method of the module.
(Or at least should contain.)

At the end of the POD  there is usually a section containing Copyright a and License information. This section is especially
imporant if you'd like to let companies use your code and/or if you'd like downsream distributions to include your code.
For example the Debian team is very picky about having clear Copyright and License information in every module they include.
This is how they ensure everthing their distribution is legal and has an appropriate Open Source license.

```perl
package App;
use strict;
use warnings;
use 5.008;

our $VERSION = '0.01';

sub add {
    my ($x, $y) = @_;
    return $x+$y;
}


=head1 NAME

App - application

=head1 SYNOPSIS

 A quick example for the really inpatient.

=head1 DESCRIPTION

=head2 Methods

=head2 Methods

=over 4

=item method_a

=item method_b

=back

=head1 BUGS

Probably plenty but nothing I know of. Please report them to the author.

=head1 Development

Instructions to those who wish to participate in the development efforts.
E.g. where is the version control system, where is the development mailing
list or forum (if you have one).

=head1 Thanks

Potential thanks to people who helped you.

=head1 AUTHOR

Gabor Szabo <gabor@szabgab.com>

=head1 COPYRIGHT

Copyright 2006 by Gabor Szabo <gabor@szabgab.com>.

This program is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html

=cut

1;
```


## Comments

Wouldn't it be better to show now to use `module-starter`?

---

That might be better for people who start a new module, but if you have already written the code and now you start to think about packaging then I think that's too late.

<hr>

Shouldn't the module define a 'run' function, or the script call the 'add' function in this example?
---
I was thinking about the same

