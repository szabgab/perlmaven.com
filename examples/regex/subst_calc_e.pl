use 5.010;
use strict;
use warnings;

my $str = "abc 24 def";

$str =~ s/(\d)(\d)/$1 + $2/e;

say $str;  # abc 6 def
