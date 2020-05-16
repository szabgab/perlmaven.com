use strict;
use warnings;
use 5.010;

my $str = "The black cat climbed the green tree";
say index $str, "e ";              # 2
say index $str, "e ", 3;           # 24
say index $str, "e", 3;            # 19

