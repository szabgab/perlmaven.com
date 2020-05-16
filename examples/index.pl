use strict;
use warnings;
use 5.010;

my $str = "The black cat climbed the green tree";

say index $str, 'cat';             # 10
say index $str, 'dog';             # -1
say index $str, "The";             # 0
say index $str, "the";             # 22

