use strict;
use warnings;
use 5.010;

use Carp qw(confess);

sub a {
    confess 'recursion' if state $recursed++;
}

a();
a();

