use strict;
use warnings;
use feature 'say';

use MySalary;

my $obj = MySalary->new("Gabor");
my $name = $obj->get_name();
my $salary = $obj->get_salary();

say "The salary of $name is $salary";

