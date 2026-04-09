use strict;
use warnings;

use Test::More;
use Plack::Test;
use Plack::Util;
use HTTP::Request::Common;

my $app = Plack::Util::load_psgi './app.psgi';

my $test = Plack::Test->create($app);
my $res = $test->request(GET '/');

is $res->status_line, '200 OK', 'Status';
is $res->headers->{"content-type"}, 'text/html; charset=utf-8', 'Content-Type';
like $res->content, qr/^The time is \d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d/, 'Content';

done_testing();
