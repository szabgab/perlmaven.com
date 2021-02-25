use strict;
use warnings;
use 5.010;

use Want qw(want);

sub func {
    if (want('VOID')) {
        say 'VOID';
        return;
    }
    if (want('ARRAY')) {
        say 'ARRAY';
        return [];
    }
    if (want('HASH')) {
        say 'HASH';
        return {};
    }
    if (want('LIST')) {
        say 'LIST';
        return;
    }
    if (want('CODE')) {
        say 'CODE';
        return sub { say 'hi' };
    }
    if (want('SCALAR')) {
        say 'SCALAR';
        return '';
    }

    die 'OTHER';
    return;
}

func();                 # VOID
my @x = func();         # LIST
my $z = func();         # SCALAR
my $y = func()->[0];    # ARRAY
my $q = func()->{name}; # HASH
func()->();             # CODE hi


print func();           # LIST
scalar func();          # SCALAR
my %h = (
    result => func(),   # LIST  Odd number of elements in hash assignment
);

