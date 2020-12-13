use strict;
use warnings;
use 5.010;

use Test::More;

# The return value of 'do' is whatever the last statement of the code.pl was.
# It can be undef as well even if everything is fine.

# $@ empty string if the  do was successful, the error message if it was not

subtest works => sub {
    do './code_works.pl';
    is $@, '';
    is $!, '';
};

subtest compile_time_error => sub {
    do './compile_time_error.pl';
    like $@, qr{Global symbol "\$name" requires explicit package name};
    is $!, '';
};

subtest code_with_wrong_use_statement => sub {
    do './code_wrong_use.pl';
    like $@, qr{Can't locate MyModule.pm};
    is $!, 'No such file or directory';
};

subtest code_with_runtime_exception => sub {
    do './code_exception.pl';
    like $@, qr{My Oups};
    is $!, '';
};

subtest do_no_such_file => sub {
    do './code_nope.pl';
    is $@, '';
    is $!, 'No such file or directory';
};


done_testing;

