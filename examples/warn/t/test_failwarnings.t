use strict;
use warnings;

use MyModule;

use Test::More;
use Test::Warn;
use Test::FailWarnings;

subtest add2 => sub {
    plan tests => 1;

    is MyModule::add(2, 3), 5;
};

subtest add1 => sub {
    plan tests => 2;

    my $res;
    warning_like { $res = MyModule::add(2) } qr/Too few parameters/;
    is $res, undef;
};

subtest add3 => sub {
    plan tests => 2;

    my $res;
    warning_like { $res = MyModule::add(2, 3, 4) } qr/Too many parameters/;
    is $res, undef;
};


subtest other => sub {
    plan tests => 1;

    my $res = MyModule::other();
    is $res, 42;
};

done_testing;
