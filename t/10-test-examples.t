use strict;
use warnings;

use Test::More;
use Capture::Tiny qw(capture);

# Experimental code to test examples

plan tests => 3;

my ($stdout, $stderr, $exit) = capture {
    system( $^X, 'examples/use_file_basename.pl' );
};
like $stdout, qr/^\d\.\d+$/;
is $stderr, '';
is $exit, 0;
