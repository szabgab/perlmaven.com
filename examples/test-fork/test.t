use strict;
use warnings;
use MyApp;

use Test::More;

my $out = MyApp::work(21);
is $out, 42;

done_testing;

