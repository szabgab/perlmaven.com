use strict;
use warnings;
use 5.010;

my $mb = shift or die;

my $str = 'x' x 1024;
 
my $mb_str = $str x (1024 * $mb);
say length($mb_str) / 1024 / 1024;
 
<STDIN>;
