use strict;
use warnings;
use 5.010;

use Devel::Size qw(size total_size);

my %a;
both('HASH', \%a);             #   120   120

my %b;
$b{0} = 1;
both('HASH-0', \%b);           #   179   203

my %c;
$c{100} = 1;
both('HASH-100', \%c);         #  181   205


my %e;
$e{1_000_000} = 1;
both('HASH-1,000,000', \%e);   #  185   209

sub both {
    my ($name, $ref) = @_;
    printf "%-25s %5d %5d\n", $name, size($ref), total_size($ref);
}

