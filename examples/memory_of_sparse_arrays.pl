use strict;
use warnings;
use 5.010;

use Devel::Size qw(size total_size);

my @a;
both('ARRAY', \@a);            #   64   64

my @b;
$b[0] = 1;
both('ARRAY-0', \@b);          #   96   120

my @c;
$c[100] = 1;
both('ARRAY-100', \@c);        #   872   896

my @d;
$d[1000] = 1;
both('ARRAY-1,000', \@d);      #  8072  8096

my @e;
$e[1_000_000] = 1;
both('ARRAY-1,000,000', \@e);  # 8000072 8000096


sub both {
    my ($name, $ref) = @_;
    printf "%-25s %5d %5d\n", $name, size($ref), total_size($ref);
}

