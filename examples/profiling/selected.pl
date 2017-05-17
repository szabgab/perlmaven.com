use strict;
use warnings;

sub a { $_[0] =~ /x/; }
sub b { $_[0] =~ /x/; }
sub c { $_[0] =~ /x/; }
sub d { $_[0] =~ /x/; }
sub e { $_[0] =~ /x/; }

my $n = 100;

a("a") for 1..$n;
DB::enable_profile() if $ENV{NYTPROF};
b("b") for 1..$n;
DB::disable_profile() if $ENV{NYTPROF};
c("c") for 1..$n;
DB::enable_profile() if $ENV{NYTPROF};
d("d") for 1..$n;
DB::disable_profile() if $ENV{NYTPROF};
e("e") for 1..$n;

