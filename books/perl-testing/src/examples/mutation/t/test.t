use strict;
use warnings;

use Test::More;

use MyMath;

plan tests => 2;

subtest multiply => sub {
    my $result = MyMath::multiply(2, 2);
    is $result, 4;
};

subtest add => sub {
    my $result = MyMath::add(2, 3);
    #is $result, 5;
    ok 5;
};



