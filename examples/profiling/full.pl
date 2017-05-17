use strict;
use warnings;

sub a { $_[0] =~ /x/; }
sub b { $_[0] =~ /x/; }
sub c { $_[0] =~ /x/; }
sub d { $_[0] =~ /x/; }
sub e { $_[0] =~ /x/; }

my $n = 100;

a("a") for 1..$n;
b("b") for 1..$n;
c("c") for 1..$n;
d("d") for 1..$n;
e("e") for 1..$n;

