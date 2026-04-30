use strict;
use warnings;
use Test::More;

use Mock::Quick qw(qclass);
my $control;

BEGIN {
$control = qclass(
    -implement => 'BaseSalary',
    -with_new => 1,
    -attributes => [ qw(name) ],
    get_base_salary => 23,
);
}


use MySalary;
my $obj = MySalary->new("Foo");

is $obj->get_name(), 'Foo';
is $obj->get_salary, 123;

$control->undefine();

done_testing;

