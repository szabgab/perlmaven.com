use strict;
use warnings;
use Test::More;
use Test::LongString;
use Plack::Test;
use Plack::Util;
use HTTP::Request::Common;

my $app = Plack::Util::load_psgi 'files/var/cgi-bin/app.psgi';

my $test = Plack::Test->create($app);

{
    my $res = $test->request(GET '/');
    is $res->header('Content-Type'), 'text/html; charset=utf8', 'content type';
    is $res->status_line, '200 OK', 'Status';
    is $res->content, "Hello \n", 'Content';
}

{
    my $res = $test->request(GET '/?name=Foo Bar');
    is $res->header('Content-Type'), 'text/html; charset=utf8', 'content type';
    is $res->status_line, '200 OK', 'Status';
    is $res->content, "Hello Foo Bar\n", 'Content';
}

{
    my $res = $test->request(POST '/', { name => 'Foo Bar'});
    is $res->header('Content-Type'), 'text/html; charset=utf8', 'content type';
    is $res->status_line, '200 OK', 'Status';
    is $res->content, "Hello Foo Bar\n", 'Content';
}


done_testing;
