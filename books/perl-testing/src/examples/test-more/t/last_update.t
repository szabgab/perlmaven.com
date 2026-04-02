use strict;
use warnings;

use lib 'lib';
use MyTools qw(last_update);

use Test::More tests => 3;

my $resp = last_update();
diag $resp;
ok( $resp =~ /^This page was last updated at/, 'last_update =~');

like( $resp, qr/^This page was last updated at/, 'last_update like');

like( $resp,
    qr/^This page was last updated at \d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d$/, 'last_update full match');

