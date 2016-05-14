use 5.010;
use strict;
use warnings;

my $str = "abc 24 def";

$str =~ s/(\d)(\d)/$2$1/;

say $str;   # abc 42 def

