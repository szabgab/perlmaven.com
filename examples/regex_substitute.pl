use strict;
use warnings;
use 5.010;

my $text = '1234567890';
$text =~ s/(\d)(\d)/$2$1/g;
say $text;  # 2143658709
