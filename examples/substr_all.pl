use strict;
use warnings;
use 5.010;

my $str = "The black cat climbed the green tree";

say substr $str, 4, 5;      # black
say substr $str, 22;        # the green tree";
say substr $str, 22, -5;    # the green           The same as: substr $str, 22, length($str)-22-5;
say substr $str, -4;        # tree                The same as: substr $str, length($str)-4;
say substr $str, -10, 5;    # green
say substr $str, -14, -11;  # the
