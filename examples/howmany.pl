use strict;
use warnings;
use 5.010;

use Want qw(howmany);

sub func {
    say howmany() // 'Undefined';

    return;
}

func();                      # 0
my ($x1, $x2) = func();      # 2
my $x3 = func();             # 1
my ($x4) = func();           # 1
my ($x5, $x6, $x7) = func(); # 3

my @a = func();              # Undefined
my %h = func();              # Undefined

