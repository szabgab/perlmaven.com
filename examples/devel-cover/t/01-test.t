use strict;
use warnings;

use Test::More;
use Example;

is Example::code(), 1;
diag explain \%ENV;

done_testing;
