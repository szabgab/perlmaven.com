use strict;
use warnings;
use Test::More;

use MySalary;

my $obj = MySalary->new("Gabor");
is $obj->get_name(), "Gabor";
is $obj->get_salary(), 1470;


done_testing;

