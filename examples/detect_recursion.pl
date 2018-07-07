use strict;
use warnings;
use 5.010;

use Carp qw(confess);

sub a {
    #say 'enter a';
    confess 'recursion' if state $recursed++;
    b();
}
sub b {
    #say 'enter b';
    confess 'recursion' if state $recursed++;
    c();
}

sub c {
    #say 'enter c';
    confess 'recursion' if state $recursed++;
    a();
}

a();
