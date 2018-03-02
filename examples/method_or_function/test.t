use strict;
use warnings;
use Test::More;

plan tests => 5;

use Module 'markdown';

is markdown('text'),             "Parsing 'text' with options ''";
is markdown('other', 'abc'),     "Parsing 'other' with options 'abc'";

my $m = Module->new;
is $m->markdown('hello'),        "Parsing 'hello' with options ''"; ;
is $m->markdown('hello', 'def'), "Parsing 'hello' with options 'def'"; ;

# Testing the incorrect use of the code
eval {
    Module->markdown('try and fail');
};
like $@, qr/^Calling Module->markdown \(as a class method\) is not supported/;

