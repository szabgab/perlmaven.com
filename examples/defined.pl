use strict;
use warnings;
use 5.010;

my $x;
my $y = 0;

sub func {
    return;
}

my $z = func();

say defined $x ? 'defined' : 'not defined';  # not defined
say defined $y ? 'defined' : 'not defined';  # defined
say defined $z ? 'defined' : 'not defined';  # not defined
say defined $z ? 'defined' : 'not defined';  # not defined

say defined &func  ? 'defined' : 'not defined';  # defined
say defined &other ? 'defined' : 'not defined';  # not defined

