use strict;
use warnings;

use Test::More;
use Plack::Test;
use Plack::Util;
use HTTP::Request::Common;

my $app = Plack::Util::load_psgi './app.psgi';

my $test = Plack::Test->create($app);

subtest main => sub {
    my $res = $test->request(GET '/');
    is $res->status_line, '200 OK', 'Status';
    is $res->headers->{"content-type"}, 'text/html; charset=utf-8', 'Content-Type';
    is $res->content, 'Hello World!', 'Content';
};

subtest not_found => sub {
    my $res = $test->request(GET '/first');
    is $res->status_line, '404 Not Found', 'Status';
    is $res->headers->{"content-type"}, 'text/html; charset=utf-8', 'Content-Type';
    like $res->content, qr{<title>Error 404 - Not Found</title>};
    like $res->content, qr{<h1>Error 404 - Not Found</h1>};
};

done_testing();
