use 5.010;
use strict;
use warnings;

my $str = "abc 24 def";

$str =~ s/(\d)(\d)/$1 + $2/;

say $str; # abc 2 + 4 def

