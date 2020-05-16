use strict;
use warnings;
use 5.010;

my $str = "The black cat climbed the green tree";
say rindex $str, "e";              # 35
say rindex $str, "e", 34;          # 34
say rindex $str, "e", 33;          # 29
