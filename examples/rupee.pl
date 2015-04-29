use strict;
use warnings;
use 5.010;

# http://en.wikipedia.org/wiki/Indian_rupee_sign
#
# U+20A8
# U+20B9

binmode(STDOUT, ":utf8");

say "\x{20A8}";
say "\x{20B9}";
say 0x20A8;
say 0x20B9;

my $generic = "20A8";
say $generic;
say hex $generic;  # 8360
