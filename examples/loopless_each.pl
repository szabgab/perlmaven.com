use strict;
use warnings;
use 5.010;

my %h = ( abc => 23, def => 19 );

say 'One';
my ($k1, $v1) = each %h;
say "$k1  => $v1";

say 'Two';
my ($k2, $v2) = each %h;
say "$k2  => $v2";

say 'Three';
my ($k3, $v3) = each %h;
say "$k3  => $v3";

say 'Four';
my ($k4, $v4) = each %h;
say "$k4  => $v4";


