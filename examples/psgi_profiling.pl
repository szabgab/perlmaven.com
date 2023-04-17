use 5.010;
use strict;
use warnings;

BEGIN {
    $ENV{HTTP_HOST} = 'http://perlmaven.com/';
}

use Plack::Test;
use HTTP::Request::Common qw(GET);
use Path::Tiny qw(path);

my $app  = do 'app.psgi';
my $test = Plack::Test->create($app);
my $res  = $test->request( GET 'http://perlmaven.com/' );

say 'ERROR: code is     ' . $res->code . ' instead of 200'   if $res->code != 200;
say 'ERROR: messages is ' . $res->message . ' instead of OK' if $res->message ne 'OK';
say 'ERROR: incorrect content'                               if $res->content !~ m{<h2>Perl tutorials and courses</h2>};
