use strict;
use warnings;
use 5.010;

my $str = "The black cat climbed the green tree";

say substr $str, 4, 5, "big";     # black
say $str;                         # The big cat climbed the green tree

say substr($str, 4, 3) = "small"; # small
say $str;                         # The small cat climbed the green tree
