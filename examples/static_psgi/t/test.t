use strict;
use warnings;
use Test::More;
use Plack::Test;
use HTTP::Request::Common qw(GET);
use Path::Tiny qw(path);

plan tests => 5;

my $app = do 'app.psgi';

my $test = Plack::Test->create($app);

my $main = path('www/index.html')->slurp_utf8;

my $res = $test->request(GET "/"); # HTTP::Response
is $res->code, 200;
is $res->message, 'OK';
#diag $res->headers; #HTTP::Headers
#diag explain [ $res->headers->header_field_names ];
is $res->header('Content-Length'), length $main;
is $res->header('Content-Type'), 'text/html; charset=utf-8';
diag $res->header('Last-Modified');
is $res->content, $main;

